//
//  ShopViewModel.swift
//  SACtudy
//
//  Created by 김윤수 on 2022/12/08.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources
import StoreKit

class ShopViewModel: NSObject, ViewModel, NetworkManager {
    let products = PublishRelay<[ProductModel]>()
    let transaction = BehaviorRelay<SKPaymentTransaction?>(value: nil)
    var storeKitProducts: [String: SKProduct] = [:]
    
    struct Input {
        let viewDidLoad: ControlEvent<Void>
        let sesacItemSelected: ControlEvent<ProductModel>
        let backgroundItemSelected: ControlEvent<ProductModel>
        let purchaseButtonTap: PublishRelay<String>
        let saveButtonTap: ControlEvent<Void>
    }
    
    struct Output {
        let sesacProducts = BehaviorRelay<[Section]>(value: [])
        let backgroundProducts = BehaviorRelay<[Section]>(value: [])
        let currentSesacItem = BehaviorRelay<Int?>(value: nil)
        let currentBackgroundItem = BehaviorRelay<Int?>(value: nil)
        let result = PublishRelay<ShopResult>()
    }
    
    func transform(_ input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        let fetchMyInfo = PublishRelay<Void>()
        let applyProducts = PublishRelay<Void>()
        let mySesac = BehaviorRelay<[Int]>(value: [])
        let myBackground = BehaviorRelay<[Int]>(value: [])
        
        fetchMyInfo
            .withUnretained(self)
            .flatMapLatest { model, token in
                model.request(router: .user(.shopInfo), type: User.self) }
            .subscribe(with: self) { model, result in
                switch result {
                case let .success(user):
                    if let user {
                        mySesac.accept(user.sesacCollection)
                        myBackground.accept(user.backgroundCollection)
                        output.currentBackgroundItem.accept(user.background)
                        output.currentSesacItem.accept(user.sesac)
                    }
                case .error(.tokenError):
                    fetchMyInfo.accept(())
                case .error(.network):
                    output.result.accept(.network)
                default:
                    print(result)
                }
            }
            .disposed(by: disposeBag)
        
        applyProducts
            .compactMap { _ in
                guard let sesac = output.currentSesacItem.value, let back = output.currentBackgroundItem.value else {
                    return nil }
                return ProductApplyModel(sesac: sesac, background: back)
            }
            .withUnretained(self)
            .flatMapLatest { model, data in
                model.request(router: .user(.updateShopItem(data: data)), type: Empty.self)
            }
            .subscribe(with: self) { model, result in
                switch result {
                case .success:
                    output.result.accept(.success)
                case .error(.network):
                    output.result.accept(.network)
                case .error(.tokenError):
                    applyProducts.accept(())
                case .status(201):
                    output.result.accept(.unownedItem)
                default:
                    print(result)
                }
            }
            .disposed(by: disposeBag)
        
        transaction
            .compactMap{$0}
            .withUnretained(self)
            .flatMapLatest { (model, transaction) in
                let itemModel = PurchaseItemModel(productId: transaction.payment.productIdentifier)
                return model.request(router: .user(.purchaseItem(data: itemModel)), type: Empty.self)
            }
            .subscribe(with: self) { model, result in
                guard let transaction = model.transaction.value else { return }
                switch result {
                case .success:
                    fetchMyInfo.accept(())
                case .error(.network):
                    output.result.accept(.network)
                case .error(.tokenError):
                    model.transaction.accept(transaction)
                default:
                    print(result)
                }
                SKPaymentQueue.default().finishTransaction(transaction)
            }
            .disposed(by: disposeBag)
        
        Observable.combineLatest(products, mySesac)
            .map { (list, own) in
                let basic = ProductModel(type: SesacProducts.basic, title: "기본새싹", price: "0", description: "새싹을 대표하는 기본 식물입니다. 다른 새싹들과 함께 하는 것을 좋아합니다.", isPurchased: true)
                var items = [basic] + list.filter { $0.type as? SesacProducts != nil }
                own.forEach { items[$0].isPurchased = true }
                
                return [Section(items: items)]
            }
            .bind(to: output.sesacProducts)
            .disposed(by: disposeBag)

        Observable.combineLatest(products, myBackground)
            .map { (list, own) in
                let basic = ProductModel(type: BackgroundProducts.basic, title: "하늘 공원", price: "0", description: "새싹들을 많이 마주치는 매력적인 하늘 공원입니다", isPurchased: true)
                var items = [basic] + list.filter { $0.type as? BackgroundProducts != nil }
                own.forEach { items[$0].isPurchased = true }
                
                return [Section(items: items)]
            }
            .bind(to: output.backgroundProducts)
            .disposed(by: disposeBag)
        
        input.viewDidLoad
            .subscribe(with: self) { model, _ in
                model.requestProductData()
                fetchMyInfo.accept(())
            }
            .disposed(by: disposeBag)
        
        input.sesacItemSelected
            .map { $0.type.rawValue }
            .bind(to: output.currentSesacItem)
            .disposed(by: disposeBag)
        
        input.backgroundItemSelected
            .map { $0.type.rawValue }
            .bind(to: output.currentBackgroundItem)
            .disposed(by: disposeBag)
        
        input.saveButtonTap
            .bind(to: applyProducts)
            .disposed(by: disposeBag)
        
        input.purchaseButtonTap
            .bind(with: self) { model, id in
                model.purchaseProduct(productId: id)
            }
            .disposed(by: disposeBag)
        
        return output
    }
}

extension ShopViewModel {
    enum ShopResult {
        case success, network, unownedItem
        var message: String {
            switch self {
            case .success:
                return "성공적으로 저장되었습니다"
            case .network:
                return Constant.networkDisconnectMessage
            case .unownedItem:
                return "구매가 필요한 아이템이 있어요"
            }
        }
    }
}

extension ShopViewModel: ProductManager {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        response.products.forEach { self.storeKitProducts[$0.productIdentifier] = $0 }
        
        let products = response.products.compactMap { product in
            if let type = productList.filter({ $0.productIdentifier == product.productIdentifier }).first {
                return ProductModel(type: type, title: product.localizedTitle, price: "\(product.price)", description: product.localizedDescription, isPurchased: false)
            }
            return nil
        }
        
        self.products.accept(products)
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased: //구매 승인 이후에 영수증 검증
                print("Transaction Approved. \(transaction.payment.productIdentifier)")
                self.transaction.accept(transaction)
            case .failed:
                print("Transaction Failed")
                SKPaymentQueue.default().finishTransaction(transaction)
            default:
                break
            }
        }
    }
}

extension ShopViewModel {
    struct Section: SectionModelType {
        typealias Item = ProductModel
        var items: [Item]
        
        init(items: [Item]) {
            self.items = items
        }
        
        init(original: Section, items: [Item]) {
            self = original
            self.items = items
        }
    }
}

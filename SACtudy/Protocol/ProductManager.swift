//
//  ProductManager.swift
//  SACtudy
//
//  Created by 김윤수 on 2022/12/12.
//

import Foundation
import StoreKit

protocol ProductManager: NSObject, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    var productList: [Products] { get }
    var storeKitProducts: [String: SKProduct] { get set }
    func requestProductData()
    func purchaseProduct(productId: String)
}

extension ProductManager {
    var productList: [Products] {
        SesacProducts.allCases + BackgroundProducts.allCases }
    
    func requestProductData() {
        if SKPaymentQueue.canMakePayments() {
            print("인앱 결제 가능")
            let idSet = Set<String>(productList.map{$0.productIdentifier})
            let request = SKProductsRequest(productIdentifiers: idSet)
            request.delegate = self
            request.start()
        } else {
            print("In App Purchase Not Enabled")
        }
    }
    
    func purchaseProduct(productId: String) {
        if let product = storeKitProducts[productId] {
            let payment = SKPayment(product: product)
            SKPaymentQueue.default().add(payment)
            SKPaymentQueue.default().add(self)
        }
    }
}

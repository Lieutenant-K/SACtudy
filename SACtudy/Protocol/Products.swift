//
//  Product.swift
//  SACtudy
//
//  Created by 김윤수 on 2022/12/09.
//

import UIKit
import RxSwift

protocol Products {
    var baseBundle: String { get }
    var productIdentifier: String { get }
    var rawValue: Int { get }
    static var allCases: [Self] { get }
}
extension Products {
    var baseBundle: String {
        "com.memolease.sesac1"
    }
}

protocol ProductCell: UICollectionViewCell {
    var purchaseButton: RoundedButton { get }
    var disposeBag: DisposeBag { get }
    func inputData(data: ProductModel)
}

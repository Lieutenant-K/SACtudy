//
//  ReceiptValidationModel.swift
//  SACtudy
//
//  Created by 김윤수 on 2022/12/12.
//

import Foundation

struct PurchaseItemModel {
    let productId: String
    var receiptString: String? {
        let receiptFileURL = Bundle.main.appStoreReceiptURL
        let receiptData = try? Data(contentsOf: receiptFileURL!)
        let receiptString = receiptData?.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        return receiptString
    }
}

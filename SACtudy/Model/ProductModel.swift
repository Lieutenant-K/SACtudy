//
//  ProductModel.swift
//  SACtudy
//
//  Created by 김윤수 on 2022/12/09.
//

import Foundation

struct ProductModel {
    let type: Products
    let title: String
    let price: String
    let description: String
    var isPurchased: Bool
}

struct ProductApplyModel {
    let sesac: Int
    let background: Int
}

enum SesacProducts: Int, Products, CaseIterable {
    case basic = 0
    case strong
    case mint
    case purple
    case gold
    
    var productIdentifier: String {
        baseBundle + ".sprout\(self.rawValue)"
    }
}

enum BackgroundProducts: Int, Products, CaseIterable {
    case basic = 0
    case cityView
    case nightWalkroad
    case walkroad
    case stage
    case livingRoom
    case homeTrainning
    case workplace
    
    var productIdentifier: String {
        baseBundle + ".background\(self.rawValue)"
    }
}

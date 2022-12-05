//
//  Protocol.swift
//  SACtudy
//
//  Created by 김윤수 on 2022/12/04.
//

import UIKit

protocol ChatData {
    var content: String { get }
    var createdAt: String { get }
}

protocol ChatCellType: UICollectionViewCell {
    func inputData(data: ChatData)
}

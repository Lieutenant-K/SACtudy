//
//  Asset.Image + Extension.swift
//  SACtudy
//
//  Created by 김윤수 on 2022/11/24.
//

import Foundation

extension Asset.Images {
    
    static func sesacBackground(number: Int) -> ImageAsset? {
        
        [sesacBackground0, sesacBackground1, sesacBackground2, sesacBackground3, sesacBackground4, sesacBackground5, sesacBackground6, sesacBackground7, sesacBackground8]
            .filter { $0.name == "sesac_background_\(number)"}.first
    }
    
    static func sesacFace(number: Int) -> ImageAsset? {
        
        [sesacFace0, sesacFace1, sesacFace2, sesacFace3, sesacFace4, sesacBackground5]
            .filter { $0.name == "sesac_face_\(number)"}.first
    }
    
}

//
//  URI.swift
//  SACtudy
//
//  Created by 김윤수 on 2022/11/25.
//

import Foundation
import Alamofire

protocol URI {
    
    var method: HTTPMethod { get }
    var parameters: Parameters? { get }
    var baseURI: String { get }
    var subURI: String { get }
    
}

extension URI {
    var path: String {
        baseURI + subURI
    }
}

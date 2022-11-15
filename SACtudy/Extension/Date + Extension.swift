//
//  Date + Extension.swift
//  SACtudy
//
//  Created by 김윤수 on 2022/11/16.
//

import Foundation

extension Date {
    
    var toBirthString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        
        return formatter.string(from: self)
    }
    
    var currentAge: Int {
        Calendar(identifier: .iso8601)
            .dateComponents([.year, .month, .day], from: self, to: Date())
            .year ?? 0
    }
}

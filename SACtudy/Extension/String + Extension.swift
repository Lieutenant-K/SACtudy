//
//  String + Extension.swift
//  SACtudy
//
//  Created by 김윤수 on 2022/11/12.
//

import Foundation


extension String {
    
    subscript(_ idx: Int) -> String? {
        guard (0..<count).contains(idx) else {
            return nil
        }
        let index = index(startIndex, offsetBy: idx)
        return String(self[index])
    }
    
    func substring(from: Int, to: Int) -> String {
            let start = index(startIndex, offsetBy: from)
            let end = index(start, offsetBy: to - from)
            return String(self[start ..< end])
        }

    func substring(range: NSRange) -> String {
        return substring(from: range.lowerBound, to: range.upperBound)
    }
    
}

extension String {
    
    var toBirthDate: Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        
        return formatter.date(from: self)
    }
    
}

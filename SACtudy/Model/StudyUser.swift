//
//  StudyUser.swift
//  SACtudy
//
//  Created by 김윤수 on 2022/11/30.
//

import UIKit

struct StudyUser {
    
    let uid, nick: String
    let reputation: Reputation
    let studylist, reviews: [String]
    let sesac, background: UIImage?
    var displayingDetail: Bool
    
}

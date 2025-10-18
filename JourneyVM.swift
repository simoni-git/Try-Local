//
//  JourneyVM.swift
//  Try-Local
//
//  Created by 시모니의 맥북 on 8/18/25.
//

import Foundation

class JourneyVM {
    var token: String 
    var userName: String
    init(token: String , userName: String) {
        self.token = token
        self.userName = userName
    }
    var sessionID: Int? = 0
}

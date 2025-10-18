//
//  RouteStruct.swift
//  Try-Local
//
//  Created by 시모니의 맥북 on 8/28/25.
//

import Foundation

// 요청 파라미터 구조
struct RouteRequest: Encodable {
    let q1: Int
    let q2: Int
    let q3: Int?
    let start_date: String
    let end_date: String
}

// 서버 응답 구조 
struct RouteResponse: Decodable {
    struct User: Decodable {
        let username: String
    }
    
    struct Answers: Decodable {
        let q1: Int
        let q2: Int
        let q3: Int?
    }
    
    struct DateInfo: Decodable {
        let start_date: String
        let end_date: String
    }
    
    struct RouteItem: Decodable {
        let order: Int
        let name: String
        let type: String
        let type_label: String
        let address: String
        let latitude: Double
        let longitude: Double
        let image_url: String?
    }
    
    struct Route: Decodable {
        let id: Int?
        let name: String?
        let routes: [RouteItem]?                 // 배열일 때 사용
        let routesByDay: [String: [RouteItem]]?  // 딕셔너리일 때 사용
        
    }
    
    // ✅ 1박2일용 RouteOvernight 추가
    struct RouteOvernight: Decodable {
        let id: Int?
        let name: String?
        let routes: [String: [RouteItem]]?  // day1, day2
    }
    
    let submission_id: Int
    let user: User
    let answers: Answers
    let date: DateInfo
    let route: Route?
    let route_overnight: RouteOvernight?  // 서버에서 1박2일 코스 내려주는 키
}

struct RouteData {
    var name: String
    var latitude: String
    var longitude: String
    var address: String?
    var imgURL: String?
    var type: String?
    var order: String?
}


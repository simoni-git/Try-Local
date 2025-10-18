//
//  HomeVM.swift
//  Try-Local
//
//  Created by 시모니의 맥북 on 8/18/25.
//

import Foundation
import Alamofire

class HomeVM {
    var token: String
    var userName: String
    init(token: String , userName: String) {
        self.token = token
        self.userName = userName
    }
    
    // ✅ 데이터 저장용 프로퍼티
    var doThisItems: [DoThisItem] = []
    var eatThisItems: [EatThisItem] = []
    var goHereItems: [GoHereItem] = []
    var eventItems: [EventItem] = []
    var myTravelItems: [MyTravel] = []
    // ✅ 뷰컨트롤러에게 알림을 주는 콜백
    var onDataUpdated: (() -> Void)?
    
    //MARK: - API func
    func getHomeInfoAPI() {
        let url = "https://we-did-this.com/home/"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Content-Type": "application/json",
        ]
        
        AF.request(url, method: .get, headers: headers)
            .validate()
            .responseDecodable(of: HomeResponse.self) { [weak self] response in
                guard let self = self else { return }
                
                switch response.result {
                case .success(let data):
                    print("✅ 데이터 받음:", data)
                    self.doThisItems = data.Shall_we_do_this
                    self.eatThisItems = data.Shall_we_eat_this
                    self.goHereItems = data.Shall_we_go_here
                    self.eventItems = data.How_about_this
                    self.myTravelItems = data.my_travel ?? []
                    
                    // ✅ 뷰컨트롤러에 데이터 갱신 알리기
                    self.onDataUpdated?()
                case .failure(let error):
                    print("❌ 에러 발생:", error)
                    // 🔎 상태코드
                    if let statusCode = response.response?.statusCode {
                        print("상태 코드:", statusCode)
                    }
                    
                    // 🔎 응답 Body (Data -> String)
                    if let data = response.data,
                       let body = String(data: data, encoding: .utf8) {
                        print("서버 응답 Body:", body)
                    }
                }
            }
    }
    
}

//MARK: - (HomeVC 에서만 사용)응답 구조체 정의

struct HomeResponse: Decodable {
    let my_travel: [MyTravel]?
    let Shall_we_do_this: [DoThisItem]
    let Shall_we_eat_this: [EatThisItem]
    let Shall_we_go_here: [GoHereItem]
    let How_about_this: [EventItem]
}

struct DoThisItem: Decodable {
    let name: String
    let experiences: [String]
    let image: String
}

struct EatThisItem: Decodable {
    let name: String
    let address: String
    let image: String
}

struct GoHereItem: Decodable {
    let name: String
    let address: String
    let image: String
}

struct EventItem: Decodable {
    let name: String
    let period: String
    let image: String
}

// 여정 구조체
struct MyTravel: Decodable {
    let submission_id: Int
    let name: String
    let date: TravelDate
}

struct TravelDate: Decodable {
    let start_date: String
    let end_date: String
}

//
//  MakeRuteSelf2_1VM.swift
//  Try-Local
//
//  Created by 시모니의 맥북 on 8/31/25.
//

import Foundation
import Combine
import Alamofire

class MakeRuteSelf2_1VM {
    var token: String = ""
    var q1: Int = 0
    var q2: Int = 0
    var q3: Int?
    var userName: String = ""
    var submissionID: Int = 0
    var startDate: String = ""
    var endDate: String = ""
    
   
    
    @Published var startAdress: String = ""
    @Published var selectedPlaces: [getFullListRouteItem] = []
    
    // 이름만 따로 저장
    var selectedPlaceNames: [String] {
        selectedPlaces.map { $0.name ?? "" }
    }
    
    // 5분 타임아웃 세션을 클래스 프로퍼티로 생성
    private let longTimeoutSession: Session = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 300
        configuration.timeoutIntervalForResource = 300
        return Session(configuration: configuration)
    }()
    
    //MARK: - API 호출
    func settingRouteAPI(submissionID: Int, startAddress: String, places: [String], startDate: String, endDate: String, token: String, completion: @escaping () -> Void) {
        print("settingRouteAPI() - called")
        let url = "https://we-did-this.com/route/save?submission_id=\(submissionID)"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Content-Type": "application/json"
        ]
        
        let parameters: [String: Any] = [
            "origin_address": startAddress,
            "places": places,
            "start_date": startDate,
            "end_date": endDate
        ]
        
        AF.request(url,
                   method: .post,
                   parameters: parameters,
                   encoding: JSONEncoding.default,
                   headers: headers)
        .validate()
        .responseJSON { response in
            switch response.result {
            case .success(let data):
                print("서버 응답: \(data)")
                completion()
            case .failure(let error):
                print("에러 발생: \(error)")
                
            }
        }
    }
    
    func gptAnswerRouteAPI(submissionID: Int,
                           username: String,
                           q1: Int,
                           q2: Int,
                           q3: Int?,
                           startDate: String,
                           endDate: String,
                           completion: @escaping (RouteResponse?) -> Void) {
            
        print("gptAnswerRouteAPI() - called")
            let url = "https://we-did-this.com/route/build?submission_id=\(submissionID)"
        
            let headers: HTTPHeaders = [
                "Authorization": "Bearer \(token)",
                "Content-Type": "application/json"
            ]
            
            let parameters: [String: Any?] = [
                "submission_id": submissionID,
                "user": [
                    "username": username
                ],
                "answers": [
                    "q1": q1,
                    "q2": q2,
                    "q3": q3 // null 허용
                ],
                "date": [
                    "start_date": startDate,
                    "end_date": endDate
                ],
                "route": [
                    "id": submissionID, // 혹은 이전 저장된 route id
                    "name": "나의 여정",
                    "routes": [] // 최초 요청 시 빈 배열
                ]
            ]
        
        
        let startTime = Date()
        print("통신 시작: \(startTime)")
        
        var elapsedSeconds = 0
        // 1초마다 콘솔에 찍히는 타이머
        let timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            elapsedSeconds += 1
            print("통신 경과: \(elapsedSeconds)초")
        }
        
        
        longTimeoutSession.request(url,
                        method: .post,
                        parameters: parameters,
                        encoding: JSONEncoding.default,
                        headers: headers)
        .validate()
        .responseDecodable(of: RouteResponse.self) { response in
            timer.invalidate()
            switch response.result {
            case .success(let data):
                print("서버 응답: \(data)")
                completion(data)
            case .failure(let error):
                print("에러 발생: \(error)")
                completion(nil)
            }
        }
    }
    
    func fetchRouteDetail(submissionID: Int, completion: @escaping () -> Void) {
        print("fetchRouteDetail() - called")
        let url = "https://we-did-this.com/route/result/detail"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]
        let parameters: [String: Any] = [
            "submission_id": submissionID
        ]
        
        AF.request(url, method: .get, parameters: parameters, headers: headers)
            .validate()
            .responseDecodable(of: RouteResponse.self) { [weak self] response in
                switch response.result {
                case .success(let data):
                    print("서버 응답: \(data)")
                       
                       // 서버에서 받은 route.routes를 selectedPlaces로 변환
                       if let routeItems = data.route?.routes {
                           self?.selectedPlaces = routeItems.map { item in
                               getFullListRouteItem(
                                name: item.name,
                                type: item.type,
                                type_label: item.type_label,
                                description: "",
                                image: item.image_url ?? "",
                                address: item.address,
                                latitude: item.latitude,
                                longitude: item.longitude,
                                order: item.order
                               )
                           }
                       }
                       completion()
                       
                   case .failure(let error):
                       print("에러 발생: \(error)")
                    
                   }
               }
       }
  
}

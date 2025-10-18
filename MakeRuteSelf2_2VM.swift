//
//  MakeRuteSelf2_2VM.swift
//  Try-Local
//
//  Created by 시모니의 맥북 on 9/1/25.
//

import Foundation
import Combine
import Alamofire

class MakeRuteSelf2_2VM {
    var token: String = ""
    var q1: Int = 0
    var q2: Int = 0
    var q3: Int?
    var userName: String = ""
    var submissionID: Int = 0
    var startDate: String = ""
    var endDate: String = ""
    
    //MARK: day1+ day2 통합배열
    var names: [String] = []
    var latitudes: [String] = []
    var longitudes: [String] = []
    var addresses: [String] = []
    var imgURLs: [String] = []
    var types: [String] = []
    var orders: [String] = []
    
    //MARK: 1박2일코스 배열
    var namesDay1: [String] = []
    var latitudesDay1: [String] = []
    var longitudesDay1: [String] = []
    var addressesDay1: [String] = []
    var imgURLsDay1: [String] = []
    var typesDay1: [String] = []
    var ordersDay1: [String] = []
    
    var namesDay2: [String] = []
    var latitudesDay2: [String] = []
    var longitudesDay2: [String] = []
    var addressesDay2: [String] = []
    var imgURLsDay2: [String] = []
    var typesDay2: [String] = []
    var ordersDay2: [String] = []
    
   
    @Published var startAdress: String = ""
    @Published var restPointAdress: String = ""
    @Published var selectedPlaces: [getFullListRouteItem] = []
    var routeOverNight: RouteResponse.RouteOvernight?
    var selectedPlacesByDay: [String: [getFullListRouteItem]] = [:]   // ✅ 저장 프로퍼티
    
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
    func settingRouteAPI(submissionID: Int, startAddress: String, restPointAdress: String, places: [String], startDate: String, endDate: String, token: String, completion: @escaping () -> Void) {
        print("✅settingRouteAPI() - called , submissionID: \(submissionID) , startAddress: \(startAddress), restPointAdress: \(restPointAdress), places: \(places), startDate: \(startDate), endDate: \(endDate), token: \(token)")
        let url = "https://we-did-this.com/route/save?submission_id=\(submissionID)"
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Content-Type": "application/json"
        ]
        
        let parameters: [String: Any] = [
            "origin_address": startAddress,
            "places": places,
            "lodging_address": restPointAdress, // 숙소정보
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
    
    // MARK: - 2. GPT 코스 생성 API
        func gptAnswerRouteAPI(submissionID: Int,
                               username: String,
                               q1: Int,
                               q2: Int,
                               q3: Int?,
                               startDate: String,
                               endDate: String,
                               completion: @escaping () -> Void) {
            
            let url = "https://we-did-this.com/route/build?submission_id=\(submissionID)"
            let headers: HTTPHeaders = [
                "Authorization": "Bearer \(token)",
                "Content-Type": "application/json"
            ]
            let parameters: [String: Any?] = [
                "submission_id": submissionID,
                "user": ["username": username],
                "answers": ["q1": q1, "q2": q2, "q3": q3],
                "date": ["start_date": startDate, "end_date": endDate],
                "route_overnight": ["id": submissionID, "name": "나의 여정", "routes": [:]]
            ]
            
            // ⏱ Timer 설정
               var elapsedSeconds = 0
               let startTime = Date()
               print("통신 시작: \(startTime)")
               
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
            .responseDecodable(of: RouteResponse.self) { [weak self] response in
                guard let self = self else { return }
                timer.invalidate()
                switch response.result {
                case .success(let data):
                    
                    print("✅ gptAnswerRouteAPI 성공")
                        
                        // day1/day2 배열 초기화
                        self.namesDay1.removeAll()
                        self.latitudesDay1.removeAll()
                        self.longitudesDay1.removeAll()
                        self.addressesDay1.removeAll()
                        self.imgURLsDay1.removeAll()
                        self.typesDay1.removeAll()
                        self.ordersDay1.removeAll()
                        
                        self.namesDay2.removeAll()
                        self.latitudesDay2.removeAll()
                        self.longitudesDay2.removeAll()
                        self.addressesDay2.removeAll()
                        self.imgURLsDay2.removeAll()
                        self.typesDay2.removeAll()
                    self.ordersDay2.removeAll()
                    
                    // 통합 배열 초기화
                    self.names.removeAll()
                    self.latitudes.removeAll()
                    self.longitudes.removeAll()
                    self.addresses.removeAll()
                    self.imgURLs.removeAll()
                    self.types.removeAll()
                    self.orders.removeAll()
                    
                    // routesByDay 확인 후 바로 day별 배열에 삽입
                    if let routesByDay = data.route_overnight?.routes {
                        for (day, items) in routesByDay {
                            for item in items {
                                switch day {
                                case "day1":
                                    self.namesDay1.append(item.name)
                                    self.latitudesDay1.append(String(item.latitude))
                                    self.longitudesDay1.append(String(item.longitude))
                                    self.addressesDay1.append(item.address)
                                    self.imgURLsDay1.append(item.image_url ?? "")
                                    self.typesDay1.append(item.type_label)
                                    self.ordersDay1.append(String(item.order))
                                    
                                    // 통합 배열에도 추가
                                    self.names.append(item.name)
                                    self.latitudes.append(String(item.latitude))
                                    self.longitudes.append(String(item.longitude))
                                    self.addresses.append(item.address)
                                    self.imgURLs.append(item.image_url ?? "")
                                    self.types.append(item.type_label)
                                    self.orders.append(String(item.order))
                                case "day2":
                                    self.namesDay2.append(item.name)
                                    self.latitudesDay2.append(String(item.latitude))
                                    self.longitudesDay2.append(String(item.longitude))
                                    self.addressesDay2.append(item.address)
                                    self.imgURLsDay2.append(item.image_url ?? "")
                                    self.typesDay2.append(item.type_label)
                                    self.ordersDay2.append(String(item.order))
                                    
                                    // 통합 배열에도 추가
                                    self.names.append(item.name)
                                    self.latitudes.append(String(item.latitude))
                                    self.longitudes.append(String(item.longitude))
                                    self.addresses.append(item.address)
                                    self.imgURLs.append(item.image_url ?? "")
                                    self.types.append(item.type_label)
                                    self.orders.append(String(item.order))
                                default: break
                                }
                            }
                        }
                    }
                    
                    
                    
                    completion()
                case .failure(let error):
                    print("❌ gptAnswerRouteAPI 에러:", error)
                    completion()
                }
            }
        }
    
    // MARK: - 1박2일 상세 조회 API
    func fetchOvernightRoute(submissionID: Int, completion: @escaping () -> Void) {
        let url = "https://we-did-this.com/route/result/detail"
        let headers: HTTPHeaders = ["Authorization": "Bearer \(token)"]
        let parameters: [String: Any] = ["submission_id": submissionID]
        
        AF.request(url,
                   method: .get,
                   parameters: parameters,
                   headers: headers)
            .validate()
            .responseDecodable(of: RouteResponse.self) { [weak self] response in
                guard let self = self else { return }
                
                switch response.result {
                case .success(let data):
                    print("✅ fetchOvernightRoute 성공")
                    // 내부 구조체만 사용하여 selectedPlaces로 변환
                    if let routesByDay = data.route_overnight?.routes {
                        self.selectedPlaces = self.convertToSelectedPlaces(from: routesByDay)
                    }
                    
                    completion()
                    
                case .failure(let error):
                    print("❌ fetchOvernightRoute 에러:", error)
                    completion()
                }
            }
    }
    
    // MARK: - 공통 변환 함수
        private func convertToSelectedPlaces(from routes: [String: [RouteResponse.RouteItem]]) -> [getFullListRouteItem] {
            var temp: [getFullListRouteItem] = []
            for (_, items) in routes {
                for item in items {
                    temp.append(getFullListRouteItem(
                        name: item.name,
                        type: item.type,
                        type_label: item.type_label,
                        description: "",
                        image: item.image_url ?? "",
                        address: item.address,
                        latitude: item.latitude,
                        longitude: item.longitude,
                        order: item.order
                    ))
                }
            }
            return temp
        }
    
    
    
    //MARK: - 1박2일 직접에서만 사용.
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
        
        // 1박2일 전용
        struct RouteOvernight: Decodable {
            let id: Int
            let name: String
            let routes: [String: [RouteItem]]  // "day1", "day2" 키를 가진 딕셔너리
        }
        
        let submission_id: Int
        let user: User
        let answers: Answers
        let date: DateInfo
        let route_overnight: RouteOvernight?
        let message: String?
    }


}

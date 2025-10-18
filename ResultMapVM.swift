//
//  MapRouteVM.swift
//  Try-Local
//
//  Created by 시모니의 맥북 on 8/28/25.
//

import Foundation
import Alamofire
import Combine

class ResultMapVM {
    var token: String
    var submissionID: Int? = 0
    var userName: String? = ""
    private let session: Session
    init(token: String) {
        self.token = token
        // Session 생성 (타임아웃 10초)
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 10
        configuration.timeoutIntervalForResource = 10
        self.session = Session(configuration: configuration)
    }
    
    var titleLabelText: String = ""
    
    // 데이터가 바뀌면 콜백으로 알림
    var onDataUpdated: (() -> Void)?
    
    var daySubViewIsHidden: Bool = true
    var removeBtnIsHidden: Bool = false
    @Published var backBtnIsHidden: Bool = false
    //MARK: 당일코스배열
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
    
    //MARK: - API func
    
    //여행일정이 있는경우에 사용 ( 만들어 놓은 일정 그대로 불러오기)
    func fetchRoute(submissionID: Int) {
        let url = "https://we-did-this.com/route/result/detail"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]
        
        let parameters: Parameters = [
            "submission_id": submissionID
        ]
        
        AF.request(url,
                   method: .get,
                   parameters: parameters,
                   encoding: URLEncoding.default,
                   headers: headers)
        .validate()
        .responseDecodable(of: RouteDetailResponse.self) { [weak self] response in
            guard let self = self else { return }
            switch response.result {
            case .success(let data):
                // 배열 초기화
                self.names.removeAll()
                self.latitudes.removeAll()
                self.longitudes.removeAll()
                self.addresses.removeAll()
                self.imgURLs.removeAll()
                self.types.removeAll()
                self.orders.removeAll()
                
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
                
                if let normalRoute = data.route {
                    // 일반 여정
                    for item in normalRoute.routes {
                        self.names.append(item.name)
                        self.latitudes.append("\(item.latitude)")
                        self.longitudes.append("\(item.longitude)")
                        self.addresses.append(item.address)
                        self.imgURLs.append(item.image_url ?? "")
                        self.types.append(item.type_label)
                        self.orders.append("\(item.order)")
                        daySubViewIsHidden = true
                    }
                } else if let overnight = data.route_overnight {
                    // 1박2일 여정
                    daySubViewIsHidden = false
                    for item in overnight.routes.day1 {
                        self.namesDay1.append(item.name)
                        self.latitudesDay1.append("\(item.latitude)")
                        self.longitudesDay1.append("\(item.longitude)")
                        self.addressesDay1.append(item.address)
                        self.imgURLsDay1.append(item.image_url ?? "")
                        self.typesDay1.append(item.type_label)
                        self.ordersDay1.append("\(item.order)")
                    }
                    for item in overnight.routes.day2 {
                        self.namesDay2.append(item.name)
                        self.latitudesDay2.append("\(item.latitude)")
                        self.longitudesDay2.append("\(item.longitude)")
                        self.addressesDay2.append(item.address)
                        self.imgURLsDay2.append(item.image_url ?? "")
                        self.typesDay2.append(item.type_label)
                        self.ordersDay2.append("\(item.order)")
                    }
                    
                    // day1 + day2 합쳐서 일반 배열에도 넣기
                    self.names = self.namesDay1 + self.namesDay2
                    self.latitudes = self.latitudesDay1 + self.latitudesDay2
                    self.longitudes = self.longitudesDay1 + self.longitudesDay2
                    self.addresses = self.addressesDay1 + self.addressesDay2
                    self.imgURLs = self.imgURLsDay1 + self.imgURLsDay2
                    self.types = self.typesDay1 + self.typesDay2
                    self.orders = self.ordersDay1 + self.ordersDay2
                }
                
                // 데이터 갱신 알림
                self.onDataUpdated?()
                
            case .failure(let error):
                print("에러 발생:", error)
            }
        }
    }
    
    // 여정 지우기
    func deleteRoute(submissionID: Int, completion: @escaping (Bool) -> Void) {
        let url = "https://we-did-this.com/route/delete"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]
        let parameters: Parameters = [
            "submission_id": submissionID
        ]
        
        AF.request(url,
                   method: .delete,
                   parameters: parameters,
                   encoding: URLEncoding.default,
                   headers: headers)
        .response { response in
            switch response.result {
            case .success:
                print("삭제 성공")
                completion(true)
            case .failure(let error):
                print("삭제 실패:", error)
                completion(false)
            }
        }
    }
    
    //MARK: - 사용자가 일정이 있는경우 여정탭에서 사용할 구조체(여정탭 , 발자취 에서 사용)
    struct RouteDetailResponse: Decodable {
        let submission_id: Int
        let user: User
        let answers: Answers
        let date: TravelDate
        let route: RouteNormal?
        let route_overnight: RouteOvernight?
    }
    
    struct User: Decodable {
        let username: String
    }
    
    struct Answers: Decodable {
        let q1: Int
        let q2: Int
        let q3: Int?
    }
    
    struct TravelDate: Decodable {
        let start_date: String
        let end_date: String
    }
    
    struct RouteNormal: Decodable {
        let id: Int
        let name: String
        let routes: [RouteItem]
    }
    
    struct RouteOvernight: Decodable {
        let id: Int
        let name: String
        let routes: OvernightRoutes
    }
    
    struct OvernightRoutes: Decodable {
        let day1: [RouteItem]
        let day2: [RouteItem]
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
}

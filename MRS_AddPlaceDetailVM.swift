//
//  MRS_AddPlaceDetailVM.swift
//  Try-Local
//
//  Created by 시모니의 맥북 on 8/31/25.
//

//import Foundation
//import Alamofire
//
//class MRS_AddPlaceDetailVM {
//    var token: String
//    var targetName: String
//    var detailInfo: PlaceDetailResponse?
//    private let session: Session
//    
//    init(token: String, targetName: String) {
//        self.token = token
//        self.targetName = targetName
//        
//        // Session 생성 (타임아웃 10초)
//        let configuration = URLSessionConfiguration.default
//        configuration.timeoutIntervalForRequest = 10
//        configuration.timeoutIntervalForResource = 10
//        self.session = Session(configuration: configuration)
//    }
//    
//    //MARK: API 반환값 모든 변수
//    var id: Int = 0
//    var type: String = ""
//    var name: String = ""
//    var descriptionText: String = ""
//    var address: String = ""
//    var latitude: String = ""
//    var longitude: String = ""
//    var contact: String = ""
//    var link: String = ""
//    var period: String = ""
//    var place: String = ""
//    var organizer: String = ""
//    var parking: String = ""
//    var sales: String = ""
//    var toilet: String = ""
//    var coffee: String = ""
//    var createdAt: String = ""
//    var updatedAt: String = ""
//    var images: [String] = []
//    
//    
//    //MARK: - API func
//    func getDetailInfoAPI(name: String, completion: @escaping () -> Void) {
//        let url = "http://3.37.172.197:8000/home/place"
//        
//        let headers: HTTPHeaders = [
//            "Authorization": "Bearer \(token)"
//        ]
//        
//        let parameters: Parameters = [
//            "name": name
//        ]
//        
//        var secondsElapsed = 0
//        let timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
//            secondsElapsed += 1
//            print("⏳ 로딩 \(secondsElapsed)초째...")
//        }
//        
//        // Session 프로퍼티 사용
//        session.request(url,
//                        method: .get,
//                        parameters: parameters,
//                        encoding: URLEncoding.default,
//                        headers: headers)
//        .validate()
//        .responseDecodable(of: PlaceDetailResponse.self) { response in
//            timer.invalidate()
//            switch response.result {
//            case .success(let data):
//                print("✅ 상세 데이터 받음:", data)
//                self.detailInfo = data
//                self.id = data.safeID
//                self.type = data.safeType
//                self.name = data.safeName
//                self.descriptionText = data.safeDescription
//                self.address = data.safeAddress
//                self.latitude = data.safeLatitude
//                self.longitude = data.safeLongitude
//                self.contact = data.safeContact
//                self.link = data.safeLink
//                self.period = data.safePeriod
//                self.place = data.safePlace
//                self.organizer = data.safeOrganizer
//                self.parking = data.safeParking
//                self.sales = data.safeSales
//                self.toilet = data.safeToilet
//                self.coffee = data.safeCoffee
//                self.createdAt = data.safeCreatedAt
//                self.updatedAt = data.safeUpdatedAt
//                self.images = data.safeImages
//                completion()
//            case .failure(let error):
//                print("❌ API 에러 또는 타임아웃:", error)
//                completion()
//            }
//        }
//    }
//}

//
//  ExperienceDetailVM.swift
//  Try-Local
//
//  Created by 시모니의 맥북 on 8/18/25.
//

import Foundation
import Alamofire
import Combine

class ExperienceDetailVM {
    var token: String
    var targetName: String
    var detailInfo: PlaceDetailResponse?
    private let session: Session
    @Published var likeBtnIsHidden: Bool = false
    
    //MARK: API 반환값 모든 변수
    var id: Int = 0
    var type: String = ""
    var name: String = ""
    var descriptionText: String = ""
    var address: String = ""
    var latitude: String = ""
    var longitude: String = ""
    var contact: String = ""
    var link: String = ""
    var period: String = ""
    var place: String = ""
    var organizer: String = ""
    var parking: String = ""
    var sales: String = ""
    var toilet: String = ""
    var coffee: String = ""
    var createdAt: String = ""
    var updatedAt: String = ""
    var images: [String] = []
    @Published var isFavorite: Bool? // 즐겨찾기 새로추가했음
    var onDismiss: (() -> Void)?  // 모달이 사라질 때 호출할 클로저
    
    
    init(token: String, targetName: String) {
        self.token = token
        self.targetName = targetName
        
        // Session 생성 (타임아웃 10초)
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 10
        configuration.timeoutIntervalForResource = 10
        self.session = Session(configuration: configuration)
    }
    
    //MARK: - API func
    
    
    //MARK: 디테일데이터 가져오기
    func getDetailInfoAPI(name: String, completion: @escaping () -> Void) {
        let url = "https://we-did-this.com/home/place"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]
        
        let parameters: Parameters = [
            "name": name
        ]
        
        // ✅ 로딩 시간 프린트용 Timer
        var secondsElapsed = 0
        let timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            secondsElapsed += 1
            print("⏳ 로딩 \(secondsElapsed)초째...")
        }
        
        // ✅ Alamofire 요청 (Session 프로퍼티 사용)
        session.request(url,
                        method: .get,
                        parameters: parameters,
                        encoding: URLEncoding.default,
                        headers: headers)
        .validate()
        .responseDecodable(of: PlaceDetailResponse.self) { [weak self] response in
            guard let self = self else { return }
            // ✅ Timer 종료
            timer.invalidate()
            
            switch response.result {
            case .success(let data):
                print("✅ 상세 데이터 받음:", data)
                
                self.detailInfo = data
                // 뷰용 변수 안전하게 저장
                self.id = data.safeID
                self.type = data.safeType
                self.name = data.safeName
                self.descriptionText = data.safeDescription
                self.address = data.safeAddress
                self.latitude = data.safeLatitude
                self.longitude = data.safeLongitude
                self.contact = data.safeContact
                self.link = data.safeLink
                self.period = data.safePeriod
                self.place = data.safePlace
                self.organizer = data.safeOrganizer
                self.parking = data.safeParking
                self.sales = data.safeSales
                self.toilet = data.safeToilet
                self.coffee = data.safeCoffee
                self.createdAt = data.safeCreatedAt
                self.updatedAt = data.safeUpdatedAt
                self.images = data.safeImages
                self.isFavorite = data.safeIsFavorite // 즐겨찾기 새로추가했음
                
                completion()
                
            case .failure(let error):
                print("❌ API 에러 또는 타임아웃:", error)
                completion() // 실패 시에도 호출
            }
        }
    }
    
    //즐겨찾기
    func plusFavoriteAPI(name: String) {
        let baseURL = "https://we-did-this.com/home/place/favorite"
        let url = "\(baseURL)?name=\(name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? name)"
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]
        
        AF.request(url,
                   method: .post,
                   headers: headers)
        .validate()
        .responseDecodable(of: FavoriteResponse.self) { response in
            switch response.result {
            case .success(let favoriteResponse):
                print("✅ 즐겨찾기 등록 성공: \(favoriteResponse.place), favorited: \(favoriteResponse.favorited)")
                
                // 서버에서 반환한 값으로 업데이트
                self.isFavorite = favoriteResponse.favorited
                
            case .failure(let error):
                print("❌ 즐겨찾기 등록 실패:", error.localizedDescription)
            }
        }
    }
    
}



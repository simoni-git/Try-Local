//
//  MyPageVM.swift
//  Try-Local
//
//  Created by 시모니의 맥북 on 8/18/25.
//

import Foundation
import Alamofire

class MyPageVM {
    var token: String 
    var userName: String
    init(token: String , userName: String) {
        self.token = token
        self.userName = userName
    }
    
    //MARK: - API func
    
    //로그아웃
    func logout(completion: @escaping () -> Void) {
        let url = "https://we-did-this.com/mypage/logout"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]
        
        AF.request(url, method: .delete, headers: headers)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success(let data):
                    if let dict = data as? [String: Any],
                       let message = dict["message"] as? String {
                        print("서버 응답: \(message)")
                        completion()
                    }
                case .failure(let error):
                    print("에러 발생: \(error)")
                    
                }
            }
    }
    
    //나의 발자취
    func getFootPrintAPI(completion: @escaping ([TripHistoryItem]) -> Void) {
        let url = "https://we-did-this.com/mypage/history"
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)" 
        ]
        
        AF.request(url,
                   method: .get,
                   headers: headers)
        .validate()
        .responseDecodable(of: TripHistoryResponse.self) { response in
            switch response.result {
            case .success(let data):
                print("✅ Trip History 불러오기 성공")
                for item in data.results {
                    print("📌 \(item.sumbission_id) | \(item.name) | \(item.date)")
                }
                completion(data.results)
                
            case .failure(let error):
                print("❌ Trip History 불러오기 실패:", error.localizedDescription)
                completion([])
            }
        }
    }
    
    func getFavoriteList(completion: @escaping ([getFullListRouteItem]) -> Void) {
        let url = "https://we-did-this.com/mypage/favorites"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]
        
        AF.request(url, method: .get, headers: headers)
            .validate()
            .responseDecodable(of: FavoritesListResponse.self) { [weak self] response in
                guard let self = self else { return }
                
                switch response.result {
                case .success(let result):
                    print("✅ 데이터 받음: => \(result.results)")
                    completion(result.results)   // results 배열을 그대로 넘김
                case .failure(let error):
                    print("❌ 에러 발생:", error.localizedDescription)
                }
            }
        
    }
    
}
    
    //MARK: - MyPage 에서 사용하는 발자취 구조체
    struct TripHistoryResponse: Decodable {
        let results: [TripHistoryItem]
    }
    
    struct TripHistoryItem: Decodable {
        let sumbission_id: Int
        let name: String
        let date: String
    }
    
    struct FavoritesListResponse: Codable {
        let results: [getFullListRouteItem]
    }

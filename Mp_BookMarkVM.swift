//
//  Mp_BookMarkVM.swift
//  Try-Local
//
//  Created by 시모니의 맥북 on 9/4/25.
//

import Foundation
import Alamofire

class Mp_BookMarkVM {
    var token: String
    init(token: String) {
        self.token = token
    }
    
    var routeItems: [getFullListRouteItem] = []
   
    func getFavoriteList(completion: @escaping ([getFullListRouteItem]) -> Void) {
        let url = "https://we-did-this.com/mypage/favorites"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]
        
        AF.request(url, method: .get, headers: headers)
            .validate()
            .responseDecodable(of: FavoritesListResponse.self) { response in
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


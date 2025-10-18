//
//  Mp_UnsubscribeDetailVM.swift
//  Try-Local
//
//  Created by 시모니의 맥북 on 9/1/25.
//

import Foundation
import Alamofire

class Mp_UnsubscribeDetailVM {
    var token: String = ""
    var reason: String = ""
    //MARK: - API func
    func deleteAccount(reason: String, token: String, completion: @escaping () -> Void) {
        let url = "https://we-did-this.com/mypage/delete_account"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Content-Type": "application/json"
        ]
        
        let parameters: [String: Any] = [
            "reason": reason
        ]
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success(let data):
                    print("회원탈퇴 성공: \(data)")
                    completion()
                case .failure(let error):
                    print("회원탈퇴 실패: \(error)")
                }
            }
    }
}

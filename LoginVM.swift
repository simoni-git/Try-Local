
//  LoginVM.swift
//  TryLocal
//
//  Created by 시모니의 맥북 on 6/5/25.


import UIKit
import Combine
import Alamofire

class LoginVM {
    var loginID: String?
    var loginPW: String?
    var token: String?
    var userName: String?
    
    @Published var loginBtnIsHidden: Bool = true
    @Published var loginFailed: Bool = false
    
    func checkIsEmptyLoginID_PW() {
        if (loginID ?? "").isEmpty || (loginPW ?? "").isEmpty {
            print("checkIsEmptyLoginID_PW() - called 로그인 ID, PW에 빈칸이 있습니다.")
            loginBtnIsHidden = true
        } else {
            print("checkIsEmptyLoginID_PW() - called 로그인 ID, PW에 빈칸이 없습니다.")
            loginBtnIsHidden = false
        }
    }
    
    //MARK: - API
    func loginAPI(accountID: String, password: String, completion: @escaping () -> Void) {
        let url = "https://we-did-this.com/accounts/login"
        
        let parameters: [String: Any] = [
            "account_id": accountID,
            "password": password
        ]
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
        
        AF.request(url,
                   method: .post,
                   parameters: parameters,
                   encoding: JSONEncoding.default,
                   headers: headers)
        .validate()
        .responseDecodable(of: LoginResponse.self) { [weak self] response in
            switch response.result {
            case .success(let loginResponse):
                print("✅ 로그인 성공:")
                print("👤 ID: \(loginResponse.accountID)")
                print("👤 이름: \(loginResponse.userName)")
                print("👤 타입: \(loginResponse.userType)")
                print("🎟️ 토큰: \(loginResponse.token)")
                print("✅ 성공 여부: \(loginResponse.success)")
                self?.loginFailed = false
                self?.token = loginResponse.token
                self?.userName = loginResponse.userName
                completion()
                // 필요하면 토큰 저장 등 추가 작업 가능
            case .failure(let error):
                print("❌ 로그인 실패:", error)
                if let data = response.data,
                   let errorMessage = String(data: data, encoding: .utf8) {
                    print("📩 서버 응답:", errorMessage)
                }
                self?.loginFailed = true
            }
        }
    }
    
    //MARK: - Struct
    struct LoginResponse: Codable {
        let accountID: String
        let userName: String
        let userType: Int
        let success: Bool
        let token: String
        
        enum CodingKeys: String, CodingKey {
            case accountID = "account_id"
            case userName = "user_name"
            case userType = "user_type"
            case success
            case token
        }
    }
    
}

    


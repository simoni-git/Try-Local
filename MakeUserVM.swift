
//  MakeUserVM.swift
//  TryLocal
//
//  Created by 시모니의 맥북 on 5/23/25.


import UIKit
import Combine
import Alamofire

class MakeUserVM {
  
    var userType: UserType?
    var id: String?
    var pw: String?
    var pw2: String?
    var nickName: String?
    
    var farmName: String?
    var farmAdress: String?
    var farmCEOname: String?
    var farmOpenDate: String?
    var farmBusinessNumber: String?
    
    @Published var isEnabeldExistIDBtn_2p: Bool = false
    @Published var continueBtnIsHidden_2p: Bool = true
    @Published var continueBtnIsHidden_3p_Customer: Bool = true
    @Published var isEnabeldExistNicknameBtn_3p_Customer: Bool = false
    @Published var continueBtnIsHidden_3p_Farmer: Bool = true
    @Published var continueBtnIsHidden_5p_Farmer: Bool = true
    @Published var isvalidCEO: Bool? = nil
    @Published var isDuplicateBusinessNumber: Bool? = nil
    
    @Published var addressList: [Juso] = []
    @Published var selectedRoadAddress: String?  // 선택된 도로명 주소 저장 변수
    
        enum UserType: Int {
        case customer = 0
        case farmer = 1
    }
    
    //MARK: - 유효성검사
    func isPwValid() -> Bool {
        guard let pw = pw else { return false }
        
        // 8자리 이상
        guard pw.count >= 8 else { return false }
        
        // 한글 포함 여부 (있으면 false)
        let containsKorean = pw.range(of: "[가-힣]", options: .regularExpression) != nil
        guard !containsKorean else { return false }
        
        // 영문자 포함 여부
        let containsLetter = pw.range(of: "[A-Za-z]", options: .regularExpression) != nil
        
        // 숫자 포함 여부
        let containsNumber = pw.range(of: "[0-9]", options: .regularExpression) != nil
        
        // 영어와 숫자만 허용 (정규식으로 전체 확인)
        let isOnlyAlphanumeric = pw.range(of: "^[A-Za-z0-9]+$", options: .regularExpression) != nil
        
        return containsLetter && containsNumber && isOnlyAlphanumeric
    }
    
    func isIdValid() -> Bool {
        guard let id = id else { return false }
        
        // 8자리 이상
        guard id.count >= 8 else { return false }
        
        // 한글 포함 여부 (있으면 false)
        let containsKorean = id.range(of: "[가-힣]", options: .regularExpression) != nil
        guard !containsKorean else { return false }
        
        // 영문자 포함 여부
        let containsLetter = id.range(of: "[A-Za-z]", options: .regularExpression) != nil
        
        // 숫자 포함 여부
        let containsNumber = id.range(of: "[0-9]", options: .regularExpression) != nil
        
        // 영어와 숫자만 허용
        let isOnlyAlphanumeric = id.range(of: "^[A-Za-z0-9]+$", options: .regularExpression) != nil
        
        return containsLetter && containsNumber && isOnlyAlphanumeric
    }
    
    // 비밀번호 일치 검사
    func isPasswordMatched() -> Bool {
        return pw == pw2
    }
    
    func isNickNameValid() -> Bool {
        guard let nickname = nickName else { return false }
        
        // 2글자 이상인지 확인
        guard nickname.count >= 2 else { return false }
        
        // 한글만 포함되어 있는지 정규식 검사
        let koreanRegex = "^[가-힣]+$"
        let isKoreanOnly = nickname.range(of: koreanRegex, options: .regularExpression) != nil
        
        return isKoreanOnly
    }
    
    //MARK: - TextField 빈칸 검사
    func checkIsEmptyID() {
        if (id ?? "").isEmpty {
            print("checkIsEmptyID() - called ID가 비어있습니다.")
            isEnabeldExistIDBtn_2p = false
        } else {
            print("checkIsEmptyID() - called ID가 존재합니다.")
            isEnabeldExistIDBtn_2p = true
        }
    }
    
    func checkIsEmptyID_PW() {
        if (id ?? "").isEmpty || (pw ?? "").isEmpty || (pw2 ?? "").isEmpty {
            print("빈칸이 있습니다.")
            //이때는 계속하기 버튼 isHidden = true
            continueBtnIsHidden_2p = true
            
        } else {
            print("모든 텍스트 필드가 존재합니다.")
            //이때는 계속하기 버튼 isHidden = false
            continueBtnIsHidden_2p = false
        }
    }
    
    func checkIsEmptyNickName() {
        if (nickName ?? "").isEmpty {
            print("checkIsEmptyNickName() - called 닉네임이 비어있습니다.")
            continueBtnIsHidden_3p_Customer = true
            isEnabeldExistNicknameBtn_3p_Customer = false
        } else {
            print("checkIsEmptyNickName() - called 닉네임이 존재합니다.")
            continueBtnIsHidden_3p_Customer = false
            isEnabeldExistNicknameBtn_3p_Customer = true
        }
    }
    
    func checkIsEmptyFarmInfo() {
        if (farmName ?? "").isEmpty || (selectedRoadAddress ?? "").isEmpty{
            print("checkIsEmptyFarmInfo() - called 농장 정보에 빈칸이 있습니다.")
            continueBtnIsHidden_3p_Farmer = true
        } else {
            print("checkIsEmptyFarmInfo() - called 농장 정보에 빈칸이 없습니다.")
            continueBtnIsHidden_3p_Farmer = false
        }
    }
    
    func checkCEOInfo() {
        if (farmCEOname ?? "").isEmpty || (farmOpenDate ?? "").isEmpty || (farmBusinessNumber ?? "").isEmpty {
            print("checkCEOInfo() - called 대표자명 , 개업일자 , 사업자번호 중 빈칸이 있습니다")
            continueBtnIsHidden_5p_Farmer = true
        } else {
            print("checkCEOInfo() - called 대표자명 , 개업일자 , 사업자번호 중 빈칸이 없습니다")
            continueBtnIsHidden_5p_Farmer = false
        }
    }
    
    //MARK: - API 관련
    
    func signUp_tourist_API(userType: UserType , accountID: String, password: String , name: String) {
        let url = "https://we-did-this.com/accounts/signup"
        let parameters: [String: Any] = [
            "user_type": userType.rawValue,
            "account_id": accountID,
            "password": password,
            "name": name,
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
        .responseJSON { response in
            switch response.result {
            case .success(let value):
                print("✅ 회원가입 성공:", value)
            case .failure(let error):
                print("❌ 회원가입 실패:", error)
                if let data = response.data,
                   let errorMessage = String(data: data, encoding: .utf8) {
                    print("📩 서버 응답:", errorMessage)
                }
            }
        }
    }
    
    //농부 사용 안하기로함
//    func signUp_farmer_API(userType: UserType , accountID: String, password: String , farmName: String , farmAdress:String , farmCEOName: String , openDate: String , businessRegNumber: String) {
//        let url = "http://3.37.172.197:8000/accounts/signup"
//        
//        let parameters: [String: Any] = [
//            "user_type": userType.rawValue,
//            "account_id": accountID,
//            "password": password,
//            "name": farmName,
//            "farm_address": farmAdress,
//            "representative_name": farmCEOName,
//            "open_date": openDate,
//            "business_reg_number": businessRegNumber
//        ]
//        
//        let headers: HTTPHeaders = [
//            "Content-Type": "application/json"
//        ]
//        
//        AF.request(url,
//                   method: .post,
//                   parameters: parameters,
//                   encoding: JSONEncoding.default,
//                   headers: headers)
//        .validate()
//        .responseJSON { response in
//            switch response.result {
//            case .success(let value):
//                print("✅ 회원가입 성공:", value)
//            case .failure(let error):
//                print("❌ 회원가입 실패:", error)
//                if let data = response.data,
//                   let errorMessage = String(data: data, encoding: .utf8) {
//                    print("📩 서버 응답:", errorMessage)
//                }
//            }
//        }
//        
//    }
    
    func checkAccountID_API(accountID: String ,  completion: @escaping (Bool) -> Void) {
        let url = "https://we-did-this.com/accounts/check_account_id"
        
        let parameters: [String: Any] = [
            "account_id": accountID
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
        .responseDecodable(of: CheckAccountIDResponse.self) { response in
            switch response.result {
            case .success(let result):
                print("✅ exists 여부: \(result.exists)")
                completion(result.exists) // true 또는 false 전달
            case .failure(let error):
                print("❌ 요청 실패: \(error)")
                completion(true) // 네트워크 오류 났을 경우 기본적으로 true (입력 허용)
            }
        }
    }
    
    func checkUserNickName_API(userType: Int, nickName: String, completion: @escaping (Bool) -> Void) {
        let url = "https://we-did-this.com/accounts/check_user_name"
        let parameters: [String: Any] = [
            "user_type": userType,
            "user_name": nickName
        ]
        
        AF.request(url,
                   method: .post,
                   parameters: parameters,
                   encoding: JSONEncoding.default,
                   headers: ["Content-Type": "application/json"])
        .validate()
        .responseDecodable(of: CheckUserNickNameResponse.self) { response in
            switch response.result {
            case .success(let result):
                print("✅ 닉네임 중복 여부:", result.exists)
                completion(result.exists)
            case .failure(let error):
                print("❌ 닉네임 중복 확인 실패:", error)
                completion(false) // 실패 시 기본값
            }
        }
    }
    //⬇️ SearchAdressVC 에서 사용
//    func searchAddressList_API(keyword: String, completion: (([Juso]) -> Void)? = nil) {
//        let url = "https://business.juso.go.kr/addrlink/addrLinkApi.do"
//        
//        let parameters: [String: String] = [
//            "confmKey": "U01TX0FVVEgyMDI1MDYwNTIxMTQxOTExNTgyMjM=",
//            "currentPage": "1",
//            "countPerPage": "20",
//            "keyword": keyword,
//            "resultType": "json"
//        ]
//        
//        AF.request(url,
//                   method: .post,
//                   parameters: parameters,
//                   encoder: URLEncodedFormParameterEncoder.default)
//        .validate()
//        .responseDecodable(of: JusoResponse.self) { [weak self] response in
//            switch response.result {
//            case .success(let data):
//                if data.results.common.errorCode == "0" {
//                    DispatchQueue.main.async {
//                        self?.addressList = data.results.juso
//                        completion?(data.results.juso)
//                    }
//                } else {
//                    print("오류: \(data.results.common.errorMessage)")
//                    completion?([])
//                }
//            case .failure(let error):
//                print("❌ 네트워크 오류: \(error)")
//                completion?([])
//            }
//        }
//    }
//
    
    // 농부 사용 안하기로함
//    func validateBusinessInfo_API(b_no: String, start_dt: String, p_nm: String) {
//        let baseURL = "http://api.odcloud.kr/api/nts-businessman/v1/validate"
//        let serviceKey = "HikDvjiiw0tsID%2FKw%2FTyvjcZdw0XHRzX%2BORoXASR5RYey%2B5wT8XzJAPxfgGO%2BfDFhGrZ5bqT2pGbmWCd6WJ1ag%3D%3D"
//        let requestURL = "\(baseURL)?serviceKey=\(serviceKey)&returnType=JSON"
//        
//        let parameters: [String: Any] = [
//            "businesses": [
//                [
//                    "b_no": b_no,
//                    "start_dt": start_dt,
//                    "p_nm": p_nm
//                ]
//            ]
//        ]
//        
//        AF.request(requestURL,
//                   method: .post,
//                   parameters: parameters,
//                   encoding: JSONEncoding.default,
//                   headers: ["Content-Type": "application/json"])
//        .validate()
//        .responseDecodable(of: BusinessValidationResponse.self) { [weak self] response in
//            switch response.result {
//            case .success(let result):
//                if let validCode = result.data.first?.valid {
//                    DispatchQueue.main.async {
//                        self?.isvalidCEO = (validCode == "01")
//                        print(validCode == "01" ? "✅ 유효한 사업자입니다" : "❌ 유효하지 않은 사업자입니다")
//                    }
//                } else {
//                    print("❌ 응답에 데이터가 없습니다")
//                }
//            case .failure(let error):
//                print("❌ 네트워크 오류: \(error)")
//            }
//        }
//    }
//
    // 농부 안하기로함.
//    func checkDuplicateBusinessNumber_API(_ number: String) {
//        let url = "http://3.37.172.197:8000/accounts/check_business_reg_number"
//        let parameters: [String: Any] = ["business_reg_number": number]
//        
//        AF.request(url,
//                   method: .post,
//                   parameters: parameters,
//                   encoding: JSONEncoding.default,
//                   headers: ["Content-Type": "application/json"])
//        .validate()
//        .responseDecodable(of: DuplicateCheckResponse.self) { [weak self] response in
//            switch response.result {
//            case .success(let result):
//                print("✅ 중복 확인 응답: \(result.exists)")
//                DispatchQueue.main.async {
//                    self?.isDuplicateBusinessNumber = result.exists
//                }
//            case .failure(let error):
//                print("❌ 중복 확인 실패: \(error)")
//                DispatchQueue.main.async {
//                    self?.isDuplicateBusinessNumber = nil // 실패 시 nil
//                }
//            }
//        }
//    }
    
    
    //MARK: - 응답 Struck
    
    struct CheckAccountIDResponse: Decodable {
        let exists: Bool
    }
    
    struct CheckUserNickNameResponse: Decodable {
        let exists: Bool
    }
    
    struct BusinessValidationResponse: Decodable {
        let data: [BusinessValidationData]
    }
    
    struct BusinessValidationData: Decodable {
        let valid: String
    }
    
    //⬇️ SearchAdressVC 에서 사용
//    struct Juso: Decodable {
//        let roadAddr: String       // 도로명 주소
//        let jibunAddr: String      // 지번 주소
//        let zipNo: String          // 우편번호
//    }
//    
//    struct JusoResponse: Decodable {
//        let results: Results
//        
//        struct Results: Decodable {
//            let common: Common
//            let juso: [Juso]
//            
//            struct Common: Decodable {
//                let errorMessage: String
//                let errorCode: String
//                let totalCount: String
//            }
//        }
//    }
//    
    struct DuplicateCheckResponse: Decodable {
        let exists: Bool
    }
    
    //MARK: - 메모리 해제
    deinit {
        print("🧹 MakeUserVM 메모리 해제")
    }
    
}

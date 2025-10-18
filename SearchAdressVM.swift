//
//  SearchAdressVM.swift
//  Try-Local
//
//  Created by 시모니의 맥북 on 8/31/25.
//

import Foundation
import Combine
import Alamofire

class SearchAdressVM {
    var isStartAdressMode: Bool = true // 출발지 찾으러 온건지 true , 숙소찾으러온건지 false
    @Published var addressList: [Juso] = []
   
    
    func searchAddressList_API(keyword: String, completion: (([Juso]) -> Void)? = nil) {
        let url = "https://business.juso.go.kr/addrlink/addrLinkApi.do"
        
        let parameters: [String: String] = [
            "confmKey": "U01TX0FVVEgyMDI1MDYwNTIxMTQxOTExNTgyMjM=",
            "currentPage": "1",
            "countPerPage": "20",
            "keyword": keyword,
            "resultType": "json"
        ]
        
        AF.request(url,
                   method: .post,
                   parameters: parameters,
                   encoder: URLEncodedFormParameterEncoder.default)
        .validate()
        .responseDecodable(of: JusoResponse.self) { [weak self] response in
            switch response.result {
            case .success(let data):
                if data.results.common.errorCode == "0" {
                    DispatchQueue.main.async {
                        self?.addressList = data.results.juso
                        completion?(data.results.juso)
                    }
                } else {
                    print("오류: \(data.results.common.errorMessage)")
                    completion?([])
                }
            case .failure(let error):
                print("❌ 네트워크 오류: \(error)")
                completion?([])
            }
        }
    }
}

struct Juso: Decodable {
    let roadAddr: String       // 도로명 주소
    let jibunAddr: String      // 지번 주소
    let zipNo: String          // 우편번호
}

struct JusoResponse: Decodable {
    let results: Results
    
    struct Results: Decodable {
        let common: Common
        let juso: [Juso]
        
        struct Common: Decodable {
            let errorMessage: String
            let errorCode: String
            let totalCount: String
        }
    }
}

//
//  MakeRuteSelf1VM.swift
//  Try-Local
//
//  Created by 시모니의 맥북 on 8/31/25.
//

import Foundation
import Alamofire

class MakeRuteSelf1VM {
    var token: String = ""
    var q1: Int = 0
    var q2: Int = 0
    var q3: Int?
    var startDate: String = ""
    var endDate: String = ""
    var userName: String = ""
    // ✅ 서버로부터 받은 submission_id 저장용
    var submissionID: Int = 0
    
    func todayDateFormatter(selectDate: Date) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        let start = selectDate
        let dateString = formatter.string(from: start)
        startDate = dateString
        endDate = dateString
    }
    
    func overnightDateFormatter(selectDate: Date) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        let start = selectDate
        let dateString = formatter.string(from: start)
        startDate = dateString
        
        if let end = Calendar.current.date(byAdding: .day, value: 1, to: start) {
            endDate = formatter.string(from: end)
        }
        
    }
    
    //MARK: - API 호출
    func sendRouteRequest(q1: Int , q2: Int, q3: Int? = nil, startDate: String, endDate: String, completion: @escaping () -> Void) {
        let url = "https://we-did-this.com/route/result"
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]
        
        let params = RouteRequest(
            q1: q1,
            q2: q2,
            q3: nil,
            start_date: startDate,
            end_date: endDate
        )
        
        AF.request(url,
                   method: .post,
                   parameters: params,
                   encoder: JSONParameterEncoder.default,
                   headers: headers)
        .validate()
        .responseString { response in
            print("서버 원본 응답: \(response.value ?? "")")
        }
        .responseDecodable(of: RouteResponse.self) { [weak self] response in
            switch response.result {
            case .success(let data):
                print("서버 응답: \(data)")
                
                       // ✅ submission_id 저장
                       let submissionID = data.submission_id
                       self?.submissionID = submissionID
                       
                completion()
                
            case .failure(let error):
                print("에러 발생: \(error)")
            }
        }
    }
}

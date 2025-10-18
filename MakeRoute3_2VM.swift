//
//  MakeRoute3_2VM.swift
//  Try-Local
//
//  Created by 시모니의 맥북 on 8/31/25.
//

import Foundation
import Alamofire

class MakeRoute3_2VM {
    var token: String = ""
    var q1: Int = 0
    var q2: Int = 0
    var q3: Int = 0
    var startDate: String = ""
    var endDate: String = ""
    
    var names: [String] = []
    var latitudes: [String] = []
    var longitudes: [String] = []
    var addresses: [String] = []
    var imgURLs: [String] = []
    var types: [String] = []
    var orders: [String] = []
    
    var submissionID: Int = 0
    
    func todayDateFormatter(selectDate: Date) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        let start = selectDate
        let dateString = formatter.string(from: start)
        startDate = dateString
        endDate = dateString
    }
    
    //MARK: - API 호출
    func sendRouteRequest(q1: Int , q2: Int, q3: Int, startDate: String, endDate: String, completion: @escaping () -> Void) {
        let url = "https://we-did-this.com/route/result"
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]
        
        let params = RouteRequest(
            q1: q1,
            q2: q2,
            q3: q3,
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
                guard let self = self else { return }
                self.submissionID = data.submission_id
                print("서버 응답: \(data)")
                // 배열 초기화
                self.names.removeAll()
                self.latitudes.removeAll()
                self.longitudes.removeAll()
                self.addresses.removeAll()
                self.imgURLs.removeAll()
                self.types.removeAll()
                self.orders.removeAll()
                
                // 서버 데이터 저장
                for item in data.route?.routes ?? [] {
                    self.names.append(item.name)
                    self.latitudes.append(String(item.latitude))
                    self.longitudes.append(String(item.longitude))
                    self.addresses.append(item.address)
                    self.imgURLs.append(item.image_url ?? "")
                    self.types.append(item.type_label)
                    self.orders.append(String(item.order))
                }
                
                completion()
                
            case .failure(let error):
                print("에러 발생: \(error)")
            }
        }
    }

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
        .response { response in
            switch response.result {
            case .success:
                print("성공")
            case .failure(let error):
                print("에러 발생:", error)
            }
        }
        
        
    }

    
}

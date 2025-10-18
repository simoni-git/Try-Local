//
//  Makeruteself_AddPlaceVM.swift
//  Try-Local
//
//  Created by 시모니의 맥북 on 8/31/25.
//

import Foundation
import Alamofire

class Makeruteself_AddPlaceVM {
    var token: String = ""
    // ✅ 뷰컨트롤러에 데이터 갱신 알림용 콜백
    var onDataUpdated: (() -> Void)?
    // 데이터 저장
    var routeItems: [getFullListRouteItem] = []
    //var selectedIndexPaths: [IndexPath] = []
    // 선택된 셀 관리
    var selectedItems: [getFullListRouteItem] = []
    var isTodayRoute: Bool = true // 당일치기는 true , 1박2일은 false
    //MARK: - API func
    func fetchItemList() {
        let url = "https://we-did-this.com/route/select"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]
        
        AF.request(url, method: .get, headers: headers)
            .validate()
            .responseDecodable(of: [getFullListRouteItem].self) { [weak self] response in
                guard let self = self else { return }
                
                switch response.result {
                case .success(let items):
                    print("✅ 데이터 받음:")
                    for item in items {
                        print("Name: \(item.name ?? "")")
                        print("Type: \(item.type ?? "")")
                        print("Label: \(item.type_label ?? "")")
                        print("Description: \(item.description ?? "")")
                        print("Image: \(item.image ?? "")")
                        print("---------------------------")
                    }
                    
                    // 데이터 저장
                    self.routeItems = items
                    
                    // UI 갱신 알리기
                    DispatchQueue.main.async {
                        self.onDataUpdated?()
                    }
                    
                case .failure(let error):
                    print("❌ 에러 발생:", error.localizedDescription)
                }
            }
    }
}

struct getFullListRouteItem: Codable {
    let name: String?
    let type: String?
    let type_label: String?
    let description: String?
    let image: String?
    
    var address: String? = nil
    var latitude: Double? = nil
    var longitude: Double? = nil
    var order: Int? = nil
}


//
//  HomeDetailResponseStruct.swift
//  Try-Local
//
//  Created by 시모니의 맥북 on 8/19/25.
//

import Foundation

//MARK: - HomeDetailResponseStruct 응답 모델 정의 (Detail 모든 VC 에서 사용)
struct PlaceDetailResponse: Codable {
    let id: Int?
    let type: String?
    let name: String?
    let description: String?
    let address: String?
    let latitude: String?
    let longitude: String?
    let contact: String?
    let link: String?
    let period: String?
    let place: String?
    let organizer: String?
    let parking: String?
    let sales: String?
    let toilet: String?
    let coffee: String?
    let createdAt: String?
    let updatedAt: String?
    let images: [String]?
    let isFavorite: Bool? // 즐겨찾기 새로추가했음
    
    enum CodingKeys: String, CodingKey {
        case id, type, name, description, address, latitude, longitude, contact, link, period, place, organizer, parking, sales, toilet, coffee
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case images
        case isFavorite = "is_favorite" // 즐겨찾기 새로추가했음
    }
    
}
// MARK:  Null-safe  Properties
extension PlaceDetailResponse {
    var safeID: Int { id ?? 0 }
    var safeType: String { type ?? "" }
    var safeName: String { name ?? "" }
    var safeDescription: String { description ?? "" }
    var safeAddress: String { address ?? "" }
    var safeLatitude: String { latitude ?? "" }
    var safeLongitude: String { longitude ?? "" }
    var safeContact: String { contact ?? "" }
    var safeLink: String { link ?? "" }
    var safePeriod: String { period ?? "" }
    var safePlace: String { place ?? "" }
    var safeOrganizer: String { organizer ?? "" }
    var safeParking: String { parking ?? "" }
    var safeSales: String { sales ?? "" }
    var safeToilet: String { toilet ?? "" }
    var safeCoffee: String { coffee ?? "" }
    var safeCreatedAt: String { createdAt ?? "" }
    var safeUpdatedAt: String { updatedAt ?? "" }
    var safeImages: [String] { images ?? [] }
    var safeIsFavorite: Bool { isFavorite ?? false } // 즐겨찾기 새로추가했음
}
 //MARK: -  좋아요 누르기 서버 응답 모델 구조체
struct FavoriteResponse: Decodable {
    let favorited: Bool
    let place: String
}

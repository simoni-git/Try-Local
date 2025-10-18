//
//  Mp_FootPrintVM.swift
//  Try-Local
//
//  Created by 시모니의 맥북 on 9/3/25.
//

import Foundation

class Mp_FootPrintVM {
    var token: String
    init(token: String) {
        self.token = token
    }
    var items: [TripHistoryItem] = []
    
    // ✅ 오늘 이전 날짜만 필터링
    var pastItems: [TripHistoryItem] {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let today = Calendar.current.startOfDay(for: Date())
        
        return items.filter { item in
            let startDateString = item.date.split(separator: "~").first?.trimmingCharacters(in: .whitespaces) ?? ""
            guard let startDate = formatter.date(from: startDateString) else { return false }
            return startDate < today
        }
    }
    
}

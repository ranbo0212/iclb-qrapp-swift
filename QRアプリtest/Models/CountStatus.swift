//
//  CountStatus.swift
//  QRアプリtest
//
//  Created by 蘭搏 on 2021/07/12.
//

import Foundation

//サーバーから取得したJSON集計情報をデコードする為のモデルを定義する
struct CountStatus: Hashable, Codable, Identifiable {
    
    var id: UUID
    var eventId: Int                   //チケット種類ID
    var dateId: Int                    //時間帯別イベントID
    var totalVisitedWebSaledSeat: Int  //Web購入来場者数
    var totalWebSaledSeat: Int         //Web購入数
    var totalVisitedSeat: Int          //
    var totalSeat: Int                 //
    var status: Int                    //
    var result: String                 //
    var message: String                //
    var error: String                  //
    
    enum CodingKeys: String, CodingKey {

        case id
        case eventId = "EVENTID"
        case dateId = "DATEID"
        case totalVisitedWebSaledSeat
        case totalWebSaledSeat
        case totalVisitedSeat
        case totalSeat
        case status
        case result
        case message
        case error
        
    }
    
    init() {
        
        self.id = UUID()
        self.eventId = 0
        self.dateId = 0
        self.totalVisitedWebSaledSeat = 0
        self.totalWebSaledSeat = 0
        self.totalVisitedSeat = 0
        self.totalSeat = 0
        self.status = 0
        self.result = ""
        self.message = ""
        self.error = ""
    }

    init(from decoder: Decoder) throws {
        
        let keyedContainer = try decoder.container(keyedBy: CodingKeys.self)

        id = try (keyedContainer.decodeIfPresent(UUID.self, forKey: .id) ?? UUID())
        eventId = try (keyedContainer.decodeIfPresent(Int.self, forKey: .eventId) ?? 0)
        dateId = try (keyedContainer.decodeIfPresent(Int.self, forKey: .dateId) ?? 0)
        totalVisitedWebSaledSeat = try (keyedContainer.decodeIfPresent(Int.self, forKey: .totalVisitedWebSaledSeat) ?? 0)
        totalWebSaledSeat = try (keyedContainer.decodeIfPresent(Int.self, forKey: .totalWebSaledSeat) ?? 0)
        totalVisitedSeat = try (keyedContainer.decodeIfPresent(Int.self, forKey: .totalVisitedSeat) ?? 0)
        totalSeat = try (keyedContainer.decodeIfPresent(Int.self, forKey: .totalSeat) ?? 0)
        status = try (keyedContainer.decodeIfPresent(Int.self, forKey: .status) ?? 0)
        result = try (keyedContainer.decodeIfPresent(String.self, forKey: .result) ?? "")
        message = try (keyedContainer.decodeIfPresent(String.self, forKey: .message) ?? "")
        error = try (keyedContainer.decodeIfPresent(String.self, forKey: .error) ?? "")
    }
}

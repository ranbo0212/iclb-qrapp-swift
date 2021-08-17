//
//  Event.swift
//  QRアプリtest
//
//  Created by 蘭搏 on 2021/07/12.
//

import Foundation

//ログイン後、サーバーから取得したイベント情報をデコードする為のモデルを定義する。
struct Event: Hashable, Codable, Identifiable {
    
    var id: UUID
    var eventId: Int              //チケット種類ID
    var dateId: Int               //時間帯別イベントID
    var image: String             //背景画像
    var eventName: String         //チケット種類名
    var facilityName: String      //会場名（HINORIでは使用しない）
    var startDate: String         //時間帯別イベント開始日
    var startTime: String         //時間帯別イベント開始時刻
    var openTime: String          //時間帯別イベント入場開始時刻
    var endDate: String           //時間帯別イベント終了日
    var endTime: String           //時間帯別イベント終了時刻
    var statusTakesPlace: Int     //イベント開催場所（HINORIでは使用しない）
    var totalSeat: Int            //全席数
    var isToday: Bool             //本日：true,本日以外：false
    var available: Bool           //取得成功：true,取得失敗：false
    var error: String             //エラーメッセージ
    
    enum CodingKeys: String, CodingKey {
        case id
        case eventId = "EVENTID"
        case dateId = "DATEID"
        case image
        case eventName = "EVENTNAME"
        case facilityName = "FACILITYNAME"
        case startDate = "STARTDATE"
        case startTime = "STARTTIME"
        case openTime = "OPENTIME"
        case endDate = "ENDDATE"
        case endTime = "ENDTIME"
        case statusTakesPlace = "STATUS_TAKES_PLACE"
        case totalSeat = "TOTALSEAT"
        case isToday
        case available
        case error
    }
    
    init() {
        self.id = UUID()
        self.eventId = 0
        self.dateId = 0
        self.image = ""
        self.eventName = ""
        self.facilityName = ""
        self.startDate = ""
        self.startTime = ""
        self.openTime = ""
        self.endDate = ""
        self.endTime = ""
        self.statusTakesPlace = 0
        self.totalSeat = 0
        self.isToday = false
        self.available = false
        self.error = ""
    }

    //JSONデータをデコードする
    init(from decoder: Decoder) throws {
        
        let keyedContainer = try decoder.container(keyedBy: CodingKeys.self)

        id = try (keyedContainer.decodeIfPresent(UUID.self, forKey: .id) ?? UUID())
        eventId = try (keyedContainer.decodeIfPresent(Int.self, forKey: .eventId) ?? 0)
        dateId = try (keyedContainer.decodeIfPresent(Int.self, forKey: .dateId) ?? 0)
        eventName = try (keyedContainer.decodeIfPresent(String.self, forKey: .eventName) ?? "-")
        facilityName = try (keyedContainer.decodeIfPresent(String.self, forKey: .facilityName) ?? "-")
        startDate = try (keyedContainer.decodeIfPresent(String.self, forKey: .startDate) ?? "-")
        startTime = try (keyedContainer.decodeIfPresent(String.self, forKey: .startTime) ?? "-")
        openTime = try (keyedContainer.decodeIfPresent(String.self, forKey: .openTime) ?? "-")
        endDate = try (keyedContainer.decodeIfPresent(String.self, forKey: .endDate) ?? "-")
        endTime = try (keyedContainer.decodeIfPresent(String.self, forKey: .endTime) ?? "-")
        statusTakesPlace = try (keyedContainer.decodeIfPresent(Int.self, forKey: .statusTakesPlace) ?? 0)
        totalSeat = try (keyedContainer.decodeIfPresent(Int.self, forKey: .totalSeat) ?? 0)
        error = try (keyedContainer.decodeIfPresent(String.self, forKey: .error) ?? "")
        
        //イベント開始日startDateは当日の場合true、当日ではない場合false
        //trueの場合、イベント一覧のイベント画面に赤い点が付けられる。
        if let isToday = try keyedContainer.decodeIfPresent(Bool.self, forKey: .isToday) {
            self.isToday = isToday
        } else {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy/MM/dd"
            dateFormatter.locale = Locale(identifier: "ja_JP")
            let today = dateFormatter.string(from: Date())
            if startDate == today {
                self.isToday = true
            } else {
                self.isToday = false
            }
        }
        
        //当日の場合true、当日ではない場合false
        //trueの場合イベント詳細画面からQRスキャン画面を開けられる。
        if let available = try keyedContainer.decodeIfPresent(Bool.self, forKey: .available) {
            self.available = available
        } else {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy/MM/dd"
            dateFormatter.locale = Locale(identifier: "ja_JP")
            let today = dateFormatter.string(from: Date())
            if startDate == today {
                self.available = true
            } else {
                self.available = false
            }
        }
        
        //当日の場合背景画像はevent-1
        //過去の場合event-0
        //将来の場合event-2
        if let image = try keyedContainer.decodeIfPresent(String.self, forKey: .image) {
            self.image = image
        } else {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy/MM/dd"
            dateFormatter.locale = Locale(identifier: "ja_JP")
            let today = Date()
            let startDate = dateFormatter.date(from: self.startDate)
            let order = Calendar.current.compare(today, to: startDate ?? Date(timeIntervalSinceReferenceDate: 0), toGranularity: .day)
            if order == .orderedSame {
                self.image = "event-1"
            } else if order == .orderedDescending {
                self.image = "event-0"
            } else {
                self.image = "event-2"
            }
        }
    }
}

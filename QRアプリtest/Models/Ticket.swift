//
//  Ticket.swift
//  QRアプリtest
//
//  Created by 蘭搏 on 2021/07/12.
//
import Foundation

//チケットリスト
struct Tickets: Codable{
    
    var listTicketIssued: Ticket
    var status: Int         //response結果ステータス
    var result: String      //QRコードスキャン結果(入場前QRの場合：OK、入場済み場合：INFO、違うQRコード：NG)
    var message: String     //QRコードスキャン結果文字列(resultがINFOの場合、”入場取消”/"入場済み")
    var error: String       //エラーメッセージ
    
    enum CodingKeys: String, CodingKey {
        case listTicketIssued
        case status
        case result
        case message
        case error
    }

    //初期値設定
    init() {
        self.listTicketIssued = Ticket()
        self.status = 0
        self.result = ""
        self.message = ""
        self.error = ""
    }
    
    init(from decoder: Decoder) throws {
        let keyedContainer = try decoder.container(keyedBy: CodingKeys.self)

        listTicketIssued = try (keyedContainer.decodeIfPresent(Ticket.self, forKey: .listTicketIssued) ?? Ticket())
        status = try (keyedContainer.decodeIfPresent(Int.self, forKey: .status) ?? 0)
        result = try (keyedContainer.decodeIfPresent(String.self, forKey: .result) ?? "")
        message = try (keyedContainer.decodeIfPresent(String.self, forKey: .message) ?? "")
        error = try (keyedContainer.decodeIfPresent(String.self, forKey: .error) ?? "")
    }
    
}

//チケット情報
struct Ticket: Hashable, Codable, Identifiable {
    var id: UUID
    var eventId: Int                  //チケット種類ID
    var dateId: Int                   //時間帯別イベントID
    var issuedTicketId: Int           //発券ID
    var qrCode: String                //QRコード文字列
    var disabled: Int                 //チケット無効フラグ(0:有効,1:無効)
    var issuedDateTime: String        //発券日時
    var reserveObjId: Int             //予約対象ID
    var qrFirstSendDateTime: String   //QRコード初回送信日時
    var qrLastSendDateTime: String    //QRコード最終送信日時
    var visited: Int                  //来場フラグ;0:未来場,1:来場済
    var recordDeviceNo: String        //記録端末番号
    var updateDeviceNo: String        //更新端末番号
    var updateDate: String            //更新日時
    var version: Int                  //バージョン:0から
    var reserveId: Int                //予約ID
    var statusId: String              //状態ID: 0:空席,1:予約,2:発券,3:未発券,4:入金,5:未入金,6:委託,7:完了,8:キャンセル,9:入金変更,10:仮予約
    var eventName: String             //チケット種類名
    var eventDateTime: String         //
    var status: String                //状態: 0:空席,1:予約,2:発券,3:未発券,4:入金,5:未入金,6:委託,7:完了,8:キャンセル,9:入金変更,10:仮予約
    var startDate: String             //イベント開始日
    var startTime: String             //イベント開始時間
    var endDate: String               //イベント終了日
    var endTime: String               //イベント終了時間
    var priceName: String             //料金名
    var fixedPrice: String            //標準単価
    var salesmethodId: Int            //販売方法ID
    var salesmethod: String           //販売方法
    var customerName: String          //顧客名
    var customerKana: String          //顧客カナ
    var tel: String                   //顧客電話番号
    var isLastCheckedDevice: Bool     //デバイス確認
    
    enum CodingKeys: String, CodingKey {
        case id
        case eventId = "EVENTID"
        case dateId = "DATEID"
        case issuedTicketId = "ISSUEDTICKETID"
        case qrCode = "QRCODE"
        case disabled = "DISABLED"
        case issuedDateTime = "ISSUEDDATETIME"
        case reserveObjId = "RESERVEOBJID"
        case qrFirstSendDateTime = "QRFIRSTSENDDATETIME"
        case qrLastSendDateTime = "QRLASTSENDDATETIME"
        case visited = "VISITED"
        case recordDeviceNo = "RECORDDEVICENO"
        case updateDeviceNo = "UPDATEDEVICENO"
        case updateDate = "UPDATEDATE"
        case version = "VERSION"
        case reserveId = "RESERVEID"
        case statusId = "STATUSID"
        case eventName = "EVENTNAME"
        case eventDateTime = "EVENTDATETIME"
        case status = "STATUS"
        case startDate = "STARTDATE"
        case startTime = "STARTTIME"
        case endDate = "ENDDATE"
        case endTime = "ENDTIME"
        case priceName = "PRICENAME"
        case fixedPrice = "FIXEDPRICE"
        case salesmethodId = "SALESMETHODID"
        case salesmethod = "SALESMETHOD"
        case customerName = "CUSTOMERNAME"
        case customerKana = "CUSTOMERKANA"
        case tel = "TEL"
        case isLastCheckedDevice
    }
    
    init() {
        self.id = UUID()
        self.eventId = 0
        self.dateId = 0
        self.issuedTicketId = 0
        self.qrCode = ""
        self.disabled = 0
        self.issuedDateTime = ""
        self.reserveObjId = 0
        self.qrFirstSendDateTime = ""
        self.qrLastSendDateTime = ""
        self.visited = 0
        self.recordDeviceNo = ""
        self.updateDeviceNo = ""
        self.updateDate = ""
        self.version = 0
        self.reserveId = 0
        self.statusId = ""
        self.eventName = ""
        self.eventDateTime = ""
        self.status = ""
        self.startDate = ""
        self.startTime = ""
        self.endDate = ""
        self.endTime = ""
        self.priceName = ""
        self.fixedPrice = ""
        self.salesmethodId = 0
        self.salesmethod = ""
        self.customerName = ""
        self.customerKana = ""
        self.tel = ""
        self.isLastCheckedDevice = false
    }

    init(from decoder: Decoder) throws {
        
        let keyedContainer = try decoder.container(keyedBy: CodingKeys.self)

        id = try (keyedContainer.decodeIfPresent(UUID.self, forKey: .id) ?? UUID())
        eventId = try (keyedContainer.decodeIfPresent(Int.self, forKey: .eventId) ?? 0)
        dateId = try (keyedContainer.decodeIfPresent(Int.self, forKey: .dateId) ?? 0)
        issuedTicketId = try (keyedContainer.decodeIfPresent(Int.self, forKey: .issuedTicketId) ?? 0)
        qrCode = try (keyedContainer.decodeIfPresent(String.self, forKey: .qrCode) ?? "-")
        disabled = try (keyedContainer.decodeIfPresent(Int.self, forKey: .disabled) ?? 0)
        issuedDateTime = try (keyedContainer.decodeIfPresent(String.self, forKey: .issuedDateTime) ?? "-")
        reserveObjId = try (keyedContainer.decodeIfPresent(Int.self, forKey: .reserveObjId) ?? 0)
        qrFirstSendDateTime = try (keyedContainer.decodeIfPresent(String.self, forKey: .qrFirstSendDateTime) ?? "-")
        qrLastSendDateTime = try (keyedContainer.decodeIfPresent(String.self, forKey: .qrLastSendDateTime) ?? "-")
        visited = try (keyedContainer.decodeIfPresent(Int.self, forKey: .visited) ?? 0)
        recordDeviceNo = try (keyedContainer.decodeIfPresent(String.self, forKey: .recordDeviceNo) ?? "-")
        updateDeviceNo = try (keyedContainer.decodeIfPresent(String.self, forKey: .updateDeviceNo) ?? "")
        updateDate = try (keyedContainer.decodeIfPresent(String.self, forKey: .updateDate) ?? "-")
        version = try (keyedContainer.decodeIfPresent(Int.self, forKey: .version) ?? 0)
        reserveId = try (keyedContainer.decodeIfPresent(Int.self, forKey: .reserveId) ?? 0)
        statusId = try (keyedContainer.decodeIfPresent(String.self, forKey: .statusId) ?? "-")
        eventName = try (keyedContainer.decodeIfPresent(String.self, forKey: .eventName) ?? "-")
        eventDateTime = try (keyedContainer.decodeIfPresent(String.self, forKey: .eventDateTime) ?? "-")
        status = try (keyedContainer.decodeIfPresent(String.self, forKey: .status) ?? "-")
        startDate = try (keyedContainer.decodeIfPresent(String.self, forKey: .startDate) ?? "-")
        startTime = try (keyedContainer.decodeIfPresent(String.self, forKey: .startTime) ?? "-")
        endDate = try (keyedContainer.decodeIfPresent(String.self, forKey: .endDate) ?? "-")
        endTime = try (keyedContainer.decodeIfPresent(String.self, forKey: .endTime) ?? "-")
        priceName = try (keyedContainer.decodeIfPresent(String.self, forKey: .priceName) ?? "-")
        fixedPrice = try (keyedContainer.decodeIfPresent(String.self, forKey: .fixedPrice) ?? "")
        salesmethodId = try (keyedContainer.decodeIfPresent(Int.self, forKey: .salesmethodId) ?? 0)
        salesmethod = try (keyedContainer.decodeIfPresent(String.self, forKey: .salesmethod) ?? "")
        
        customerName = try (keyedContainer.decodeIfPresent(String.self, forKey: .customerName) ?? "-")
        customerKana = try (keyedContainer.decodeIfPresent(String.self, forKey: .customerKana) ?? "-")
        
        if let customerKana = try keyedContainer.decodeIfPresent(String.self, forKey: .customerKana) {
                    if customerKana == "＜WEB購入者＞" {
                        self.customerKana = "-"
                    } else {
                        self.customerKana = customerKana
                    }
                } else {
                    self.customerKana = "-"
                }
                
                if let tel = try keyedContainer.decodeIfPresent(String.self, forKey: .tel) {
                    if tel == "99999999999" {
                        self.tel = "-"
                    } else {
                        self.tel = tel
                    }
                } else {
                    self.tel = "-"
                }
        
        if let isLastCheckedDevice = try keyedContainer.decodeIfPresent(Bool.self, forKey: .isLastCheckedDevice) {
            self.isLastCheckedDevice = isLastCheckedDevice
        } else {
            if updateDeviceNo.isEmpty {
                self.isLastCheckedDevice = false
            } else {
                let deviceId = Utilities.getDeviceID()
                if updateDeviceNo == deviceId {
                    self.isLastCheckedDevice = true
                } else {
                    self.isLastCheckedDevice = false
                }
            }
        }
    }
}

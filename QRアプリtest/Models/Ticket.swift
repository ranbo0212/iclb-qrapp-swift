//
//  Ticket.swift
//  QRアプリtest
//
//  Created by 蘭搏 on 2021/07/12.
//

import Foundation

//イベント一覧から時間帯を選んで、サーバーからその時間帯のJSONチケット情報をデコードする為のモデルを定義する。
struct Tickets: Codable{
    
    var listTicketIssued: Ticket
    var status: Int
    var result: String
    var message: String
    var error: String
    
    enum CodingKeys: String, CodingKey {
        case listTicketIssued
        case status
        case result
        case message
        case error
    }
    
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

//チケット
struct Ticket: Hashable, Codable, Identifiable {
    var id: UUID
    var eventId: Int
    var dateId: Int
    var issuedTicketId: Int
    var qrCode: String
    var disabled: Int
    var issuedDateTime: String
    var reserveObjId: Int
    var qrFirstSendDateTime: String
    var qrLastSendDateTime: String
    var visited: Int
    var recordDeviceNo: String
    var updateDeviceNo: String
    var updateDate: String
    var version: Int
    var reserveId: Int
    var statusId: String
    var customerName: String
    var eventName: String
    var facilityName: String
    var eventDateTime: String
    var status: String
    var startDate: String
    var startTime: String
    var endDate: String
    var endTime: String
    var seatName: String
    var priceName: String
    var floor: String
    var seatRow: String
    var seatNo: String
    
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
        case customerName = "CUSTOMERNAME"
        case eventName = "EVENTNAME"
        case facilityName = "FACILITYNAME"
        case eventDateTime = "EVENTDATETIME"
        case status = "STATUS"
        case startDate = "STARTDATE"
        case startTime = "STARTTIME"
        case endDate = "ENDDATE"
        case endTime = "ENDTIME"
        case seatName = "SEATNAME"
        case priceName = "PRICENAME"
        case floor = "FLOOR"
        case seatRow = "SEATROW"
        case seatNo = "SEATNO"
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
        self.customerName = ""
        self.eventName = ""
        self.facilityName = ""
        self.eventDateTime = ""
        self.status = ""
        self.startDate = ""
        self.startTime = ""
        self.endDate = ""
        self.endTime = ""
        self.seatName = ""
        self.priceName = ""
        self.floor = ""
        self.seatRow = ""
        self.seatNo = ""
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
        updateDeviceNo = try (keyedContainer.decodeIfPresent(String.self, forKey: .updateDeviceNo) ?? "-")
        updateDate = try (keyedContainer.decodeIfPresent(String.self, forKey: .updateDate) ?? "-")
        version = try (keyedContainer.decodeIfPresent(Int.self, forKey: .version) ?? 0)
        reserveId = try (keyedContainer.decodeIfPresent(Int.self, forKey: .reserveId) ?? 0)
        statusId = try (keyedContainer.decodeIfPresent(String.self, forKey: .statusId) ?? "-")
        customerName = try (keyedContainer.decodeIfPresent(String.self, forKey: .customerName) ?? "-")
        eventName = try (keyedContainer.decodeIfPresent(String.self, forKey: .eventName) ?? "-")
        facilityName = try (keyedContainer.decodeIfPresent(String.self, forKey: .facilityName) ?? "-")
        eventDateTime = try (keyedContainer.decodeIfPresent(String.self, forKey: .eventDateTime) ?? "-")
        status = try (keyedContainer.decodeIfPresent(String.self, forKey: .status) ?? "-")
        startDate = try (keyedContainer.decodeIfPresent(String.self, forKey: .startDate) ?? "-")
        startTime = try (keyedContainer.decodeIfPresent(String.self, forKey: .startTime) ?? "-")
        endDate = try (keyedContainer.decodeIfPresent(String.self, forKey: .endDate) ?? "-")
        endTime = try (keyedContainer.decodeIfPresent(String.self, forKey: .endTime) ?? "-")
        seatName = try (keyedContainer.decodeIfPresent(String.self, forKey: .seatName) ?? "-")
        priceName = try (keyedContainer.decodeIfPresent(String.self, forKey: .priceName) ?? "-")
        
        if let floor = try keyedContainer.decodeIfPresent(String.self, forKey: .floor) {
            self.floor = floor.trimmingCharacters(in: .whitespacesAndNewlines)
        } else {
            self.floor = ""
        }
        
        if let seatRow = try keyedContainer.decodeIfPresent(String.self, forKey: .seatRow) {
            self.seatRow = seatRow.trimmingCharacters(in: .whitespacesAndNewlines)
        } else {
            self.seatRow = ""
        }
        
        if let seatNo = try keyedContainer.decodeIfPresent(String.self, forKey: .seatNo) {
            self.seatNo = seatNo.trimmingCharacters(in: .whitespacesAndNewlines)
        } else {
            self.seatNo = ""
        }
    }
}

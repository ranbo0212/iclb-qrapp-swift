//
//  UpdateQRCodeNetWorkManager.swift
//  QRアプリtest
//
//  Created by 蘭搏 on 2021/07/12.
//

import Foundation
import Combine
import AVFoundation

//QRコードをスキャンして、正しいQRコードであることを確認するクラスを確認する
class UpdateQRCodeNetWorkManager: ObservableObject {
    var willChange = PassthroughSubject<UpdateQRCodeNetWorkManager, Never>()
    
        //イベント情報取得ごのデータを定義する
        //レスポンス結果resultが"OK"の場合：soundIdRingOK
        //レスポンス結果resultが"INFO"、self.tickets.message ="入場取消"の場合：soundIdRingOK
        //レスポンス結果resultが"INFO"、self.tickets.message ="入場済み"の場合：soundIdRingNG
        //レスポンス結果resultが"INFO"、self.tickets.message ="入場済み","入場取消"以外の場合：soundIdRingNG
        //レスポンス結果resultが"NG"の場合：soundIdRingNG
    @Published var tickets: Tickets = Tickets() {
        willSet {
            willChange.send(self)
        }
        
        didSet {
            if (self.tickets.result == "OK") {
                sounds.stop()
                AudioServicesPlaySystemSound(sounds.soundIdRingOK)
            } else if (self.tickets.result == "INFO") {
                if (self.tickets.message == "入場取消") {
                    sounds.stop()
                    AudioServicesPlaySystemSound(sounds.soundIdRingOK)
                    AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
                } else if (self.tickets.message == "入場済み") {
                    sounds.stop()
                    AudioServicesPlaySystemSound(sounds.soundIdRingNG)
                    AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
                } else {
                    sounds.stop()
                    AudioServicesPlaySystemSound(sounds.soundIdRingNG)
                    AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
                }
                
            } else if (self.tickets.result == "NG") {
                sounds.stop()
                AudioServicesPlaySystemSound(sounds.soundIdRingNG)
                AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            } else {
                sounds.stop()
            }
        }
    }
    
    @Published var requestError: String = "" {
        willSet {
            willChange.send(self)
        }
    }
    
    @Published var requestStatus: RequestStatus = RequestStatus.Idle {
        willSet {
            willChange.send(self)
        }
    }
    
    var sounds: Sounds = Sounds()
    
        //QRコードスキャン処理
    //APIURLが間違った場合self.requestStatus = .Rejected
    //ログインしていない場合self.requestStatus = .Rejected
    //スキャン失敗(クライアント通信)：self.requestStatus = .Rejected
    //スキャン失敗(サーバー通信)：self.requestStatus = .Rejected
    //スキャン成功self.requestStatus = .Fulfilled・self.events = events
    func update(qrData: String = "", data: Event) {
        self.requestStatus = .Pending
        
        guard let url = URL(string: APIURL.QRCheckInUpdate) else {
            print("APIURLが存在しない")
            self.requestStatus = .Rejected
            return
        }
        
        if !Utilities.isAuthorized()  {
            print("ログインしていない")
            Utilities.logout()
            self.requestError = "ログインしていない"
            self.requestStatus = .Rejected
            return
        }
        
        let authString = Utilities.getToken()
        var request = URLRequest(url: url)
        let deviceId = Utilities.getDeviceID()
        let body: [String:Any] = ["eventId": data.eventId, "dateId": data.dateId, "qrCode": qrData, "qrSearchFlg": 1, "page": 1, "recordDeviceNo": deviceId]
        let finalBody = try! JSONSerialization.data(withJSONObject: body)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(authString)", forHTTPHeaderField: "Authorization")
        request.timeoutInterval = 3
        request.httpBody = finalBody
        
        URLSession.shared.dataTask(with: request) { (data, URLResponse, error) in
            
            if let error = error {
                print("クライアント側システムエラー")
                print(error)
                DispatchQueue.main.async {
                    self.requestError = "通信エラー"
                    self.requestStatus = .Rejected
                }
            }
            
            if let response = URLResponse as? HTTPURLResponse {
                print("response.statusCode = \(response.statusCode)")
                
                if response.statusCode != 200 {
                    if (response.statusCode == 205 || response.statusCode == 401) {
                        print("サーバ側システムエラー")
                        DispatchQueue.main.async {
                            self.requestError = "通信エラー"
                            self.requestStatus = .Rejected
                        }
                    } else {
                        print("サーバ側システムエラー")
                        DispatchQueue.main.async {
                            self.requestError = "通信エラー"
                            self.requestStatus = .Rejected
                        }
                    }
                }
                
                guard let data = data else { return }
                
                do {
                    let tickets = try JSONDecoder().decode(Tickets.self, from: data)
                    DispatchQueue.main.async {
                        self.tickets = tickets
                        print(self.tickets)
                        self.requestStatus = .Fulfilled
                    }
                } catch {
                    self.requestStatus = .Rejected
                    print(error)
                }
            }
        }.resume()
    }
    
    //入場取消処理
    //APIURLが間違った場合self.requestStatus = .Rejected
    //ログインしていない場合self.requestStatus = .Rejected
    //入場取消失敗(クライアント通信)：self.requestStatus = .Rejected
    //入場取消失敗(サーバー通信)：self.requestStatus = .Rejected
    //入場取消成功self.requestStatus = .Fulfilled・self.events = events
    func delete(qrData: String = "", data: Event) {
        self.requestStatus = .Pending
        
        guard let url = URL(string: APIURL.QRCheckInDelete) else {
            print("APIURLが存在しない")
            self.requestStatus = .Rejected
            return
        }
        
        if !Utilities.isAuthorized() {
            print("ログインしていない")
            self.requestError = "ログインしていない"
            self.requestStatus = .Rejected
            return
        }
        
        let authString = Utilities.getToken()
        var request = URLRequest(url: url)
        let deviceId = Utilities.getDeviceID()
        let body: [String:Any] = ["eventId": data.eventId, "dateId": data.dateId, "qrCode": qrData, "qrSearchFlg": 1, "page": 1, "recordDeviceNo": deviceId]
        let finalBody = try! JSONSerialization.data(withJSONObject: body)
        request.httpBody = finalBody
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(authString)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { (data, URLResponse, error) in
            
            if let error = error {
                print("クライアント側システムエラー")
                print(error)
                DispatchQueue.main.async {
                    self.requestError = "通信エラー"
                    self.requestStatus = .Rejected
                }
            }
            
            if let response = URLResponse as? HTTPURLResponse {
                print("response.statusCode = \(response.statusCode)")
                
                if response.statusCode != 200 {
                    if (response.statusCode == 205 || response.statusCode == 401) {
                        print("サーバ側システムエラー")
                        DispatchQueue.main.async {
                            self.requestError = "認証失敗"
                            self.requestStatus = .Rejected
                        }
                    } else {
                        print("サーバ側システムエラー")
                        DispatchQueue.main.async {
                            self.requestError = "通信エラー"
                            self.requestStatus = .Rejected
                        }
                    }
                }
                
                guard let data = data else { return }
                
                do {
                    let tickets = try JSONDecoder().decode(Tickets.self, from: data)
                    DispatchQueue.main.async {
                        self.tickets = tickets
                        print(self.tickets)
                        self.requestStatus = .Fulfilled
                    }
                } catch {
                    print(error)
                }
            }
        }.resume()
    }
    
    func initTickets() {
        DispatchQueue.main.async {
            self.requestStatus = .Idle
            self.tickets = Tickets()
        }
    }
}

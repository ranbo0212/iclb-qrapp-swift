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
    
    @Published var tickets: Tickets = Tickets() {
        willSet {
            willChange.send(self)
        }
        
        //チケットメッセージによって、ボタンの文字列を変更する
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
    
    //QRコードスキャン
    func update(qrData: String = "", data: Event) {
        self.requestStatus = .Pending
        
        //URL設定していない場合
        guard let url = URL(string: APIURL.QRCheckInUpdate) else {
            print("APIURLが存在しない")
            self.requestStatus = .Rejected
            return
        }
        
        //オフラインの場合
        if !UserDefaults.standard.isAuthorized() {
            print("ログインしていない")
            UserDefaults.standard.setIsAuthorized(value: false)
            UserDefaults.standard.setToken(value: "")
            self.requestError = "ログインしていない"
            self.requestStatus = .Rejected
            return
        }
        
        let authString = UserDefaults.standard.getToken()
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
                    print(error)
                }
            }
        }.resume()
    }
    
    func delete(qrData: String = "", data: Event) {
        self.requestStatus = .Pending
        
        guard let url = URL(string: APIURL.QRCheckInDelete) else {
            print("APIURLが存在しない")
            self.requestStatus = .Rejected
            return
        }
        
        if !UserDefaults.standard.isAuthorized() {
            print("ログインしていない")
            self.requestError = "ログインしていない"
            self.requestStatus = .Rejected
            return
        }
        
        let authString = UserDefaults.standard.getToken()
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
    
    //初期化
    func initTickets() {
        DispatchQueue.main.async {
            self.requestStatus = .Idle
            self.tickets = Tickets()
        }
    }
}


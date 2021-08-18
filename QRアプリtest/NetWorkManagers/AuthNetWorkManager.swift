//
//  AuthNetWorkManager.swift
//  QRアプリtest
//
//  Created by 蘭搏 on 2021/07/12.
//
import Foundation
import Combine
import AVFoundation

//ログイン時利用されるクラスを定義する
class AuthNetWorkManager: ObservableObject {
    var willChange = PassthroughSubject<AuthNetWorkManager, Never>()
    
    //ログイン時サーバーから取得したJSONをUserに保存して、更新する。
    @Published var user: User = User() {
        willSet {
            willChange.send(self)
        }
    }
    
    //Response通信エラーメッセージ
    @Published var requestError: String = "" {
        willSet {
            willChange.send(self)
        }
    }
    
    //Response成功したが、ログイン失敗のエラーメッセージ
    @Published var error: String = "" {
        willSet {
            willChange.send(self)
            if !newValue.isEmpty {
                DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
                    self.initError()
                }
            }
        }
    }
    
    //Responseステータス
    //初期値はIdle ロード画面と通信エラー画面が表示されない
    @Published var requestStatus: RequestStatus = RequestStatus.Idle {
        willSet {
            willChange.send(self)
        }
    }
    
    //ログイン処理
    //ログイン失敗(クライアント通信)：self.requestStatus = .Rejected
    //ログイン失敗(サーバー通信)：self.requestStatus = .Rejected
    //ログイン失敗(パスワード不正)：self.requestStatus = .Idle
    //ログイン成功：self.requestStatus = .Fulfilled
    func login(email: String, password: String) {
        self.requestStatus = .Pending
        
        guard let url = URL(string: APIURL.Login) else { return }
        var request = URLRequest(url: url)
        let body: [String: String] = ["email": email, "password": password]
        let finalBody = try! JSONSerialization.data(withJSONObject: body)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
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
                    print("サーバ側システムエラー")
                    self.requestError = "通信エラー"
                    self.requestStatus = .Rejected
                    return
                }
                
                guard let data = data else { return }
                
                let user = try! JSONDecoder().decode(User.self, from: data)
                
                DispatchQueue.main.async {
                    self.user = user
                    if !user.available {
                        self.error = "IDまたはパスワードが異なります。"
//                                let soundIdRing:SystemSoundID = 1200
//                                AudioServicesPlaySystemSound(SystemSoundID(soundIdRing))
                        AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
                        self.requestStatus = .Idle
                    } else {
                        print("self.user.available \(self.user.available)")
                        self.requestStatus = .Fulfilled
                    }
                }
            }
        }.resume()
    }
    
    //ログアウト
    func logout() {
        DispatchQueue.main.async {
            Utilities.logout()
            self.user = User()
        }
    }
    
    
    func initUser() {
        DispatchQueue.main.async {
            self.user = User()
        }
    }
    
    func initError() {
        DispatchQueue.main.async {
            self.error = ""
        }
    }

}

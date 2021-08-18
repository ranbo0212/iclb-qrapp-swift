//
//  SelectEventsNetWorkManager.swift
//  QRアプリtest
//
//  Created by 蘭搏 on 2021/07/12.
//

import Foundation
import UIKit
import Combine

//ログイン成功した後、サーバーからイベント情報を取得するクラスを定義する
class SelectEventsNetWorkManager: ObservableObject {
    var willChange = PassthroughSubject<SelectEventsNetWorkManager, Never>()
    
    //イベント情報
    @Published var events: [Event] = [] {
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
    
    //Responseステータス
    @Published var requestStatus: RequestStatus = RequestStatus.Idle {
        willSet {
            willChange.send(self)
        }
    }
    
    //画面更新
    @Published var refreshing = false {
        willSet {
            willChange.send(self)
        }
        
        didSet {
            if oldValue == false && refreshing == true {
                self.refresh()
            }
        }
    }
    
   init() {
       getEvents()
   }
    
    //イベント情報取得処理
    //APIURLが間違った場合self.requestStatus = .Rejected
    //ログインしていない場合self.requestStatus = .Rejected
    //イベント情報取得失敗(クライアント通信)：self.requestStatus = .Rejected
    //イベント情報取得失敗(サーバー通信)：self.requestStatus = .Rejected
    //イベント情報取得成功self.requestStatus = .Fulfilled・self.events = events
    func getEvents() {
        self.requestStatus = .Pending
        
        guard let url = URL(string: APIURL.GetEvents) else {
            print("APIURLが存在しない")
            self.requestStatus = .Rejected
            self.initRefreshing()
            return
        }
        
        if !Utilities.isAuthorized() {
            print("ログインしていない")
            Utilities.logout()
            self.requestError = "ログインしていない"
            self.requestStatus = .Rejected
            self.initRefreshing()
            return
        }
        
        let authString = Utilities.getToken()
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(authString)", forHTTPHeaderField: "Authorization")
        request.timeoutInterval = 3
        //            request.httpBody = finalBody
        
        URLSession.shared.dataTask(with: request) { (data, URLResponse, error) in
            
            if let error = error {
                print("クライアント側システムエラー")
                print(error)
                DispatchQueue.main.async {
                    self.requestError = "通信エラー"
                    self.requestStatus = .Rejected
                    self.initRefreshing()
                }
            }
            
            if let response = URLResponse as? HTTPURLResponse {
                print("response.statusCode = \(response.statusCode)")
                
                if response.statusCode != 200 {
                    if (response.statusCode == 205 || response.statusCode == 401) {
                        print("サーバ側システムエラー")
                        DispatchQueue.main.async {
                            Utilities.logout()
                            self.requestError = "認証失敗"
                            self.requestStatus = .Rejected
                            self.initRefreshing()
                        }
                    } else {
                        print("サーバ側システムエラー")
                        DispatchQueue.main.async {
                            self.requestError = "通信エラー"
                            self.requestStatus = .Rejected
                            self.initRefreshing()
                        }
                    }
                }
                
                guard let data = data else { return }
                
                do {
                    let events = try JSONDecoder().decode([Event].self, from: data)
                    DispatchQueue.main.async {
                        self.events = events
                        print(self.events)
                        self.requestStatus = .Fulfilled
                        self.initRefreshing()
                    }
                } catch {
                    print(error)
                }
            }
        }.resume()
    }
    
    func refresh() {
        self.refreshing = true
        self.requestStatus = .Pending
        
        guard let url = URL(string: APIURL.GetEvents) else {
            print("APIURLが存在しない")
            self.requestStatus = .Rejected
            self.initRefreshing()
            return
        }
        
        if !Utilities.isAuthorized() {
            print("ログインしていない")
            self.requestError = "ログインしていない"
            self.requestStatus = .Rejected
            self.initRefreshing()
            return
        }
        
        let authString = UserDefaults.standard.getToken()
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(authString)", forHTTPHeaderField: "Authorization")
        //            request.timeoutInterval = 20
        //            request.httpBody = finalBody
        
        URLSession.shared.dataTask(with: request) { (data, URLResponse, error) in
            
            if let error = error {
                print("クライアント側システムエラー")
                print(error)
                DispatchQueue.main.async {
                    self.requestError = "通信エラー"
                    self.requestStatus = .Rejected
                    self.initRefreshing()
                }
            }
            
            
            if let response = URLResponse as? HTTPURLResponse {
                print("response.statusCode = \(response.statusCode)")
                
                if response.statusCode != 200 {
                    if (response.statusCode == 205 || response.statusCode == 401) {
                        print("サーバ側システムエラー")
                        DispatchQueue.main.async {
                            Utilities.logout()
                            self.requestError = "認証失敗"
                            self.requestStatus = .Rejected
                            self.initRefreshing()
                        }
                    } else {
                        print("サーバ側システムエラー")
                        DispatchQueue.main.async {
                            self.requestError = "通信エラー"
                            self.requestStatus = .Rejected
                            self.initRefreshing()
                        }
                    }
                }
                
                guard let data = data else { return }
                
                do {
                    let events = try JSONDecoder().decode([Event].self, from: data)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self.events = events
                        print(self.events)
                        self.requestStatus = .Fulfilled
                        self.initRefreshing()
                    }
                } catch {
                    print(error)
                }
            }
        }.resume()
    }
    
    func initRefreshing() {
        DispatchQueue.main.async {
            self.refreshing = false
        }
    }
}


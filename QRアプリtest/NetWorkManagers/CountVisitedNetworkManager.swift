//
//  CountVisitedNetworkManager.swift
//  QRアプリtest
//
//  Created by 蘭搏 on 2021/07/12.
//

import Foundation
import Combine

//集計情報を取得するクラス
class CountVisitedNetworkManager: ObservableObject {
    
    var willChange = PassthroughSubject<CountVisitedNetworkManager, Never>()
    
    @Published var countStatus = CountStatus() {
        willSet {
            willChange.send(self)
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
    
    func count(data: Event) {
        self.requestStatus = .Pending
        
        guard let url = URL(string: APIURL.CountVisited) else {
            print("APIURLが存在しない")
            self.requestStatus = .Rejected
            return
        }
        
        if !UserDefaults.standard.isAuthorized() {
            print("ログインしていない")
            UserDefaults.standard.setIsAuthorized(value: false)
            UserDefaults.standard.setToken(value: "")
            self.requestError = "ログインしていない"
            self.requestStatus = .Rejected
            return
        }
        
        print(data.eventId)

        let authString = UserDefaults.standard.getToken()
        var request = URLRequest(url: url)
        let body: [String:Any] = ["eventId": data.eventId, "dateId": data.dateId]
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
                    let count = try JSONDecoder().decode(CountStatus.self, from: data)
                    DispatchQueue.main.async {
                        print(self.countStatus)
                        self.countStatus = count
                        self.requestStatus = .Fulfilled
                    }
                } catch {
                    print(error)
                }
            }
        }.resume()
    }
}


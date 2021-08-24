//
//  AppStoreInfo.swift
//  QRアプリtest
//
//  Created by 蘭搏 on 2021/08/18.
//

import Foundation
import Combine
import AVFoundation

//バージョンタイプ
enum AlertType {
    case supportOsVersion, updateVersion
}

class AppStoreInfo: ObservableObject {
    var willChange = PassthroughSubject<AppStoreInfo, Never>()
    
    @Published var showAlert: Bool = false {
        willSet {
            willChange.send(self)
        }
    }
    
    @Published var alerType: AlertType = .supportOsVersion {
        willSet {
            willChange.send(self)
        }
    }
    
    var osVersion: String = Utilities.getOSVersion() {
        willSet {
            willChange.send(self)
        }
    }
    
    var version: String = Utilities.getVersion() {
        willSet {
            willChange.send(self)
        }
    }
    
    var trackViewUrl: String = "" {
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
    
        //バージョン確認処理
    //APIURLが間違った場合self.requestStatus = .Rejected
    //ログインしていない場合self.requestStatus = .Rejected
    //アプリ情報取得失敗(クライアント通信)：self.requestStatus = .Rejected
    //アプリ情報取得失敗(サーバー通信)：self.requestStatus = .Rejected
    //アプリ情報取得成功self.requestStatus = .Fulfilled
    //OSバージョン古い：self.showAlert = true・self.alerType = .supportOsVersion
    //OSバージョン最新・アプリバージョン古い：self.showAlert = true・self.alerType = .updateOsVersion
    func checkIfLatestVersion() {
        self.requestStatus = .Pending
        
        guard let url = URL(string: "https://itunes.apple.com/jp/lookup?bundleId=" + Utilities.getBundleId()) else { return }
        
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
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
                
                let lookup = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [String: Any]
                
                if let resultCount = lookup!["resultCount"] as? Int, resultCount == 1 {
                    if let results = lookup!["results"] as? [[String:Any]] {
                        if let minimumOsVersion = results[0]["minimumOsVersion"] as? String {
                            print(minimumOsVersion)
                            print(self.osVersion)
                            
                            if self.osVersion.compare(minimumOsVersion, options: .numeric) == .orderedAscending {
                                DispatchQueue.main.async {
                                    self.showAlert = true
                                    self.alerType = .supportOsVersion
                                }
                            } else {
                                if let appStoreVersion = results[0]["version"] as? String {
                                    print(appStoreVersion)
                                    print(self.version)
                                    
                                    if self.version != appStoreVersion {
                                        DispatchQueue.main.async {
                                            self.showAlert = true
                                            self.alerType = .updateVersion
                                        }
                                    }
                                }
                                
                                //アプリ更新URL
                                if let trackViewUrl = results[0]["trackViewUrl"] as? String {
                                    print(trackViewUrl)
                                    
                                    DispatchQueue.main.async {
                                        self.trackViewUrl = trackViewUrl
                                    }
                                }
                            }
                        }
                        
                    }
                }
            }
        }.resume()
    }
}

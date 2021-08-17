//
//  User.swift
//  QRアプリtest
//
//  Created by 蘭搏 on 2021/07/12.
//

import Foundation

//ログイン処理を行う時Response結果をデコードする為のモデルを定義する。
class User: Codable, ObservableObject {

    var sub: String        //サブドメイン
    var token: String      //response結果文字列 空白の場合IsAuthorizedはfalse、トップ画面が表示される。
    var status: Int        //response結果ステータス
    var redirect: String   //
    var available: Bool    //trueの場合ログイン成功
    var error: String      //エラーメッセージ
    
    enum CodingKeys: String, CodingKey {
        case sub
        case token
        case status
        case redirect
        case available
        case error
    }
    
    init() {
        self.sub = ""
        self.token = ""
        self.status = 0
        self.redirect = ""
        self.available = false
        self.error = ""
    }
    
    required init(from decoder: Decoder) throws {
        
        let keyedContainer = try decoder.container(keyedBy: CodingKeys.self)

        sub = try (keyedContainer.decodeIfPresent(String.self, forKey: .sub) ?? "-")
        token = try (keyedContainer.decodeIfPresent(String.self, forKey: .token) ?? "")
        status = try (keyedContainer.decodeIfPresent(Int.self, forKey: .status) ?? 0)
        redirect = try (keyedContainer.decodeIfPresent(String.self, forKey: .redirect) ?? "-")
        error = try (keyedContainer.decodeIfPresent(String.self, forKey: .error) ?? "")
        if let available = try keyedContainer.decodeIfPresent(Bool.self, forKey: .available) {
            self.available = available
        } else {
            
            if !token.isEmpty {
                self.available = true
                //文字列の更新
                UserDefaults.standard.setIsAuthorized(value: true)
                UserDefaults.standard.setToken(value: token)
            } else {
                self.available = false
                UserDefaults.standard.setIsAuthorized(value: false)
                UserDefaults.standard.setToken(value: token)
            }
            print(self.available)
        }
    }
}


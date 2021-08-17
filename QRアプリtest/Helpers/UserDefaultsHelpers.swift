//
//  UserDefaultsHelpers.swift
//  QRアプリtest
//
//  Created by 蘭搏 on 2021/07/12.
//

import Foundation


extension UserDefaults {
    
    enum UserDefaultsKeys: String {
        case isAuthorized    //trueの場合イベント一覧画面/通信エラー画面/ロード画面が表示される、falseの場合、トップ画面が表示される
        case token
    }
    
    func getToken() -> String {
        return string(forKey: UserDefaultsKeys.token.rawValue) ?? ""
    }
    
    func setToken(value: String) {
        //値を更新
        set(value, forKey: UserDefaultsKeys.token.rawValue)
        synchronize()
    }
    
    func setIsAuthorized(value: Bool) {
        //値を更新
        set(value, forKey: UserDefaultsKeys.isAuthorized.rawValue)
        synchronize()
    }
    
    func isAuthorized() -> Bool {
        return bool(forKey: UserDefaultsKeys.isAuthorized.rawValue)
    }
    
    func logout() {
        //値を削除
        removeObject(forKey: UserDefaultsKeys.isAuthorized.rawValue)
        removeObject(forKey: UserDefaultsKeys.token.rawValue)
    }
}

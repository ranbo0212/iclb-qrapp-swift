//
//  UserDefaultsHelpers.swift
//  QRアプリtest
//
//  Created by 蘭搏 on 2021/07/12.
//

import Foundation

extension UserDefaults {
    
    enum UserDefaultsKeys: String {
        case token               //ログインレスポンス文字列
        case lastedCheckedDate   //前回バージョン確認日
    }
    
    //tokenは空白：""
    //tokenは空白以外：token
    func getToken() -> String {
        return string(forKey: UserDefaultsKeys.token.rawValue) ?? ""
    }
    
    //token値更新
    func setToken(value: String) {
        set(value, forKey: UserDefaultsKeys.token.rawValue)
        synchronize()
    }
    
    //前回バージョン確認日は空白：""
    //前回バージョン確認日は空白以外：lastedCheckedDate
    func getLastedCheckedDate() -> String {
        return string(forKey: UserDefaultsKeys.lastedCheckedDate.rawValue) ?? ""
    }
    
    //前回バージョン確認日値更新
    func setLastedCheckedDate(value: String) {
        set(value, forKey: UserDefaultsKeys.lastedCheckedDate.rawValue)
        synchronize()
    }
}

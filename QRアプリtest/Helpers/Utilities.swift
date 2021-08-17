//
//  Utilities.swift
//  QRアプリtest
//
//  Created by 蘭搏 on 2021/07/12.
//

import Foundation
import UIKit
import SwiftUI

class Utilities {
    
        //ログイン状態確認
        //tokenは空白：false
        //tokenは空白以外：true
    static func isAuthorized() -> Bool {
        if !UserDefaults.standard.getToken().isEmpty {
            return true
        }
        return false
    }
    
        //レスポンス文字列確認
        //tokenは空白：false
        //tokenは空白以外：true
    static func getToken() -> String {
        return UserDefaults.standard.getToken()
    }
    
        //ログアウト
        //レスポンス文字列tokenが””の場合ログイン状態がfalseになる
    static func logout() {
        UserDefaults.standard.setToken(value: "")
    }
    
        //デバイスID取得
    static func getDeviceID() -> String {
        guard let deviceID = UIDevice.current.identifierForVendor?.uuidString else {
            return ""
        }
        return String(deviceID.prefix(20))
    }
    
        //バンドルID取得
    static func getBundleId() -> String {
        guard let bundleId = Bundle.main.infoDictionary?["CFBundleIdentifier"] as? String else {
            return ""
        }
        return bundleId
    }
    
        //アプリバージョン取得
    static func getVersion() -> String {
        guard let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else {
            return ""
        }
        return version
    }
    
        //端末OSバージョン取得
    static func getOSVersion() -> String {
        let osVersion = UIDevice.current.systemVersion
        return osVersion
    }

        //前回バージョン確認日付確認
        //本日の場合：true
        //本日ではない場合：false
    static func isVersionCheckedToday() -> Bool {
        print("isVersionCheckedToday")
        var result: Bool = true
        
        if let lastedCheckedDate = getLastedCheckedDate() {
            let today = Date()
            let order = Calendar.current.compare(today, to: lastedCheckedDate, toGranularity: .day)
            if order != .orderedSame {
                result = false
            }
        } else {
            result = false
        }
        
        return result
    }
    
        //前回バージョン確認日取得
    static func getLastedCheckedDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "ja_JP")
        let lastedCheckedDate = dateFormatter.date(from: UserDefaults.standard.getLastedCheckedDate())
        
        return lastedCheckedDate
    }
    
        //前回バージョン確認日更新
    static func setLastedCheckedDateToToday() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "ja_JP")
        let today = Date()
        
        UserDefaults.standard.setLastedCheckedDate(value: dateFormatter.string(from: today))
    }
}

enum RequestStatus {
    //インターネット接続していない
    //トップ画面が表示される
    case Idle
    //インターネット接続中
    //loaderViewが表示される
    case Pending
    //インターネット接続成功
    //イベント一覧画面が表示される
    case Fulfilled
    //インターネット接続失敗
    //通信エラー画面が表示される
    case Rejected
}

//スライドで画面を操作する
extension UINavigationController: UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}

//ビューを条件付きで別のビューに埋め込む
extension View {
    /// Applies the given transform if the given condition evaluates to `true`.
    /// - Parameters:
    ///   - condition: The condition to evaluate.
    ///   - transform: The transform to apply to the source `View`.
    /// - Returns: Either the original `View` or the modified `View` if the condition is `true`.
    @ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}

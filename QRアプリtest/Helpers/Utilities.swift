//
//  Utilities.swift
//  QRアプリtest
//
//  Created by 蘭搏 on 2021/07/12.
//

import Foundation
import UIKit

// 各端末ユニークなIDを取得する
class Utilities {
    static func getDeviceID() -> String {
        guard let deviceID = UIDevice.current.identifierForVendor?.uuidString else {
           return ""
        }
        return deviceID
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

extension UINavigationController: UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}

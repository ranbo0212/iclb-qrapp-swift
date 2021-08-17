//
//  APIURL.swift
//  QRアプリtest
//
//  Created by 蘭搏 on 2021/07/12.
//

import Foundation

struct APIURL {
    private struct Domains {
        static let STG = "https://qrapp-stg-hinori.net"
        static let PROD = "https://qrapp-hinori.jp"
    }

    private struct Routes {
        static let Api = "/api"
    }

    //下記のドメインを切り替え：　ステージング(Domains.STG)、本番(Domains.PROD)
    private static let Domain = Domains.PROD
    
    private static let Route = Routes.Api
    private static let BaseURL = Domain + Route
    
    static var getRoute: String {
        return Domain
    }

    static var Login: String {
        return BaseURL + "/auth/login"
    }
    
    static var GetEvents: String {
        return BaseURL + "/event"
    }
    
    static var QRCheckInUpdate: String {
        return BaseURL + "/qrcode/update"
    }
    
    static var QRCheckInDelete: String {
        return BaseURL + "/qrcode/delete"
    }
    
    static var CountVisited: String {
        return BaseURL + "/qrcode/count"
    }
}

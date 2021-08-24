//
//  RootView.swift
//  QRアプリtest
//
//  Created by 蘭搏 on 2021/07/12.
//

import SwiftUI

struct RootView: View {

    //ログイン確認マネージャー
    @EnvironmentObject var authNetWorkManager: AuthNetWorkManager
    //バージョン確認マネージャー
    @ObservedObject var appStoreInfo = AppStoreInfo()
    
    var body: some View {
        //IOSバージョンは14.0以降の場合
        if #available(iOS 14.0, *) {
            ZStack {
                //isAuthorizedがfalseの場合TopViewが表示される
                if Utilities.isAuthorized() != true {
                    ZStack {
                        TopView()
                            //当日バージョン確認行った場合何も表示しない
                            .onAppear {
                                if !Utilities.isVersionCheckedToday() {
                                    appStoreInfo.checkIfLatestVersion()
                                }
                            }
                            //ダイアログ表示
                            //当日バージョン確認行ってない、バージョンが古い場合ダイアログ表示
                            .alert(isPresented: Binding.constant(!Utilities.isVersionCheckedToday() && appStoreInfo.showAlert)) {
                                //appStoreInfo.alerTypeの値によって、ダイアログ表示
                                switch appStoreInfo.alerType {
                                    //IOSバージョンが古い場合
                                    case .supportOsVersion:
                                        return Alert(
                                            title: Text("OSバージョン更新のお願い"),
                                            message: Text("お使いのOSはサポート対象外となりました。OSをアップデートした後、最新のアプリケーションをご利用ください。"),
                                            dismissButton: .default(Text("OK")) {
                                                exit(0)
                                            }
                                        )
                                    //IOSバージョンが最新、アプリバージョンが古い場合場合
                                    case .updateVersion:
                                        return Alert(
                                            title: Text("アプリ更新のお願い"),
                                            message: Text("新しいバージョンが利用可能です。最新版にアップデートしてご利用ください。"),
                                            primaryButton: .default(Text("アップデート")) {
                                                Utilities.setLastedCheckedDateToToday()
                                                if let url = URL(string: appStoreInfo.trackViewUrl) {
                                                    UIApplication.shared.open(url)
                                                }
                                            },
                                            secondaryButton: .cancel(Text("後で通知")) {
                                                Utilities.setLastedCheckedDateToToday()
                                            }
                                        )
                                }
                            }
                    }
                    //通信エラーの場合、ぼかし程度：３　通信エラー以外の場合、ぼかしなし
                    .blur(radius: authNetWorkManager.requestStatus == .Rejected ? 3 : 0)
                }
                
                //データ取得中の場合、Loader画面が表示される
                if self.authNetWorkManager.requestStatus == .Pending {
                    VStack {
                        Loader()
                    }
                    //セーフエリア指定、IOS14.0以降必要
                    .ignoresSafeArea(.keyboard, edges: .all)
                }
                
                //データ取得中通信エラー発生の場合、NetworkErrorViewが表示される
                if self.authNetWorkManager.requestStatus == .Rejected {
                    NetworkErrorView()
                        //ダイアログをクリックすると、見えなくなる、インターネットが接続していない状態に変更
                        .onTapGesture() {
                            authNetWorkManager.requestStatus = .Idle
                        }
                }
            }
            //ログイン済みの場合、SelectEventViewが表示される
            .fullScreenCover(isPresented: Binding.constant(Utilities.isAuthorized()), content: {
                ZStack {
                    SelectEventView()
                        .onAppear {
                            if !Utilities.isVersionCheckedToday() {
                                appStoreInfo.checkIfLatestVersion()
                            }
                        }
                        //バージョン確認
                        .alert(isPresented: Binding.constant(!Utilities.isVersionCheckedToday() && appStoreInfo.showAlert)) {
                            switch appStoreInfo.alerType {
                                case .supportOsVersion:
                                    return Alert(
                                        title: Text("OSバージョン更新のお願い"),
                                        message: Text("お使いのOSはサポート対象外となりました。OSをアップデートした後、最新のアプリケーションをご利用ください。"),
                                        dismissButton: .default(Text("OK")) {
                                            exit(0)
                                        }
                                    )
                                case .updateVersion:
                                    return Alert(
                                        title: Text("アプリ更新のお願い"),
                                        message: Text("新しいバージョンが利用可能です。最新版にアップデートしてご利用ください。"),
                                        primaryButton: .default(Text("アップデート")) {
                                            Utilities.setLastedCheckedDateToToday()
                                            if let url = URL(string: appStoreInfo.trackViewUrl) {
                                                UIApplication.shared.open(url)
                                            }
                                        },
                                        secondaryButton: .cancel(Text("後で通知")) {
                                            Utilities.setLastedCheckedDateToToday()
                                        }
                                    )
                            }
                        }
                    }
                }
            )
            
            
        } else {
            // iOS 14.0以前の場合
            ZStack {
                VStack {
                    //ログイン済みの場合
                    if Utilities.isAuthorized() == true {
                        SelectEventView()
                            //バージョン確認
                            .onAppear {
                                if !Utilities.isVersionCheckedToday() {
                                    appStoreInfo.checkIfLatestVersion()
                                }
                            }
                            .alert(isPresented: Binding.constant(!Utilities.isVersionCheckedToday() && appStoreInfo.showAlert)) {
                                switch appStoreInfo.alerType {
                                    case .supportOsVersion:
                                        return Alert(
                                            title: Text("OSバージョン更新のお願い"),
                                            message: Text("お使いのOSはサポート対象外となりました。OSをアップデートした後、最新のアプリケーションをご利用ください。"),
                                            dismissButton: .default(Text("OK")) {
                                                exit(0)
                                            }
                                        )
                                    case .updateVersion:
                                        return Alert(
                                            title: Text("アプリ更新のお願い"),
                                            message: Text("新しいバージョンが利用可能です。最新版にアップデートしてご利用ください。"),
                                            primaryButton: .default(Text("アップデート")) {
                                                Utilities.setLastedCheckedDateToToday()
                                                if let url = URL(string: appStoreInfo.trackViewUrl) {
                                                    UIApplication.shared.open(url)
                                                }
                                            },
                                            secondaryButton: .cancel(Text("後で通知")) {
                                                Utilities.setLastedCheckedDateToToday()
                                            }
                                        )
                                }
                            }
                    } else {
                        //未ログインの場合
                        TopView()
                            //バージョン確認
                            .onAppear {
                                if !Utilities.isVersionCheckedToday() {
                                    appStoreInfo.checkIfLatestVersion()
                                }
                            }
                            .alert(isPresented: Binding.constant(!Utilities.isVersionCheckedToday() && appStoreInfo.showAlert)) {
                                switch appStoreInfo.alerType {
                                    case .supportOsVersion:
                                        return Alert(
                                            title: Text("OSバージョン更新のお願い"),
                                            message: Text("お使いのOSはサポート対象外となりました。OSをアップデートした後、最新のアプリケーションをご利用ください。"),
                                            dismissButton: .default(Text("OK")) {
                                                exit(0)
                                            }
                                        )
                                    case .updateVersion:
                                        return Alert(
                                            title: Text("アプリ更新のお願い"),
                                            message: Text("新しいバージョンが利用可能です。最新版にアップデートしてご利用ください。"),
                                            primaryButton: .default(Text("アップデート")) {
                                                Utilities.setLastedCheckedDateToToday()
                                                if let url = URL(string: appStoreInfo.trackViewUrl) {
                                                    UIApplication.shared.open(url)
                                                }
                                            },
                                            secondaryButton: .cancel(Text("後で通知")) {
                                                Utilities.setLastedCheckedDateToToday()
                                            }
                                        )
                                }
                            }
                    }
                    
                }
                .blur(radius: authNetWorkManager.requestStatus == .Rejected ? 3 : 0)
                
                //データ取得中の場合、Loader画面表示
                if self.authNetWorkManager.requestStatus == .Pending {
                    VStack {
                        Loader()
                    }
                }
                
                //通信エラーの場合、NetworkErrorViewが表示される
                if self.authNetWorkManager.requestStatus == .Rejected {
                    NetworkErrorView()
                        .onTapGesture() {
                            authNetWorkManager.requestStatus = .Idle
                        }
                }
            }
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}

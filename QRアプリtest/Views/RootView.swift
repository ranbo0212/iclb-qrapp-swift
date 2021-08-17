//
//  RootView.swift
//  QRアプリtest
//
//  Created by 蘭搏 on 2021/07/12.
//

import SwiftUI

struct RootView: View {
    @EnvironmentObject var authNetWorkManager:AuthNetWorkManager
    
    var body: some View {
        if #available(iOS 14.0, *) {
            ZStack{
                //未ログインの場合トップVIewが表示される
                if UserDefaults.standard.isAuthorized() != true {
                    VStack{
                        TopView()
                    }
                     //ぼかし
                    .blur(radius: authNetWorkManager.requestStatus == .Rejected ? 3 : 0)
                }
                //ログイン済みデータ取得中の場合roaderViewが表示される
                if self.authNetWorkManager.requestStatus == .Pending {
                    VStack {
                        Loader()
                    }
                    .ignoresSafeArea(.keyboard, edges: .all)
                }
                //ログイン済みネットが切れた場合、通信エラー画面が表示される
                if self.authNetWorkManager.requestStatus == .Rejected {
                    NetworkErrorView()
                        .onTapGesture() {
                            authNetWorkManager.requestStatus = .Idle
                        }
                }
            }
            .fullScreenCover(isPresented: Binding.constant(UserDefaults.standard.isAuthorized()), content: {
                SelectEventView()
            })
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}

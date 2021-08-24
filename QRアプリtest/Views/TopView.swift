//
//  TopView.swift
//  QRアプリtest
//
//  Created by 蘭搏 on 2021/07/12.
//

import SwiftUI

struct TopView: View {
    //ログイン確認マネージャー
    @EnvironmentObject var authNetWorkManager: AuthNetWorkManager
    //画面遷移変数
    @State var isActive = false
    
    var body: some View {
        
        //IOSバージョンは14.0以降の場合
        if #available(iOS 14.0, *) {
            NavigationView {
                ZStack {
                    VStack {
                        //画像top.pngを使用する
                        //事前Assets.xcassetsに置いとく
                        Image("top")
                            .renderingMode(.original)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .clipped()
                            .frame(minWidth: 0, maxWidth: UIScreen.main.bounds.width, minHeight: 0, maxHeight: UIScreen.main.bounds.height)
                            .position(x:UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2 - 60)
                        
                        VStack {
                            Spacer()
                            //ログインボタンを定義する
                            //クリックするとEmailInputViewへ遷移
                            HStack {
                                NavigationLink(destination: EmailInputView()) {
                                    Text("ログイン")
                                        .font(.headline)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.white)
                                        .frame(minWidth: 0, maxWidth: .infinity)
                                        .padding(.all, 16)
                                        .background(Color("navigation"))
                                        .cornerRadius(32)
                                        .shadow(color: Color("navigation").opacity(0.12), radius: 24, x: 0, y: 24)
                                }
                            }
                            .padding(.all, 32)
                            .frame(height: 100)
                        }
                    }
                    
                }
                //IOS14.0以降が必要?
//                .ignoresSafeArea(.keyboard, edges: .all)
                //Viewタイトル
                .navigationBarTitle(Text("HINORI QRリーダー"), displayMode: .inline)
            }
            .navigationViewStyle(StackNavigationViewStyle())
        } else {
            // iOS 13
            NavigationView {
                ZStack {
                    VStack {
                        Image("top")
                            .renderingMode(.original)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .clipped()
                            .frame(minWidth: 0, maxWidth: UIScreen.main.bounds.width, minHeight: 0, maxHeight: UIScreen.main.bounds.height)
                            .position(x:UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2 - 60)
                        
                        VStack {
                            Spacer()
                            HStack {
                                NavigationLink(destination: EmailInputView()) {
                                    Text("ログイン")
                                        .font(.headline)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.white)
                                        .frame(minWidth: 0, maxWidth: .infinity)
                                        .padding(.all, 16)
                                        .background(Color("navigation"))
                                        .cornerRadius(32)
                                        .shadow(color: Color("navigation").opacity(0.12), radius: 24, x: 0, y: 24)
                                }
                            }
                            .padding(.all, 32)
                            .frame(height: 100)
                        }
                    }
                    
                }
                .navigationBarTitle(Text("HINORI QRリーダー"), displayMode: .inline)
            }
        }
    }
}

struct Top_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(["iPhone Xs"], id: \.self) { deviceName in
            TopView()
                .previewDevice(PreviewDevice(rawValue: deviceName))
                .previewDisplayName(deviceName)
        }
    }
}


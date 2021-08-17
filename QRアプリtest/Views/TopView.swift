//
//  TopView.swift
//  QRアプリtest
//
//  Created by 蘭搏 on 2021/07/12.
//

import SwiftUI

struct TopView: View {
    @EnvironmentObject var authNetWorkManager: AuthNetWorkManager  // 利用されない
    @State var isActive = false   // 利用されない
    
    var body: some View {
        if #available(iOS 14.0, *) {
            NavigationView {
                ZStack {
                    VStack{
                        Image("top")
                            .renderingMode(.original)  //色を元の色にする
                            .resizable()   //サイズを画面に合わせる
                            .aspectRatio(contentMode: .fill)  //纵横比を最大にする
                            .clipped()   //画像を丸くする
                            .frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, maxWidth: UIScreen.main.bounds.width, minHeight: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, maxHeight: UIScreen.main.bounds.height)
                            .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2 - 60)
                        
                        VStack {
                            Spacer()
                            HStack {
                                //画面遷移
                                NavigationLink(destination: EmailInputView()) {
                                    Text("ログイン")
                                        .font(.headline)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.white)
                                        .frame(minWidth: 0, maxWidth: .infinity)
                                        .padding(.all, 16)
                                        .background(Color("navigation"))
                                        .cornerRadius(32)  //四角を丸くする
                                        .shadow(color: Color("navigation").opacity(0.12), radius: 24, x: 0, y: 24)
                                }
                            }
                            .padding(.all, 32)
                            .frame(height: 100)
                        }
                    }
                }
                .ignoresSafeArea(.keyboard, edges: .all)
                //タイトルスタイル
                .navigationBarTitle(Text("QRCodeTest"), displayMode: .inline)
            }
            .navigationViewStyle(StackNavigationViewStyle())
        }
    }
}

struct TopView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(["iPhone Xs"], id: \.self) { deviceName in TopView()
                .previewDevice(PreviewDevice(rawValue: deviceName))
            .previewDisplayName(deviceName)
        }
        
    }
}

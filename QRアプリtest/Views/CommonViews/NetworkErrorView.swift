//
//  NetworkErrorView.swift
//  QRアプリtest
//
//  Created by 蘭搏 on 2021/07/12.
//

import SwiftUI

struct NetworkErrorView: View {
    @State var show: Bool = false
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.2)
                .edgesIgnoringSafeArea(.all)  //背景透明度0.2
            ZStack {
                Color.black
                    .edgesIgnoringSafeArea(.all)  //背景透明度0.2

                VStack(spacing: 30) {
                    Image(systemName: "wifi.exclamationmark")
                        .font(Font.system(size: 32, weight: .regular))
                        .foregroundColor(Color.gray)
                    Text("ネットワーク環境をもう一度確認してください。")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(Color.gray)
                    Text("確認")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(Color.white)
                    
                }
                .padding(20)
            }
            .cornerRadius(8)
            .opacity(show ? 1 : 0)
            .offset(y: show ? 0 : 10)
            .frame(maxHeight: 200, alignment: .center)
            .padding(40)
            .animation(Animation.spring().delay(0.2))
        }
        .onAppear {
            withAnimation {
                self.show = true
            }
        }
    }
}

struct NetworkErrorView_Previews: PreviewProvider {
    static var previews: some View {
        NetworkErrorView()
    }
}

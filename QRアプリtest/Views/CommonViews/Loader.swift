//
//  Loader.swift
//  QRアプリtest
//
//  Created by 蘭搏 on 2021/07/12.
//

import SwiftUI

struct Loader: View {
    
    var diameter: CGFloat = 80
    @State var isAnimating = false
    
    var foreverAnimation: Animation {
        Animation.linear(duration: 1)
            //            .delay(0.1)
            .repeatForever(autoreverses: false)
    }
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.2).edgesIgnoringSafeArea(.all)  //背景の透明度を0.2にする
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)   //背景の透明度をを１にする
                
                //通信中の丸を描く
                Circle()
                    .trim(from: 0, to: 1) // 全円
                    .stroke(Color.white, style: StrokeStyle(
                        lineWidth: 12,
                        lineCap: .round
                    ))    // スタイルを定義する
                    .frame(width: diameter, height: diameter, alignment: .center)
                    .opacity(0.2)
                    
                    .overlay(
                        Circle()
                            .trim(from: 0, to: 1 / 5)  //1/5円
                            .stroke(
                                LinearGradient(gradient: Gradient(colors: [ .black, Color("overlayShadow"), .white, .white]),
                                               startPoint: .topLeading, endPoint: .bottomTrailing)
                                , style: StrokeStyle(
                                    lineWidth: 12,
                                    lineCap: .round
                            ))  // スタイル定義
                            .frame(width: diameter, height: diameter, alignment: .center)
                            .rotationEffect(.degrees(isAnimating ? 360 : 0), anchor: .center)
                            .rotation3DEffect(.degrees(0), axis: (x: 1, y: 0, z: 0))
                            .animation(foreverAnimation) //永遠に動く
                            .onAppear {
                                self.isAnimating.toggle()
                        }  //表示する条件
                )
            }
            .cornerRadius(8)
            .frame(width: 120, height: 120, alignment: .center)
        }
    }
}

struct Loader_Previews: PreviewProvider {
    static var previews: some View {
        Loader()
    }
}

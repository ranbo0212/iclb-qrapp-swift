//
//  Loader.swift
//  QRアプリtest
//
//  Created by 蘭搏 on 2021/07/12.
//

import SwiftUI

//データ取得中の場合表示される
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
                        //背景の透明度を0.2にする
            Color.black.opacity(0.2)
                .edgesIgnoringSafeArea(.all)
            ZStack {
                                //背景の透明度をを１にする
                Color.black
                    .edgesIgnoringSafeArea(.all)

                //通信中の丸を描く
                Circle()
                                        // 全円
                    .trim(from: 0, to: 1)
                    .stroke(Color.white, style: StrokeStyle(
                        lineWidth: 12,
                        lineCap: .round
                    ))
                    .frame(width: diameter, height: diameter, alignment: .center)
                    .opacity(0.2)
                    
                    .overlay(
                        Circle()
                                                        // 1／5円
                            .trim(from: 0, to: 1 / 5)
                            .stroke(
                                LinearGradient(gradient: Gradient(colors: [ .black, Color("overlayShadow"), .white, .white]),
                                               startPoint: .topLeading, endPoint: .bottomTrailing)
                                , style: StrokeStyle(
                                    lineWidth: 12,
                                    lineCap: .round
                            ))
                            .frame(width: diameter, height: diameter, alignment: .center)
                            .rotationEffect(.degrees(isAnimating ? 360 : 0), anchor: .center)
                            .rotation3DEffect(.degrees(0), axis: (x: 1, y: 0, z: 0))
                            ////永遠に動く
                                                        .animation(foreverAnimation)
                            .onAppear {
                                self.isAnimating.toggle()
                        }
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

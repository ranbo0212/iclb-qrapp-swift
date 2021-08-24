//
//  PullDownLoader.swift
//  QRアプリtest
//
//  Created by 蘭搏 on 2021/08/18.
//

import SwiftUI

//イベント一覧画面で画面を下にスクロールするとき、画面の上に表示される
struct PullDownLoader: View {
    
    var diameter: CGFloat = 30
    @State var isAnimating = false
    
    var foreverAnimation: Animation {
        Animation.linear(duration: 0.8)
            .repeatForever(autoreverses: false)
    }
    
    var body: some View {
        ZStack {
            //背景
            Color.black.opacity(0)
                .edgesIgnoringSafeArea(.all)
            ZStack {
                //外円
                Color.white
                    .edgesIgnoringSafeArea(.all)
                
                //内円
                Circle()
                    .trim(from: 0, to: 1)
                    .stroke(Color.white, style: StrokeStyle(
                        lineWidth: 12,
                        lineCap: .round
                    ))
                    .frame(width: diameter, height: diameter, alignment: .center)
                    .opacity(0.2)
                    
                    .overlay(
                        Circle()
                            .trim(from: 0, to: 1 / 2)
                            .stroke(
                                //円形の色
                                LinearGradient(gradient: Gradient(colors: [Color("statusCircleGradienLight"), Color("statusCircleGradienDark")]),
                                               startPoint: .topLeading, endPoint: .bottomTrailing)
                                //円形線のスタイル
                                , style: StrokeStyle(
                                    lineWidth: 6,
                                    //線の端の形状指定
                                    lineCap: .round
                            ))
                            //サイズ設定
                            .frame(width: diameter, height: diameter, alignment: .center)
                            .rotationEffect(.degrees(isAnimating ? 360 : 0), anchor: .center)
                            .rotation3DEffect(.degrees(0), axis: (x: 1, y: 0, z: 0))
//                            .animation(foreverAnimation)
//                            .onAppear {
//                                self.isAnimating.toggle()
//                        }
                            
                            .onAppear {
                                withAnimation(self.foreverAnimation) {
                                    self.isAnimating.toggle()
                                }
                            }
                )
            }
            .cornerRadius(100)
            .frame(width: 60, height: 60, alignment: .center)
        }
        .shadow(color: .gray, radius: 8, x: 0, y: 4)
    }
}

struct PullDownLoader_Previews: PreviewProvider {
    static var previews: some View {
        PullDownLoader()
    }
}

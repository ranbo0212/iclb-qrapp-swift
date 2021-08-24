//
//  SelectEventLoader.swift
//  QRアプリtest
//
//  Created by 蘭搏 on 2021/08/18.
//

import SwiftUI

//イベント一覧画面データ取得中に表示される
struct SelectEventLoader: View {
    
    @State var angle: Double = 0.0
    @State var isAnimating = false
    var body: some View {
        
        VStack (spacing: 20) {
            ZStack {
                
                //画面範囲
                Rectangle()
                    .overlay (
                        //灰色画面はんい
                        Rectangle()
                            .fill(Color.gray)
                    )
                    .frame(width: UIScreen.main.bounds.width, height: 240)
                    .clipped()
                
                VStack {
                    VStack {
                        //イベント名枠
                        HStack {
                            GradientLoaderView()
                                .frame(minWidth: 100, maxHeight: 20, alignment: .topLeading)
                                .cornerRadius(10)
                                .clipped()
                            Spacer()
                        }
                        HStack {
                            GradientLoaderView()
                                .frame(maxWidth: 100, maxHeight: 20, alignment: .topLeading)
                                .cornerRadius(10)
                                .clipped()
                            Spacer()
                        }
                        
                    }
                    .frame(maxHeight: 60)
                    .padding(.vertical, 10)
                    .background(Color.clear)
                    
                    //イベント日時枠
                    VStack {
                        //イベント日付枠
                        HStack  {
                            GradientLoaderView()
                            .frame(width: 200, height: 20, alignment: .topLeading)
                            .cornerRadius(10)
                            .clipped()
                            Spacer()
                        }
                        .background(Color.clear)
                        
                        //イベント日時枠
                        HStack {
                            HStack {
                                GradientLoaderView()
                                    .frame(minWidth: 100, maxHeight: 20, alignment: .topLeading)
                                    .cornerRadius(10)
                                    .clipped()
                                Spacer()
                            }
                            .frame(minWidth: 120)
                            .background(Color.clear)
                            HStack () {
                                GradientLoaderView()
                                    .frame(minWidth: 100, maxHeight: 20, alignment: .topLeading)
                                    .cornerRadius(10)
                                    .clipped()
                                Spacer()
                            }
                            .frame(minWidth: 120)
                            .background(Color.clear)
                        }
                        .frame(minWidth: 240)
                        .background(Color.clear)
                    }
                }
                .padding(.all, 24)
                .frame(minWidth: 0, maxWidth: UIScreen.main.bounds.width - 40, minHeight: 120, maxHeight: .infinity, alignment: Alignment.bottomLeading)
            }
            .frame(width: UIScreen.main.bounds.width - 40, height: 240, alignment: .top)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .shadow(color: .gray, radius: 8, x: 0, y: 4)
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 20)
        .background(Color.white)
    }
}

struct SelectEventLoader_Previews: PreviewProvider {
    static var previews: some View {
        SelectEventLoader()
    }
}

//イベント枠内のロードView
struct GradientLoaderView: View {
    //アニメーションタイプ
    var foreverAnimation: Animation {
        Animation.linear(duration: 1)
            .repeatForever(autoreverses: false)
    }
    
    @State var angle: Double = 0.0
    @State var isAnimating = false
    
    var body: some View {
        VStack {
            Circle()
                .fill (
                    LinearGradient(gradient: Gradient(colors: [ .black, Color("overlayShadow"), .white, .white]),
                                   startPoint: .topLeading, endPoint: .bottomTrailing)
            )
                .foregroundColor(Color.white)
                .frame(width: 900, height: 900, alignment: .center)
                .rotationEffect(Angle(degrees: self.isAnimating ? 360 : 0))
                .offset(x: -300.0, y: -300.0)
                .animation(self.foreverAnimation)
                .onAppear {
                    self.isAnimating = true
            }
            
        }
    }
}

//
//  StatusView.swift
//  QRアプリtest
//
//  Created by 蘭搏 on 2021/08/23.
//

import SwiftUI

struct StatusView: View {
    //集計情報取得処理
    @ObservedObject var countVisitedNetworkManager = CountVisitedNetworkManager()
    //他のViewから呼ばれるかどうか判定するため
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var pickerItem = "totalWebSaledSeat"
    var event: Event

    var body: some View {
        ZStack {
            Color("status")
                .edgesIgnoringSafeArea(.all)
            VStack {
                VStack {
                    //集計タイプ選択バー
                    Picker(selection: $pickerItem, label: Text("").opacity(0.3)) {
                        Text("WEB販売").foregroundColor(.white).frame(width: 100, height: 40, alignment: .center).tag("totalWebSaledSeat")
                        Text("全体").foregroundColor(.white).frame(width: 100, height: 40, alignment: .center).tag("totalSeat")
                    }.pickerStyle(SegmentedPickerStyle()).background(Color.white.opacity(0.5)).cornerRadius(8)
                        .padding(.horizontal, 48)
                        .padding(.top, 20)
                        .padding(.bottom, 20)
                }
                
                //集計詳細View
                StatusCircleView(diameter: 200, value: $pickerItem).environmentObject(countVisitedNetworkManager)
                
            }
            .blur(radius: countVisitedNetworkManager.requestStatus == .Rejected ? 3 : 0)

            .navigationBarBackButtonHidden(true)
            //タイトル
            .navigationBarTitle(Text("入場ステータス"), displayMode: .inline)
            //左上ボタン、前画面に戻る
            .navigationBarItems(leading:
                Button(action: {
                    //今のViewを閉じる
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    ZStack {
                        Circle()
                            .fill(Color.clear)
                            .frame(width: 36, height: 36)
                        
                        Image(systemName: "arrow.left")
                            .font(Font.system(size: 20, weight: .regular))
                            .foregroundColor(.black)
                            .frame(width: 44, height: 44)
                            
                    }
                    .frame(width: 44, height: 44, alignment: .center)
                }
            )
            
            if self.countVisitedNetworkManager.requestStatus == .Pending {
                VStack {
                    Loader()
                }
            }
            
            if self.countVisitedNetworkManager.requestStatus == .Rejected {
                NetworkErrorView()
                    .onTapGesture() {
                        countVisitedNetworkManager.count(data: event)
                    }
            }
        }
        .onAppear{
            countVisitedNetworkManager.count(data: event)
        }
    }
    
}

struct StatusView_Previews: PreviewProvider {
    static var previews: some View {
        StatusView(event: Event())
    }
}

struct StatusCircleView: View {
    //引数：円マークサーズ
    var diameter: CGFloat
    @EnvironmentObject var countVisitedNetworkManager: CountVisitedNetworkManager
    
    //パーセンテージ表示動画
    var foreverAnimation: Animation {
        Animation.linear(duration: 0.2)
    }
    @State var grow = false
    @Binding var value: String
    
    var body: some View {
        VStack(spacing: 0) {
            
            ZStack {
                Color("status")
                    //                .opacity(0.6)
                    .edgesIgnoringSafeArea(.vertical)
                //背景円
                Circle()
                    //全円
                    .trim(from: 0, to: 1)
                    //背景、円の太さ、スタイル
                    .stroke(Color.white, style: StrokeStyle(
                        lineWidth: 12,
                        lineCap: .round
                    ))
                    .frame(width: diameter, height: diameter, alignment: .center)
                    .opacity(0.2)
                    
                    .overlay(
                        //入場者パーセンテージ表示円マーク
                        Circle()
                            //パーセンテージ表示
                            .trim(from: 0, to: grow ? CGFloat(getPercentageValue(data: countVisitedNetworkManager, pickerItem: value) / 100) : 0)
                            .stroke(
                                LinearGradient(gradient: Gradient(colors: [Color("statusCircleGradienLight"), Color("statusCircleGradienDark")]),
                                                   startPoint: .topLeading, endPoint: .bottomTrailing)
                                , style: StrokeStyle(
                                                    lineWidth: 16,
                                                    lineCap: .round
                            ))
                            .frame(width: diameter, height: diameter, alignment: .center)
                            .rotationEffect(.degrees(-90), anchor: .center)
                            .rotation3DEffect(.degrees(0), axis: (x: 1, y: 0, z: 0))
                            .animation(foreverAnimation)

                            .onAppear() {
                                self.grow.toggle()
                        }
                )
                //円マーク内入場者数パーセンテージ表示
                VStack {
                    Text(getPickerItemName(pickerItem: value))
                        .font(Font.system(size: 32, weight: .semibold))
                        .foregroundColor(.white)
                    Text(String(format: "%.0f", getPercentageValue(data: countVisitedNetworkManager, pickerItem: value)) + "%")
                        .font(Font.system(size: 32, weight: .semibold))
                        .foregroundColor(.white)
                }
            }
            .frame(width: UIScreen.main.bounds.width, height: 300, alignment: .bottom)
            
            //入場者数と購入者数枠
            VStack {
                HStack {
                    //入場者数カウント
                    VStack(spacing: 10) {
                        Text("入場者数")
                            .font(.system(size: 14))
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .opacity(0.5)
                        Text(String(getVisitedSeatValue(data: countVisitedNetworkManager, pickerItem: value)))
                            .font(.system(size: 24))
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                    }
                    .frame(width: 140, height: 100, alignment: .center)
                    
                    //購入者数カウント
                    VStack(spacing: 10) {
                        Text("購入者数")
                            .font(.system(size: 14))
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .opacity(0.5)
                        Text(String(getTotalSeatValue(data: countVisitedNetworkManager, pickerItem: value)))
                            .font(.system(size: 24))
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                    .frame(width: 140, height: 100, alignment: .center)
                }
                
                .frame(width: 280, height: 100, alignment: .center)
                .cornerRadius(20)
                .shadow(color: .gray, radius: 4, x: 0, y: 2)
            }
            .frame(width: UIScreen.main.bounds.width, height: 100, alignment: .center)
            .background(Color("status"))
        }
        
    }
    
    //入場者パーセンテージ
    func getPercentageValue (data: CountVisitedNetworkManager , pickerItem: String) -> Float {
        let countStatus = data.countStatus
        if pickerItem == "totalWebSaledSeat" && countStatus.totalWebSaledSeat != 0 {
            let percentage = Double(countStatus.totalVisitedWebSaledSeat) / Double(countStatus.totalWebSaledSeat) * 100
            return Float(ceil(percentage))
        } else if pickerItem == "totalSeat" && countStatus.totalSeat != 0 {
            let percentage = Double(countStatus.totalVisitedSeat) / Double(countStatus.totalSeat) * 100
            return Float(ceil(percentage))
        } else {
            return 0
        }
        
    }
    
    //円マーク内タイトル
    func getPickerItemName (pickerItem: String) -> String {
        if pickerItem == "totalWebSaledSeat" {
            return "WEB販売"
        } else if pickerItem == "totalSeat" {
            return "全体"
        } else {
            return ""
        }

    }
    
    //入場者数数
    func getVisitedSeatValue (data: CountVisitedNetworkManager , pickerItem: String) -> Int {
        let countStatus = data.countStatus
        if pickerItem == "totalWebSaledSeat" {
            return countStatus.totalVisitedWebSaledSeat
        } else if pickerItem == "totalSeat" {
            return countStatus.totalVisitedSeat
        } else {
            return 0
        }
    }
    
    //購入者数
    func getTotalSeatValue (data: CountVisitedNetworkManager , pickerItem: String) -> Int {
        let countStatus = data.countStatus
        if pickerItem == "totalWebSaledSeat" {
            return countStatus.totalWebSaledSeat
        } else if pickerItem == "totalSeat" {
            return countStatus.totalSeat
        } else {
            return 0
        }
    }
}


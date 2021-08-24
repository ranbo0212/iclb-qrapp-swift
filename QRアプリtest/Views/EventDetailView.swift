//
//  EventDetailView.swift
//  QRアプリtest
//
//  Created by 蘭搏 on 2021/08/23.
//

import SwiftUI

struct EventDetailView: View {
    //引数：イベント情報
    var event: Event
    //引数：[onPressed] false:イベント一覧画面、true:イベント詳細画面
    @Binding var onPressed: Bool
    //スライドデータ
    @State var slideSize = CGSize.zero
    //引数：[isPresented] false:イベント詳細画面、true:QRスキャン画面
    @State var isPresented = false
    //利用されない
    @State var isShowedStatus = false
    //引数：[isActive] false:イベント詳細画面、true:集計情報画面
    @State var isActive = false
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack {
                    //イベント画像
                    VStack {
                        VStack {
                            Image(event.image)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .clipped()
                                .overlay (
                                    Rectangle()
                                        .fill (
                                            LinearGradient(gradient: Gradient(colors: [.clear, Color("overlayShadowDetail")]),
                                                           startPoint: .center, endPoint: .bottom)
                                ))
                            Spacer()
                        }
                    }
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 2, alignment: .center)
                    .shadow(color: .gray, radius: 8, x: 0, y: 4)
                    
                    VStack {
                        VStack {
                            //イベント名
                            HStack {
                                Text(event.eventName)
                                    .font(.system(size: 18))
                                    .fontWeight(.semibold)
                                    .foregroundColor(.black)
                                Spacer()
                            }
                            .frame(maxHeight: 40)
                            .background(Color.clear)
                            
                            VStack (alignment: .leading) {
                                //イベント日付
                                HStack {
                                    Image(systemName: "calendar")
                                        .font(Font.body.weight(.semibold))
                                        .foregroundColor(.black)
                                    Text(event.startDate)
                                        .font(.system(size: 12))
                                        .fontWeight(.semibold)
                                        .foregroundColor(.black)
                                    Spacer()
                                }
                                .frame(maxHeight: 40)
                                .background(Color.clear)
                                
                                //イベント時間帯
                                HStack {
                                    Image(systemName: "clock")
                                        .font(Font.body.weight(.semibold))
                                        .foregroundColor(.black)
                                    Text(event.startTime + " 〜 " + event.endTime)
                                        .font(.system(size: 12))
                                        .fontWeight(.semibold)
                                        .foregroundColor(.black)
                                    Spacer()
                                }
                                .frame(maxHeight: 40)
                                .background(Color.clear)
                            }
                            .frame(minWidth: 240, minHeight: 80, idealHeight: 140, maxHeight: 180)
                            .background(Color.clear)
                        }
                        .padding(.vertical, 10)
                        .padding(.horizontal, 60)
                        .background(Color.clear)
                        
                        //スライド
                        VStack {
                            HStack {
                                if self.isPresented {
                                    //空白を入れる
                                    Spacer()
                                }
                                //イベント開始日は当日の場合、スライドできる
                                Circle()
                                    .fill ( self.event.available ?
                                                  LinearGradient(gradient:Gradient(colors:[Color("statusCircleGradienLight"),Color("statusCircleGradienDark")]),
                                                                 startPoint: .topLeading, endPoint: .bottomTrailing)
                                                : LinearGradient(gradient:Gradient(colors:
                                                      [Color.gray, Color.white]),
                                                                 startPoint: .topLeading, endPoint: .bottomTrailing)
                                    )
                                    .overlay(Image(systemName: "chevron.right")
                                                .font(Font.system(size: 24, weight: .semibold))
                                                .foregroundColor(.black))
                                    .frame(width: 50, height: 50)
                                    .animation(.interactiveSpring())
                                    .padding(.leading, 5)
                                    .padding(.trailing, 5)
                                    .offset(x: self.event.available == true ? slideSize.width : 0, y: 0)
                                    .gesture(
                                        DragGesture()
                                            //スライト時位置情報取得
                                            .onChanged { value in
                                                if self.event.available {
                                                    if self.isPresented == false {
                                                        print(value.startLocation)
                                                        print(1)
                                                        if value.location.x >= value.startLocation.x - 10 && value.location.x <= value.startLocation.x + 245  {
                                                            self.slideSize = value.translation
                                                        }
                                                    } else {
                                                        print(value.startLocation)
                                                        print(2)
                                                        if value.location.x <= value.startLocation.x + 10 && value.location.x >= value.startLocation.x - 245 {
                                                            self.slideSize = value.translation
                                                        }
                                                    }
                                                }
                                            }
                                            //位置情報によって、画面遷移を行う
                                            .onEnded { value in
                                                if self.event.available {
                                                    if self.isPresented == false {
                                                        print(value.translation.width)
                                                        print(1)
                                                        if value.translation.width > 130 {
                                                            self.slideSize = .zero
                                                            self.isPresented = true
                                                        } else {
                                                            self.slideSize = .zero
                                                            self.isPresented = false
                                                        }
                                                    } else {
                                                        print(value.translation.width)
                                                        print(2)
                                                        if value.translation.width < -130 {
                                                            self.slideSize = .zero
                                                            self.isPresented = false
                                                        } else {
                                                            self.slideSize = .zero
                                                            self.isPresented = true
                                                        }
                                                    }
                                                }
                                            }
                                        )
                                if !self.isPresented {
                                    Spacer()
                                }
                            }
                            .frame(width: UIScreen.main.bounds.width - 80, height: 60)
                            .background(
                                //スライド欄内のスタイル
                                HStack(spacing: 8) {
                                    Image(systemName: "qrcode.viewfinder")
                                        .font(Font.system(size: 24, weight: .regular))
                                        .foregroundColor(.white)
                                    Text("スライド")
                                        .font(Font.system(size: 18, weight: .semibold))
                                        .foregroundColor(.white)
                                }
                                .frame(width: UIScreen.main.bounds.width - 80, height: 60)
                                .offset(x: 8)
                                .background(Color.black)
                            )
                                .cornerRadius(90.0)
                        }
                        .frame(maxHeight: 80)
                        .background(Color.clear)
                    }
                    .padding(.all, 40)
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 2, alignment: .center)
                    .background(Color.clear)
                }
            }
            //$isPresentedがtrueになった場合、QRScannerViewに遷移する
            .sheet(
                isPresented: $isPresented,
                content: {
                    QRScannerView(isPresented: self.$isPresented, event: self.event)
            })
            
        }
            
        .edgesIgnoringSafeArea(.all)
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(false)
        .navigationBarItems(
            //左上ボタン、押すと前画面に遷移
            leading:
                Button(action: {
                    self.onPressed = false
                }) {
                    ZStack {
                        Circle()
                            .fill(Color.white)
                            .frame(width: 36, height: 36)
                        
                        Image(systemName: "arrow.left")
                            .font(Font.system(size: 20, weight: .regular))
                            .foregroundColor(.black)
                            
                    }
                    .frame(width: 44, height: 44, alignment: .center)
                },
            //右上ボタン、押すと集計画面に遷移
            trailing:
                Button(action: {
                    self.isActive = true
                }) {
                    ZStack {
                        Circle()
                            .fill(Color.white)
                            .frame(width: 36, height: 36)
                        
                        Image(systemName: "person.crop.circle.badge.checkmark")
                            .font(Font.system(size: 20, weight: .regular))
                            .foregroundColor(.black)
                            .frame(width: 44, height: 44)
                            
                    }
                    .frame(width: 44, height: 44, alignment: .center)
                }
        )
        
        NavigationLink(destination: StatusView(event: event), isActive: self.$isActive) {
        }
    }
}

//
//  SelectEventView.swift
//  QRアプリtest
//
//  Created by 蘭搏 on 2021/07/12.
//

import SwiftUI

struct SelectEventView: View {
    @EnvironmentObject var authNetWorkManager: AuthNetWorkManager
    @ObservedObject var selectEventsNetWorkManager = SelectEventsNetWorkManager()
    //ログアウトボタンが非活性/活性
    @State var showLogoutButton = false
    
    var body: some View {
        ZStack {
            NavigationView {
                ZStack(alignment: .top) {
                    VStack {
                        RefreshableScrollView()
                    }
                    
                    //四角形を描画
                    Rectangle()
//                        .fill(Color.white)
                        .frame(width: UIScreen.main.bounds.width, height: 88, alignment: .center)
                        .offset(x: 0, y: -148)

                        .navigationBarTitle(Text("時間帯"))
                        //右上にボタンを追加
                        //ボタンをクリックすると、showLogouButtonが逆になる
                        .navigationBarItems(trailing:Button(action: {
                                                    self.$showLogoutButton.wrappedValue.toggle()
                        }) {
                            //ボタン表示画像、サイズ、色、文字スタイル設定
                            Image(systemName: "text.alignright")
                                .font(Font.system(size: 20, weight: .regular))
                                .foregroundColor(.black)
                                .frame(width: 44, height: 44, alignment: .trailing)
                        }
                        //Bar Buttonをクリックする場合の処理
                        .actionSheet(isPresented: $showLogoutButton) {
                            ActionSheet(title: Text("ログアウトしますか？"),
                                        buttons: [
                                            .destructive(
                                                Text("ログアウト")
                                                    .font(.headline)
                                                    .fontWeight(.semibold)
                                                    .foregroundColor(.red)
                                                , action: {
                                                    self.authNetWorkManager.logout()
                                            }),
                                            .cancel((Text("キャンセル")))])
                        }
                    )
                }
            }
            //イベント取得失敗の場合、ぼかしする
//            .blur(radius: selectEventsNetWorkManager.requestStatus == .Rejected ? 3 : 0)
//
//
//            if self.selectEventsNetWorkManager.requestStatus == .Rejected {
//                //ネットワーク通信エラーの場合通信エラーViewが表示される
//                NetworkErrorView()
//                    //通信エラーViewの任意場所をクリックすると、ログアウトするか、イベント情報を取得する
//                    .onTapGesture() {
//                        if UserDefaults.standard.isAuthorized() == false {
//                            //ネットが切れた場合、ログアウトする
//                            self.authNetWorkManager.logout()
//                        } else {
//                            //ネットが繋がっている場合、イベントを再取得する
//                            selectEventsNetWorkManager.getEvents()
//                        }
//                    }
//            }
        }
    }
}

struct SelectEventView_Previews: PreviewProvider {
    static var previews: some View {
        SelectEventView()
    }
}


struct EventCardView: View {
    // Animation
    var foreverAnimation: Animation {
        Animation.linear(duration: 1.5)
            .repeatForever(autoreverses: false)
    }
    
    
    let event: Event
    @State var onPressed: Bool = false
    @State var liveAnimationAmount: CGFloat = 1
    var body: some View {
        
        VStack {
            NavigationLink(destination: TopView()
//                            EventDetailView(event: event, onPressed: $onPressed), isActive: $onPressed
            ) {
                ZStack {
                    Image(event.image)
                        .renderingMode(.original)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .overlay (
                            Rectangle()
                                .fill (
                                    LinearGradient(gradient: Gradient(colors: [.clear, Color("overlayShadow")]),
                                                   startPoint: .center, endPoint: .bottom)
                        ))
                        .frame(width: UIScreen.main.bounds.width, height: 240)
                        .clipped()
                    
                    ZStack {
                        if event.isToday == true {
                            Rectangle()
                                .fill(Color.red)
                                .foregroundColor(Color.white)
                                .frame(width: 80, height: 24, alignment: .topLeading)
                            
                            HStack {
                                Circle()
                                    .fill(Color.white)
                                    .frame(width: 8, height: 8)
                                    .overlay(
                                        Circle()
                                            .stroke(Color.white)
                                            .scaleEffect(liveAnimationAmount)
                                            .opacity(Double(2 - liveAnimationAmount))
                                            .onAppear {
                                                withAnimation(self.foreverAnimation) {
                                                    self.liveAnimationAmount = 2
                                                }
                                            }
                                )
                                
                                Text("本日入場")
                                    .font(.system(size: 12))
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                            }
                        }
                        
                    }
                    .cornerRadius(4)
                    .padding(.all, 24)
                    .frame(minWidth: 0, maxWidth: UIScreen.main.bounds.width - 40, minHeight: 120, maxHeight: .infinity, alignment: Alignment.topLeading)
                    .shadow(color: .gray, radius: 8, x: 0, y: 4)
                    .background(Color.clear)
                    
                    VStack {
                        HStack {
                            Text(event.eventName)
                                .font(.system(size: 18))
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                            Spacer()
                        }
                        .frame(maxHeight: 60)
                        .padding(.vertical, 10)
                        .background(Color.clear)
                        
                        
                        VStack (alignment: .leading, spacing: 10) {
                            HStack  {
                                Image(systemName: "calendar")
                                    .font(Font.body.weight(.light))
                                    .foregroundColor(.white)
                                Text(event.startDate)
                                    .font(.system(size: 12))
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                                Spacer()
                            }
                            .background(Color.clear)
                            
                            HStack {
                                HStack {
                                    Image(systemName: "clock")
                                        .font(Font.body.weight(.light))
                                        .foregroundColor(.white)
                                    Text(event.startTime + " 〜 " + event.endTime)
                                        .font(.system(size: 12))
                                        .fontWeight(.semibold)
                                        .foregroundColor(.white)
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
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 20)
        .background(Color.white)
    }
}

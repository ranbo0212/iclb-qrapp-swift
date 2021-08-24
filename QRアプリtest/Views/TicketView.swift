//
//  TicketView.swift
//  QRアプリtest
//
//  Created by 蘭搏 on 2021/08/23.
//

import SwiftUI

struct TicketView: View {
    //QRスキャン処理
    @EnvironmentObject var updateQRCodeNetWorkManager: UpdateQRCodeNetWorkManager
    //引数：[qrcodeIsRead] false:QRスキャン画面、true:スキャン結果画面
    @Binding var qrcodeIsRead : Bool
    
    //引数：イベント情報
    var event: Event
    
    var body: some View {
        ZStack {
            Color.white.opacity(0.6)
                .edgesIgnoringSafeArea(.vertical)
            
            VStack {
                
                //QRスキャン結果View
                TicketResultView().environmentObject(updateQRCodeNetWorkManager)
                
                //QRスキャン詳細View
                TicketBodyView().environmentObject(updateQRCodeNetWorkManager)
                
                //QRスキャン後対応ボタンView
                TicketButtonView(qrcodeIsRead: $qrcodeIsRead, event: event).environmentObject(updateQRCodeNetWorkManager)
                
                
            }
            .frame(width: 351)
            .background(Color("ticketBackground"))
            .cornerRadius(20)
            .shadow(color: Color("overlayShadowDetail"), radius: 40, x: 0, y: 20)
        }
        .scaleEffect(UIScreen.main.bounds.width < 340 ? 0.85 : 1)
    }
}

//リクエスト結果
//入場済みの場合、端末確認("（前回読取端末：当端末）" : "（前回読取端末：別端末）")
//入場済みまたはOKの場合、入場時間表示("前回入場時間:" : "入場時間:")
struct TicketResultView: View {
    @EnvironmentObject var updateQRCodeNetWorkManager: UpdateQRCodeNetWorkManager
    var body: some View {
        
        VStack {
            VStack(spacing: 4) {
                HStack(spacing: 2) {
                    //入場状態表示
                    Text(self.updateQRCodeNetWorkManager.tickets.message)
                        .fontWeight(.bold)
                        .foregroundColor(Color.white)
                    
                    //入場済みの場合、端末確認
                    if self.updateQRCodeNetWorkManager.tickets.message == "入場済み" {
                        Text(self.updateQRCodeNetWorkManager.tickets.listTicketIssued.isLastCheckedDevice ? "（前回読取端末：当端末）" : "（前回読取端末：別端末）")
                            .fontWeight(.bold)
                            .foregroundColor(Color.white)
                    }
                }
                
                //入場済みまたはOKの場合、入場時間表示
                if !self.updateQRCodeNetWorkManager.tickets.listTicketIssued.updateDate.isEmpty {
                    if (self.updateQRCodeNetWorkManager.tickets.result == "OK" || self.updateQRCodeNetWorkManager.tickets.message == "入場済み") {
                        HStack {
                            Text(self.updateQRCodeNetWorkManager.tickets.message == "入場済み" ? "前回入場時間:" : "入場時間:")
                                .font(.system(size: 14))
                                .fontWeight(.semibold)
                            Text(self.updateQRCodeNetWorkManager.tickets.listTicketIssued.updateDate)
                                .font(.system(size: 14))
                                .fontWeight(.semibold)
                        }
                        .foregroundColor(.white)
                        
                    }
                }
            }
            .padding(.top, 20)
            .padding(.bottom, 20)
            .frame(maxWidth: .infinity)
            //入場状態によって、バックグランド色が変わる
            .if(self.updateQRCodeNetWorkManager.tickets.result == "OK") { view in
                view.background(Color("ok"))
            }
            .if(self.updateQRCodeNetWorkManager.tickets.result == "NG") { view in
                view.background(Color("ng"))
            }
            .if(self.updateQRCodeNetWorkManager.tickets.message == "入場済み") { view in
                view.background(Color("warning"))
            }
            .if(self.updateQRCodeNetWorkManager.tickets.message == "入場取消") { view in
                view.background(Color("info"))
            }
        }
    }
}

//リクエスト詳細
//"NG"の場合、空白Viewが表示される
//それ以外の場合、イベント情報が表示される
struct TicketBodyView: View {
    @EnvironmentObject var updateQRCodeNetWorkManager: UpdateQRCodeNetWorkManager
    var body: some View {
        
        VStack {
            if self.updateQRCodeNetWorkManager.tickets.result == "NG" {
                EmptyView()
            } else {
                VStack (spacing: 10) {
                    //イベント名
                    HStack {
                        Spacer()
                        Text(self.updateQRCodeNetWorkManager.tickets.listTicketIssued.eventName)
                            .font(.system(size: 14))
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                        Spacer()
                    }
                    .frame(height: 40, alignment: .bottom)
                    .padding(.top, 12)
                    .padding(.bottom, 8)
                    .background(Color.clear)
                    
                    VStack (spacing: 20) {
                        //受付番号
                        HStack {
                            Text("受付番号：")
                                .font(.system(size: 12))
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                            Text(self.updateQRCodeNetWorkManager.tickets.listTicketIssued.reserveId == 0 ? "": String(format: "%010d", arguments: [self.updateQRCodeNetWorkManager.tickets.listTicketIssued.reserveId]))
                                .font(.system(size: 12))
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                            Spacer()
                        }
                        .background(Color.clear)
                        
                        //イベント日付
                        HStack (spacing: 20) {
                            HStack {
                                Image(systemName: "calendar")
                                    .font(Font.body.weight(.light))
                                    .foregroundColor(.white)
                                Text(self.updateQRCodeNetWorkManager.tickets.listTicketIssued.startDate)
                                    .font(.system(size: 12))
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                            }
                            .background(Color.clear)
                            Spacer()
                            
                        }
                        .background(Color.clear)
                        
                        //イベント時間帯
                        HStack (spacing: 20) {
                            HStack {
                                Image(systemName: "clock")
                                    .font(Font.body.weight(.light))
                                    .foregroundColor(.white)
                                Text(self.updateQRCodeNetWorkManager.tickets.listTicketIssued.startTime + " 〜 " + self.updateQRCodeNetWorkManager.tickets.listTicketIssued.endTime)
                                    .font(.system(size: 12))
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                            }
                            .background(Color.clear)
                            Spacer()
                            
                        }
                        .background(Color.clear)
                        
                        //料金種別
                        HStack (spacing: 10) {
                            //料金種別
                            if !self.updateQRCodeNetWorkManager.tickets.listTicketIssued.priceName.isEmpty {
                                HStack {
                                    Text(self.updateQRCodeNetWorkManager.tickets.listTicketIssued.priceName)
                                        .font(.system(size: 12))
                                        .fontWeight(.semibold)
                                        .foregroundColor(.white)
                                        .lineLimit(2)
                                }
                                .frame(maxWidth: 40, alignment: .leading)
                            }
                            
                            //一般価格
                            if !self.updateQRCodeNetWorkManager.tickets.listTicketIssued.fixedPrice.isEmpty {
                                HStack {
                                    Text(self.updateQRCodeNetWorkManager.tickets.listTicketIssued.fixedPrice + "円")
                                        .font(.system(size: 12))
                                        .fontWeight(.semibold)
                                        .foregroundColor(.white)
                                        .lineLimit(2)
                                }
                                .frame(maxWidth: 60, alignment: .leading)
                            }
                            
                            //販売方法
                            if !self.updateQRCodeNetWorkManager.tickets.listTicketIssued.salesmethod.isEmpty {
                                HStack {
                                    Text(self.updateQRCodeNetWorkManager.tickets.listTicketIssued.salesmethod)
                                        .font(.system(size: 12))
                                        .fontWeight(.semibold)
                                        .foregroundColor(.white)
                                        .lineLimit(2)
                                }
                                .frame(maxWidth: 100, alignment: .leading)
                            }
                            Spacer()
                            
                        }
                        .background(Color.clear)
                        
                        //顧客名
                        HStack (spacing: 10) {
                            if !self.updateQRCodeNetWorkManager.tickets.listTicketIssued.customerKana.isEmpty {
                                HStack {
                                    Text("顧客名: " + self.updateQRCodeNetWorkManager.tickets.listTicketIssued.customerKana)
                                        .font(.system(size: 12))
                                        .fontWeight(.semibold)
                                        .foregroundColor(.white)
                                }
                            }
                
                            Spacer()
                        }
                        .background(Color.clear)
                        
                        //電話番号
                        HStack (spacing: 30) {
                            if !self.updateQRCodeNetWorkManager.tickets.listTicketIssued.tel.isEmpty {
                                HStack {
                                    Text("電話番号: " + self.updateQRCodeNetWorkManager.tickets.listTicketIssued.tel)
                                        .font(.system(size: 12))
                                        .fontWeight(.semibold)
                                        .foregroundColor(.white)
                                }
                            }
                
                            Spacer()
                        }
                        .background(Color.clear)
                    }
                    .padding(.leading, 20)
                    .padding(.trailing, 10)
                }
                .frame(minWidth: 0, maxWidth: UIScreen.main.bounds.width, minHeight: 120, maxHeight: 320, alignment: .topLeading)
                .background(Color.clear)
                .padding(20)
            }
        }
        .frame(minWidth: 120, maxWidth: UIScreen.main.bounds.width, minHeight: 120, maxHeight: 320, alignment: .center)
        .clipped()
        .background(
            Image("ticket")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 342, height: 320, alignment: .bottom)
                .clipped()
        )
            .shadow(color: Color("overlayShadow"), radius: 4, x: 0, y: 2)
        
    }
}

//
struct TicketButtonView: View {
    @EnvironmentObject var updateQRCodeNetWorkManager: UpdateQRCodeNetWorkManager
    @Binding var qrcodeIsRead : Bool
    var event: Event
    var body: some View {
        
        HStack(spacing: 20) {
            
            //確認ボタン、クリックすると、QRスキャン画面が表示される。
            Button(action: {
                self.updateQRCodeNetWorkManager.sounds.stop()
                self.qrcodeIsRead = false
            }) {
                Text("確認")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                    .frame(width: self.updateQRCodeNetWorkManager.tickets.result == "INFO" && self.updateQRCodeNetWorkManager.tickets.message != "入場取消" ? 140 : 300, height: 60)
                    .clipped()
            }
                
            .background(Color.white)
            .cornerRadius(30)
            
            //入場済みの場合、入場取消が表示される。
            if self.updateQRCodeNetWorkManager.tickets.result == "INFO" && self.updateQRCodeNetWorkManager.tickets.message != "入場取消" {
                Button(action: {
                    self.updateQRCodeNetWorkManager.delete(qrData: self.updateQRCodeNetWorkManager.tickets.listTicketIssued.qrCode, data: self.event)
                }) {
                    Text("入場取消")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(width: 140, height: 60)
                        .clipped()
                }
                    
                .background(Color("delete"))
                .cornerRadius(30)
                
            }
            
        }
        .offset(y: 4)
        .frame(maxWidth: .infinity, maxHeight: 100)
        .clipped()
    }
}

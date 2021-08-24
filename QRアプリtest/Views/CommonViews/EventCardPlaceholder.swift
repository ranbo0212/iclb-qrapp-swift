//
//  EventCardPlaceholder.swift
//  QRアプリtest
//
//  Created by 蘭搏 on 2021/08/18.
//

import SwiftUI

//イベント一覧画面に利用される
struct EventCardPlaceholder: View {
    var body: some View {
        
        VStack (spacing: 20) {
            
            ZStack {
                Image("event-1")
                    .renderingMode(.original)
                    .overlay (
                        Rectangle()
                            .fill (
                                LinearGradient(gradient: Gradient(colors: [.clear, Color("overlayShadow")]),
                                               startPoint: .center, endPoint: .bottom)
                    ))
                    .frame(width: UIScreen.main.bounds.width, height: 240)
                    .foregroundColor(Color.black)
                    .clipped()

                VStack {
                    //イベント名
                    HStack {
                        Text("event.eventName.eventName.event.eventName.eventName")
                            .font(.system(size: 18))
                            .fontWeight(.semibold)
                            .foregroundColor(Color("navigation"))
                        Spacer()
                    }
                    .frame(maxHeight: 60)
                    .padding(.vertical, 10)
                    .background(Color.clear)
                    
                    VStack (alignment: .leading, spacing: 10) {
                        //イベント日付
                        HStack  {
                            Image(systemName: "calendar")
                                .font(Font.body.weight(.light))
                                .foregroundColor(.blue)
                            Text("0000/00/00")
                                .font(.system(size: 12))
                                .fontWeight(.semibold)
                                .foregroundColor(Color("navigation"))
                            Spacer()
                        }
                        .background(Color.clear)
                        
                        //イベント時間帯
                        HStack {
                            HStack {
                                Image(systemName: "clock")
                                    .font(Font.body.weight(.light))
                                    .foregroundColor(.blue)
                                Text("00:00 〜 00:00")
                                    .font(.system(size: 12))
                                    .fontWeight(.semibold)
                                    .foregroundColor(Color("navigation"))
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
                .background(Color.clear)
            }
            .frame(width: UIScreen.main.bounds.width - 40, height: 240, alignment: .top)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .shadow(color: .gray, radius: 8, x: 0, y: 4)
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 20)
        .background(Color.clear)
    }
}

struct EventCardPlaceholder_Previews: PreviewProvider {
    static var previews: some View {
        EventCardPlaceholder()
    }
}

//
//  TestView.swift
//  QRアプリtest
//
//  Created by 蘭搏 on 2021/08/23.
//

import SwiftUI

struct TestView: View {
    
    var body: some View {
        GeometryReader { proxy in
            Color.clear.preference(key: RefreshableKeyTypes.PrefKey.self, value: [RefreshableKeyTypes.PrefData(vType: .movingView, bounds: proxy.frame(in: .global))])
        }.frame(height: 0)
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}


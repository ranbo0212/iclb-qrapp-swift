//
//  RefreshableScrollView.swift
//  QRアプリtest
//
//  Created by 蘭搏 on 2021/07/14.
//

import SwiftUI

struct RefreshableScrollView<Content: View>: View {
    //スクロール距離(直前)
    @State private var previousScrollOffset: CGFloat = 0
    //スクロール距離(現在)
    @State private var scrollOffset: CGFloat = 0
    //方向マーク位置固定
    @State private var frozen: Bool = false
    //方向マークの角度、初期値は0
    @State private var rotation: Angle = .degrees(0)
    
    //リフレッシュのしきい値
    var threshold: CGFloat = 80
    //引数：refreshing、true:リフレッシュを行う、false:リフレッシュを行わない
    @Binding var refreshing: Bool
    //引数：View
    let content: Content

    //初期値設定
    init(height: CGFloat = 80, refreshing: Binding<Bool>, @ViewBuilder content: () -> Content) {
        self.threshold = height
        self._refreshing = refreshing
        self.content = content()

    }
    
    var body: some View {
        return VStack {
            ScrollView {
                ZStack(alignment: .top) {
                    //スクロール距離を取得するため、２つのView(MovingView,FixedView)を定義する
                    //MovingViewはスクロースするViewの一致情報取得
                    MovingView()
                    
                    //メイン画面を前画面から取得
                    VStack { self.content }.alignmentGuide(.top, computeValue: { d in (self.refreshing && self.frozen) ? -self.threshold : 0.0 })
                    
                    //ロード画面はリフレッシュ状況によって変わる
                    SymbolView(height: self.threshold, loading: self.refreshing, frozen: self.frozen, rotation: self.rotation)
                }
            }
            //FixedViewは固定位置情報取得
            .background(FixedView())
            .onPreferenceChange(RefreshableKeyTypes.PrefKey.self) { values in
                self.refreshLogic(values: values)
            }
        }
    }
    
    func refreshLogic(values: [RefreshableKeyTypes.PrefData]) {
        DispatchQueue.main.async {
            // Calculate scroll offset
            let movingBounds = values.first { $0.vType == .movingView }?.bounds ?? .zero
            let fixedBounds = values.first { $0.vType == .fixedView }?.bounds ?? .zero
            
            //スクロールした距離
            self.scrollOffset  = movingBounds.minY - fixedBounds.minY
            
            //方向マークの回転角度
            self.rotation = self.symbolRotation(self.scrollOffset)
            
            //リフレッシュしていない、スクロール距離は限界値を超える瞬間、リフレッシュする
            if !self.refreshing && (self.scrollOffset > self.threshold && self.previousScrollOffset <= self.threshold) {
                self.refreshing = true
            }
            
            //リフレッシュ開始後、スクロール距離は限界値より小さくなる瞬間、画面相対位置が固定する
            if self.refreshing {
                // Crossing the threshold on the way up, we add a space at the top of the scrollview
                if self.previousScrollOffset > self.threshold && self.scrollOffset <= self.threshold {
                    self.frozen = true

                }
            }
            //リフレッシュ終了後、画面相対位置固定が解除する
            else {
                // remove the sapce at the top of the scroll view
                self.frozen = false
            }
            
            // スクロール時の距離を直前の距離として保存する
            self.previousScrollOffset = self.scrollOffset
        }
    }
    
    //スクロール距離のよって、方向マーク回転角度を計算する
    //スクロール距離<=48の場合：回転しない
    //48<スクロース距離<80の場合:回転角度=180*(scrollOffset-48)/32
    //スクロース距離=80の場合：
    func symbolRotation(_ scrollOffset: CGFloat) -> Angle {
        
        // We will begin rotation, only after we have passed
        // 60% of the way of reaching the threshold.
        if scrollOffset < self.threshold * 0.60 {
            return .degrees(0)
        } else {
            // Calculate rotation, based on the amount of scroll offset
            let h = Double(self.threshold)
            let d = Double(scrollOffset)
            let v = max(min(d - (h * 0.6), h * 0.4), 0)
            return .degrees(180 * v / (h * 0.4))
        }
    }
    
    struct SymbolView: View {
        var height: CGFloat
        var loading: Bool
        var frozen: Bool
        var rotation: Angle
        
        
        var body: some View {
            Group {
                //リフレッシュ開始後、ロード画面が表示される
                if self.loading { // If loading, show the activity control
                    VStack {
                        Spacer()
                        PullDownLoader()
                        Spacer()
                    }.frame(height: height).fixedSize()
                        .offset(y: -40 - height + (self.loading && self.frozen ? height : 0.0))
                }
                //リフレッシュ開始前、方向マークが表示される
                else {
                    Image(systemName: "arrow.down") // If not loading, show the arrow
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: height * 0.25, height: height * 0.25).fixedSize()
                        .padding(height * 0.375)
                        .rotationEffect(rotation)
                        .offset(y: -40 - height + (loading && frozen ? +height : 0.0))
                        
                }
            }
        }
    }
    
    //移動されたView
    struct MovingView: View {
        var body: some View {
            GeometryReader { proxy in
                Color.clear.preference(key: RefreshableKeyTypes.PrefKey.self, value: [RefreshableKeyTypes.PrefData(vType: .movingView, bounds: proxy.frame(in: .global))])
            }.frame(height: 0)
        }
    }
    
    //固定View
    struct FixedView: View {
        var body: some View {
            GeometryReader { proxy in
                Color.clear.preference(key: RefreshableKeyTypes.PrefKey.self, value: [RefreshableKeyTypes.PrefData(vType: .fixedView, bounds: proxy.frame(in: .global))])
            }
        }
    }
}

struct RefreshableKeyTypes {
    enum ViewType: Int {
        case movingView
        case fixedView
    }

    struct PrefData: Equatable {
        let vType: ViewType
        let bounds: CGRect
    }

    struct PrefKey: PreferenceKey {
        static var defaultValue: [PrefData] = []

        static func reduce(value: inout [PrefData], nextValue: () -> [PrefData]) {
            value.append(contentsOf: nextValue())
        }

        typealias Value = [PrefData]
    }
}


//ロード画面、ここでは使用されない
struct ActivityRep: UIViewRepresentable {
    func makeUIView(context: UIViewRepresentableContext<ActivityRep>) -> UIActivityIndicatorView {
        return UIActivityIndicatorView()
    }
    
    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<ActivityRep>) {
        uiView.startAnimating()
    }
}

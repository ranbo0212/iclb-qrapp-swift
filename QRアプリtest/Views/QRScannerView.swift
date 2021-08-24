//
//  QRScannerView.swift
//  QRアプリtest
//
//  Created by 蘭搏 on 2021/08/23.
//

import SwiftUI

struct QRScannerView: View {
    //QRスキャン処理
    @ObservedObject var updateQRCodeNetWorkManager = UpdateQRCodeNetWorkManager()
    //引数：[isPresented] false:イベント詳細画面、true:QRスキャン画面
    @Binding var isPresented : Bool
    //引数：[qrcodeIsRead] false:QRスキャン画面、true:スキャン結果画面
    @State var qrcodeIsRead : Bool = false
    @State var animateViewfinder : Bool = false
    
    var event: Event
    
    var body: some View {
        
        ZStack(alignment: .top) {
            Color.white.opacity(0.6)
                .edgesIgnoringSafeArea(.vertical)
                .blur(radius: updateQRCodeNetWorkManager.requestStatus == .Rejected ? 3 : 0)
            
            //QRスキャンする前、または失敗した場合、QRスキャン画面が表示される
            if !self.qrcodeIsRead {
                QRCodeScan(showingModal: self.$qrcodeIsRead, event: event).environmentObject(updateQRCodeNetWorkManager)
                
                //
                LinearGradient(gradient: Gradient(colors: [Color("statusCircleGradienLight"), Color("statusCircleGradienDark")]),
                               startPoint: .topLeading, endPoint: .bottomTrailing)
                    .opacity(animateViewfinder ? 0 : 0.3)
                    .edgesIgnoringSafeArea(.all)
                
                //カメラ内枠をつける
                VStack(alignment: .center) {
                    Spacer()
                    Image("cameraViewFinder")
                        .renderingMode(.original)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipped()
                        .padding(30)
                        .colorMultiply(Color.white)
                        .scaleEffect(animateViewfinder ? 0.95 : 1)
                        .animation(.spring())
                        .onAppear(perform: {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                                withAnimation {
                                    self.animateViewfinder = true
                                }
                            }
                        })
                    Spacer()
                }
                //下にスクロールすると、全画面に戻る処理
                Rectangle()
                    .fill(Color.clear)
                    .frame(width: UIScreen.main.bounds.width, height: 60, alignment: .center)
                    .overlay(
                        Button(action: {
                            self.isPresented = false
                            print(self.isPresented)
                        }) {
                            Image(systemName: "chevron.compact.down")
                                .font(.system(size: 36))
                                .foregroundColor(Color.white)
                                .frame(width: 60, height: 60, alignment: .center)
                                .background(Color.clear)
                        })
                //                    .navigationBarHidden(true)
            } else {
                if updateQRCodeNetWorkManager.requestStatus == .Pending {
                    Loader()
                } else if updateQRCodeNetWorkManager.requestStatus == .Rejected {
                    NetworkErrorView()
                        .onTapGesture() {
                            qrcodeIsRead = false
                            updateQRCodeNetWorkManager.initTickets()
                    }
                } else if updateQRCodeNetWorkManager.requestStatus == .Fulfilled {
                    TicketView(qrcodeIsRead: $qrcodeIsRead, event: event).environmentObject(updateQRCodeNetWorkManager)
                }
            }
        }
    }
}


//QRスキャンコントローラを利用する
struct QRCodeScan: UIViewControllerRepresentable {
    
    @EnvironmentObject var updateQRCodeNetWorkManager : UpdateQRCodeNetWorkManager
    @Binding var showingModal : Bool
    
    var event: Event
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    func makeUIViewController(context: Context) -> QRScannerViewController {
        let qrScannerViewController = QRScannerViewController()
        qrScannerViewController.delegate = context.coordinator
        return qrScannerViewController
    }
    
    func updateUIViewController(_ qrScannerViewController: QRScannerViewController, context: Context) {
    }
    
    class Coordinator: NSObject, QRCodeScannerDelegate {
        
        let parent: QRCodeScan
        
        init(parent: QRCodeScan) {
            self.parent = parent
        }
        
        func codeDidFind(_ code: String) {
            
            //QRコードを見つけた場合、サーバーへリクエストする
            if !code.isEmpty {
                self.parent.updateQRCodeNetWorkManager.update(qrData: code, data: parent.event)
                self.parent.showingModal = true
            }
            print(code)
        }
    }
}

struct QRScannerView_Previews: PreviewProvider {
    @State static var isPresented = true
    
    static var previews: some View {
        ForEach(["iPhone Xs"], id: \.self) { deviceName in
            QRScannerView(isPresented: $isPresented, event: Event())
                .previewDevice(PreviewDevice(rawValue: deviceName))
                .previewDisplayName(deviceName)
        }
    }
}

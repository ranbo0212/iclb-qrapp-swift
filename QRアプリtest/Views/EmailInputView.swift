//
//  EmailInputView.swift
//  QRアプリtest
//
//  Created by 蘭搏 on 2021/07/13.
//

import SwiftUI

struct EmailInputView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var email : String = ""
    @State var isActive = false
    
    var body: some View {
        VStack(spacing: 0){
            VStack (alignment: .leading, spacing: 4) {
                // テキスト”メールアドレス”未入力の場合非表示
                HStack {
                    Text("メールアドレス")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(Color("label"))
                    Spacer()
                }
                .opacity(!email.isEmpty ? 1 : 0)  //未入力の場合透明度は"1"
                .offset(x: 0, y: !email.isEmpty ? 10 : 60)  //未入力→入力済み　移動距離：10⇨60
                .animation(Animation.easeInOut(duration: 0.3).delay(0.2)) //表示するアニメーション

                //テキスト入力フォーム
                CustomEmailTextField(text: $email, isFirstResponder: $isActive)
                    .frame(width: UIScreen.main.bounds.width, height: 60, alignment: .leading)

            }
            .frame(height: 240, alignment: .bottom)
            
            Spacer()
        }
        .padding(.leading, 30)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(
            //左上ボタン
            leading:
            Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "arrow.left")
                    .font(.system(size: 20))
                    .foregroundColor(Color.black)
                    .frame(width: 44, height: 44, alignment: .leading)
            },
            //右上ボタン
            trailing:
            Button(action: {
                self.isActive = true
                print(self.$email)
            }) {
                Text("次へ")
                .font(.system(size: 17))
                .fontWeight(.bold)
                    .foregroundColor(changeButtonColor)
                .frame(width: 44, height: 44, alignment: .trailing)
            }
            .disabled(email.isEmpty)  // 未入力の場合非活性
        )
        
        NavigationLink(destination: PasswordInputView(email: self.$email), isActive: self.$isActive) {
        }
    }
    var changeButtonColor: Color {
        return email.isEmpty ? .gray : Color("navigation")
    }
}

//SwiftUI.TextField の入力がおかしいときは、マークされたテキストのときに起こっているようだったので、そのときの入力だけ無視するように UITextField を代わりに使って実装します。
//※ マークされたテキストは、日本語のような multistage text input のときに起きるそうです。

struct CustomEmailTextField: UIViewRepresentable {

    @Binding var text: String
    @Binding var isFirstResponder: Bool
    
    func makeCoordinator() -> CustomEmailTextField.Coordinator {
        return Coordinator(parent: self)
    }

    //UIViewを作成
    func makeUIView(context: UIViewRepresentableContext<CustomEmailTextField>) -> UITextField {
        print("makeUIView")
        let textField = UITextField(frame: .init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 0))
        textField.font = UIFont.systemFont(ofSize: 28.0)
        textField.placeholder = "メールアドレス"
        textField.delegate = context.coordinator
        return textField
    }

    //テキスト更新
    func updateUIView(_ uiView: UITextField, context: UIViewRepresentableContext<CustomEmailTextField>) {
        uiView.text = text
        
        if !isFirstResponder  {
            // UITextField をファーストレスポンダにする（その結果、キーボードが表示される）
            uiView.becomeFirstResponder()
        } else {
            // UITextField のファーストレスポンダをやめる（その結果、キーボードが非表示になる）
            uiView.resignFirstResponder()
        }
    }
    
    class Coordinator: NSObject, UITextFieldDelegate {

        let parent: CustomEmailTextField
        
        init(parent: CustomEmailTextField) {
            self.parent = parent
        }

        func textFieldDidChangeSelection(_ textField: UITextField) {
            self.parent.text = textField.text ?? ""
        }
        
    }
}

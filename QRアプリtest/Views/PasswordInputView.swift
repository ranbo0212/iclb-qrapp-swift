//
//  PasswordInputView.swift
//  QRアプリtest
//
//  Created by 蘭搏 on 2021/07/13.
//

import SwiftUI
struct PasswordInputView: View {
    //環境変数presentationModeを利用する
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Binding var email : String
    @State var password : String = ""
    
    @EnvironmentObject var authNetWorkManager: AuthNetWorkManager
    
    var body: some View {
        ZStack {
            
            VStack (spacing: 0) {
                VStack (alignment: .leading, spacing: 4) {
                    //文字列パスワード
                    //未入力の場合非表示
                    //パスワード入力後Animation.easeInOutで表示
                    HStack {
                        Text("パスワード")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(Color("label"))
                        Spacer()
                    }
                    .opacity(!password.isEmpty ? 1 : 0)
                    .offset(x: 0, y: !password.isEmpty ? 10 : 60)
                    .animation(Animation.easeInOut(duration: 0.3).delay(0.2))
                    
                    //パスワード入力テキストフィルター
                    CustomPasswordTextField(email: $email, password: $password, isFirstResponder: Binding.constant(self.authNetWorkManager.requestStatus == .Idle || self.authNetWorkManager.requestStatus == .Fulfilled))
                        .frame(width: UIScreen.main.bounds.width, height: 60, alignment: .leading)
                    
                }
                .frame(height: 240, alignment: .bottom)
                
                HStack {
                    //未ログインの場合エラーは””
                    //前画面から取得したメールアドレス表示
                    if authNetWorkManager.error.isEmpty {
                        Text("以下のユーザーのパスワード：\n\(email)")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(Color("overlayShadowDetail"))
                    } else {
                        //ログインした後エラー発生の場合、エラーメッセージ表示
                        Text(authNetWorkManager.error)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(Color("overlayShadowDetail"))
                    }

                    Spacer()
                }
                
                Spacer()
            }
            .padding(.leading, 30)
                               
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(
                //左上ボタン
                leading:
                Button(action: {
                    //現在のVIewを閉じる
                    self.presentationMode.wrappedValue.dismiss()
                    authNetWorkManager.user.error = ""
                }) {
                    Image(systemName: "arrow.left")
                        .font(.system(size: 20))
                        .foregroundColor(.black)
                        .frame(width: 44, height: 44, alignment: .leading)
                }
                //右上ボタン
                , trailing:
                Button(action: {
                    print(self.email)
                    print(self.password)
                    //ログイン処理を行う
                    self.authNetWorkManager.login(email: self.email, password: self.password)
                }) {
                    Text("次へ")
                        .font(.system(size: 17))
                        .fontWeight(.bold)
                        .foregroundColor(changeButtonColor)
                        .frame(width: 44, height: 44, alignment: .trailing)
                }
                    //パスワード未入力の場合非活性
                    .disabled(password.isEmpty || self.authNetWorkManager.requestStatus == .Pending)
            )
        }
    }
    
    var changeButtonColor: Color {
        return password.isEmpty || self.authNetWorkManager.requestStatus == .Pending ? .gray : Color("navigation")
    }

}

struct CustomPasswordTextField: UIViewRepresentable {

    @EnvironmentObject var authNetWorkManager: AuthNetWorkManager
    @Binding var email: String
    @Binding var password: String
    @Binding var isFirstResponder: Bool
    
    func makeCoordinator() -> CustomPasswordTextField.Coordinator {
        return Coordinator(parent: self, authNetWorkManager: self.authNetWorkManager)
    }

    func makeUIView(context: UIViewRepresentableContext<CustomPasswordTextField>) -> UITextField {
        let textField = UITextField(frame: .init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 0))
//        textField.addTarget(context.coordinator, action: #selector(Coordinator.textFieldEditingChanged(_:)), for: .editingChanged)
        textField.font = UIFont.systemFont(ofSize: 28.0)
        textField.placeholder = "パスワード"
        textField.isSecureTextEntry = true
        textField.text = password
        textField.delegate = context.coordinator
        return textField
    }

    func updateUIView(_ textField: UITextField, context: UIViewRepresentableContext<CustomPasswordTextField>) {
        if isFirstResponder {
            textField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
    }
    
    class Coordinator: NSObject, UITextFieldDelegate {

        let authNetWorkManager: AuthNetWorkManager
        
        let parent: CustomPasswordTextField

        init(parent: CustomPasswordTextField, authNetWorkManager: AuthNetWorkManager) {
            self.parent = parent
            self.authNetWorkManager = authNetWorkManager
        }

        //パスワードが間違った場合、キーボードから任意のボタンをクリックすると、
        //エラーメッセージが消えて、パスワードが消される。
        func textFieldDidChangeSelection(_ textField: UITextField) {
            self.parent.password = textField.text ?? ""
            if !self.authNetWorkManager.user.error.isEmpty {
                self.authNetWorkManager.user.error = ""
            }
        }
        
        //キーボードの「Enter」ボタンをクリックするときの処理
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            
            //未入力の場合、エラーメッセージが表示される
            if self.parent.password.isEmpty {
                self.authNetWorkManager.error = "パスワードを入力してください。"
                return true
            }
//            UserDefaults.standard.setIsAuthorized(value: true)
//            self.authNetWorkManager.requestStatus = .Fulfilled
            //ログイン処理を行う
            self.authNetWorkManager.login(email: self.parent.email, password: self.parent.password)
            return true
        }
    }
}

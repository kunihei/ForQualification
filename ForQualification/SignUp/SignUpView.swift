//
//  SignUpView.swift
//  ForQualification
//
//  Created by 祥平 on 2021/10/23.
//

import UIKit
import FirebaseAuth

class SignUpView: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var mailTextField: UITextField!
    @IBOutlet weak var passTextField: UITextField!
    
    var auth: Auth!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        auth = Auth.auth()
        
        mailTextField.delegate = self
        passTextField.delegate = self
        
        mailTextField.layer.borderWidth = 2
        passTextField.layer.borderWidth = 2
        mailTextField.layer.cornerRadius = 10
        passTextField.layer.cornerRadius = 10
        mailTextField.layer.borderColor = UIColor(named: "TextColor")?.cgColor
        passTextField.layer.borderColor = UIColor(named: "TextColor")?.cgColor
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if auth.currentUser != nil {
            
            auth.currentUser?.reload(completion: { error in
                
                if error == nil {
                    if self.auth.currentUser?.isEmailVerified == true { self.segueMenu() }
                }
            })
        }
    }
    
    @IBAction func registAccountBtn(_ sender: Any) {
        
        if mailTextField.text?.count == 0 {
            self.alert(title: "エラー", message: "入力されてない箇所があります。", actiontitle: "OK")
            return
        }
        
        registStart()
    }
    
    //会員登録開始
    func registStart() {
        
        if let user = auth.currentUser, user.isAnonymous {
            
            let credential = EmailAuthProvider.credential(withEmail: mailTextField.text ?? "", password: passTextField.text ?? "")
            user.link(with: credential) { authResult, error in
                //ログイン成功
                if error == nil {
                    //登録メアドに確認のメールを送る
                    self.auth.currentUser?.sendEmailVerification(completion: { (error) in
                        //エラー処理
                        if error == nil {
                            self.alert(title: "仮登録を行いました。", message: "入力したメールアドレス宛に確認メールを送信しました。", actiontitle: "OK")
                        }
                    })
                    //ログイン失敗
                } else {
                    self.alert(title: "エラー", message: "ログイン失敗", actiontitle: "OK")
                }
            }
        }
    }
    
    func segueMenu() {
        let storyboard = UIStoryboard(name: "Main", bundle:Bundle.main)
        let rootViewController = storyboard.instantiateViewController(withIdentifier: "main")
        UIApplication.shared.keyWindow?.rootViewController = rootViewController
    }
    
    //アラート
    func alert(title:String,message:String,actiontitle:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: actiontitle, style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    //Returnでキーボードを閉じる
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //画面外タップでキーボードを閉じる
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        mailTextField.resignFirstResponder()
        passTextField.resignFirstResponder()
    }
    
    @IBAction func loginViewMoveBtn(_ sender: Any) {
        let loginView = LoginView()
        navigationController?.pushViewController(loginView, animated: true)
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

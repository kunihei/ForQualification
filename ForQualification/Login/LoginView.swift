//
//  LoginView.swift
//  ForQualification
//
//  Created by 祥平 on 2021/10/21.
//

import UIKit
import FirebaseAuth

class LoginView: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var mailTextField: UITextField!
    @IBOutlet weak var passTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    @IBAction func loginBtn(_ sender: Any) {
        
        if mailTextField.text?.count == 0 || passTextField.text?.count == 0 {
            self.alert(title: "エラー", message: "入力されてない箇所があります。", actiontitle: "OK")
            return
        }
        
        Auth.auth().signIn(withEmail: mailTextField.text ?? "", password: passTextField.text ?? "") { user, err in
            if err == nil {
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let menuView = storyBoard.instantiateViewController(withIdentifier: "main")
                self.navigationController?.pushViewController(menuView, animated: true)
            } else {
                self.alert(title: "エラー", message: "メールアドレスまたはパスワードが間違ってます。", actiontitle: "OK")
            }
        }
    }
    @IBAction func reset(_ sender: Any) {
        
        let remaindPasswordAlert = UIAlertController(title: "パスワードをリセット", message: "メールアドレスを入力してください", preferredStyle: .alert)
        remaindPasswordAlert.addAction(UIAlertAction(title: "キャンセル", style: .cancel, handler: nil))
        remaindPasswordAlert.addAction(UIAlertAction(title: "リセット", style: .default, handler: { (action) in
            self.resetPass(remaindPasswordAlert: remaindPasswordAlert)
        }))
        
        remaindPasswordAlert.addTextField { textField in
            textField.placeholder = "例）test@gmail.com"
        }
        self.present(remaindPasswordAlert, animated: true, completion: nil)
    }
    
    @IBAction func accountViewBtn(_ sender: Any) {
        let signUpView = SignUpView()
        navigationController?.pushViewController(signUpView, animated: true)
    }
    
    // リセットメールのアラート
    func resetPass(remaindPasswordAlert: UIAlertController) {
        let resetEmail = remaindPasswordAlert.textFields?.first?.text
        Auth.auth().sendPasswordReset(withEmail: resetEmail!, completion: { (error) in
            DispatchQueue.main.async {
                if error != nil {
                    self.alert(title: "メールを送信しました。", message: "メールでパスワードの再設定を行ってください。", actiontitle: "OK")
                } else {
                    self.alert(title: "エラー", message: "このメールアドレスは登録されてません。", actiontitle: "OK")
                }
            }
        })
    }
    
    //アラート
    func alert(title:String,message:String,actiontitle:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: actiontitle, style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        mailTextField.resignFirstResponder()
        passTextField.resignFirstResponder()
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

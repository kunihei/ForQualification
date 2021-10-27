//
//  MenuProblem.swift
//  ForQualification
//
//  Created by 祥平 on 2021/09/11.
//

import UIKit
import FirebaseAuth

class MenuProblem: UIViewController {
    
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var challengeButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var logoutBtn: CustomButton!
    
    private let getProblem = GetProblem_Answer()
    
    private var userId = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userId = UserDefaults.standard.string(forKey: "userId") ?? ""
        
        if userId == "" {
            Auth.auth().signInAnonymously { authResult, err in
                if let err = err {
                    print("匿名ログインに失敗しました", err)
                    return
                }
                guard let user = authResult?.user else {return}
                UserDefaults.standard.set(user.uid, forKey: "userId")
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        
        getProblem.problemList = []
        getProblem.getProblemList()
        
    }
    
    @IBAction func createButton(_ sender: Any) {
        
        createButton.pulsate()
        
        userId = UserDefaults.standard.string(forKey: "userId") ?? ""
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            let settingView = SettingProblem()
            self.navigationController?.pushViewController(settingView, animated: true)
        }
    }
    
    @IBAction func challengeButton(_ sender: Any) {
        
        userId = UserDefaults.standard.string(forKey: "userId") ?? ""
        
        if getProblem.problemList.isEmpty {
            settingViewAlert(title: "挑戦する問題がありません！", message: "問題を登録して下さい")
            return
        }
        
        challengeButton.pulsate()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            let MenuChallengeView = MenuChallengeProblem()
            self.navigationController?.pushViewController(MenuChallengeView, animated: true)
        }
    }
    
    @IBAction func editButton(_ sender: Any) {
        
        userId = UserDefaults.standard.string(forKey: "userId") ?? ""
        
        if getProblem.problemList.isEmpty {
            settingViewAlert(title: "編集する問題がありません！", message: "問題を登録して下さい")
            return
        }
        
        editButton.pulsate()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            let editView = EditProblem()
            self.navigationController?.pushViewController(editView, animated: true)
        }
    }
    
    func mailCheckAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let mailCheckAction: UIAlertAction = UIAlertAction(title: "OK", style: .destructive, handler: nil)
        alert.addAction(mailCheckAction)
        present(alert, animated: true, completion: nil)
    }
    
    // 問題をひとつも登録していない場合にアラートを表示させ問題登録画面に遷移
    func settingViewAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let errAction: UIAlertAction = UIAlertAction(title: "OK", style: .destructive) { action in
            let settingView = SettingProblem()
            self.navigationController?.pushViewController(settingView, animated: true)
        }
        alert.addAction(errAction)
        present(alert, animated: true, completion: nil)
    }
    
    // 本登録を促すアラート
    func mainRegist() -> Bool {
        if Auth.auth().currentUser?.email == nil {
            let alert = UIAlertController(title: "無料の本登録のお願い", message: "編集または問題を解きたい場合はメールとパスワードを登録して下さい。 ※登録済みの方はログインして下さい。", preferredStyle: UIAlertController.Style.alert)
            let action: UIAlertAction = UIAlertAction(title: "OK", style: .default) { action in
                let signinUpView = SignUpView()
                self.navigationController?.pushViewController(signinUpView, animated: true)
            }
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
            return true
        }
        return false
    }
    
    // メール認証をしていない場合のアラート
    func unauthenticated() -> Bool {
        if Auth.auth().currentUser?.isEmailVerified == false {
            Auth.auth().currentUser?.reload(completion: { err in
                if err == nil {
                    self.mailCheckAlert(title: "確認用メールを送信しているので確認をお願いします。", message: "まだメール認証が完了していません。")
                }
            })
            return true
        }
        return false
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

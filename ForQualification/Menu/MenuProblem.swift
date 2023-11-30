//
//  MenuProblem.swift
//  ForQualification
//
//  Created by 祥平 on 2021/09/11.
//

import GoogleMobileAds
import UIKit
import FirebaseAuth
import AdSupport
import AppTrackingTransparency

class MenuProblem: UIViewController, GADBannerViewDelegate {
    
    // 変数一覧
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var challengeButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var menuLabel: UILabel!
    @IBOutlet weak var configurationBtn: UIButton!
    
    private let getProblem = GetProblem_Answer()
    
    private var userId = String()
    private var bannerID = String()
    private let apple_id = "1590729960"
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.navigationItem.title = NaviTitle.problemMenu
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        AppVersionCompare.toAppStoreVersion(appId: apple_id) { type in
            switch type {
            case .latest:
                print("最新バージョンです")
            case .old:
                print("旧バージョンです")
                DispatchQueue.main.async {
                    self.updateAlert()
                }
            case .error:
                print("エラー")
            }
        }
        
        setBackButton()
#if DEBUG
        bannerID = "ca-app-pub-3940256099942544/6300978111"
#else
        bannerID = "ca-app-pub-3279976203462809/3585101848"
#endif
        bannerView.adUnitID = bannerID
        bannerView.rootViewController = self
        bannerView.delegate = self
        bannerView.load(GADRequest())
        
        userId = UserDefaults.standard.string(forKey: "userId") ?? ""
        
        if userId == "" { createAccount() }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        startIndicator()
        getProblem.getProblemList()
        DispatchQueue.main.async {
            self.dismissIndicator()
        }
    }
    
    func setBackButton() {
        let backItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        backItem.tintColor = .black
        navigationItem.backBarButtonItem = backItem
    }
    
    func createAccount() {
        Auth.auth().signInAnonymously { authResult, err in
            if let err = err {
                print("匿名ログインに失敗しました", err)
                return
            }
            guard let user = authResult?.user else {return}
            UserDefaults.standard.set(user.uid, forKey: "userId")
        }
    }
    
    @IBAction func createButton(_ sender: Any) {
        
        createButton.pulsate()
        
        userId = UserDefaults.standard.string(forKey: "userId") ?? ""
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//            let settingView = SettingProblem()
            self.problemMove()
        }
    }
    
    @IBAction func challengeButton(_ sender: Any) {
        
        userId = UserDefaults.standard.string(forKey: "userId") ?? ""
        
        if GetProblem_Answer.problemList.isEmpty {
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
        
        if GetProblem_Answer.problemList.isEmpty {
            settingViewAlert(title: "編集する問題がありません！", message: "問題を登録して下さい")
            return
        }
        
        editButton.pulsate()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            let editView = EditProblem()
            self.navigationController?.pushViewController(editView, animated: true)
        }
    }
    
//    func mailCheckAlert(title: String, message: String) {
//        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
//        let mailCheckAction: UIAlertAction = UIAlertAction(title: "OK", style: .destructive, handler: nil)
//        alert.addAction(mailCheckAction)
//        present(alert, animated: true, completion: nil)
//    }
    
    // 問題をひとつも登録していない場合にアラートを表示させ問題登録画面に遷移
    func settingViewAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let errAction: UIAlertAction = UIAlertAction(title: "OK", style: .destructive) { action in
//            let settingView = SettingProblem()
            self.problemMove()
        }
        alert.addAction(errAction)
        present(alert, animated: true, completion: nil)
    }
    
    func problemMove() {
        self.moveView(storyboardName: StoryboardName.problem)
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
//    func unauthenticated() -> Bool {
//        if Auth.auth().currentUser?.isEmailVerified == false {
//            Auth.auth().currentUser?.reload(completion: { err in
//                if err == nil {
//                    self.mailCheckAlert(title: "確認用メールを送信しているので確認をお願いします。", message: "まだメール認証が完了していません。")
//                }
//            })
//            return true
//        }
//        return false
//    }
    
    private func updateAlert() {
        let actionA: UIAlertAction = UIAlertAction(title: "更新", style: .default) { action in
            if let url = URL(string: "itms-apps://itunes.apple.com/app/id\(self.apple_id)"),
                UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
//            let actionA = UIAlertAction(title: "更新", style: .default, handler: {
//                        (action: UIAlertAction!) in
//                if let url = URL(string: "itms-apps://itunes.apple.com/app/id\(self.apple_id)"),
//                    UIApplication.shared.canOpenURL(url) {
//                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
//                }
//            })
            
            let actionB = UIAlertAction(title: "あとで", style: .default, handler: {
                        (action: UIAlertAction!) in
            })
            
            let alert: UIAlertController = UIAlertController(title: "最新バージョンのお知らせ", message: "最新バージョンがあります。", preferredStyle: .alert)
            alert.addAction(actionA)
            alert.addAction(actionB)
            present(alert, animated: true, completion: nil)
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

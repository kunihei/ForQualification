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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "メニュー"
        trackingAlert()
        
        setBackButton()
        bannerView.adUnitID = "ca-app-pub-3940256099942544/6300978111"//"ca-app-pub-3279976203462809/3585101848"
        bannerView.rootViewController = self
        bannerView.delegate = self
        bannerView.load(GADRequest())
        
        userId = UserDefaults.standard.string(forKey: "userId") ?? ""
        
        if userId == "" { createAccount() }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getProblem.getProblemList()
        
//        if UserDefaults.standard.bool(forKey: "colorFlag") == true { darkMode() }
//        else { lightMode() }
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
    
    func darkMode() {
        view.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.241, alpha: 1.0)
        
        createButton.setTitleColor(UIColor.white, for: .normal)
        createButton.layer.borderColor = UIColor.white.cgColor
        createButton.layer.shadowColor = UIColor.white.cgColor
        
        challengeButton.setTitleColor(UIColor.white, for: .normal)
        challengeButton.layer.borderColor = UIColor.white.cgColor
        challengeButton.layer.shadowColor = UIColor.white.cgColor
        
        editButton.setTitleColor(UIColor.white, for: .normal)
        editButton.layer.borderColor = UIColor.white.cgColor
        editButton.layer.shadowColor = UIColor.white.cgColor
        
        menuLabel.textColor = UIColor.white
        configurationBtn.setImage(UIImage(named: "設定の歯車White"), for: .normal)
    }
    
    func lightMode() {
        view.backgroundColor = UIColor.white
        
        createButton.setTitleColor(UIColor.black, for: .normal)
        createButton.layer.borderColor = UIColor.black.cgColor
        createButton.layer.shadowColor = UIColor.black.cgColor
        
        challengeButton.setTitleColor(UIColor.black, for: .normal)
        challengeButton.layer.borderColor = UIColor.black.cgColor
        challengeButton.layer.shadowColor = UIColor.black.cgColor
        
        editButton.setTitleColor(UIColor.black, for: .normal)
        editButton.layer.borderColor = UIColor.black.cgColor
        editButton.layer.shadowColor = UIColor.black.cgColor
        
        menuLabel.textColor = UIColor.black
        configurationBtn.setImage(UIImage(named: "設定の歯車"), for: .normal)
    }
    
    private func trackingAlert() {
        if #available(iOS 15, *) {
            switch ATTrackingManager.trackingAuthorizationStatus {
            case .authorized:
                print("Allow Tracking")
                print("IDFA: \(ASIdentifierManager.shared().advertisingIdentifier)")
            case .denied:
                print("😭拒否")
            case .restricted:
                print("🥺制限")
            case .notDetermined:
                showRequestTrackingAuthorizationAlert()
            @unknown default:
                fatalError()
            }
        } else {// iOS14未満
            if ASIdentifierManager.shared().isAdvertisingTrackingEnabled {
                print("Allow Tracking")
                print("IDFA: \(ASIdentifierManager.shared().advertisingIdentifier)")
            } else {
                print("🥺制限")
            }
        }
    }
    
    ///Alert表示
    private func showRequestTrackingAuthorizationAlert() {
        if #available(iOS 15, *) {
            ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
                switch status {
                case .authorized:
                    print("🎉")
                    //IDFA取得
                    print("IDFA: \(ASIdentifierManager.shared().advertisingIdentifier)")
                case .denied, .restricted, .notDetermined:
                    print("😭")
                @unknown default:
                    fatalError()
                }
            })
        }
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
    
    // FIXME: 現状は設定を何もないようしているのでコメントアウト
//    @IBAction func configuration(_ sender: Any) {
//        //　設定画面に遷移する
//        let configurationView = ConfigurationView()
//        navigationController?.pushViewController(configurationView, animated: true)
//
//    }
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

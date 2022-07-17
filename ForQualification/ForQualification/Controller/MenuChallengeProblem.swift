//
//  MenuChallengeProblem.swift
//  ForQualification
//
//  Created by 祥平 on 2021/09/11.
//

import GoogleMobileAds
import UIKit

class MenuChallengeProblem: UIViewController, GADBannerViewDelegate {
    
    @IBOutlet weak var nomalButton: CustomButton!
    @IBOutlet weak var shuffleButton: CustomButton!
    @IBOutlet weak var bannerView: GADBannerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "モード選択"
        bannerView.adUnitID = "ca-app-pub-3940256099942544/6300978111"//"ca-app-pub-3279976203462809/1649822190"
        bannerView.rootViewController = self
        bannerView.delegate = self
        
        bannerView.load(GADRequest())
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        if UserDefaults.standard.bool(forKey: "colorFlag") == true { darkMode() }
//        else { lightMode() }
    }
    
    @IBAction func nomalButton(_ sender: Any) {
        
        let challengeView = ChallengeProblem()
        if (sender as AnyObject).tag! == 2 {
            shuffleButton.flash()
            challengeView.shuffleModeFlag = true
        } else {
            nomalButton.flash()
            challengeView.shuffleModeFlag = false
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.navigationController?.pushViewController(challengeView, animated: true)
        }
    }
    
    func darkMode() {
        view.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.241, alpha: 1.0)
        
        nomalButton.setTitleColor(UIColor.white, for: .normal)
        nomalButton.layer.borderColor = UIColor.white.cgColor
        nomalButton.layer.shadowColor = UIColor.white.cgColor
        
        shuffleButton.setTitleColor(UIColor.white, for: .normal)
        shuffleButton.layer.borderColor = UIColor.white.cgColor
        shuffleButton.layer.shadowColor = UIColor.white.cgColor
    }
    
    func lightMode() {
        view.backgroundColor = UIColor.white
        
        nomalButton.setTitleColor(UIColor.black, for: .normal)
        nomalButton.layer.borderColor = UIColor.black.cgColor
        nomalButton.layer.shadowColor = UIColor.black.cgColor
        
        shuffleButton.setTitleColor(UIColor.black, for: .normal)
        shuffleButton.layer.borderColor = UIColor.black.cgColor
        shuffleButton.layer.shadowColor = UIColor.black.cgColor
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

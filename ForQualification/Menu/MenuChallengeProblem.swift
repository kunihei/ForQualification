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
    
    private var challengeProblemModel = ChallengeProblemModel.shard
    private var bannerID = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = NaviTitle.problemMode
#if DEBUG
        bannerID = "ca-app-pub-3940256099942544/6300978111"
#else
        bannerID = "ca-app-pub-3279976203462809/1649822190"
#endif
        bannerView.adUnitID = bannerID
        bannerView.rootViewController = self
        bannerView.delegate = self
        
        bannerView.load(GADRequest())
        // Do any additional setup after loading the view.
    }
    
    @IBAction func nomalButton(_ sender: Any) {
        
        let challengeView = ChallengeProblem()
        if (sender as AnyObject).tag! == 2 {
            shuffleButton.flash()
            challengeProblemModel.shuffleModeFlag = true
        } else {
            nomalButton.flash()
            challengeProblemModel.shuffleModeFlag = false
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.navigationController?.pushViewController(challengeView, animated: true)
        }
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

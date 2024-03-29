//
//  ResultProblem.swift
//  ForQualification
//
//  Created by 祥平 on 2021/09/12.
//

import GoogleMobileAds
import UIKit

class ResultProblem: UIViewController, GADFullScreenContentDelegate {
    
    @IBOutlet weak var correctAnswerCountLabel: UILabel!
    @IBOutlet weak var incorrectAnswerCountLabel: UILabel!
    @IBOutlet weak var averageTotalLabel: UILabel!
    @IBOutlet weak var correctLabel: UILabel!
    @IBOutlet weak var incorrectLabel: UILabel!
    @IBOutlet weak var averageLabel: UILabel!
    
    var correctAnswerCount = Int()
    var incorrectAnswerCount = Int()
    var interstitialID: String?
    var averageTotal = Int()
    
    private var interstitial: GADInterstitialAd?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true
        self.navigationItem.title = NaviTitle.problemResult
        let request = GADRequest()
#if DEBUG
        interstitialID = "ca-app-pub-3940256099942544/4411468910"
#else
        interstitialID = "ca-app-pub-3279976203462809/1824656986"
#endif
        GADInterstitialAd.load(withAdUnitID: interstitialID ?? "", request: request) { [self] ad, err in
            if let err = err {
                print("Failed to load interstitial ad with error: \(err.localizedDescription)")
                return
            }
            interstitial = ad
            interstitial?.fullScreenContentDelegate = self
        }
        correctAnswerCountLabel.text = "\(correctAnswerCount)問"
        incorrectAnswerCountLabel.text = "\(incorrectAnswerCount)問"
        averageTotalLabel.text = "\(averageTotal)%"
        // Do any additional setup after loading the view.
    }
    
    @IBAction func topButton(_ sender: Any) {
        if interstitial != nil {
            interstitial?.present(fromRootViewController: self)
        }
        let menuChallengeView = MenuChallengeProblem()
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.pushViewController(menuChallengeView, animated: true)
        
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

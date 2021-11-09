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
    @IBOutlet weak var resulutLabel: UILabel!
    @IBOutlet weak var correctLabel: UILabel!
    @IBOutlet weak var incorrectLabel: UILabel!
    @IBOutlet weak var averageLabel: UILabel!
    @IBOutlet weak var menuBackBtn: CustomButton!
    
    var correctAnswerCount = Int()
    var incorrectAnswerCount = Int()
    var averageTotal = Int()
    
    private var interstitial: GADInterstitialAd?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let request = GADRequest()
        GADInterstitialAd.load(withAdUnitID: "ca-app-pub-3279976203462809/1824656986", request: request) { [self] ad, err in
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }

    @IBAction func menuBack(_ sender: Any) {
        if interstitial != nil {
            interstitial?.present(fromRootViewController: self)
        }
        let menuChallengeView = MenuChallengeProblem()
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

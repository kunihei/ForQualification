//
//  ResultProblem.swift
//  ForQualification
//
//  Created by 祥平 on 2021/09/12.
//

import UIKit

class ResultProblem: UIViewController {
    
    @IBOutlet weak var correctAnswerCountLabel: UILabel!
    @IBOutlet weak var incorrectAnswerCountLabel: UILabel!
    @IBOutlet weak var averageTotalLabel: UILabel!
    
    var correctAnswerCount = Int()
    var incorrectAnswerCount = Int()
    var averageTotal = Int()

    override func viewDidLoad() {
        super.viewDidLoad()
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

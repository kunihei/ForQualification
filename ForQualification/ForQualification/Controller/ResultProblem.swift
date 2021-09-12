//
//  ResultProblem.swift
//  ForQualification
//
//  Created by 祥平 on 2021/09/12.
//

import UIKit

class ResultProblem: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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

//
//  MenuChallengeProblem.swift
//  ForQualification
//
//  Created by 祥平 on 2021/09/11.
//

import UIKit

class MenuChallengeProblem: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }

    @IBAction func nomalButton(_ sender: Any) {
        let challengeView = ChallengeProblem()
        if (sender as AnyObject).tag! == 2 {
            challengeView.shuffleModeFlag = true
        } else {
            challengeView.shuffleModeFlag = false
        }
        navigationController?.pushViewController(challengeView, animated: true)
    }
    
    @IBAction func menuBackButton(_ sender: Any) {
        let menuView = MenuProblem()
        navigationController?.pushViewController(menuView, animated: true)
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

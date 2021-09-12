//
//  MenuProblem.swift
//  ForQualification
//
//  Created by 祥平 on 2021/09/11.
//

import UIKit

class MenuProblem: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }

    @IBAction func createButton(_ sender: Any) {
        let registerView = RegisterProblem()
        navigationController?.pushViewController(registerView, animated: true)
    }
    
    @IBAction func challengeButton(_ sender: Any) {
        let MenuChallengeView = MenuChallengeProblem()
        navigationController?.pushViewController(MenuChallengeView, animated: true)
    }
    
    @IBAction func editButton(_ sender: Any) {
        let editView = EditProblem()
        navigationController?.pushViewController(editView, animated: true)
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

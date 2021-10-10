//
//  MenuProblem.swift
//  ForQualification
//
//  Created by 祥平 on 2021/09/11.
//

import UIKit

class MenuProblem: UIViewController {

    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var challengeButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        let boaderColor = UIColor(named: "TextColor")
        createButton.layer.borderColor = boaderColor?.cgColor
        challengeButton.layer.borderColor = boaderColor?.cgColor
        editButton.layer.borderColor = boaderColor?.cgColor
    }

    @IBAction func createButton(_ sender: Any) {
        createButton.pulsate()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            let registerView = RegisterProblem()
            self.navigationController?.pushViewController(registerView, animated: true)
        }
    }
    
    @IBAction func challengeButton(_ sender: Any) {
        challengeButton.pulsate()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            let MenuChallengeView = MenuChallengeProblem()
            self.navigationController?.pushViewController(MenuChallengeView, animated: true)
        }
    }
    
    @IBAction func editButton(_ sender: Any) {
        editButton.pulsate()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            let editView = EditProblem()
            self.navigationController?.pushViewController(editView, animated: true)
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

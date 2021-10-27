//
//  MenuChallengeProblem.swift
//  ForQualification
//
//  Created by 祥平 on 2021/09/11.
//

import UIKit

class MenuChallengeProblem: UIViewController {
    
    @IBOutlet weak var nomalButton: CustomButton!
    @IBOutlet weak var shuffleButton: CustomButton!
    @IBOutlet weak var menuBackButton: CustomButton!
    
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
    
    @IBAction func menuBackButton(_ sender: Any) {
        menuBackButton.pulsate()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let menuView = storyBoard.instantiateViewController(withIdentifier: "main")
            self.navigationController?.pushViewController(menuView, animated: true)
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

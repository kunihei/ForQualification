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
    
    private let getProblem = GetProblem_Answer()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        getProblem.problemList = []
        getProblem.getProblemList()
        let boaderColor = UIColor(named: "TextColor")
        createButton.layer.borderColor = boaderColor?.cgColor
        challengeButton.layer.borderColor = boaderColor?.cgColor
        editButton.layer.borderColor = boaderColor?.cgColor
    }

    @IBAction func createButton(_ sender: Any) {
        createButton.pulsate()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            let settingView = SettingProblem()
            self.navigationController?.pushViewController(settingView, animated: true)
        }
    }
    
    @IBAction func challengeButton(_ sender: Any) {
        if getProblem.problemList.isEmpty {
            alert(title: "挑戦する問題がありません！", message: "問題を登録して下さい")
            return
        }
        challengeButton.pulsate()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            let MenuChallengeView = MenuChallengeProblem()
            self.navigationController?.pushViewController(MenuChallengeView, animated: true)
        }
    }
    
    @IBAction func editButton(_ sender: Any) {
        if getProblem.problemList.isEmpty {
            alert(title: "編集する問題がありません！", message: "問題を登録して下さい")
            return
        }
        editButton.pulsate()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            let editView = EditProblem()
            self.navigationController?.pushViewController(editView, animated: true)
        }
    }
    
    func alert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let errAction: UIAlertAction = UIAlertAction(title: "OK", style: .destructive) { action in
            let settingView = SettingProblem()
            self.navigationController?.pushViewController(settingView, animated: true)
        }
        alert.addAction(errAction)
        present(alert, animated: true, completion: nil)
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

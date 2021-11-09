//
//  EditProblem.swift
//  ForQualification
//
//  Created by 祥平 on 2021/09/11.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseStorage

class EditProblem: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var editLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var menuBackButton: CustomButton!
    
    private let getProblemList = GetProblem_Answer()
    private let getProblemSelectList = GetProblemSelect()
    private let userUid = Auth.auth().currentUser?.uid
    
    private var problemList = [Problem_AnswerModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        if UserDefaults.standard.bool(forKey: "colorFlag") == true { darkMode() }
        else { lightMode() }
        getProblemList.problemList = []
        problemList = []
        getProblemSelectList.problemSelectEmptyDelete = []
        getProblemSelectList.getProblemSelect()
        getProblemList.getProblemList()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        problemList = getProblemList.problemList
        tableView.reloadData()
    }
    
    func darkMode() {
        view.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.241, alpha: 1.0)
        tableView.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.241, alpha: 1.0)
        tableView.separatorColor = UIColor.white
        
        editLabel.textColor = UIColor.white
        
        menuBackButton.setTitleColor(UIColor.white, for: .normal)
        menuBackButton.layer.borderColor = UIColor.white.cgColor
        menuBackButton.layer.shadowColor = UIColor.white.cgColor
    }
    
    func lightMode() {
        view.backgroundColor = UIColor.white
        tableView.backgroundColor = UIColor.white
        tableView.separatorColor = UIColor.black
        
        editLabel.textColor = UIColor.black
        
        menuBackButton.setTitleColor(UIColor.black, for: .normal)
        menuBackButton.layer.borderColor = UIColor.black.cgColor
        menuBackButton.layer.shadowColor = UIColor.black.cgColor
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        //削除処理
        let deleteAction = UIContextualAction(style: .destructive, title: "削除") { (action, view, completionHandler) in
            guard let userId = self.userUid else {return}
            let desertRef = Storage.storage().reference().child("problemImages").child("\(userId + String(self.problemList[indexPath.row].createAt)).jpg")
            desertRef.delete { err in
                if let err = err {
                    print("画像の削除に失敗しました。", err)
                    return
                }
            }
            Firestore.firestore().collection("problems").document(self.problemList[indexPath.row].documentID).delete() { err in
                if let err = err {
                    print("削除に失敗しました", err)
                    return
                }
                self.problemList.remove(at: indexPath.row)
                tableView.reloadData()
            }
            completionHandler(true)
        }
        
        let editAction = UIContextualAction(style: .normal, title: "編集") { (action, view, completionHandler) in
            self.getProblemSelectList.selectEmptyDelete(problemCount: indexPath.row)
            let settingView = SettingProblem()
            settingView.editFlag = true
            settingView.documentId = self.problemList[indexPath.row].documentID
            settingView.problem = self.problemList[indexPath.row].problem
            settingView.problemImageData = self.problemList[indexPath.row].problemImageData
            settingView.selects = self.getProblemSelectList.problemSelectEmptyDelete
            settingView.answer = self.problemList[indexPath.row].answer
            settingView.createAt = self.problemList[indexPath.row].createAt
            self.navigationController?.pushViewController(settingView, animated: true)
            
            completionHandler(true)
        }
        return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return problemList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.font = UIFont.systemFont(ofSize: 20)
        cell.selectionStyle = .none
        cell.textLabel?.text = problemList[indexPath.row].problem
        
        if UserDefaults.standard.bool(forKey: "colorFlag") == true {
            cell.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.241, alpha: 1.0)
            cell.textLabel?.textColor = UIColor.white
        } else {
            cell.backgroundColor = UIColor.white
            cell.textLabel?.textColor = UIColor.black
        }
        
        return cell
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

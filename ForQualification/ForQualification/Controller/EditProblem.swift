//
//  EditProblem.swift
//  ForQualification
//
//  Created by 祥平 on 2021/09/11.
//

import UIKit
import Firebase
import FirebaseFirestore

class EditProblem: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    private let getProblemList = GetProblem_Answer()
    private let getProblemSelectList = GetProblemSelect()
    
    private var problemList = [Problem_AnswerModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
        getProblemList.problemList = []
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
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        //削除処理
        let deleteAction = UIContextualAction(style: .destructive, title: "削除") { (action, view, completionHandler) in
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
            let registerView = RegisterProblem()
            registerView.editFlag = true
            registerView.documentId = self.problemList[indexPath.row].documentID
            registerView.problem = self.problemList[indexPath.row].problem
            registerView.problemImageData = self.problemList[indexPath.row].problemImageData
            registerView.selects = self.getProblemSelectList.problemSelectEmptyDelete
            registerView.answer = self.problemList[indexPath.row].answer
            self.navigationController?.pushViewController(registerView, animated: true)
            
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
        
        return cell
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

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

class EditProblem: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    private let getProblemList = GetProblem_Answer()
    private let getProblemSelectList = GetProblemSelect()
    private let userUid = Auth.auth().currentUser?.uid
    
    private var problemList = [Problem_AnswerModel]()
    private var challengeProblemModel = ChallengeProblemModel.shard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = NaviTitle.problemEdit_Del
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "ProblemCell", bundle: nil), forCellReuseIdentifier: "ProblemCell")
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        GetProblem_Answer.problemList = []
        problemList = []
        challengeProblemModel.problemSelectEmptyDelete = []
        getProblemSelectList.getProblemSelect()
        getProblemList.getProblemList()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        problemList = GetProblem_Answer.problemList
        tableView.reloadData()
    }
    
    func moveSettingView(index: Int) {
        self.getProblemSelectList.selectEmptyDelete(problemCount: index)
        let settingView = SettingProblem()
        settingView.editFlag = true
        settingView.documentId = self.problemList[index].documentID
        settingView.problem = self.problemList[index].problem
        settingView.problemImageData = self.problemList[index].problemImageData
        settingView.selects = self.challengeProblemModel.problemSelectEmptyDelete
        settingView.answer = self.problemList[index].answer
        settingView.createAt = self.problemList[index].createAt
        self.navigationController?.pushViewController(settingView, animated: true)
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

extension EditProblem: UITableViewDelegate, UITableViewDataSource {
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
            self.moveSettingView(index: indexPath.row)
            completionHandler(true)
        }
        return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return problemList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProblemCell", for: indexPath) as! ProblemCell
        print("kuni_problemList: \(problemList)")
        cell.setCell(problem: problemList[indexPath.row])
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: false)
        let cell = self.tableView.cellForRow(at: indexPath) as! ProblemCell
        UIView.animate(withDuration: 0.2) {
            cell.tapGestureView.alpha = 0.5
        } completion: { result in
            cell.tapGestureView.alpha = 0.0
            self.moveSettingView(index: indexPath.row)
        }
    }
}

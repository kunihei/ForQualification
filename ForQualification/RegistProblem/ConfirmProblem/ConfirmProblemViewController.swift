//
//  ConfirmProblemViewController.swift
//  ForQualification
//
//  Created by 祥平 on 2023/11/23.
//

import UIKit
import Firebase
import SDWebImage
import FirebaseStorage
import FirebaseFirestore

class ConfirmProblemViewController: UIViewController {

    @IBOutlet weak var problemTextLabel: UILabel!
    @IBOutlet weak var problemImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    private var count = 0
    private var selectList = [String]()
    private var observation: NSKeyValueObservation?
    private let userId = Auth.auth().currentUser?.uid

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: "ConfirmSelectCell", bundle: nil), forCellReuseIdentifier: "confirmSelectCell")
        tableView.dataSource = self
        tableView.delegate = self
        
        observation = tableView.observe(\.contentSize, options: [.new]) { [weak self] (_, _) in
                guard let self = self else { return }
                self.tableViewHeight?.constant = self.tableView.contentSize.height
            }
        
        // Do any additional setup after loading the view.
    }
    
    deinit {
        observation?.invalidate()
        observation = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if !ProblemSelect.shared.getProblemText().isEmpty {
            problemTextLabel.text = ProblemSelect.shared.getProblemText()
        }

        problemImageView.isHidden = true
        if !ProblemSelect.shared.getImageData().isEmpty {
            problemImageView.isHidden = false
            problemImageView.image = UIImage(data: ProblemSelect.shared.getImageData())
        }
        if !ProblemSelect.shared.getSelects().isEmpty {
            for select in ProblemSelect.shared.getSelects().sorted(by: {$0.key < $1.key}) {
                selectList.append(select.value)
            }
        }
    }

    @IBAction func backButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func problemEditButton(_ sender: UIButton) {
        let storyBoard = UIStoryboard(name: StoryboardName.problem, bundle: nil)
        let problem = storyBoard.instantiateViewController(withIdentifier: StoryboardName.problem) as! ProblemViewController
        problem.confirmFlg = true
        self.navigationController?.pushViewController(problem, animated: true)
    }
    @IBAction func problemRegistButton(_ sender: CustomButton) {
        let answerText = selectList[0]
        selectList.remove(at: 0)
        let createProblem = CreateProblem(problemText: ProblemSelect.shared.getProblemText(), answer: ProblemSelect.shared.getSelects()[0]!, selects: selectList, userId: userId!, problemImageData: ProblemSelect.shared.getImageData())
        createProblem.createProblem { flg in
            if flg {
                print("hisa:成功")
            } else {
                print("hisa:失敗")
            }
        }
    }
}

extension ConfirmProblemViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "confirmSelectCell", for: indexPath) as! ConfirmSelectCell
        cell.editSelectDelegate = self
        if indexPath.row == 1 {
            cell.firstSelectItem()
        }
        cell.setSelectLabel(index: indexPath.row, text: selectList[indexPath.row])
        
        cell.selectionStyle = .none
        return cell
    }
    
}

extension ConfirmProblemViewController: EditSelectDelegate {
    func editSelects(button: UIButton) {
        self.moveView(storyboardName: StoryboardName.select)
    }
    
    
}

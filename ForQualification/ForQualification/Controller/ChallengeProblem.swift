//
//  ChallengeProblem.swift
//  ForQualification
//
//  Created by 祥平 on 2021/09/11.
//

import UIKit

class ChallengeProblem: UIViewController {

    @IBOutlet weak var selectTextView: UITextView!
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var answerNextButton: UIButton!
    
    private let getSelectList = GetProblemSelect()
    private let getProblemAnswerList = GetProblem_Answer()
    
    var pickerView = UIPickerView()
    private var problemCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        pickerView.delegate = self
        pickerView.dataSource = self
        selectTextView.isEditable = false
        selectTextView.text = "ここをタッチして正解を選んでください！"
        answerNextButton.setTitle("決定", for: .normal)
        answerNextButton.isEnabled = false
        pickerView.selectRow(0, inComponent: 0, animated: true)
        getProblemAnswerList.getProblemList()
        getSelectList.getProblemSelect()
        problemCount = 0
        getSelectList.problemSelectEmptyDelete = []
        getProblemAnswerList.problemList = []
    }
    
    override func viewDidAppear(_ animated: Bool) {
        doneBar()
        getSelectList.selectEmptyDelete(problemCount: problemCount)
    }
    
    func doneBar() {
        pickerView.showsSelectionIndicator = true
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 35))
        let spacleItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        toolBar.setItems([spacleItem, doneItem], animated: true)
        selectTextView.inputView = pickerView
        selectTextView.inputAccessoryView = toolBar
    }
    
    @objc func done() {
        selectTextView.endEditing(true)
        selectTextView.text = "\(getSelectList.problemSelectEmptyDelete[pickerView.selectedRow(inComponent: 0)])"
        answerNextButton.isEnabled = true
    }

    @IBAction func answerNextButton(_ sender: Any) {
        if selectTextView.text == getProblemAnswerList.problemList[problemCount].answer {
            answerLabel.text = "正解"
        } else {
            answerLabel.text = "正解は「\(getProblemAnswerList.problemList[problemCount].answer)」"
        }
        answerNextButton.setTitle("次の問題へ", for: .normal)
    }
    @IBAction func backButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
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

extension ChallengeProblem: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let cellLabel = UILabel()
        cellLabel.frame = CGRect(x: 0, y: 0, width: pickerView.rowSize(forComponent: 0).width, height: pickerView.rowSize(forComponent: 0).height)
        cellLabel.textAlignment = .center
        cellLabel.font = UIFont.boldSystemFont(ofSize: 30)
        cellLabel.backgroundColor = UIColor.darkGray
        cellLabel.textColor = UIColor.white
        cellLabel.text = getSelectList.problemSelectEmptyDelete[row]
        
        return cellLabel
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        getSelectList.problemSelectEmptyDelete.count

    }
    
    
}

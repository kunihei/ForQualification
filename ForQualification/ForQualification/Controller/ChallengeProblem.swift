//
//  ChallengeProblem.swift
//  ForQualification
//
//  Created by 祥平 on 2021/09/11.
//

import UIKit
import SDWebImage

class ChallengeProblem: UIViewController {

    @IBOutlet weak var selectTextView: UITextView!
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var answerButton: UIButton!
    @IBOutlet weak var problemCountLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var problemTextView: UITextView!
    @IBOutlet weak var problemImage: UIImageView!
    
    private let getSelectList = GetProblemSelect()
    private let getProblemAnswerList = GetProblem_Answer()
    
    var pickerView = UIPickerView()
    private var lastFlag = false
    private var problemCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        selectTextView.isEditable = false
        problemTextView.isEditable = false
        nextButton.isHidden = true
        pickerView.selectRow(0, inComponent: 0, animated: true)
        getProblemAnswerList.getProblemList()
        getSelectList.getProblemSelect()
        problemCount = 0
        initialValue()
        getSelectList.problemSelectEmptyDelete = []
        getProblemAnswerList.problemList = []
    }
    
    override func viewDidAppear(_ animated: Bool) {
        pickerView.delegate = self
        pickerView.dataSource = self
        doneBar()
        problemTextView.text = getProblemAnswerList.problemList[problemCount].problem
        if getProblemAnswerList.problemList[problemCount].problemImageData != "" {
            problemImage.sd_setImage(with: URL(string: getProblemAnswerList.problemList[problemCount].problemImageData), completed: nil)
        } else {
            problemImage.isHidden = true
        }
        getSelectList.selectEmptyDelete(problemCount: problemCount)
    }
    
    func initialValue() {
        problemCountLabel.text = "第\(problemCount + 1)問"
        selectTextView.text = "ここをタッチして正解を選んでください！"
        answerLabel.text = "結果"

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
    }
    
    //pickerViewの表示を消す
    func notPickerView(){
        selectTextView.inputView = .none
        selectTextView.inputAccessoryView = .none
        selectTextView.isEditable = false
    }

    @IBAction func answerButton(_ sender: Any) {
        if selectTextView.text == "ここをタッチして正解を選んでください！" {
            let alert: UIAlertController = UIAlertController(title: "未選択", message: "選択肢から答えを選んで下さい！", preferredStyle: UIAlertController.Style.alert)
            let confirmAction: UIAlertAction = UIAlertAction(title: "OK", style: .cancel)
            alert.addAction(confirmAction)
            present(alert, animated: true, completion: nil)
            return
        }
        
        if problemCount == getProblemAnswerList.problemList.count - 1 {
            nextButton.setTitle("採点画面へ", for: .normal)
            lastFlag = true
        }
        
        checkTheAnswer()
        notPickerView()
        nextButton.isHidden = false
        answerButton.isEnabled = false
    }
    
    func checkTheAnswer() {
        if selectTextView.text == getProblemAnswerList.problemList[problemCount].answer {
            answerLabel.text = "正解"
        } else {
            answerLabel.text = "正解は「\(getProblemAnswerList.problemList[problemCount].answer)」"
        }
    }
    
    func nextProblem() {
        if problemCount < getProblemAnswerList.problemList.count - 1 {
            problemCount += 1
            initialValue()
            problemTextView.text = getProblemAnswerList.problemList[problemCount].problem
            if getProblemAnswerList.problemList[problemCount].problemImageData != "" {
                problemImage.isHidden = false
                problemImage.sd_setImage(with: URL(string: getProblemAnswerList.problemList[problemCount].problemImageData), completed: nil)
            } else {
                problemImage.isHidden = true
            }
            getSelectList.selectEmptyDelete(problemCount: problemCount)
            doneBar()
            pickerView.selectRow(0, inComponent: 0, animated: true)
        }
    }
    
    func lastProblem() {
        if lastFlag {
            let resultView = ResultProblem()
            navigationController?.pushViewController(resultView, animated: true)
        }
    }
    
    @IBAction func nextButton(_ sender: Any) {
        nextProblem()
        nextButton.isHidden = true
        answerButton.isEnabled = true
        lastProblem()
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

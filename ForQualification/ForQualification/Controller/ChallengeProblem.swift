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
    var shuffleModeFlag = false
    private var lastFlag = false
    private var problemCount = 0
    private var correctAnswerCount = 0
    private var incorrectAnswerCount = 0
    private var averageCount = 0.0
    private var averageTotal = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
        selectTextView.isEditable = false
        problemTextView.isEditable = false
        nextButton.isHidden = true
        pickerView.selectRow(0, inComponent: 0, animated: true)
        getProblemAnswerList.getProblemList()
        getSelectList.getProblemSelect()
        initialValue()
        resetCount()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        pickerView.delegate = self
        pickerView.dataSource = self
        doneBar()
        imageCheck()
        problemTextView.text = getProblemAnswerList.problemList[problemCount].problem
        getSelectList.selectEmptyDelete(problemCount: problemCount)
        if shuffleModeFlag {
            getSelectList.problemSelectEmptyDelete.shuffle()
        }
    }
    
    // UIImageViewの表示・非表示のチェック
    func imageCheck() {
        if getProblemAnswerList.problemList[problemCount].problemImageData != "" {
            problemImage.isHidden = false
            problemImage.sd_setImage(with: URL(string: getProblemAnswerList.problemList[problemCount].problemImageData), completed: nil)
        } else {
            problemImage.isHidden = true
        }
    }
    
    // 採点結果で使用する数値
    func resetCount() {
        problemCount = 0
        averageCount = 0.0
        averageTotal = 0.0
        correctAnswerCount = 0
        incorrectAnswerCount = 0
    }
    
    // 表示ラベルの初期化
    func initialValue() {
        problemCountLabel.text = "第\(problemCount + 1)問"
        selectTextView.text = "ここをタッチして正解を選んでください！"
        answerLabel.text = "結果"

    }
    
    //ドラムロール作成
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
    }

    @IBAction func answerButton(_ sender: Any) {
        if selectTextView.text == "ここをタッチして正解を選んでください！" {
            let alert: UIAlertController = UIAlertController(title: "未選択", message: "選択肢から答えを選んで下さい！", preferredStyle: UIAlertController.Style.alert)
            let confirmAction: UIAlertAction = UIAlertAction(title: "OK", style: .cancel)
            alert.addAction(confirmAction)
            present(alert, animated: true, completion: nil)
            return
        }
        
        checkTheAnswer()
        checkLastProblem()
        notPickerView()
        nextButton.isHidden = false
        answerButton.isEnabled = false
    }
    
    // 最終問題解答後に表示
    func checkLastProblem() {
        if problemCount == getProblemAnswerList.problemList.count - 1 {
            problemCountLabel.text = "問題終了"
            nextButton.setTitle("採点画面へ", for: .normal)
            lastFlag = true
            averageCount = Double(correctAnswerCount) / Double(getProblemAnswerList.problemList.count)
            averageTotal = averageCount * 100.0
        }
    }
    
    // 正解の判断
    func checkTheAnswer() {
        if selectTextView.text == getProblemAnswerList.problemList[problemCount].answer {
            answerLabel.text = "正解"
            correctAnswerCount += 1
        } else {
            answerLabel.text = "正解は「\(getProblemAnswerList.problemList[problemCount].answer)」"
            incorrectAnswerCount += 1
        }
    }
    
    // 次の問題に進める
    func nextProblem() {
        if problemCount < getProblemAnswerList.problemList.count - 1 {
            problemCount += 1
            initialValue()
            problemTextView.text = getProblemAnswerList.problemList[problemCount].problem
            imageCheck()
            getSelectList.selectEmptyDelete(problemCount: problemCount)
            if shuffleModeFlag {
                getSelectList.problemSelectEmptyDelete.shuffle()
            }
            doneBar()
            pickerView.selectRow(0, inComponent: 0, animated: true)
        }
    }
    
    // 採点結果をResultProblemに値を渡し画面遷移
    func lastProblem() {
        if lastFlag {
            let resultView = ResultProblem()
            resultView.correctAnswerCount = correctAnswerCount
            resultView.incorrectAnswerCount = incorrectAnswerCount
            resultView.averageTotal = Int(averageTotal)
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

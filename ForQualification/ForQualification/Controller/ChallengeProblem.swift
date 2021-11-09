//
//  ChallengeProblem.swift
//  ForQualification
//
//  Created by 祥平 on 2021/09/11.
//

import UIKit
import SDWebImage
import PKHUD

class ChallengeProblem: UIViewController {

    @IBOutlet weak var selectTextView: UITextView!
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var answerButton: UIButton!
    @IBOutlet weak var problemCountLabel: UILabel!
    @IBOutlet weak var problemTextView: UITextView!
    @IBOutlet weak var problemImage: UIImageView!
    
    private let getSelectList = GetProblemSelect()
    private let getProblemAnswerList = GetProblem_Answer()
    
    private var pickerView = UIPickerView()
    private var problemList = [Problem_AnswerModel]()
    private var problemCount = 0
    private var correctAnswerCount = 0
    private var incorrectAnswerCount = 0
    private var averageCount = 0.0
    private var averageTotal = 0.0
    private var lastFlag = false
    private var nextFlag = false
    var shuffleModeFlag = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
        if UserDefaults.standard.bool(forKey: "colorFlag") == true { darkMode() }
        else { lightMode() }
        HUD.show(.progress)
        problemList = []
        selectTextView.isEditable = false
        problemTextView.isEditable = false
        pickerView.selectRow(0, inComponent: 0, animated: true)
        getProblemAnswerList.getProblemList()
        getSelectList.getProblemSelect()
        initialValue()
        resetCount()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        pickerView.delegate = self
        pickerView.dataSource = self
        problemList = getProblemAnswerList.problemList
        doneBar()
        imageCheck()
        problemTextView.text = problemList[problemCount].problem
        getSelectList.selectEmptyDelete(problemCount: problemCount)
        if shuffleModeFlag {
            getSelectList.problemSelectEmptyDelete.shuffle()
        }
        HUD.hide()
    }
    
    func darkMode() {
        view.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.241, alpha: 1.0)
        
        selectTextView.textColor = UIColor.white
        selectTextView.layer.borderColor = UIColor.white.cgColor
        selectTextView.layer.shadowColor = UIColor.white.cgColor
        selectTextView.backgroundColor = UIColor.darkGray
        
        answerLabel.textColor = UIColor.white
        answerLabel.layer.borderColor = UIColor.white.cgColor
        answerLabel.layer.shadowColor = UIColor.white.cgColor
        answerLabel.backgroundColor = UIColor.darkGray
        
        problemCountLabel.textColor = UIColor.white
        
        problemTextView.textColor = UIColor.white
        problemTextView.layer.borderColor = UIColor.white.cgColor
        problemTextView.layer.shadowColor = UIColor.white.cgColor
        problemTextView.backgroundColor = UIColor.darkGray
        
        answerButton.setTitleColor(UIColor.white, for: .normal)
        answerButton.layer.borderColor = UIColor.white.cgColor
        answerButton.layer.shadowColor = UIColor.white.cgColor
        answerButton.backgroundColor = UIColor.darkGray
    }
    
    func lightMode() {
        view.backgroundColor = UIColor.white
        
        selectTextView.textColor = UIColor.black
        selectTextView.layer.borderColor = UIColor.black.cgColor
        selectTextView.layer.shadowColor = UIColor.black.cgColor
        selectTextView.backgroundColor = UIColor.lightGray
        
        answerLabel.textColor = UIColor.black
        answerLabel.layer.borderColor = UIColor.black.cgColor
        answerLabel.layer.shadowColor = UIColor.black.cgColor
        answerLabel.backgroundColor = UIColor.lightGray
        
        problemCountLabel.textColor = UIColor.black
        
        problemTextView.textColor = UIColor.black
        problemTextView.layer.borderColor = UIColor.black.cgColor
        problemTextView.layer.shadowColor = UIColor.black.cgColor
        problemTextView.backgroundColor = UIColor.lightGray
        
        answerButton.setTitleColor(UIColor.black, for: .normal)
        answerButton.layer.borderColor = UIColor.black.cgColor
        answerLabel.layer.shadowColor = UIColor.black.cgColor
        answerButton.backgroundColor = UIColor.lightGray
    }
    
    // UIImageViewの表示・非表示のチェック
    func imageCheck() {
        if problemList[problemCount].problemImageData != "" {
            problemImage.isHidden = false
            problemImage.sd_setImage(with: URL(string: problemList[problemCount].problemImageData), completed: nil)
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
        if nextFlag {
            nextButton()
            nextFlag = false
            return
        }
        
        answerButton.setTitle("次の問題へ", for: .normal)
        nextFlag = checkTheAnswer()
        checkLastProblem()
        notPickerView()
    }
    
    // 最終問題解答後に表示
    func checkLastProblem() {
        if problemCount == problemList.count - 1 {
            problemCountLabel.text = "問題終了"
            answerButton.setTitle("採点画面へ", for: .normal)
            lastFlag = true
            averageCount = Double(correctAnswerCount) / Double(problemList.count)
            averageTotal = averageCount * 100.0
        }
    }
    
    // 正解の判断
    func checkTheAnswer() -> Bool {
        if selectTextView.text == problemList[problemCount].answer {
            answerLabel.text = "正解"
            correctAnswerCount += 1
        } else {
            answerLabel.text = "正解は「\(problemList[problemCount].answer)」"
            incorrectAnswerCount += 1
        }
        return true
    }
    
    // 次の問題に進める
    func nextProblem() {
        if problemCount < problemList.count - 1 {
            problemCount += 1
            initialValue()
            problemTextView.text = problemList[problemCount].problem
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
    
    func nextButton() {
        nextProblem()
        lastProblem()
        answerButton.setTitle("決定", for: .normal)
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
        cellLabel.numberOfLines = 0
        cellLabel.font = UIFont.boldSystemFont(ofSize: 20)
        cellLabel.backgroundColor = UIColor.darkGray
        cellLabel.textColor = UIColor.white
        cellLabel.text = getSelectList.problemSelectEmptyDelete[row]
        
        return cellLabel
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        getSelectList.problemSelectEmptyDelete.count

    }
    
    
}

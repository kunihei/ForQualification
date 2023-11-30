//
//  SelectRegistViewController.swift
//  ForQualification
//
//  Created by 祥平 on 2023/11/11.
//

import UIKit

class SelectRegistViewController: UIViewController, KeyboardDetector  {
    
    @IBOutlet weak var tableView: UITableView!
    private var selectCount = 2
    private var textList = [Int: String]()
    private var emptySelect = [Int: Bool]()
    private var emptyAnsFlg = false
    private var delShowFlg = false
    private var answerText = ""
    private var index = 0
    private var oldIndex:Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "SelectCell", bundle: nil), forCellReuseIdentifier: "selectCell")
        if !ProblemSelect.shared.getSelects().isEmpty {
            selectCount = ProblemSelect.shared.getSelects().count
            textList = ProblemSelect.shared.getSelects()
        }
        self.view.closeTapKeyborad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // キーボードがパーツと被るかを検知する
        startObservingKeyboardChanges()
    }
    

    @IBAction func backButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func confirmButton(_ sender: UIButton) {
        emptyAnsFlg = false
        if textList[0] == nil {
            emptyAnsFlg = true
        }
        if selectCount >= 2 {
            for item in 1..<selectCount {
                if textList[item] == nil || textList[item] == "" {
                    emptySelect[item] = false
                } else {
                    emptySelect[item] = true
                }
            }
        }
        var selectFlg = 0
        emptySelect.forEach { (key, val) in
            if val {
                selectFlg += 1
                emptySelect.removeAll()
            }
        }
        tableView.reloadData()
        if emptyAnsFlg || selectFlg == 0 {
            return
        }
        
        ProblemSelect.shared.setSelects(array: textList)
        self.moveView(storyboardName: StoryboardName.confirm)
    }

}

// MARK: テーブルビュー
extension SelectRegistViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "selectCell", for: indexPath) as! SelectCell
        cell.addSelectDelegate = self
        // 一つ目は回答、二つ目は選択肢の初回でタイトルがいるのでその判断
        if indexPath.row < 2 {
            cell.initCell(title: "選択肢", tag: indexPath.row)
        } else {
            cell.setCell(tag: indexPath.row)
        }
        if emptyAnsFlg && indexPath.row == 0 {
            cell.errorLabel.isHidden = false
            cell.selectTextView.borderColor = .red
        } else if indexPath.row == 0 {
            cell.errorLabel.isHidden = true
            cell.selectTextView.borderColor = ColorPalette.borderColor
        }
        if emptySelect.count != 0 && indexPath.row > 0 {
            cell.errorLabel.isHidden = emptySelect[indexPath.row] ?? true
            if emptySelect[indexPath.row] != nil {
                cell.selectTextView.borderColor = .red
            }
        } else if indexPath.row > 0 {
            cell.errorLabel.isHidden = true
            cell.selectTextView.borderColor = ColorPalette.borderColor
        }
        
        // 正解のテキストを取得
        if indexPath.row == 0 {
            answerText = cell.selectTextView.text
        }
        
        // 選択肢の一つだけの時は削除ボタンを表示しないようにする
        if indexPath.row == 1 && delShowFlg {
            cell.delButton.isHidden = false
        } else if 1 == indexPath.row && selectCount == 2 {
            cell.delButton.isHidden = true
        }
        
        // 選択肢が10個になったら追加ボタン非表示
        if selectCount - 1 == 10 {
            cell.addButton.isHidden = true
        }
        
        // テーブルビューのリサイクル対策のためにtextViewのテキストを配列に格納しリロードかかるたびにtextViewに反映するようにする
        if textList.count != 0 {
            cell.selectTextView.text = textList[indexPath.row]
        }
        
        cell.selectionStyle = .none
        return cell
    }
}

extension SelectRegistViewController: AddSelectDelegate {
    func setAnswerText(index: Int) {
//        var tmpIndex = index
//        var tmpTextList = [Int: String]()
//        var firstFlg = true
        if oldIndex != nil {
            if textList[oldIndex!] != nil {
                textList.removeValue(forKey: oldIndex!)
            }
//            textList.forEach { (key, val) in
//                if key > oldIndex! {
//                    tmpTextList[key - 1] = val
//                    if firstFlg && tmpIndex > 1 {
//                        firstFlg = false
//                        tmpIndex = index - 1
//                    }
//                } else {
//                    tmpTextList[key] = val
//                }
//            }
//
//            textList.removeAll()
//            textList = tmpTextList
        }
        oldIndex = index
        textList.updateValue(textList[0] ?? "", forKey: index)
        tableView.reloadData()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        textList.updateValue(textView.text, forKey: textView.tag)
    }
    
    func addSelectTextView(button: UIButton) {
        delShowFlg = true
        var tmpTextList = [Int: String]()
        textList.forEach { (key, val) in
            if key > button.tag {
                tmpTextList[key + 1] = val
            } else {
                tmpTextList[key] = val
            }
        }
        textList.removeAll()
        textList = tmpTextList
        selectCount += 1
        tableView.reloadData()
    }
    
    func delSelectTextView(button: UIButton) {
        delShowFlg = false
        var tmpTextList = [Int: String]()
        if textList[button.tag] != nil {
            textList.removeValue(forKey: button.tag)
        }
        textList.forEach { (key, val) in
            if key > button.tag {
                tmpTextList[key - 1] = val
            } else {
                tmpTextList[key] = val
            }
        }
        textList.removeAll()
        textList = tmpTextList
        selectCount -= 1
        tableView.reloadData()
    }
    
}

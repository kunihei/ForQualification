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
    private var delShowFlg = false
    private var answerText = ""
    private var index = 0
    private var oldIndex:Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "SelectCell", bundle: nil), forCellReuseIdentifier: "selectCell")
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
        ProblemSelect.shared.setSelects(array: textList)
        print(ProblemSelect.shared.getSelects())
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
        
        if indexPath.row == 0 {
            answerText = cell.selectTextView.text
        }
        if indexPath.row == index {
            cell.selectTextView.text = answerText
        }
        
        // 選択肢の一つだけの時は削除ボタンを表示しないようにする
        if indexPath.row == 1 && delShowFlg {
            cell.delButton.isHidden = false
        } else if 1 == indexPath.row && selectCount == 2 {
            cell.delButton.isHidden = true
        }
        
        // 選択肢が10個になったら追加ボタン非表示
        if selectCount - 1 == 10 {
            cell.addBtnHidden()
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
        var tmpIndex = index
        var tmpTextList = [Int: String]()
        if oldIndex != nil {
            if textList[oldIndex!] != nil {
                textList.removeValue(forKey: oldIndex!)
            }
            textList.forEach { (key, val) in
                if key > oldIndex! {
                    tmpTextList[key - 1] = val
                } else {
                    tmpTextList[key] = val
                }
            }

            textList.removeAll()
            textList = tmpTextList
            tmpIndex = index - 1
            selectCount -= 1
        }
        oldIndex = tmpIndex
        textList.updateValue(textList[0] ?? "", forKey: tmpIndex)
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

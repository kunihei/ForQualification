//
//  RegisterProblem.swift
//  ForQualification
//
//  Created by 祥平 on 2021/09/11.
//

import UIKit
import Photos
import Firebase
import SDWebImage
import FirebaseStorage
import FirebaseFirestore

class SettingProblem: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var select1Label: UILabel!
    @IBOutlet weak var select2Label: UILabel!
    @IBOutlet weak var select3Label: UILabel!
    @IBOutlet weak var select4Label: UILabel!
    @IBOutlet weak var select5Label: UILabel!
    @IBOutlet weak var select6Label: UILabel!
    @IBOutlet weak var select7Label: UILabel!
    @IBOutlet weak var select8Label: UILabel!
    @IBOutlet weak var select9Label: UILabel!
    @IBOutlet weak var select10Label: UILabel!
    @IBOutlet weak var explanationLabel: UILabel!
    @IBOutlet weak var selectsLabel: UILabel!
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var smallProblemLabel: UILabel!
    @IBOutlet weak var problemLabel: UILabel!
    @IBOutlet weak var problemstatement: UITextView!
    @IBOutlet weak var problemImage: UIImageView!
    @IBOutlet weak var select1: UITextView!
    @IBOutlet weak var select2: UITextView!
    @IBOutlet weak var select3: UITextView!
    @IBOutlet weak var select4: UITextView!
    @IBOutlet weak var select5: UITextView!
    @IBOutlet weak var select6: UITextView!
    @IBOutlet weak var select7: UITextView!
    @IBOutlet weak var select8: UITextView!
    @IBOutlet weak var select9: UITextView!
    @IBOutlet weak var select10: UITextView!
    @IBOutlet weak var settingButton: UIButton!
    @IBOutlet weak var answerTextField: UITextView!
    @IBOutlet weak var settingView: UIView!
    @IBOutlet weak var photoExplanationLabel: UILabel!
    
    private let userUid = Auth.auth().currentUser?.uid
    private var selectList:[UITextView] = []
    private var selectLabelList:[UILabel] = []
    var documentId = String()
    var editFlag = false
    var problem = String()
    var problemImageData = String()
    var selects = [String]()
    var answer = String()
    var createAt = Double()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "問題登録"
        photoExplanationLabel.text = "ここをタップして\n画像を選択してください"
        problemstatement.delegate = self
        navigationController?.isNavigationBarHidden = false
        selectList = [self.select1, self.select2, self.select3, self.select4, self.select5, self.select6, self.select7, self.select8, self.select9, self.select10]
        selectLabelList = [select1Label, select2Label, select3Label, select4Label, select5Label, select6Label, select7Label, select8Label, select9Label, select10Label]
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        closeKeyboard(textView: problemstatement)
        closeKeyboard(textView: answerTextField)
        for i in 0..<selectList.count {
            closeKeyboard(textView: selectList[i])
        }
        editProblem(editFlag: editFlag)
    }
    
    // 更新画面作成
    func editProblem(editFlag: Bool) {
        if editFlag {
            settingButton.setTitle("更新", for: .normal)
            problemstatement.text = problem
            answerTextField.text = answer
            if problemImageData != "" {
                problemImage.sd_setImage(with: URL(string: problemImageData), completed: nil)
            }
            for i in 0..<selects.count {
                selectList[i].text = selects[i]
            }
        }
    }
    
    // textView入力時キーボードを閉じるボタン表示
    func closeKeyboard(textView: UITextView) {
        // ツールバー生成
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 40))
        // スタイルを設定
        toolBar.barStyle = UIBarStyle.default
        // 画面幅に合わせてサイズを変更
        toolBar.sizeToFit()
        // 閉じるボタンを右に配置するためのスペース?
        let spacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil)
        // 閉じるボタン
        let commitButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(commitButtonTapped))
        // スペース、閉じるボタンを右側に配置
        toolBar.items = [spacer, commitButton]
        // textViewのキーボードにツールバーを設定
        textView.inputAccessoryView = toolBar
    }
    
    @objc func commitButtonTapped() {
         self.view.endEditing(true)
     }
    
    @IBAction func settingButton(_ sender: Any) {
        let emptyFlag = emptySetting()
        if !emptyFlag {
            return
        }
        guard let userId = userUid else { return }
        if editFlag {
            judgmentEditProblem(userId: userId)
        } else {
            judgmentCreateProblem(userId: userId)
        }
    }
    
    // 問題文・解答文が空か・選択肢が２つ以上入力されていないとアラートを表示
    func emptySetting() -> Bool {
        var emptyCount = 0
        for i in 0..<selectList.count {
            if selectList[i].text.isEmpty {
                emptyCount += 1
            }
        }
        let proAnsEmptyFlag = problemAnswerEmptyValue(problemstatementCount: problemstatement.text.count, answerCount: answerTextField.text.count)
        let selectEmptyFlag = selectEmptyValue(emptyCount: emptyCount)
        if proAnsEmptyFlag {
            alert(title: "未入力", message: "問題文又は解答文が空です。")
            return false
        }
        if selectEmptyFlag {
            alert(title: "未入力", message: "選択肢を2つ以上入力して下さい。")
            return false
        }
        return true
    }
    
    // 選択肢の空判定
    func selectEmptyValue(emptyCount: Int) -> Bool {
        let limitEmptyCount = 8
        if emptyCount > limitEmptyCount {
            return true
        }
        return false
    }
    
    // 問題文と解答文の空判定
    func problemAnswerEmptyValue(problemstatementCount: Int, answerCount: Int) -> Bool {
        let zeroWordCount = 0
        if (problemstatementCount == zeroWordCount || answerCount == zeroWordCount) {
            return true
        }
        return false
    }
    
    // 登録の成否の判定表示
    func judgmentRegistFlag(judgmentFlag: Bool) {
        if judgmentFlag {
            resetValues()
            alert(title: "登録完了", message: "問題の登録に成功しました。")
        } else {
            alert(title: "登録失敗", message: "問題の登録に失敗しました。")
        }
    }
    
    // irebageに登録の成否判断
    func judgmentCreateProblem(userId: String) {
        if let problemImageConversion = problemImage.image {
            let problemImageData = problemImageConversion.jpegData(compressionQuality: 0.3)
            let judgmentFlag = thereIsPictureDatas(userId: userId, problemImageData: problemImageData!)
            judgmentRegistFlag(judgmentFlag: judgmentFlag)
        } else {
            let judgmentFlag = noPictureDatas(userId: userId)
            judgmentRegistFlag(judgmentFlag: judgmentFlag)
        }
    }
    
    // 更新の成否の判定表示
    func judgmentEditFlag(judgmentFlag: Bool) {
        if judgmentFlag {
            editSuccessAlert()
        } else {
            alert(title: "更新失敗", message: "問題の更新に失敗しました。")
            return
        }
    }
    
    // Firebaseに更新の成否判断
    func judgmentEditProblem(userId: String) {
        if let problemImageConversion = problemImage.image {
            let problemImageData = problemImageConversion.jpegData(compressionQuality: 0.3)
            let judgmentFlag = editThereIsPictureDatas(userId: userId, documentId: documentId, editProblemImageData: problemImageData!)
            judgmentEditFlag(judgmentFlag: judgmentFlag)
        } else {
            let judgmentFlag = editNoPictureDatas(userId: userId, documentId: documentId)
            judgmentEditFlag(judgmentFlag: judgmentFlag)
        }
    }
    
    // アラート表示
    func alert(title:String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let confirmAction: UIAlertAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(confirmAction)
        present(alert, animated: true, completion: nil)
    }
    
    //更新完了したらアラートを表示
    func editSuccessAlert() {
        let alert = UIAlertController(title: "更新完了", message: "問題の更新に成功しました。", preferredStyle: UIAlertController.Style.alert)
        let confirmAction: UIAlertAction = UIAlertAction(title: "OK", style: .default) { action in
            let editProblemView = EditProblem()
            self.navigationController?.pushViewController(editProblemView, animated: true)
        }
        alert.addAction(confirmAction)
        present(alert, animated: true, completion: nil)
    }
    
    //　画像ありの情報をFirebaseに更新
    func editThereIsPictureDatas(userId: String, documentId: String, editProblemImageData: Data) -> Bool {
        let isImageUpdateProblem = UpdateProblem(editProblemstatement: problemstatement.text, problemImageData: editProblemImageData, answer: answerTextField.text, select1: selectList[0].text, select2: selectList[1].text, select3: selectList[2].text, select4: selectList[3].text, select5: selectList[4].text, select6: selectList[5].text, select7: selectList[6].text, select8: selectList[7].text, select9: selectList[8].text, select10: selectList[9].text, documentId: documentId, userId: userId, createAt: createAt)
        return isImageUpdateProblem.isImageUpdateProblem()
    }
    
    //　画像なしの情報をFirebaseに更新
    func editNoPictureDatas(userId: String, documentId: String) -> Bool {
        let noImageUpdateProblem = UpdateProblem(editProblemstatement: problemstatement.text, answer: answerTextField.text, select1: selectList[0].text, select2: selectList[1].text, select3: selectList[2].text, select4: selectList[3].text, select5: selectList[4].text, select6: selectList[5].text, select7: selectList[6].text, select8: selectList[7].text, select9: selectList[8].text, select10: selectList[9].text, documentId: documentId, userId: userId, createAt: createAt)
        return noImageUpdateProblem.noImageupdateProblem()
    }
    
    // 画像ありの情報をFirebaseに登録
    func thereIsPictureDatas(userId: String, problemImageData: Data) -> Bool {
        let createProblem = CreateProblem(problemstatement: problemstatement.text, problemImageData: problemImageData, answer: answerTextField.text, select1: selectList[0].text, select2: selectList[1].text, select3: selectList[2].text, select4: selectList[3].text, select5: selectList[4].text, select6: selectList[5].text, select7: selectList[6].text, select8: selectList[7].text, select9: selectList[8].text, select10: selectList[9].text, userId: userId)
        return createProblem.isImageCreateProblem()
    }
    
    // 画像なしの情報をFirebaseに登録
    func noPictureDatas(userId: String) -> Bool {
        let createProblem = CreateProblem(problemstatement: problemstatement.text, answer: answerTextField.text, select1: selectList[0].text, select2: selectList[1].text, select3: selectList[2].text, select4: selectList[3].text, select5: selectList[4].text, select6: selectList[5].text, select7: selectList[6].text, select8: selectList[7].text, select9: selectList[8].text, select10: selectList[9].text, userId: userId)
        return createProblem.noImageCreateProblem()
    }
    
    // 登録後全ての値を空にする
    func resetValues() {
        problemstatement.text = ""
        answerTextField.text = ""
        problemImage.image = UIImage(named: "")
        for i in 0..<selectList.count {
            selectList[i].text = ""
        }
    }
    
    // キーボードを閉じる
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.problemstatement.isFirstResponder {
            self.problemstatement.resignFirstResponder()
        }
        
        if self.answerTextField.isFirstResponder {
            self.answerTextField.resignFirstResponder()
        }
        
        for i in 0..<selectList.count {
            if self.selectList[i].isFirstResponder {
                self.selectList[i].resignFirstResponder()
            }
        }
    }
    @IBAction func tapPhoto(_ sender: Any) {
        showAlert()
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

// カメラ＆アルバムを使用
extension SettingProblem: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func doCamera() {
        let sourceType:UIImagePickerController.SourceType = .camera
        
        //カメラ利用可能かチェック
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            
            let cameraPicker = UIImagePickerController()
            cameraPicker.allowsEditing = true
            cameraPicker.sourceType = sourceType
            cameraPicker.delegate = self
            self.present(cameraPicker, animated: true, completion: nil)
        }
    }
    
    func doAlbum() {
        let sourceType:UIImagePickerController.SourceType = .photoLibrary
        
        //カメラ利用可能かチェック
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            
            let cameraPicker = UIImagePickerController()
            cameraPicker.allowsEditing = true
            cameraPicker.sourceType = sourceType
            cameraPicker.delegate = self
            self.present(cameraPicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if info[.originalImage] as? UIImage != nil {
            let selectedImage = info[.originalImage] as! UIImage
            problemImage.image = selectedImage
            picker.dismiss(animated: true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    //アラート
    func showAlert() {
        
        let alertController = UIAlertController(title: "選択", message: "どちらを使用しますか？", preferredStyle: .actionSheet)
        
        let actionCamera = UIAlertAction(title: "カメラ", style: .default) { (alert) in
            self.doCamera()
        }
        
        let actionAlbum = UIAlertAction(title: "アルバム", style: .default) { (alert) in
            self.doAlbum()
        }
        
        let actionDelete = UIAlertAction(title: "削除", style: .default) { (alert) in
            self.problemImage.image = UIImage(named: "")
        }
        
        let actionCancel = UIAlertAction(title: "キャンセル", style: .cancel)
        
        alertController.addAction(actionCamera)
        alertController.addAction(actionAlbum)
        alertController.addAction(actionDelete)
        alertController.addAction(actionCancel)
        self.present(alertController, animated: true, completion: nil)
    }
}

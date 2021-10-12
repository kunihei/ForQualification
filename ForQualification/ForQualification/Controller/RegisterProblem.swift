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

class RegisterProblem: UIViewController, UITextViewDelegate {

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
    
    private let userUid = Auth.auth().currentUser?.uid
    private var selectList:[UITextView] = []
    var documentId = String()
    var editFlag = false
    var problem = String()
    var problemImageData = String()
    var selects = [String]()
    var answer = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        problemstatement.delegate = self
        navigationController?.isNavigationBarHidden = false
        selectList = [self.select1, self.select2, self.select3, self.select4, self.select5, self.select6, self.select7, self.select8, self.select9, self.select10]
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        for i in 0..<selectList.count {
            selectList[i].layer.cornerRadius = 5
        }
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
    
    @IBAction func settingButton(_ sender: Any) {
        guard let userId = userUid else { return }
        if editFlag {
            if let problemImageConversion = problemImage.image {
                let problemImageData = problemImageConversion.jpegData(compressionQuality: 0.3)
                editThereIsPictureDatas(userId: userId, documentId: documentId, editProblemImageData: problemImageData!)
            } else {
                editNoPictureDatas(userId: userId, documentId: documentId)
            }
            editSuccessAlert()
        } else {
            if let problemImageConversion = problemImage.image {
                let problemImageData = problemImageConversion.jpegData(compressionQuality: 0.3)
                thereIsPictureDatas(userId: userId, problemImageData: problemImageData!)
            } else {
                noPictureDatas(userId: userId)
            }
            resetValues()
            successAlert()
        }
    }
    
    // 登録完了したらアラートを表示
    func successAlert() {
        let alert = UIAlertController(title: "登録完了", message: "問題の登録に成功しました。", preferredStyle: UIAlertController.Style.alert)
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
    func editThereIsPictureDatas(userId: String, documentId: String, editProblemImageData: Data) {
        let isImageUpdateProblem = UpdateProblem(editProblemstatement: problemstatement.text, problemImageData: editProblemImageData, answer: answerTextField.text, select1: selectList[0].text, select2: selectList[1].text, select3: selectList[2].text, select4: selectList[3].text, select5: selectList[4].text, select6: selectList[5].text, select7: selectList[6].text, select8: selectList[7].text, select9: selectList[8].text, select10: selectList[9].text, documentId: documentId, userId: userId)
        isImageUpdateProblem.isImageUpdateProblem()
    }
    
    //　画像なしの情報をFirebaseに更新
    func editNoPictureDatas(userId: String, documentId: String) {
        let noImageUpdateProblem = UpdateProblem(editProblemstatement: problemstatement.text, answer: answerTextField.text, select1: selectList[0].text, select2: selectList[1].text, select3: selectList[2].text, select4: selectList[3].text, select5: selectList[4].text, select6: selectList[5].text, select7: selectList[6].text, select8: selectList[7].text, select9: selectList[8].text, select10: selectList[9].text, documentId: documentId, userId: userId)
        noImageUpdateProblem.noImageupdateProblem()
    }
    
    // 画像ありの情報をFirebaseに登録
    func thereIsPictureDatas(userId: String, problemImageData: Data) {
        let createProblem = CreateProblem(problemstatement: problemstatement.text, problemImageData: problemImageData, answer: answerTextField.text, select1: selectList[0].text, select2: selectList[1].text, select3: selectList[2].text, select4: selectList[3].text, select5: selectList[4].text, select6: selectList[5].text, select7: selectList[6].text, select8: selectList[7].text, select9: selectList[8].text, select10: selectList[9].text, userId: userId)
        createProblem.isImageCreateProblem()
    }
    
    // 画像なしの情報をFirebaseに登録
    func noPictureDatas(userId: String) {
        let createProblem = CreateProblem(problemstatement: problemstatement.text, answer: answerTextField.text, select1: selectList[0].text, select2: selectList[1].text, select3: selectList[2].text, select4: selectList[3].text, select5: selectList[4].text, select6: selectList[5].text, select7: selectList[6].text, select8: selectList[7].text, select9: selectList[8].text, select10: selectList[9].text, userId: userId)
        createProblem.noImageCreateProblem()
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
    
    @IBAction func photoButton(_ sender: Any) {
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
extension RegisterProblem: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
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

//
//  RegisterProblem.swift
//  ForQualification
//
//  Created by 祥平 on 2021/09/11.
//

import UIKit
import Photos
import Firebase
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
    @IBOutlet weak var answerTextField: UITextView!
    
    private let userUid = Auth.auth().currentUser?.uid
    private var selectList:[UITextView] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        problemstatement.delegate = self
        navigationController?.isNavigationBarHidden = false
        selectList = [self.select1, self.select2, self.select3, self.select4, self.select5, self.select6, self.select7, self.select8, self.select9, self.select10]
        // Do any additional setup after loading the view.
    }
    
    @IBAction func registerButton(_ sender: Any) {
        
        guard let userId = userUid else { return }
        
        if let problemImageConversion = problemImage.image {
            
            let problemImageData = problemImageConversion.jpegData(compressionQuality: 0.3)
            let createProblem = CreateProblem(problemstatement: problemstatement.text, problemImageData: problemImageData!, answer: answerTextField.text, select1: select1.text, select2: select2.text, select3: select3.text, select4: select4.text, select5: select5.text, select6: select6.text, select7: select7.text, select8: select8.text, select9: select9.text, select10: select10.text, userId: userId)
            createProblem.isImageCreateProblem()
        } else {
            
            let createProblem = CreateProblem(problemstatement: problemstatement.text, answer: answerTextField.text, select1: select1.text, select2: select2.text, select3: select3.text, select4: select4.text, select5: select5.text, select6: select6.text, select7: select7.text, select8: select8.text, select9: select9.text, select10: select10.text, userId: userId)
            createProblem.noImageCreateProblem()
        }
        problemstatement.text = ""
        answerTextField.text = ""
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

//
//  ProblemViewController.swift
//  ForQualification
//
//  Created by 祥平 on 2023/10/28.
//

import UIKit
import Photos
import Firebase
import SDWebImage

class ProblemViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var problemImageView: UIImageView!
    @IBOutlet weak var problemTextView: CustomTextView!
    @IBOutlet weak var nextButton: CustomButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    private let userUid = Auth.auth().currentUser?.uid
    var documentId = String()
    var editFlag = false
    var problem = String()
    var problemImageData = String()
    var selects = [String]()
    var answer = String()
    var createAt = Double()
    var confirmFlg = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        problemTextView.delegate = self
        self.view.closeTapKeyborad()
        if confirmFlg {
            nextButton.setTitle("確認する", for: .normal)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !ProblemSelect.shared.getImageData().isEmpty {
            problemImageView.image = UIImage(data: ProblemSelect.shared.getImageData())
        }
        if !ProblemSelect.shared.getProblemText().isEmpty {
            problemTextView.text = ProblemSelect.shared.getProblemText()
        }
        
        problemTextView.closeKeyboard()
        if editFlag {
            editProblem()
        }
    }
        
    @IBAction func backButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tapregistImage(_ sender: UITapGestureRecognizer) {
        showPhotoAlert()
    }
    @IBAction func nextStepButton(_ sender: UIButton) {
        if problemTextView.chkEmpty() {
            errorLabel.isHidden = false
            problemTextView.borderColor = .red
            return
        }
        errorLabel.isHidden = true
        problemTextView.borderColor = ColorPalette.borderColor
        ProblemSelect.shared.setProblemText(text: problemTextView.text)
        ProblemSelect.shared.setImageData(image: nil)
        if let problemImageConversion = problemImageView.image {
            let problemImageData = problemImageConversion.jpegData(compressionQuality: 0.3)
            ProblemSelect.shared.setImageData(image: problemImageData)
        }
        if (confirmFlg) {
            self.moveView(storyboardName: StoryboardName.confirm)
            return
        }
        self.moveView(storyboardName: StoryboardName.select)
        
    }
}

// MARK: メソッド
extension ProblemViewController {
    // 更新画面作成
    func editProblem() {
        problemTextView.text = problem
        if problemImageData != "" {
            problemImageView.sd_setImage(with: URL(string: problemImageData), completed: nil)
        }
    }
}

// MARK: カメラ＆アルバム
extension ProblemViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
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
            problemImageView.image = selectedImage
            picker.dismiss(animated: true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    //アラート
    func showPhotoAlert() {
        
        let alertController = UIAlertController(title: ButtonTitle.Photo.selected, message: MessageList.Photo.select, preferredStyle: .actionSheet)
        
        let actionCamera = UIAlertAction(title: ButtonTitle.Photo.camera, style: .default) { (alert) in
            self.doCamera()
        }
        
        let actionAlbum = UIAlertAction(title: ButtonTitle.Photo.alubm, style: .default) { (alert) in
            self.doAlbum()
        }
        
        let actionDelete = UIAlertAction(title: ButtonTitle.Common.delete, style: .default) { (alert) in
            self.problemImageView.image = UIImage(named: "")
        }
        
        let actionCancel = UIAlertAction(title: ButtonTitle.Common.cancel, style: .cancel)
        
        alertController.addAction(actionCamera)
        alertController.addAction(actionAlbum)
        alertController.addAction(actionDelete)
        alertController.addAction(actionCancel)
        self.present(alertController, animated: true, completion: nil)
    }
}


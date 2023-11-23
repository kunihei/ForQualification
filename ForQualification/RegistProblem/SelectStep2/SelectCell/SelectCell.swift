//
//  SelectCell.swift
//  ForQualification
//
//  Created by 祥平 on 2023/11/11.
//

import UIKit

protocol AddSelectDelegate: AnyObject {
    func addSelectTextView(button: UIButton)
    func delSelectTextView(button: UIButton)
    func textViewDidEndEditing(_ textView: UITextView)
    func setAnswerText(index: Int)
}

class SelectCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var selectTextView: UITextView!
    @IBOutlet weak var answerButton: UIButton!
    @IBOutlet weak var delButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    
    weak var addSelectDelegate: AddSelectDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectTextView.closeKeyboard()
        selectTextView.delegate = self
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func addAnswerBtn(_ sender: UIButton) {
        addSelectDelegate?.setAnswerText(index: sender.tag)
    }
    
    @IBAction func addSelect(_ sender: UIButton) {
        addSelectDelegate?.addSelectTextView(button: sender)
    }
    
    @IBAction func delSelect(_ sender: UIButton) {
        addSelectDelegate?.delSelectTextView(button: sender)
    }
}

extension SelectCell {
    func initCell (title: String, tag: Int) {
        answerButton.tag   = tag
        delButton.tag      = tag
        addButton.tag      = tag
        selectTextView.tag = tag
        switch tag {
        case 0:
            titleLabel.isHidden        = false
            titleLabel.text            = "回答文"
            answerButton.isHidden      = true
            delButton.isHidden         = true
            addButton.isHidden         = true
        case 1:
            titleLabel.isHidden        = false
            titleLabel.text            = "選択肢"
            answerButton.isHidden      = false
            delButton.isHidden         = false
            addButton.isHidden         = false
        default:
            return
        }
    }
    
    func setCell(tag: Int) {
        titleLabel.isHidden        = true
        answerButton.isHidden      = false
        delButton.isHidden         = false
        addButton.isHidden         = false
        answerButton.tag           = tag
        delButton.tag              = tag
        addButton.tag              = tag
        selectTextView.tag         = tag
        if tag == 10 {
            addButton.isHidden = true
        }
    }
    
    func addBtnHidden () {
        addButton.isHidden = true
    }
    
    func addBtnShow () {
        addButton.isHidden = false
    }
    
}

extension SelectCell: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        self.addSelectDelegate?.textViewDidEndEditing(textView)
    }
}

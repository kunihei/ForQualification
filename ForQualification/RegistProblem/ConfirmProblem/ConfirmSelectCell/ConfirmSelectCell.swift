//
//  ConfirmSelectCell.swift
//  ForQualification
//
//  Created by 祥平 on 2023/11/23.
//

import UIKit

class ConfirmSelectCell: UITableViewCell {

    @IBOutlet weak var mainStackHeight: NSLayoutConstraint!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak private var selectLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func editSelectButton(_ sender: UIButton) {
    }
    func firstSelectItem() {
        editButton.isHidden = true
        titleLabel.text = "選択肢"
    }
    func setSelectLabel(index: Int, text: String) {
        selectLabel.text = text
        if index > 1 {
            mainStackHeight.constant = 0
            titleLabel.isHidden = true
            editButton.isHidden = true
        }
        
    }
    
}

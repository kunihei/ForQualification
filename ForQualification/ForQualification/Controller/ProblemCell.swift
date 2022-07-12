//
//  ProblemCell.swift
//  ForQualification
//
//  Created by 祥平 on 2022/07/10.
//

import UIKit

class ProblemCell: UITableViewCell {

    @IBOutlet weak var tapGestureView: UIView!
    @IBOutlet weak var problemTitileLabel: UILabel!
    @IBOutlet weak var problemLabel: UILabel!
    @IBOutlet weak var answerTitileLabel: UILabel!
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var problemImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCell(problem: Problem_AnswerModel) {
        problemLabel.text = problem.problem
        answerLabel.text = problem.answer
        if problem.problemImageData != "" {
            problemImageView.sd_setImage(with: URL(string: problem.problemImageData))
        }
    }
    
}

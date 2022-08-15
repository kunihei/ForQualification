//
//  SelectButtonView.swift
//  ForQualification
//
//  Created by 祥平 on 2022/08/14.
//

import UIKit

class SelectButtonView: UIViewController {

    @IBOutlet weak var selectButton1: UIButton!
    @IBOutlet weak var selectButton2: UIButton!
    @IBOutlet weak var selectButton3: UIButton!
    @IBOutlet weak var selectButton4: UIButton!
    @IBOutlet weak var selectButton5: UIButton!
    @IBOutlet weak var selectButton6: UIButton!
    @IBOutlet weak var selectButton7: UIButton!
    @IBOutlet weak var selectButton8: UIButton!
    @IBOutlet weak var selectButton9: UIButton!
    @IBOutlet weak var selectButton10: UIButton!
    private var selectButtons = [UIButton]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectButtons = [
            selectButton1,
            selectButton2,
            selectButton3,
            selectButton4,
            selectButton5,
            selectButton6,
            selectButton7,
            selectButton8,
            selectButton9,
            selectButton10
        ]
        UIView.setAnimationsEnabled(false)
        selectButtons.forEach { button in
            button.titleLabel?.numberOfLines = 0
            button.titleLabel?.textAlignment = .center
            button.layoutIfNeeded()
        }
        UIView.setAnimationsEnabled(true)
        // Do any additional setup after loading the view.
    }

    @IBAction func selectButtons(_ sender: Any) {
        switch (sender as AnyObject).tag {
            
        case 1:
            print("1")
        case 2:
            print("2")
        case 3:
            print("3")
        case 4:
            print("4")
        case 5:
            print("5")
        case 6:
            print("6")
        case 7:
            print("7")
        case 8:
            print("8")
        case 9:
            print("9")
        case 10:
            print("10")
        default:
            return
        }
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

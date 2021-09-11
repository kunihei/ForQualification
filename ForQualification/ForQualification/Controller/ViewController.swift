//
//  ViewController.swift
//  ForQualification
//
//  Created by 祥平 on 2021/09/05.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func loginButton(_ sender: Any) {
        let menuVC = MenuProblem()
        navigationController?.pushViewController(menuVC, animated: true)
    }
    
}


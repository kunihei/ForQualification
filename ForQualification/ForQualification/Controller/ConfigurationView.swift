//
//  ConfigurationView.swift
//  ForQualification
//
//  Created by 祥平 on 2021/10/30.
//

import UIKit

class ConfigurationView: UIViewController {

    @IBOutlet weak var darkSwitch: UISwitch!
    @IBOutlet weak var darkModeLabel: UILabel!
    @IBOutlet weak var configurationLabel: UILabel!
    
    private let userDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = false
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        darkSwitch.isOn = userDefaults.bool(forKey: "On")
        if userDefaults.bool(forKey: "colorFlag") == true { darkMode() }
        else { rightMode() }
    }
    
    @IBAction func darkModeSwitch(_ sender: UISwitch) {
        if sender.isOn {
            userDefaults.set(true, forKey: "colorFlag")
            darkMode()
        } else {
            userDefaults.set(false, forKey: "colorFlag")
            rightMode()
        }
        
        userDefaults.set(sender.isOn, forKey: "On")
    }
    
    func darkMode() {
        view.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.241, alpha: 1.0)
        
        darkModeLabel.textColor = UIColor.white
        configurationLabel.textColor = UIColor.white
    }
    
    func rightMode() {
        view.backgroundColor = UIColor.white
        
        darkModeLabel.textColor = UIColor.black
        configurationLabel.textColor = UIColor.black
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

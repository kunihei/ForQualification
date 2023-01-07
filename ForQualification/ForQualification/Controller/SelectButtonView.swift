//
//  SelectButtonView.swift
//  ForQualification
//
//  Created by 祥平 on 2022/08/14.
//

import UIKit

class SelectButtonView: UIViewController {

    
    @IBOutlet weak var tableView: UITableView!
    
    private let getSelectList = ChallengeProblemModel.shard
    weak var delegate: SelectedButtonTextDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "SelectButtonsCell", bundle: nil), forCellReuseIdentifier: "SelectButtonCell")
        // Do any additional setup after loading the view.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        delegate = nil
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

extension SelectButtonView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getSelectList.problemSelectEmptyDelete.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectButtonCell", for: indexPath) as! SelectButtonsCell
        cell.selectionStyle = .none
        cell.selectTitleLabel.text = getSelectList.problemSelectEmptyDelete[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.setButtonText(text: getSelectList.problemSelectEmptyDelete[indexPath.row])
        dismiss(animated: true)
        print(indexPath.row)
    }
    
}


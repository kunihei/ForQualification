//
//  UIViewController.swift
//  ForQualification
//
//  Created by 祥平 on 2023/11/05.
//

import UIKit
protocol AddCancelActionDelegate: AnyObject {
    func tap()
}
extension UIViewController {
    private struct tapActionDelegate {
            static var delegate: AddCancelActionDelegate? = nil
        }
    weak var addCancelDelegate: AddCancelActionDelegate? {
        get {
            guard let delegate = objc_getAssociatedObject(self, &tapActionDelegate.delegate) as? AddCancelActionDelegate else {
                return nil
            }
            return delegate
        }
        set {
            objc_setAssociatedObject(self, &tapActionDelegate.delegate, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    /// iOS標準のダイアログを表示させたい場合に使用
    /// (呼び出し方: 呼び出したい箇所で[self.showAlert(title: "文字指定", message: "文字指定", actions: [ボタンを指定])])
    func showAlert(title: String, message: String, actions: [UIAlertAction]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        actions.forEach { alert.addAction($0) }
        present(alert, animated: true)
    }
    
    /// インジケータ表示(呼び出し方: 呼び出したい画面で[startIndicator(hideCancelButnFlg: false)])
    func startIndicator(hideCancelButnFlg: Bool = true) {
        let loadingIndicator = UIActivityIndicatorView(style: .large)
        loadingIndicator.color = .red
        
        loadingIndicator.center = self.view.center
        let grayOutView = UIView(frame: self.view.frame)
        grayOutView.backgroundColor = .black.withAlphaComponent(0.4)
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 250, height: 50))
        button.setTitle("キャンセル", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(tapAction), for: .touchUpInside)
        button.isHidden = hideCancelButnFlg
        
        // 他のViewと被らない値を代入
        grayOutView.tag = 999
        
        grayOutView.addSubview(loadingIndicator)
        grayOutView.addSubview(button)
        self.view.addSubview(grayOutView)
        self.view.bringSubviewToFront(grayOutView)
        button.topAnchor.constraint(
            equalTo:  loadingIndicator.bottomAnchor,
            constant: 10
        ).isActive = true
        button.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        loadingIndicator.startAnimating()
    }
    
    /// インジケータのキャンセルボタンがタップされた時のアクション
    @objc func tapAction() {
        DispatchQueue.main.async {
            self.dismissIndicator()
        }
        addCancelDelegate?.tap()
    }
    
    /// インジケータ非表示
    func dismissIndicator() {
        self.view.subviews.first(where: { $0.tag == 999 })?.removeFromSuperview()
    }
    
    /// 画面遷移のみ行う時に使用する(遷移先に値を渡す場合は使用できない)
    /// - Parameters:
    ///   - storyboardName: ストーリーボードの名前を指定
    func moveView(storyboardName: String) {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: storyboardName)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}


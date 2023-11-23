//
//  KeyboardDetector.swift
//  ForQualification
//
//  Created by 祥平 on 2023/11/16.
//

import UIKit

// キーボードがTextFieldやTextViewが被った時にそのパーツを上に上げる処理
fileprivate var keyboardDetectorShowKey: UInt8 = 0
fileprivate var keyboardDetectorHideKey: UInt8 = 0

protocol KeyboardDetector {
    var tableView: UITableView! { get }
}

extension KeyboardDetector where Self: UIViewController {
    
    /// キーボードに被らせたくない画面のコントローラー箇所でこのメソッドを呼ぶ
    /// (その際にスクロールビューは必要&KeyboardDetectorを継承しviewWillAppearで呼び出す)
    func startObservingKeyboardChanges() {
        let observerShow = NotificationObserver { [weak self] notification in
            self?.onKeyboardWillShow(notification)
        }
        NotificationCenter.default.addObserver(
            observerShow,
            selector: #selector(NotificationObserver.invoke(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
        objc_setAssociatedObject(
            self,
            &keyboardDetectorShowKey,
            observerShow,
            .OBJC_ASSOCIATION_RETAIN)
        let observerHide = NotificationObserver { [weak self] _ in
            self?.onKeyboardWillHide()
        }
        NotificationCenter.default.addObserver(
            observerHide,
            selector: #selector(NotificationObserver.invoke(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
        objc_setAssociatedObject(
            self,
            &keyboardDetectorHideKey,
            observerHide,
            .OBJC_ASSOCIATION_RETAIN)
    }
    
    // 使用が終わったらメモリを圧迫しないために解放するためのメソッド(viewWillDisappearでこれを呼び出す)
    func stopObservingKeyboardChanges() {
        if let observerShow = objc_getAssociatedObject(
            self, &keyboardDetectorShowKey) as? NotificationObserver {
            NotificationCenter.default.removeObserver(
                observerShow, name: UIResponder.keyboardWillShowNotification, object: nil)
        }
        if let observerHide = objc_getAssociatedObject(
            self, &keyboardDetectorHideKey) as? NotificationObserver {
            NotificationCenter.default.removeObserver(
                observerHide, name: UIResponder.keyboardWillHideNotification, object: nil)
        }
    }
    
    // キーボードが開いたことを検知しパーツを上に上げる
    private func onKeyboardWillShow(_ notification: Notification) {
        guard
            let userInfo = notification.userInfo,
            let keyboardInfo = UIKeyboardInfo(info: userInfo),
            let inputView = view.findFirstResponder()
            else { return }
        let inputRect = inputView.convert(inputView.bounds, to: tableView)
        let keyboardRect = tableView.convert(keyboardInfo.frame, from: nil)
        let offsetY = inputRect.maxY - keyboardRect.minY
        if offsetY > 0 {
            let contentOffset = CGPoint(x: tableView.contentOffset.x,
                                        y: tableView.contentOffset.y + offsetY)
            tableView.contentOffset = contentOffset
        }
        let contentInset = UIEdgeInsets(top: 0,
                                        left: 0,
                                        bottom: keyboardInfo.frame.height - view.safeAreaInsets.bottom,
                                        right: 0)
        tableView.contentInset = contentInset
        tableView.scrollIndicatorInsets = contentInset
    }
    
    // キーボードが閉じたことを検知し元の位置に戻す
    private func onKeyboardWillHide() {
        tableView.contentInset = .zero
        tableView.scrollIndicatorInsets = .zero
    }
}



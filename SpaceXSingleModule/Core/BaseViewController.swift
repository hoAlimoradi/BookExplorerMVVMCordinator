//
//  BaseViewController.swift
//  SpaceXSingleModule
//
//  Created by ho on 4/8/1403 AP.
//
import Foundation
import UIKit
import Combine

class BaseViewController: UIViewController  {

    private var cancellablesBag = Set<AnyCancellable>()
    private var alertController: UIAlertController? = nil
    
    // MARK: - Initial
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - UI Configuration
    open func configureSubViews() {
        fatalError("override and impelement \(#function)")
    }
    
    open func configureConstraints() {
        fatalError("override and impelement \(#function)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad() 
        view.backgroundColor = ThemeManager.shared.getCurrentThemeColors().white1
 
        configureSubViews()
        configureConstraints()
        registerForKeyboardNotifications() 
    }
    
    //MARK: registerForKeyboardNotifications
    private func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            keyboardWillAppear(keyboardSize: keyboardSize)
        }
    }
    
    @objc private func keyboardWillHide(notification: Notification) {
        keyboardWillDisappear()
    }
    
    func keyboardWillAppear(keyboardSize: CGRect) {
        // Can be overridden by subclasses
    }
    
    func keyboardWillDisappear() {
        // Can be overridden by subclasses
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}
public typealias TableViewDelegateDataSource = UITableViewDelegate & UITableViewDataSource

//
//  BaseViewController.swift
//  SpaceXSingleModule
//
//  Created by ho on 4/8/1403 AP.
//
import Foundation
import UIKit
import Combine
 
//MARK: deprecated
class BaseViewController: UIViewController {

    private var cancellablesBag = Set<AnyCancellable>()
    private var alertController: UIAlertController? = nil
    internal var lifecycleObserverSubject = PassthroughSubject<LifecycleEvent, Never>()
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
        lifecycleObserverSubject.send(.didLoadView)
        observeLifecycleEvents()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        lifecycleObserverSubject.send(.willAppearView)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        lifecycleObserverSubject.send(.didAppearView)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        lifecycleObserverSubject.send(.willDisappearView)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        lifecycleObserverSubject.send(.didDisappearView)
    }

    private func observeLifecycleEvents() {
        NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.lifecycleObserverSubject.send(.didBecomeActiveView)
            }.store(in: &cancellablesBag)

        NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.lifecycleObserverSubject.send(.willResignActiveView)
            }.store(in: &cancellablesBag)

        NotificationCenter.default.publisher(for: UIApplication.didEnterBackgroundNotification)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.lifecycleObserverSubject.send(.didEnterBackgroundView)
            }.store(in: &cancellablesBag)

        NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.lifecycleObserverSubject.send(.willEnterForegroundView)
            }.store(in: &cancellablesBag)

        NotificationCenter.default.publisher(for: UIApplication.didReceiveMemoryWarningNotification)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.lifecycleObserverSubject.send(.didReceiveMemoryWarning)
            }.store(in: &cancellablesBag)

        NotificationCenter.default.publisher(for: UIApplication.willTerminateNotification)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.lifecycleObserverSubject.send(.willTerminateApplication)
            }.store(in: &cancellablesBag)
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
 
/*
 class <ViewModel: >: UIViewController {

     private var cancellablesBag = Set<AnyCancellable>()
     private var alertController: UIAlertController?
     private let lifecycleObserver: LifecycleObserver<BaseViewModelProtocol>

     // MARK: - Initializers
     init(viewModel: ViewModel, nibName nibNameOrNil: String? = nil, bundle nibBundleOrNil: Bundle? = nil) {
         self.viewModel = viewModel
         self.lifecycleObserver = LifecycleObserver(viewModel: viewModel)
         super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

         // Trigger the initial lifecycle event (view did load)
         //self.viewModel.handleLifecycleEvent(.didLoadView)
         
         // Setup the lifecycle observer to watch for changes in the view controller's lifecycle
         lifecycleObserver.observe(viewController: self)
     }

     required init?(coder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }

     // MARK: - Lifecycle Methods
     override func viewDidLoad() {
         super.viewDidLoad()
         view.backgroundColor = ThemeManager.shared.getCurrentThemeColors().white1
         
         configureSubViews()
         configureConstraints()
         //registerForKeyboardNotifications()

         // Trigger lifecycle event for view did load
         viewModel.handleLifecycleEvent(.didLoadView)
     }

     override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)
         // Trigger lifecycle event for view will appear
         viewModel.handleLifecycleEvent(.willAppearView)
     }

     override func viewDidAppear(_ animated: Bool) {
         super.viewDidAppear(animated)
         // Trigger lifecycle event for view did appear
         viewModel.handleLifecycleEvent(.didAppearView)
     }

     override func viewWillDisappear(_ animated: Bool) {
         super.viewWillDisappear(animated)
         // Trigger lifecycle event for view will disappear
         viewModel.handleLifecycleEvent(.willDisappearView)
     }

     override func viewDidDisappear(_ animated: Bool) {
         super.viewDidDisappear(animated)
         // Trigger lifecycle event for view did disappear
         viewModel.handleLifecycleEvent(.didDisappearView)
     }

     // MARK: - UI Configuration
     open func configureSubViews() {
         fatalError("override and implement \(#function)")
     }

     open func configureConstraints() {
         fatalError("override and implement \(#function)")
     }
  
 }
 */

// MARK: - Initializers
/*
 
 
 class ViewControllerGenerator1<ViewModel: BaseViewModel>: UIViewController {
     
     private var cancellablesBag = Set<AnyCancellable>()
     private var alertController: UIAlertController?
     private let viewModel: ViewModel
     private let lifecycleObserver: LifecycleObserver
     
  
     init(viewModel: ViewModel, nibName nibNameOrNil: String? = nil, bundle nibBundleOrNil: Bundle? = nil) {
         self.viewModel = viewModel
         self.lifecycleObserver = LifecycleObserver()
         super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
         
         // Trigger the initial lifecycle event
         self.viewModel.handleLifecycleEvent(.didLoadView)
         
         // Observe lifecycle events
         lifecycleObserver.observe(viewController: self, viewModel: viewModel)
     }
     
     required init?(coder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }
     
     // MARK: - Lifecycle Methods
     override func viewDidLoad() {
         super.viewDidLoad()
         view.backgroundColor = ThemeManager.shared.getCurrentThemeColors().white1
         
         configureSubViews()
         configureConstraints()
         registerForKeyboardNotifications()
  
         // Trigger lifecycle event
         viewModel.handleLifecycleEvent(.didLoadView)
     }
     
     override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)
         viewModel.handleLifecycleEvent(.willAppearView)
     }
     
     override func viewDidAppear(_ animated: Bool) {
         super.viewDidAppear(animated)
         viewModel.handleLifecycleEvent(.didAppearView)
     }
     
     override func viewWillDisappear(_ animated: Bool) {
         super.viewWillDisappear(animated)
         viewModel.handleLifecycleEvent(.willDisappearView)
     }
     
     override func viewDidDisappear(_ animated: Bool) {
         super.viewDidDisappear(animated)
         viewModel.handleLifecycleEvent(.didDisappearView)
     }
     
     // MARK: - UI Configuration
     open func configureSubViews() {
         fatalError("override and implement \(#function)")
     }
     
     open func configureConstraints() {
         fatalError("override and implement \(#function)")
     }
     
     // MARK: - Keyboard Handling
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
 */

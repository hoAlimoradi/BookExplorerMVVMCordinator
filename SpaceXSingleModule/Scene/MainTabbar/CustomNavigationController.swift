//
//  CustomNavigationController.swift
//  SpaceXSingleModule
//
//  Created by ho on 4/9/1403 AP.
// 
import UIKit

protocol NavigationBarCustomizable {
    var shouldHideNavigationBar: Bool { get }
    func customizeNavigationBarAppearance(_ appearance: UINavigationBarAppearance)
}

extension NavigationBarCustomizable {
    var shouldHideNavigationBar: Bool {
        return false
    }
}

class CustomNavigationController: UINavigationController,
                                  UINavigationControllerDelegate,
                                    UIGestureRecognizerDelegate {
    
    // MARK: Initialization
    var isNavigationBarTransparent: Bool = false {
        didSet {
            setupDefaultNavigationBarAppearance()
        }
    }
    
    // MARK: Initialization
    convenience init() {
        self.init()
        self.delegate = self
        setupDefaultNavigationBarAppearance()
    }
    
    init(rootViewController: UIViewController,
         hideNavigationBar: Bool = false, transparentNavigationBar: Bool = false) {
        self.isNavigationBarTransparent = transparentNavigationBar
        super.init(rootViewController: rootViewController)
        self.delegate = self
        setupDefaultNavigationBarAppearance()
        self.isNavigationBarHidden = hideNavigationBar
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.delegate = self
        setupDefaultNavigationBarAppearance()
    }
    
    // MARK: Navigation Bar Appearance Setup
    private func setupDefaultNavigationBarAppearance() {
        let appearance = UINavigationBarAppearance()
        
        if isNavigationBarTransparent {
            appearance.configureWithTransparentBackground()
            appearance.shadowColor = nil // Optional: remove shadow
            appearance.shadowImage = UIImage()
            appearance.backgroundImage = UIImage()
        } else {
            appearance.backgroundColor = ThemeManager.shared.getCurrentThemeColors().white2
        }
        
        navigationBar.standardAppearance = appearance
        if #available(iOS 13.0, *) {
            navigationBar.scrollEdgeAppearance = navigationBar.standardAppearance
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        interactivePopGestureRecognizer?.isEnabled = (viewControllers.count > 1)
    }
    
    private func applyCustomAppearance(_ viewController: UIViewController) {
        let appearance = UINavigationBarAppearance()
        
        if isNavigationBarTransparent {
            appearance.configureWithTransparentBackground()
            appearance.shadowColor = nil // Optional: remove shadow
            appearance.shadowImage = UIImage()
            appearance.backgroundImage = UIImage()
        } else {
            appearance.backgroundColor = ThemeManager.shared.getCurrentThemeColors().white2
        }
        
        if let customizableVC = viewController as? NavigationBarCustomizable {
            customizableVC.customizeNavigationBarAppearance(appearance)
            navigationBar.isHidden = customizableVC.shouldHideNavigationBar
        } else {
            navigationBar.isHidden = false
        }
        
        navigationBar.standardAppearance = appearance
        if #available(iOS 13.0, *) {
            navigationBar.scrollEdgeAppearance = appearance
        }
    }
    
    // MARK: UINavigationControllerDelegate
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        
        if viewController !== viewControllers[0] && viewController.navigationItem.leftBarButtonItem == nil {
            setupCustomBackButton(for: viewController)
        }
        
        applyCustomAppearance(viewController)
    }
    
    // MARK: Custom Back Button Setup
    private func setupCustomBackButton(for viewController: UIViewController) {
        
        let backButton = UIButton(type: .system)
        
        backButton.setImage(UIImage(named: "iconBack")?.withRenderingMode(.alwaysOriginal), for: .normal)
        backButton.addTarget(self, action: #selector(self.backButtonTapped), for: .touchUpInside)
        
        let backBarItem = UIBarButtonItem(customView: backButton)
        viewController.navigationItem.leftBarButtonItem = backBarItem
        self.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
    }
    
    @objc private func backButtonTapped() {
        popViewController(animated: true)
    }
}

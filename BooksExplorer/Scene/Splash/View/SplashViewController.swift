//
//  SplashViewController.swift
//  

import UIKit
import Foundation
import Combine

final class SplashViewController: BaseViewController  {

    // MARK: - Properties
    private enum Constants { 
        static var logo = "logo"
        static var logoWidth = CGFloat(240)
        static var logoHeight = CGFloat(120)
    }
    
    private let router: SplashRouting
    private var cancellables = Set<AnyCancellable>()
    private let viewModel: SplashViewModel
    
    private lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.isUserInteractionEnabled = false
        label.textAlignment = .center
        label.text = AppStrings.Splash.title.localized
        label.font = Fonts.H2.medium
        label.textColor = ThemeManager.shared.getCurrentThemeColors().primary1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var logoIcon: UIImageView = {
        var imageView = UIImageView(image: UIImage(named: Constants.logo) ?? UIImage())
        imageView.isUserInteractionEnabled = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var vertionLabel : UILabel = {
        let label = UILabel()
        label.isUserInteractionEnabled = false
        label.textAlignment = .center
        label.text = AppStrings.Splash.vertion.localized
        label.font = Fonts.B3.medium
        label.textColor = ThemeManager.shared.getCurrentThemeColors().primary2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    init(configuration: SplashModule.Configuration,
         viewModel: SplashViewModel,
         router: SplashRouting) {
        self.viewModel =  viewModel
        self.router = router
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }

    internal override func configureSubViews() {
        view.backgroundColor = ThemeManager.shared.getCurrentThemeColors().white1
        view.addSubview(logoIcon)
        view.addSubview(titleLabel)
        view.addSubview(vertionLabel)
    }
   
    internal override func configureConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: TopMargin.spacingMed),
            
            logoIcon.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            logoIcon.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoIcon.widthAnchor.constraint(equalToConstant: Constants.logoWidth),
            logoIcon.heightAnchor.constraint(equalToConstant: Constants.logoHeight),
            
            vertionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            vertionLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: BottomMargin.spacingMed)
        ])
        bind()
    }
 
     private func bind() {
         lifecycleObserverSubject
             .receive(on: DispatchQueue.main)
             .sink { [weak self] lifecycleObserver in
                 self?.viewModel.action(.observeLifecycle(lifecycleObserver))
             }.store(in: &cancellables)
 
        viewModel.route
            .receive(on: DispatchQueue.main)
            .sink { [weak self] routeAction in
                guard let self else { return }
                switch routeAction {
                case .navigateToMainTab:
                    self.router.navigateToMainTab()
                case .idleRoute:
                    break
                }
            }.store(in: &cancellables)
    }
}
 

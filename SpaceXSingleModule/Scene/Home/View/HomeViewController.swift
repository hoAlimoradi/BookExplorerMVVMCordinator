//
//  HomeViewController.swift
//  SpaceXSingleModule
//
//  Created by ho on 4/9/1403 AP.
//
 
import UIKit
import Combine 

final class HomeViewController: BaseViewController {
    
    // MARK: - Properties
    private enum Constants {
        static let delay = 0.5
        static var logo = "logo"
        
        static var logoWidth = CGFloat(144)
        static var logoHeight = CGFloat(44)
    }
    
    private let router: HomeRouting
    private var cancellables = Set<AnyCancellable>()
    private let viewModel: HomeViewModel
    
    private lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.isUserInteractionEnabled = false
        label.textAlignment = .center
        label.text = AppStrings.Home.title.localized
        label.font = Fonts.B3.medium
        label.textColor = ThemeManager.shared.getCurrentThemeColors().grey1
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
        label.text = AppStrings.Home.title.localized
        label.font = Fonts.B1.medium
        label.textColor = ThemeManager.shared.getCurrentThemeColors().grey1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    init(configuration: HomeModule.Configuration,
         viewModel: HomeViewModel,
         router: HomeRouting) {
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
            titleLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: TopMargin.spacingSm),
            
            logoIcon.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            logoIcon.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoIcon.widthAnchor.constraint(equalToConstant: Constants.logoWidth),
            logoIcon.heightAnchor.constraint(equalToConstant: Constants.logoHeight),
            
            vertionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            vertionLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: BottomMargin.spacingMed)
        ])
        navigateToMainTab()
        bind()
    }
    
    
    fileprivate func navigateToMainTab() {
        DispatchQueue.main.asyncAfter(deadline: .now() + Constants.delay) {[weak self] in
            guard let self = self else {return}
            self.viewModel.action(.navigateToMainTab)
        }
    }
     
    private func bind() {
        viewModel.route
            .receive(on: DispatchQueue.main)
            .sink { [weak self] routeAction in
                guard let self else { return }
                switch routeAction {
                case .navigateToMainTab:
                    self.router.navigateToDetials()
                case .idleRoute:
                    break
                }
            }.store(in: &cancellables)
    }
}


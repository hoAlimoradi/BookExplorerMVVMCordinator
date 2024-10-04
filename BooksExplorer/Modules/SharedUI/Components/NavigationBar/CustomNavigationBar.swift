//
//  CustomNavigationBar.swift
//  
 
import Foundation
import UIKit

open class CustomNavigationBar: UINavigationBar {
    
    enum Contants {
        static var titleHuggingPriority: Float = 501
        static var titleCompressionResistancePriority: Float = 748
        static var spacerHuggingPriority: Float = 248
        static var spacerCompressionResistancePriority: Float = 740
        static var titleIconWidth = 18
        static var titleIconHeight = 18
        static var barButtonSize = 60
        static var barButtonMargin = 8
        static var barButtonToViewMargin = 16
        static var titleViewDefaultHeight: CGFloat = 40
        static var titleViewSpacing: CGFloat = 8
        static var iconArrowLeft = "iconArrowLeft"
    }
    
    var titleView: UIView?
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setDefaultStyle()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setDefaultStyle()
    }
    
    open func setDefaultStyle() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = ThemeManager.shared.getCurrentThemeColors().white2
        appearance.shadowColor = .clear
        appearance.titleTextAttributes = [.foregroundColor: ThemeManager.shared.getCurrentThemeColors().black2]
        standardAppearance = appearance
        scrollEdgeAppearance = appearance
        self.tintColor = ThemeManager.shared.getCurrentThemeColors().primary1
        barTintColor = ThemeManager.shared.getCurrentThemeColors().primary1
    }
    
    // Add a custom height constant
    static var customHeight: CGFloat = 60  // Example custom height
    
    // Override sizeThatFits to increase height of navigation bar
    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        let originalSize = super.sizeThatFits(size)
        return CGSize(width: originalSize.width, height: CustomNavigationBar.customHeight)
    }
    
}

extension UIViewController {
    
    var leftButtonsSpace: Int {
        let leftButtons = navigationItem.leftBarButtonItems?.count ?? 0
        return leftButtons * CustomNavigationBar.Contants.barButtonSize + (leftButtons * CustomNavigationBar.Contants.barButtonMargin) + CustomNavigationBar.Contants.barButtonToViewMargin
    }
    
    var rightButtonsSpace: Int {
        let rightButtons = navigationItem.rightBarButtonItems?.count ?? 0
        return rightButtons * CustomNavigationBar.Contants.barButtonSize + (rightButtons * CustomNavigationBar.Contants.barButtonMargin) + CustomNavigationBar.Contants.barButtonToViewMargin
    }
    
    public func getNavigationBar() -> CustomNavigationBar? {
        return navigationController?.navigationBar as? CustomNavigationBar
    }
    
    public func setNavigationLeftTitle(_ title: String, icon: UIImage? = nil, font: UIFont? = nil) {
        getNavigationBar()?.titleView?.removeFromSuperview()
        getNavigationBar()?.titleView = makeTitleView(title: title, icon: icon, font: font ?? Fonts.B1.medium)
        getNavigationBar()?.addSubview(getNavigationBar()?.titleView ?? UIView())
    }
    public func setNavigationLeftTitlesWithTouchCallBack(_ title: String,
                                                         icon: UIImage? = nil,
                                                         font: UIFont? = nil,
                                                         touched: (() -> Void)? = nil) {
        getNavigationBar()?.titleView?.removeFromSuperview()
        getNavigationBar()?.titleView = makeTitleView(title: title,
                                                      icon: icon,
                                                      font: font ?? Fonts.B1.medium,
                                                      touched: touched)
        getNavigationBar()?.addSubview(getNavigationBar()?.titleView ?? UIView())
    }
    public func setNavigationLeftTitles(_ titles: [(String, UIFont?)], icon: UIImage? = nil) {
        getNavigationBar()?.titleView?.removeFromSuperview()
        getNavigationBar()?.titleView = makeTitleView(titles: titles, icon: icon)
        getNavigationBar()?.addSubview(getNavigationBar()?.titleView ?? UIView())
    }
    public func setNavigationLeftTitleWithBack(_ title: String, backButtonImage: UIImage? = UIImage(named: "iconArrowLeft"), titleIcon: UIImage? = nil, font: UIFont? = nil) {
        let button = UIButton(frame: CGRect(x: 0, y: 0,
                                            width: CustomNavigationBar.Contants.barButtonSize,
                                            height: CustomNavigationBar.Contants.barButtonSize))
        button.setImage(backButtonImage, for: .normal)
        button.imageView?.tintColor = getNavigationBar()?.tintColor
        button.addTarget(self, action: #selector(back), for: .touchUpInside)
        let backButton = UIBarButtonItem(customView: button)
        navigationItem.setLeftBarButton(backButton, animated: true)
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
        setNavigationLeftTitle(title, icon: titleIcon, font: font ?? Fonts.B1.medium)
    }
    
    private func makeTitleView(title: String,
                               icon: UIImage? = nil,
                               font: UIFont,
                               touched: (() -> Void)? = nil) -> UIView {
        return makeTitleView(titles: [(title, font)],
                             icon: icon,
                             touched: touched)
    }
    
    private func makeTitleView(titles: [(String, UIFont?)],
                               icon: UIImage? = nil,
                               touched: (() -> Void)? = nil) -> UIView {
        var titleLabels = [UILabel]()
        for (title, font) in titles {
            let titleLabel = UILabel(frame: CGRect.zero)
            titleLabel.font = font ?? Fonts.B1.medium
            titleLabel.textColor = getNavigationBar()?.tintColor
            titleLabel.text = title
            titleLabel.setContentHuggingPriority(UILayoutPriority(CustomNavigationBar.Contants.titleHuggingPriority), for: .horizontal)
            titleLabel.setContentCompressionResistancePriority(UILayoutPriority(CustomNavigationBar.Contants.titleCompressionResistancePriority), for: .horizontal)
            titleLabel.setOnTapped { [touched] in
                touched?()
            }
            
            titleLabels.append(titleLabel)
        }
        // ... existing code for titleLabels setup ...
        
        let iconView = UIImageView(image: icon)
        iconView.contentMode = .scaleAspectFit
        iconView.widthAnchor.constraint(equalToConstant: CGFloat(CustomNavigationBar.Contants.titleIconWidth)).isActive = true
        iconView.heightAnchor.constraint(equalToConstant: CGFloat(CustomNavigationBar.Contants.titleIconHeight)).isActive = true
        
        // Use a container view for the icon to apply top margin
        let iconContainer = UIView()
        iconContainer.addSubview(iconView)
        iconView.translatesAutoresizingMaskIntoConstraints = false
        iconView.topAnchor.constraint(equalTo: iconContainer.topAnchor, constant: 10).isActive = true // Top margin for icon
        iconView.centerXAnchor.constraint(equalTo: iconContainer.centerXAnchor).isActive = true
        
        // Use a container view for the title labels to apply bottom margin
        let labelsContainer = UIView()
        let labelsStack = UIStackView(arrangedSubviews: titleLabels)
        labelsStack.axis = .vertical
        labelsStack.spacing = 4 // Spacing between labels if you have multiple
        labelsContainer.addSubview(labelsStack)
        labelsStack.translatesAutoresizingMaskIntoConstraints = false
        labelsStack.topAnchor.constraint(equalTo: labelsContainer.topAnchor).isActive = true
        labelsStack.bottomAnchor.constraint(equalTo: labelsContainer.bottomAnchor, constant: -10).isActive = true // Bottom margin for text
        labelsStack.leadingAnchor.constraint(equalTo: labelsContainer.leadingAnchor).isActive = true
        labelsStack.trailingAnchor.constraint(equalTo: labelsContainer.trailingAnchor).isActive = true
        
        // Main stack view setup
        let mainStack = UIStackView(arrangedSubviews: [iconContainer, labelsContainer])
        mainStack.axis = .vertical
        mainStack.alignment = .center
        mainStack.distribution = .equalSpacing
        mainStack.spacing = 8 // Spacing between icon and labels container
        
        // Since we are using autolayout constraints, we do not set the frame directly
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        
        // Assuming the 'leftButtonsSpace' and 'rightButtonsSpace' calculations are done elsewhere and are correct
        NSLayoutConstraint.activate([
            iconView.bottomAnchor.constraint(equalTo: mainStack.topAnchor, constant: 10), // This applies top margin to icon view
            labelsStack.bottomAnchor.constraint(equalTo: mainStack.bottomAnchor, constant: -10) // This applies bottom margin to labels
        ])
        
        // Now, 'mainStack' can be added to the navigation bar and constraints can be applied based on the desired layout
        return mainStack
    }
    
    public func removeTitleView() {
        getNavigationBar()?.titleView?.removeFromSuperview()
    }
    
    public func addTitleView() {
        getNavigationBar()?.addSubview(getNavigationBar()?.titleView ?? UIView())
    }
    
    @objc func back() {
        navigationController?.popViewController(animated: true)
    }
}


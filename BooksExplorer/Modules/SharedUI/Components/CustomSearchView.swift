//
//  CustomSearchView.swift
 
import UIKit
import Combine

class CustomSearchView: UIView {
    
    private enum Constants {
        static var icSearchIcon = "ic_search_gray"
        static var icCancelIcon = "ic_close_gray"

        static var topTagIconWidth = CGFloat(24)
        static var topTagIconHeight = CGFloat(24)
        static var topTagIconLeadingMargin = CGFloat(4)

        static var borderWidth = CGFloat(1)
        static var cornerRadius = CGFloat(12)
        
        static var topMargin = CGFloat(8)
        static var leadingMargin = CGFloat(16)
        static var trailinMargin = CGFloat(-16)
        static var bottomMargin = CGFloat(-8)

        static var parentHeightSize = CGFloat(50)
        static var parentTopMargin = CGFloat(4)
    }
    private lazy var parentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = ThemeManager.shared.getCurrentThemeColors().white2
        view.layer.borderColor = ThemeManager.shared.getCurrentThemeColors().grey1.cgColor
        view.layer.borderWidth = Constants.borderWidth
        view.layer.cornerRadius = Constants.cornerRadius
        return view
    }()

    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.attributedPlaceholder = NSAttributedString(string: "Search", attributes: [NSAttributedString.Key.foregroundColor: ThemeManager.shared.getCurrentThemeColors().grey1])
        textField.textColor = ThemeManager.shared.getCurrentThemeColors().black2
        textField.font = Fonts.B2.regular
        textField.backgroundColor = ThemeManager.shared.getCurrentThemeColors().white2
        textField.borderStyle = .none
        textField.leftView = searchIcon
        textField.leftViewMode = .always
        //textField.rightView = cancelIcon
        //textField.rightViewMode = .whileEditing
        textField.clearButtonMode = .never
        // Disable spell suggestion and autocorrection
        textField.autocorrectionType = .no
           
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        return textField
    }()
    
    private lazy var searchIcon: UIImageView = {
        let image = UIImage(named: Constants.icSearchIcon)
        let searchIcon = UIImageView(image: image)
        searchIcon.contentMode = .scaleAspectFit
        searchIcon.translatesAutoresizingMaskIntoConstraints = false
        return searchIcon
    }()
    private lazy var cancelIcon: UIImageView = {
        let image = UIImage(named: Constants.icCancelIcon)
        let cancelIcon = UIImageView(image: image)
        cancelIcon.contentMode = .scaleAspectFit
        cancelIcon.translatesAutoresizingMaskIntoConstraints = false
        return cancelIcon
    }()
    private lazy var cancelButton: UIButton = {
        let cancelButton = UIButton()
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        //cancelButton.backgroundColor = .red
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        return cancelButton
    }()
    
    let textSubject = PassthroughSubject<String?, Never>()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        // Add text field to view
        addSubview(parentView)
        parentView.addSubview(textField)
        parentView.addSubview(cancelIcon)
        parentView.addSubview(cancelButton)
        
        cancelIcon.isHidden = true
        cancelButton.isHidden = true
        // Set up constraints
        NSLayoutConstraint.activate([
            parentView.topAnchor.constraint(equalTo: topAnchor),
            parentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            parentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            parentView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            textField.topAnchor.constraint(equalTo: parentView.topAnchor, constant: Constants.topMargin),
            textField.leadingAnchor.constraint(equalTo: parentView.leadingAnchor, constant: Constants.leadingMargin),
            textField.trailingAnchor.constraint(equalTo: parentView.trailingAnchor, constant: Constants.trailinMargin),
            textField.bottomAnchor.constraint(equalTo: parentView.bottomAnchor, constant: Constants.bottomMargin),

            searchIcon.widthAnchor.constraint(equalToConstant: 20),

            cancelIcon.heightAnchor.constraint(equalToConstant: 20),
            cancelIcon.widthAnchor.constraint(equalToConstant: 20),
            cancelIcon.centerYAnchor.constraint(equalTo: parentView.centerYAnchor),
            cancelIcon.trailingAnchor.constraint(equalTo: parentView.trailingAnchor,
                                                 constant: TrailingMargin.spacingXs),

            cancelButton.topAnchor.constraint(equalTo: parentView.topAnchor),
            cancelButton.trailingAnchor.constraint(equalTo: parentView.trailingAnchor),
            cancelButton.bottomAnchor.constraint(equalTo: parentView.bottomAnchor),
            cancelButton.widthAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    @objc private func cancelButtonTapped() {
        textField.text?.removeAll()
        textSubject.send(nil)
        cancelIcon.isHidden = true
        cancelButton.isHidden = true
    }
    
    @objc private func textFieldDidChange() {
        if let text = textField.text {
            textSubject.send(text)
            if text.isEmpty {
                cancelIcon.isHidden = true
                cancelButton.isHidden = true
            } else {
                cancelIcon.isHidden = false
                cancelButton.isHidden = false
            }
            //textField.leftViewMode = text.isEmpty ? .never : .always
        } else {
            // Hide searchIcon if text is nil
            //textField.leftViewMode = .never
            cancelIcon.isHidden = true
            cancelButton.isHidden = true
        }
    }
    public func clearSearchBar() {
        textField.text?.removeAll()
    }
}



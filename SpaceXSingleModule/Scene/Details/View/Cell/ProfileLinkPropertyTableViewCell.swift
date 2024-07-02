//
//  ProfileLinkPropertyTableViewCell.swift
//  SpaceXSingleModule
//
//  Created by ho on 4/11/1403 AP.
//
import Foundation
import UIKit
import Combine

class ProfileLinkPropertyTableViewCell: UITableViewCell {
    
    static let identifier = "ProfileLinkPropertyTableViewCell"
    
    private enum Constants {
        static var borderWidth = CGFloat(1)
    }

    private var cancelBag = Set<AnyCancellable>()
    
    public var urlString: String?
    
    public var selectionButtonPressedSubject = PassthroughSubject<String?, Never>()
    
    private lazy var parentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = ThemeManager.shared.getCurrentThemeColors().white1
        return view
    }()
 
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.isUserInteractionEnabled = false
        label.numberOfLines = 0
        label.textAlignment = .left
        label.autoresize()
        label.font = Fonts.B1.medium
        label.textColor = ThemeManager.shared.getCurrentThemeColors().black2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
 
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.isUserInteractionEnabled = false
        label.numberOfLines = 1
        label.textAlignment = .left
        label.autoresize()
        label.font = Fonts.C1Caps.regular
        label.textColor = ThemeManager.shared.getCurrentThemeColors().grey1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private lazy var selectionButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(self.selectionButtonPressed), for: .touchUpInside)
        button.backgroundColor = .clear
        return button
    }()
   
    
    @objc private func selectionButtonPressed() {
        selectionButtonPressedSubject.send(urlString)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        backgroundColor =  ThemeManager.shared.getCurrentThemeColors().white1
 
        contentView.addSubview(parentView)
        parentView.addSubview(titleLabel)
        parentView.addSubview(descriptionLabel)
        parentView.addSubview(selectionButton)
 
        NSLayoutConstraint.activate([
            parentView.topAnchor.constraint(equalTo: contentView.topAnchor),
            parentView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            parentView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            parentView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: parentView.topAnchor, constant: TopMargin.spacingXs),
            titleLabel.leadingAnchor.constraint(equalTo: parentView.leadingAnchor, constant: LeadingMargin.spacingLg),
            titleLabel.trailingAnchor.constraint(equalTo: parentView.trailingAnchor, constant: TrailingMargin.spacingLg),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: TopMargin.spacingXs),
            descriptionLabel.leadingAnchor.constraint(equalTo: parentView.leadingAnchor, constant: LeadingMargin.spacingLg),
            descriptionLabel.trailingAnchor.constraint(equalTo: parentView.trailingAnchor, constant: TrailingMargin.spacingLg),
            descriptionLabel.bottomAnchor.constraint(equalTo: parentView.bottomAnchor, constant: BottomMargin.spacingXxs),
            
            selectionButton.topAnchor.constraint(equalTo: parentView.topAnchor),
            selectionButton.leadingAnchor.constraint(equalTo: parentView.leadingAnchor),
            selectionButton.trailingAnchor.constraint(equalTo: parentView.trailingAnchor),
            selectionButton.bottomAnchor.constraint(equalTo: parentView.bottomAnchor),
        ])
    }
 
    override func prepareForReuse() {
        titleLabel.text = ""
        descriptionLabel.text = ""
    }
 
    func config(title: String?, description: String?) {
        guard let title = title, let description = description else {
            parentView.isHidden = true
            return
        }
        parentView.isHidden = false
        urlString = description
        titleLabel.text = title
        descriptionLabel.text = description
    }
}
 

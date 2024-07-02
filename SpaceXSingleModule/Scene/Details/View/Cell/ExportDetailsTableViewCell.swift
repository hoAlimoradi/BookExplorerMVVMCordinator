//
//  ExportDetailsTableViewCell.swift
//  SpaceXSingleModule
//
//  Created by ho on 4/11/1403 AP.
//
import Foundation
import UIKit
import Combine

class ExportDetailsTableViewCell: UITableViewCell {
    
    static let identifier = "ExportDetailsTableViewCell"
    
    private enum Constants {
        static var borderWidth = CGFloat(1)
    }
 
    private var cancelBag = Set<AnyCancellable>()
    private var launchKeyValueItemModel: LaunchKeyValueItemModel? = nil
    public var selectionButtonPressedSubject = PassthroughSubject<LaunchKeyValueItemModel?, Never>()
    private lazy var contentParentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
 
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
        label.text = "Export"
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
        label.text = "Get all information as a key value"
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
        selectionButtonPressedSubject.send(launchKeyValueItemModel)
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
 
        contentView.addSubview(contentParentView)
        contentParentView.addSubview(parentView)
        
        parentView.addSubview(titleLabel)
        parentView.addSubview(descriptionLabel)
        parentView.addSubview(selectionButton)
 
        NSLayoutConstraint.activate([
            contentParentView.topAnchor.constraint(equalTo: contentView.topAnchor),
            contentParentView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            contentParentView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            contentParentView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            parentView.topAnchor.constraint(equalTo: contentParentView.topAnchor, constant: TopMargin.spacingXxs),
            parentView.leadingAnchor.constraint(equalTo: contentParentView.leadingAnchor),
            parentView.trailingAnchor.constraint(equalTo: contentParentView.trailingAnchor),
            parentView.bottomAnchor.constraint(equalTo: contentParentView.bottomAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: parentView.topAnchor, constant: TopMargin.spacingXs),
            titleLabel.leadingAnchor.constraint(equalTo: parentView.leadingAnchor, constant: LeadingMargin.spacingLg),
            titleLabel.trailingAnchor.constraint(equalTo: parentView.trailingAnchor, constant: TrailingMargin.spacingLg),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: TopMargin.spacingXxs),
            descriptionLabel.leadingAnchor.constraint(equalTo: parentView.leadingAnchor, constant: LeadingMargin.spacingLg),
            descriptionLabel.trailingAnchor.constraint(equalTo: parentView.trailingAnchor, constant: TrailingMargin.spacingLg),
            descriptionLabel.bottomAnchor.constraint(equalTo: parentView.bottomAnchor, constant: BottomMargin.spacingXxs),
            selectionButton.topAnchor.constraint(equalTo: parentView.topAnchor),
            selectionButton.leadingAnchor.constraint(equalTo: parentView.leadingAnchor),
            selectionButton.trailingAnchor.constraint(equalTo: parentView.trailingAnchor),
            selectionButton.bottomAnchor.constraint(equalTo: parentView.bottomAnchor),
        ])
    } 
}


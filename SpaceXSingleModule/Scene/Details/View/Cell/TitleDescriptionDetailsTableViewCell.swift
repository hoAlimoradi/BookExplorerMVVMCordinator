//
//  TitleDescriptionDetailsTableViewCell.swift
//  SpaceXSingleModule
//
//  Created by ho on 4/10/1403 AP.
//
import Foundation
import UIKit
import Combine

class TitleDescriptionDetailsTableViewCell: UITableViewCell {
    
    static let identifier = "TitleDescriptionDetailsTableViewCell"
    
    private enum Constants {
        static var borderWidth = CGFloat(1)
    }

    private var cancelBag = Set<AnyCancellable>()
    
    private lazy var contentParentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = ThemeManager.shared.getCurrentThemeColors().white1
        return view
    }()
    
    private lazy var parentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = ThemeManager.shared.getCurrentThemeColors().yellow3
        view.layer.borderColor = ThemeManager.shared.getCurrentThemeColors().yellow1.cgColor
        view.layer.borderWidth = Constants.borderWidth
        view.layer.cornerRadius = RoundedCornerDimens.radius3
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
        label.numberOfLines = 0
        label.textAlignment = .left
        label.autoresize()
        label.font = Fonts.B2.regular
        label.textColor = ThemeManager.shared.getCurrentThemeColors().red1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

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
 
        NSLayoutConstraint.activate([
            contentParentView.topAnchor.constraint(equalTo: contentView.topAnchor),
            contentParentView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            contentParentView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            contentParentView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            parentView.topAnchor.constraint(equalTo: contentParentView.topAnchor, constant: TopMargin.spacingXxs),
            parentView.leadingAnchor.constraint(equalTo: contentParentView.leadingAnchor, constant: LeadingMargin.spacingXs),
            parentView.trailingAnchor.constraint(equalTo: contentParentView.trailingAnchor, constant: TrailingMargin.spacingXs),
            parentView.bottomAnchor.constraint(equalTo: contentParentView.bottomAnchor, constant: BottomMargin.spacingXxs),
            
            titleLabel.topAnchor.constraint(equalTo: parentView.topAnchor, constant: TopMargin.spacingXs),
            titleLabel.leadingAnchor.constraint(equalTo: parentView.leadingAnchor, constant: LeadingMargin.spacingXs),
            titleLabel.trailingAnchor.constraint(equalTo: parentView.trailingAnchor, constant: TrailingMargin.spacingMed),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: TopMargin.spacingXs),
            descriptionLabel.leadingAnchor.constraint(equalTo: parentView.leadingAnchor, constant: LeadingMargin.spacingMed),
            descriptionLabel.trailingAnchor.constraint(equalTo: parentView.trailingAnchor, constant: TrailingMargin.spacingMed),
            descriptionLabel.bottomAnchor.constraint(equalTo: parentView.bottomAnchor, constant: BottomMargin.spacingXxs)
        ])
    }
 
    override func prepareForReuse() {
        titleLabel.text = ""
        descriptionLabel.text = ""
    }
 
    func config(_ model: LaunchKeyValueItemModel?) {
        guard let model = model else { return }
        titleLabel.text = model.key
        descriptionLabel.text = model.value
    }
}

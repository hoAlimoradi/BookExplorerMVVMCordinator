//
//  HomeLaunchCell.swift
//  SpaceXSingleModule
//
//  Created by ho on 4/9/1403 AP.
//

import Foundation
import UIKit
// MARK: - LaunchCell
class HomeLaunchCell: UICollectionViewCell {
    private enum Constants {
        static var borderWidth = CGFloat(1)
    }
    
    private lazy var contentParentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = ThemeManager.shared.getCurrentThemeColors().white1
        return view
    }()
    
    private lazy var parentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = ThemeManager.shared.getCurrentThemeColors().primary3
        view.layer.borderColor = ThemeManager.shared.getCurrentThemeColors().primary2.cgColor
        view.layer.borderWidth = Constants.borderWidth
        view.layer.cornerRadius = RoundedCornerDimens.radius3
        return view
    }()
 
    private lazy var nameLabel: UILabel = {
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
     
    private lazy var rocketLabel: UILabel = {
        let label = UILabel()
        label.isUserInteractionEnabled = false
        label.numberOfLines = 1
        label.textAlignment = .left
        label.autoresize()
        label.font = Fonts.B3.semiBold
        label.textColor = ThemeManager.shared.getCurrentThemeColors().grey1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
     
   
    private lazy var dateLabel: UILabel = {
        let label = UILabel() 
        label.isUserInteractionEnabled = false
        label.numberOfLines = 1
        label.textAlignment = .right
        label.autoresize()
        //label.text = "13:34"
        label.font = Fonts.B3.regular
        label.textColor = ThemeManager.shared.getCurrentThemeColors().grey1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    private func setup() {
        contentView.addSubview(contentParentView)
        contentParentView.addSubview(parentView)
        
        parentView.addSubview(nameLabel)
        parentView.addSubview(rocketLabel)
        parentView.addSubview(dateLabel)
        NSLayoutConstraint.activate([
            contentParentView.topAnchor.constraint(equalTo: contentView.topAnchor),
            contentParentView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            contentParentView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            contentParentView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            parentView.topAnchor.constraint(equalTo: contentParentView.topAnchor, constant: TopMargin.spacingXxs),
            parentView.leadingAnchor.constraint(equalTo: contentParentView.leadingAnchor, constant: LeadingMargin.spacingXs),
            parentView.trailingAnchor.constraint(equalTo: contentParentView.trailingAnchor, constant: TrailingMargin.spacingXs),
            parentView.bottomAnchor.constraint(equalTo: contentParentView.bottomAnchor, constant: BottomMargin.spacingXxs),
 
            nameLabel.topAnchor.constraint(equalTo: parentView.topAnchor, constant: TopMargin.spacingSm),
            nameLabel.leadingAnchor.constraint(equalTo: parentView.leadingAnchor, constant: LeadingMargin.spacingXs),
            nameLabel.trailingAnchor.constraint(equalTo: parentView.trailingAnchor, constant: TrailingMargin.spacingXs),
            
            rocketLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: TopMargin.spacingSm),
            rocketLabel.leadingAnchor.constraint(equalTo: parentView.leadingAnchor, constant: LeadingMargin.spacingXs),
            rocketLabel.trailingAnchor.constraint(equalTo: parentView.trailingAnchor, constant: TrailingMargin.spacingXs),
            
            dateLabel.topAnchor.constraint(equalTo: rocketLabel.bottomAnchor, constant: TopMargin.spacingSm),
            dateLabel.trailingAnchor.constraint(equalTo: parentView.trailingAnchor, constant: TrailingMargin.spacingXs)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func configure(with launch: LaunchItemModel) {
        nameLabel.text = launch.name
        rocketLabel.text = launch.rocket
        guard let date = launch.dateUTC else {
            dateLabel.text?.removeAll()
            return
        }
        dateLabel.text = date.toDayMonthString()
    }
}

 

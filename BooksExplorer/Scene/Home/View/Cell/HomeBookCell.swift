//
//  HomeLaunchCell.swift

import Foundation
import UIKit
// MARK: - HomeBookCell
class HomeBookCell: UICollectionViewCell {
    
    static let identifier = "HomeBookCell"
    
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
 
    private lazy var titleKeyLabel: UILabel = {
        let label = UILabel()
        label.isUserInteractionEnabled = false
        label.numberOfLines = 0
        label.textAlignment = .left
        label.autoresize()
        label.text = "Title: "
        label.font = Fonts.B1.medium
        label.textColor = ThemeManager.shared.getCurrentThemeColors().black2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
     
    private lazy var titleLabel: UILabel = {
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
     
   
    private lazy var moreLabel: UILabel = {
        let label = UILabel()
        label.isUserInteractionEnabled = false
        label.numberOfLines = 1
        label.textAlignment = .right
        label.autoresize()
        label.text = "more"
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
        
        parentView.addSubview(titleKeyLabel)
        parentView.addSubview(titleLabel)
        parentView.addSubview(moreLabel)
        NSLayoutConstraint.activate([
            contentParentView.topAnchor.constraint(equalTo: contentView.topAnchor),
            contentParentView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            contentParentView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            contentParentView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            parentView.topAnchor.constraint(equalTo: contentParentView.topAnchor, constant: TopMargin.spacingXxs),
            parentView.leadingAnchor.constraint(equalTo: contentParentView.leadingAnchor, constant: LeadingMargin.spacingXs),
            parentView.trailingAnchor.constraint(equalTo: contentParentView.trailingAnchor, constant: TrailingMargin.spacingXs),
            parentView.bottomAnchor.constraint(equalTo: contentParentView.bottomAnchor, constant: BottomMargin.spacingXxs),
 
            titleKeyLabel.topAnchor.constraint(equalTo: parentView.topAnchor, constant: TopMargin.spacingSm),
            titleKeyLabel.leadingAnchor.constraint(equalTo: parentView.leadingAnchor, constant: LeadingMargin.spacingXs),
            titleKeyLabel.trailingAnchor.constraint(equalTo: parentView.trailingAnchor, constant: TrailingMargin.spacingXs),
            
            titleLabel.topAnchor.constraint(equalTo: titleKeyLabel.bottomAnchor, constant: TopMargin.spacingSm),
            titleLabel.leadingAnchor.constraint(equalTo: parentView.leadingAnchor, constant: LeadingMargin.spacingXs),
            titleLabel.trailingAnchor.constraint(equalTo: parentView.trailingAnchor, constant: TrailingMargin.spacingXs),
            
            moreLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: TopMargin.spacingSm),
            moreLabel.trailingAnchor.constraint(equalTo: parentView.trailingAnchor, constant: TrailingMargin.spacingXs)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func configure(with boolItemModel: BookItemModel) {
        guard let title = boolItemModel.title else {
            titleLabel.text?.removeAll()
            return
        }
        titleLabel.text = title
    }
}

 

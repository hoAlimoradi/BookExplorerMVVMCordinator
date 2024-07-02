//
//  InfoProfilePropertyTableViewCell.swift
//  SpaceXSingleModule
//
//  Created by ho on 4/11/1403 AP.
//
import Foundation
import UIKit
import Combine

class InfoProfilePropertyTableViewCell: UITableViewCell {
    
    static let identifier = "InfoProfilePropertyTableViewCell"
    
    private enum Constants {
        static var lineViewHeight = CGFloat(1)
        static var avatarIconWidth = CGFloat(68)
        static var avatarIconHeight = CGFloat(68)
    }
 
    private lazy var parentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = ThemeManager.shared.getCurrentThemeColors().white1
        return view
    }()
   
    private lazy var centerLineView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var avataImageView : RoundImageView = {
        var imageView = RoundImageView(frame: CGRect())
        let imageViewImage = UIImage()
        imageView.image = imageViewImage
        imageView.isUserInteractionEnabled = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = ThemeManager.shared.getCurrentThemeColors().white2
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private lazy var fullNameLabel: UILabel = {
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

    private lazy var usernameLabel: UILabel = {
        let label = UILabel()
        label.isUserInteractionEnabled = false
        label.numberOfLines = 1
        label.textAlignment = .left
        label.autoresize()
        label.font = Fonts.B3.medium
        label.textColor = ThemeManager.shared.getCurrentThemeColors().grey1
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
        backgroundColor = ThemeManager.shared.getCurrentThemeColors().white1
 
        contentView.addSubview(parentView) 
        parentView.addSubview(avataImageView)
        parentView.addSubview(centerLineView)
        centerLineView.isHidden = true

        parentView.addSubview(fullNameLabel)
        parentView.addSubview(usernameLabel)
 
        configureConstraints()
    }
    
    private func configureConstraints() {
        NSLayoutConstraint.activate([
            parentView.topAnchor.constraint(equalTo: contentView.topAnchor),
            parentView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            parentView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            parentView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
 
            avataImageView.topAnchor.constraint(equalTo: parentView.topAnchor, constant: TopMargin.spacingSm),
            avataImageView.leadingAnchor.constraint(equalTo: parentView.leadingAnchor, constant: LeadingMargin.spacingLg),
            avataImageView.widthAnchor.constraint(equalToConstant: Constants.avatarIconWidth),
            avataImageView.heightAnchor.constraint(equalToConstant: Constants.avatarIconWidth),
 
            centerLineView.centerYAnchor.constraint(equalTo: avataImageView.centerYAnchor),
            centerLineView.trailingAnchor.constraint(equalTo: parentView.trailingAnchor),
            centerLineView.leadingAnchor.constraint(equalTo: parentView.leadingAnchor),
            centerLineView.heightAnchor.constraint(equalToConstant: Constants.lineViewHeight),
 
            fullNameLabel.bottomAnchor.constraint(equalTo: centerLineView.topAnchor, constant: BottomMargin.spacing2),
            fullNameLabel.leadingAnchor.constraint(equalTo: avataImageView.trailingAnchor, constant: LeadingMargin.spacingXs),
            usernameLabel.topAnchor.constraint(equalTo: centerLineView.bottomAnchor, constant: TopMargin.spacing2),
            usernameLabel.leadingAnchor.constraint(equalTo: avataImageView.trailingAnchor, constant: LeadingMargin.spacingXs)
        ])
    }
  

    func config(model: LaunchDetailsItemModel?) {
        guard let model = model else {
            parentView.isHidden = true
            return
        }
        parentView.isHidden = false
        usernameLabel.text = "@\(model.id)"
        fullNameLabel.text = model.name
        
        if let imageUrlString = model.imageUrlString {
            avataImageView.downloadPublicImage(from: imageUrlString)
        }
    }
}

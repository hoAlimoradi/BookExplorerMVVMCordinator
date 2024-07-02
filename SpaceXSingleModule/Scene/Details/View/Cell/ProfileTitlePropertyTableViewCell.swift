//
//  ProfileTitlePropertyTableViewCell.swift
//  SpaceXSingleModule
//
//  Created by ho on 4/11/1403 AP.
//

import Foundation
import UIKit
import Combine

class ProfileTitlePropertyTableViewCell: UITableViewCell {
   
   static let identifier = "ProfileTitlePropertyTableViewCell"
   
   private enum Constants {
       static var lineViewHeight = CGFloat(3)
   }

   private lazy var parentView: UIView = {
       let view = UIView()
       view.translatesAutoresizingMaskIntoConstraints = false
       view.backgroundColor = ThemeManager.shared.getCurrentThemeColors().white1
       return view
   }()
  
   private lazy var lineView: UIView = {
       let view = UIView()
       view.translatesAutoresizingMaskIntoConstraints = false
       view.backgroundColor = ThemeManager.shared.getCurrentThemeColors().white2
       return view
   }()

   private lazy var titleLabel: UILabel = {
       let label = UILabel() 
       label.isUserInteractionEnabled = false
       label.numberOfLines = 1
       label.textAlignment = .left
       label.autoresize()
       label.font = Fonts.B2.medium
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
       parentView.addSubview(lineView)
       parentView.addSubview(titleLabel)
       configureConstraints()
   }

   private func configureConstraints() {
       NSLayoutConstraint.activate([
           parentView.topAnchor.constraint(equalTo: contentView.topAnchor),
           parentView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
           parentView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
           parentView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
 
           lineView.topAnchor.constraint(equalTo: parentView.topAnchor),
           lineView.trailingAnchor.constraint(equalTo: parentView.trailingAnchor),
           lineView.leadingAnchor.constraint(equalTo: parentView.leadingAnchor),
           lineView.heightAnchor.constraint(equalToConstant: Constants.lineViewHeight),
           
           titleLabel.topAnchor.constraint(equalTo: lineView.bottomAnchor, constant: TopMargin.spacingSm),
           titleLabel.leadingAnchor.constraint(equalTo: parentView.leadingAnchor, constant: LeadingMargin.spacingLg),
           titleLabel.trailingAnchor.constraint(equalTo: parentView.trailingAnchor, constant: TrailingMargin.spacingLg)
       ])
   }

   override func layoutSubviews() {
       super.layoutSubviews()
   }
   
   func config(title: String) {
       titleLabel.text = title
   }
} 

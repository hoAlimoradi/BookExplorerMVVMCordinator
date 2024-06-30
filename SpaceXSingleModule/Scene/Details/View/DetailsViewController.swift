//
//  DetailsViewController.swift
//  SpaceXSingleModule
//
//  Created by ho on 4/9/1403 AP.
//

import UIKit
import Combine

final class DetailsViewController: BaseViewController {
    
    private enum Constants {
        static var icSelectorNavigatorIcon = "ic_selector_navigator"
        
        static var icSelectorNavigatorIconWidth = CGFloat(60)
        static var icSelectorNavigatorIconHeight = CGFloat(4)
        
        static var iconWidth = CGFloat(20)
        static var iconHeight = CGFloat(20)
        static var optionIcon = "ic_more_horizental"
        
        static var lineViewHeight = CGFloat(1)
        static var searchViewHeight = CGFloat(50)
    }
    
    private let router: DetailsRouting
    private var cancellables = Set<AnyCancellable>()
    private let viewModel: DetailsViewModel
    private var detailItems = [LaunchKeyValueItemModel]()
    
     init(configuration: DetailsModule.Configuration,
          viewModel: DetailsViewModel,
          router: DetailsRouting) {
         self.viewModel =  viewModel
         self.router = router
         super.init(nibName: nil, bundle: nil)
     }
     
     required init?(coder: NSCoder) {
         fatalError()
     }
  
   
    private lazy var eventDetailsTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(TitleDescriptionDetailsTableViewCell.self,
                                    forCellReuseIdentifier: TitleDescriptionDetailsTableViewCell.identifier)
        
        tableView.setDefaultProperties()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        return tableView
    }()
    
    //MARK: -- Button
    private lazy var selectionButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(self.selectionButtonPressed), for: .touchUpInside)
        return button
    }()
    
    @objc private func selectionButtonPressed() {
        viewModel.action(.toggleButton)
    }
    internal override func configureSubViews() {
        view.backgroundColor = ThemeManager.shared.getCurrentThemeColors().white1
        view.addSubview(eventDetailsTableView)
        view.addSubview(selectionButton)
    }
   
    internal override func configureConstraints() {
        NSLayoutConstraint.activate([
            selectionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: BottomMargin.spacingSm),
            selectionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                                  constant: LeadingMargin.spacingSm),
            selectionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: TrailingMargin.spacingMed),
            selectionButton.heightAnchor.constraint(equalToConstant: ButtonHeight.large56),

            eventDetailsTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            eventDetailsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            eventDetailsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            eventDetailsTableView.bottomAnchor.constraint(equalTo: selectionButton.topAnchor, constant: BottomMargin.spacingSm)
        ])
        bind()
    }

    private func bind() {
        viewModel.action(.checkIsFavorite)
        viewModel.launchDetailItemsSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] details in
                guard let self else { return }
                self.detailItems = details
                self.eventDetailsTableView.reloadData()
            }.store(in: &cancellables)
        
        viewModel.favoriteStatusSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] favoriteStatus in
                guard let self else { return }
                self.configSelectionButton(by: favoriteStatus)
            }.store(in: &cancellables)
 
    }
    
    private func configSelectionButton(by favoriteStatus: FavoriteStatusEnum?) {
        guard let favoriteStatus = favoriteStatus else {
            selectionButton.isHidden = true
            return
        }
        selectionButton.isHidden = false
        selectionButton.translatesAutoresizingMaskIntoConstraints = false
        selectionButton.titleLabel?.font = Fonts.B1.semiBold
        selectionButton.isUserInteractionEnabled = true
        switch favoriteStatus {
        case .favorite:
            selectionButton.setTitle("Remove", for: .normal)
            selectionButton.backgroundColor = ThemeManager.shared.getCurrentThemeColors().red1
            selectionButton.layer.cornerRadius = RoundedCornerDimens.radius3
            selectionButton.setTitleColor(ThemeManager.shared.getCurrentThemeColors().white2, for: .normal)
        case .notFavorite:
            selectionButton.setTitle("Add", for: .normal)
            selectionButton.backgroundColor = ThemeManager.shared.getCurrentThemeColors().primary1
            selectionButton.layer.cornerRadius = RoundedCornerDimens.radius3
            selectionButton.setTitleColor(ThemeManager.shared.getCurrentThemeColors().white2, for: .normal)
        }
    }
}
//MARK: TableViewDelegateDataSource
extension DetailsViewController: TableViewDelegateDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleDescriptionDetailsTableViewCell.identifier, for: indexPath) as? TitleDescriptionDetailsTableViewCell else {
            fatalError()
        }
        if indexPath.row < detailItems.count {
            cell.config(detailItems[indexPath.row])
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return detailItems.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
 

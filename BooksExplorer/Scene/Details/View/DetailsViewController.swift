//
//  DetailsViewController.swift

import UIKit
import Combine

final class DetailsViewController: BaseViewController {
    
    private enum Constants {
        static var bookmarkIcon = "ic_eye"
        static var bookmarkedIcon = "ic_eye_show"
    }
    
    private let router: DetailsRouting
    private var cancellables = Set<AnyCancellable>()
    private let viewModel: DetailsViewModelProtocol
    private var detailsItemModel = [BookKeyValueItemModel]()
    init(configuration: DetailsModule.Configuration,
         viewModel: DetailsViewModelProtocol,
         router: DetailsRouting) {
        self.viewModel =  viewModel
        self.router = router
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - configNavigationItems
    private func configNavigationItems() {
        navigationController?.navigationBar.tintColor = ThemeManager.shared.getCurrentThemeColors().primary1
        navigationItem.title = AppStrings.Details.title.localized
        
    }
    
    private func updateBookmarkButton(for favoriteStatus: FavoriteStatusEnum) {
        let bookmarkImage: UIImage?
        switch favoriteStatus {
        case .favorite:
            bookmarkImage = UIImage(named: Constants.bookmarkedIcon)?.withRenderingMode(.alwaysOriginal)
        case .notFavorite:
            bookmarkImage = UIImage(named: Constants.bookmarkIcon)?.withRenderingMode(.alwaysOriginal)
        }
        
        let bookmarkNavigationItem = UIBarButtonItem(image: bookmarkImage, style: .plain, target: self, action: #selector(selectionBookmarkButtonPressed))
        
        navigationItem.rightBarButtonItem = bookmarkNavigationItem
    }
    private func configSelectionButton(by favoriteStatus: FavoriteStatusEnum?) {
        guard let favoriteStatus = favoriteStatus else {
            return
        }
        updateBookmarkButton(for: favoriteStatus)
    }
    @objc private func selectionBookmarkButtonPressed() {
        viewModel.action(.toggleButton)
    }
    
    private lazy var eventDetailsTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(TitleDescriptionDetailsTableViewCell.self,
                           forCellReuseIdentifier: TitleDescriptionDetailsTableViewCell.identifier)

        tableView.register(ExportDetailsTableViewCell.self,
                           forCellReuseIdentifier: ExportDetailsTableViewCell.identifier)
        tableView.setDefaultProperties()
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    //MARK: -- configureSubViews
    internal override func configureSubViews() {
        view.backgroundColor = ThemeManager.shared.getCurrentThemeColors().white1
        configNavigationItems()
        view.addSubview(eventDetailsTableView)
    }
    
    internal override func configureConstraints() {
        NSLayoutConstraint.activate([
            eventDetailsTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            eventDetailsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            eventDetailsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            eventDetailsTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: BottomMargin.spacingSm)
        ])
        bind()
    }
    
    private func bind() { 
        lifecycleObserverSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] lifecycleObserver in
                self?.viewModel.action(.observeLifecycle(lifecycleObserver))
            }.store(in: &cancellables)
        
        viewModel.bookKeyValueItemModelsSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] details in
                guard let self = self, let details = details else { return }
                self.detailsItemModel = details
                self.eventDetailsTableView.reloadData()
            }.store(in: &cancellables)
        
        viewModel.favoriteStatusSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] favoriteStatus in
                guard let self else { return }
                self.configSelectionButton(by: favoriteStatus)
            }.store(in: &cancellables)
        
        viewModel.route
            .receive(on: DispatchQueue.main)
            .sink { [weak self] routeAction in
                guard let self = self else { return }
                switch routeAction {
                case .openUrl(let urlString):
                    self.router.openUrl(urlString)
                case .idleRoute:
                    break
                case .shareExport(let data):
                    shareExport(data)
                }
            }.store(in: &cancellables)
        
    }
}
//MARK: TableViewDelegateDataSource

extension DetailsViewController: TableViewDelegateDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           if indexPath.row == 0 {
               guard let cell = tableView.dequeueReusableCell(withIdentifier: ExportDetailsTableViewCell.identifier, for: indexPath) as? ExportDetailsTableViewCell else {
                   fatalError("Could not dequeue ExportDetailsTableViewCell")
               }
               cell.selectionStyle = .none
               cell.selectionButtonPressedSubject
                   .sink { [weak self] _ in
                       self?.viewModel.action(.export)
                   }
                   .store(in: &cancellables)
               
               return cell
           } else {
               // Check indexPath.row is valid for detailsItemModel
               let modelIndex = indexPath.row - 1 // Adjust for the first row
               guard modelIndex < detailsItemModel.count else {
                   fatalError("Invalid index path for detailsItemModel")
               }
               
               guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleDescriptionDetailsTableViewCell.identifier, for: indexPath) as? TitleDescriptionDetailsTableViewCell else {
                   fatalError("Could not dequeue TitleDescriptionDetailsTableViewCell")
               }
               cell.config(with: detailsItemModel[modelIndex])
               cell.selectionStyle = .none
               
               return cell
           }
       }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            switch indexPath.row {
            case 0:
                return 85 // Fixed height for the first row
            default:
                return UITableView.automaticDimension // Use automatic dimension for dynamic heights
            }
        }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return detailsItemModel.count + 1
    }
}

//MARK: show export
extension DetailsViewController {
    func shareExport(_ exportedAsString: String) {
        let invitationMessage = """
         
        date:
        \(Date().toDayMonthString())
        
        data:
        \(exportedAsString)
         
        """
        
        let activityViewController = UIActivityViewController(activityItems: [invitationMessage], applicationActivities: nil)
        
        // For iPads, you need to specify where the activity sheet should be anchored to.
        if let popoverPresentationController = activityViewController.popoverPresentationController {
            popoverPresentationController.sourceView = self.view
            popoverPresentationController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverPresentationController.permittedArrowDirections = []
        }
        
        self.present(activityViewController, animated: true, completion: nil)
    }
}

//
//  HomeViewController.swift
//  

import UIKit
import Combine
 
final class HomeViewController: BaseViewController {

     // MARK: - Properties
     private enum Constants {
         static let spacing: CGFloat = 10
         static var searchViewHeight = CGFloat(50)
     }
     private let router: HomeRouting
     private var cancellables = Set<AnyCancellable>()
     private let viewModel: HomeViewModelProtocol

    private var state: HomeFetchState = .idleBook {
         didSet {
             updateUI(for: state)
         }
     }

     private lazy var titleLabel: UILabel = {
         let label = UILabel()
         label.isUserInteractionEnabled = false
         label.textAlignment = .center
         label.font = Fonts.B3.medium
         label.textColor = ThemeManager.shared.getCurrentThemeColors().grey1
         label.translatesAutoresizingMaskIntoConstraints = false
         return label
     }()

    private lazy var searchView: CustomSearchView = {
        let searchView = CustomSearchView()
        searchView.translatesAutoresizingMaskIntoConstraints = false
        searchView.textSubject
            .compactMap { $0 }
            .removeDuplicates()
            .sink {[weak self] text in
                guard let self = self else { return }
                if(text.isEmpty) {
                    self.viewModel.action(.getBooks)
                } else {
                    self.viewModel.action(.search(text))
                }
            }
            .store(in: &cancellables)

        searchView.cancelButtonTappedSubject
            .sink {[weak self] text in
                guard let self = self else { return }
                self.view.endEditing(true)
            }
            .store(in: &cancellables)
        return searchView
    }()

    
     private lazy var collectionView: UICollectionView = {
         let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
         collectionView.backgroundColor = .clear
         collectionView.translatesAutoresizingMaskIntoConstraints = false
         collectionView.delegate = self
         collectionView.register(HomeBookCell.self, forCellWithReuseIdentifier: HomeBookCell.identifier)
         return collectionView
     }()

     private lazy var dataSource: UICollectionViewDiffableDataSource<Int, BookItemModel> = {
         return UICollectionViewDiffableDataSource<Int, BookItemModel>(collectionView: collectionView) { collectionView, indexPath, bookItem in
             guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeBookCell.identifier, for: indexPath) as? HomeBookCell else {
                 fatalError("Unable to dequeue HomeBookCell")
             }
             cell.configure(with: bookItem)
             return cell
         }
     }()

     private lazy var loadingIndicator: UIActivityIndicatorView = {
         let indicator = UIActivityIndicatorView(style: .large)
         indicator.translatesAutoresizingMaskIntoConstraints = false
         indicator.hidesWhenStopped = true
         return indicator
     }()
     private lazy var footerSpinner: UIActivityIndicatorView = {
         let spinner = UIActivityIndicatorView(style: .medium)
         spinner.startAnimating()
         spinner.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 100)
         return spinner
     }()
     private lazy var emptyView: UIView = {
         let view = UIView()
         view.translatesAutoresizingMaskIntoConstraints = false
         // Configure empty view appearance
         let label = UILabel()
         label.text = "No Bookes Available"
         label.textAlignment = .center
         view.addSubview(label)
         label.translatesAutoresizingMaskIntoConstraints = false
         NSLayoutConstraint.activate([
             label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
             label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
         ])
         view.isHidden = true
         return view
     }()

     private lazy var errorView: UIView = {
         let view = UIView()
         view.translatesAutoresizingMaskIntoConstraints = false
         // Configure error view appearance
         let label = UILabel()
         label.text = "An error occurred. Please try again."
         label.textAlignment = .center
         view.addSubview(label)
         label.translatesAutoresizingMaskIntoConstraints = false
         NSLayoutConstraint.activate([
             label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
             label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
         ])
         view.isHidden = true
         return view
     }()

     init(configuration: HomeModule.Configuration,
          viewModel: HomeViewModelProtocol,
          router: HomeRouting) {
         self.viewModel = viewModel
         self.router = router
 
         super.init(nibName: nil, bundle: nil)
     }

     required init?(coder: NSCoder) {
         fatalError()
     }

     internal override func configureSubViews() {
         navigationItem.title = AppStrings.Home.title.localized
         view.backgroundColor = ThemeManager.shared.getCurrentThemeColors().white1
         view.addSubview(titleLabel)
         view.addSubview(searchView)
         view.addSubview(collectionView)
         view.addSubview(loadingIndicator)
         view.addSubview(emptyView)
         view.addSubview(errorView)
     }

     internal override func configureConstraints() {
         NSLayoutConstraint.activate([
             titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
             titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: TopMargin.spacingSm),

             searchView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor,
                                             constant: TopMargin.spacingXs),
             searchView.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                                 constant: LeadingMargin.spacingMed),
             
             searchView.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                  constant: TrailingMargin.spacingMed),
             searchView.heightAnchor.constraint(equalToConstant: Constants.searchViewHeight),
             
             collectionView.topAnchor.constraint(equalTo: searchView.bottomAnchor, constant: TopMargin.spacingXs),
             collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
             collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
             collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

             loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
             loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),

             emptyView.topAnchor.constraint(equalTo: view.topAnchor),
             emptyView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
             emptyView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
             emptyView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

             errorView.topAnchor.constraint(equalTo: view.topAnchor),
             errorView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
             errorView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
             errorView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
         ])

         bind()
     }
 }

 // MARK: - bind
 extension HomeViewController  {
     private func bind() {
         lifecycleObserverSubject
             .receive(on: DispatchQueue.main)
             .sink { [weak self] lifecycleObserver in 
                 self?.viewModel.action(.observeLifecycle(lifecycleObserver))
             }.store(in: &cancellables)
 
         viewModel.route
             .receive(on: DispatchQueue.main)
             .sink { [weak self] routeAction in
                 guard let self = self else { return }
                 switch routeAction {
                 case .navigateToDetails(let bookItemModel):
                     self.router.navigateToDetials(by: bookItemModel)
                 case .idleRoute:
                     break
                 }
             }.store(in: &cancellables)

         viewModel.bookListSubject
             .receive(on: DispatchQueue.main)
             .sink { [weak self] Bookes in
                 self?.applySnapshot(with: Bookes)
             }.store(in: &cancellables)
         
         viewModel.homeFetchState
             .receive(on: DispatchQueue.main)
             .sink { [weak self] state in
                 //self?.state = state
                 self?.updateUI(for: state)
             }.store(in: &cancellables)
     }
 }


 // MARK: - collectionView
 extension HomeViewController  {
     private func createLayout() -> UICollectionViewLayout {
         let itemSize = NSCollectionLayoutSize(
             widthDimension: .fractionalWidth(1.0),
             heightDimension: .absolute(100))
         let item = NSCollectionLayoutItem(layoutSize: itemSize)

         let groupSize = NSCollectionLayoutSize(
             widthDimension: .fractionalWidth(1.0),
             heightDimension: .absolute(100))
         let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])

         let section = NSCollectionLayoutSection(group: group)
         section.interGroupSpacing = Constants.spacing
         section.contentInsets = NSDirectionalEdgeInsets(top: Constants.spacing, leading: Constants.spacing, bottom: Constants.spacing, trailing: Constants.spacing)

         return UICollectionViewCompositionalLayout(section: section)
     }
     private func applySnapshot(with Bookes: [BookItemModel]) {
         var snapshot = NSDiffableDataSourceSnapshot<Int, BookItemModel>()
         snapshot.appendSections([0])
         snapshot.appendItems(Bookes)
         if Bookes.isEmpty {
             titleLabel.text?.removeAll()
         } else {
             titleLabel.text = "Total Count: \(Bookes.count)"
         }
         dataSource.apply(snapshot, animatingDifferences: true)
     }
     func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
         guard let bookItem = dataSource.itemIdentifier(for: indexPath) else { return }
         viewModel.action(.selectBook(bookItem))
     }
 }

 // MARK: - UICollectionViewDelegate
 extension HomeViewController: UICollectionViewDelegate {
     func scrollViewDidScroll(_ scrollView: UIScrollView) {
         let offsetY = scrollView.contentOffset.y
         let contentHeight = scrollView.contentSize.height

         if offsetY > contentHeight - scrollView.frame.height * 4 {
             viewModel.action(.moreLoadBooks)
         }
     }
 }

 // MARK: - updateUI based on HomeFetchState
 extension HomeViewController  {
     private func updateUI(for state: HomeFetchState) {
         switch state {
         case .idleBook:
             loadingIndicator.stopAnimating()
             emptyView.isHidden = true
             errorView.isHidden = true
             collectionView.isHidden = false

         case .loadingBook:
             loadingIndicator.startAnimating()
             emptyView.isHidden = true
             errorView.isHidden = true
             collectionView.isHidden = true

         case .loadMoreBook:
             // Handle loading more Bookes UI if needed
             break

         case .emptyBook:
             loadingIndicator.stopAnimating()
             emptyView.isHidden = false
             errorView.isHidden = true
             collectionView.isHidden = true

         case .failedBook:
             loadingIndicator.stopAnimating()
             emptyView.isHidden = true
             errorView.isHidden = false
             collectionView.isHidden = true
         }
     }
  
 }

 

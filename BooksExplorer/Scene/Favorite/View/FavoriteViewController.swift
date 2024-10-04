//
//  FavoriteViewController.swift
//  
 
 
import UIKit
import Combine
 
final class FavoriteViewController: BaseViewController {

    // MARK: - Properties
    private enum Constants { 
        static let spacing: CGFloat = 10
    }

    private let router: FavoriteRouting
    private var cancellables = Set<AnyCancellable>()
    private let viewModel: FavoriteViewModelProtocol
    private var state: FavoriteFetchState = .idleLaunch {
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

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.register(FavoriteBookCell.self, forCellWithReuseIdentifier: FavoriteBookCell.identifier)
        return collectionView
    }()

    private lazy var dataSource: UICollectionViewDiffableDataSource<Int, BookItemModel> = {
        return UICollectionViewDiffableDataSource<Int, BookItemModel>(collectionView: collectionView) { collectionView, indexPath, bookItem in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavoriteBookCell.identifier, for: indexPath) as? FavoriteBookCell else {
                fatalError("Unable to dequeue FavoriteLaunchCell")
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
        label.text = "No Launches Available"
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

    init(configuration: FavoriteModule.Configuration,
         viewModel: FavoriteViewModelProtocol,
         router: FavoriteRouting) {
        self.viewModel = viewModel
        self.router = router
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    internal override func configureSubViews() {
        view.backgroundColor = ThemeManager.shared.getCurrentThemeColors().white1
        navigationItem.title = AppStrings.Favorite.title.localized
        view.addSubview(titleLabel)
        view.addSubview(collectionView)
        view.addSubview(loadingIndicator)
        view.addSubview(emptyView)
        view.addSubview(errorView)
    }

    internal override func configureConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: TopMargin.spacingSm),

            collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Constants.spacing),
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
extension FavoriteViewController  {
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
                case .navigateToDetails(let bookItem):
                    self.router.navigateToDetials(by: bookItem)
                case .idleRoute:
                    break
                }
            }.store(in: &cancellables)

        viewModel.bookListSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] launches in
                self?.applySnapshot(with: launches)
            }.store(in: &cancellables)
        
        viewModel.favoriteFetchState
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                //self?.state = state
                self?.updateUI(for: state)
            }.store(in: &cancellables)
    }
}


// MARK: - collectionView
extension FavoriteViewController  {
    private func applySnapshot(with launches: [BookItemModel]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, BookItemModel>()
        snapshot.appendSections([0])
        snapshot.appendItems(launches)
        if launches.isEmpty {
            titleLabel.text?.removeAll()
        } else {
            titleLabel.text = "Total Favorite Count: \(launches.count)"
        }
        dataSource.apply(snapshot, animatingDifferences: true)
    }

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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let bookItem = dataSource.itemIdentifier(for: indexPath) else { return }
        viewModel.action(.selectBook(bookItem))
    }
}
 
// MARK: - updateUI based on FavoriteFetchState
extension FavoriteViewController  {
    private func updateUI(for state: FavoriteFetchState) {
        switch state {
        case .idleLaunch:
            loadingIndicator.stopAnimating()
            emptyView.isHidden = true
            errorView.isHidden = true
            collectionView.isHidden = false

        case .loadingLaunch:
            loadingIndicator.startAnimating()
            emptyView.isHidden = true
            errorView.isHidden = true
            collectionView.isHidden = true

        case .emptyLaunch:
            loadingIndicator.stopAnimating()
            emptyView.isHidden = false
            errorView.isHidden = true
            collectionView.isHidden = true

        case .failedLaunch:
            loadingIndicator.stopAnimating()
            emptyView.isHidden = true
            errorView.isHidden = false
            collectionView.isHidden = true
        }
    }
 
}
 

// MARK: - UICollectionViewDelegate
extension FavoriteViewController: UICollectionViewDelegate {
     
}
 

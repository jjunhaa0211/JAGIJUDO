import SnapKit
import UIKit
import RxSwift
import RxCocoa

final class BookmarkListViewController: UIViewController {
    
    struct Dependency {
        let viewModel: BookmarkListViewModel
    }
    
    private var bookmark: [Bookmark] = []
    private let viewModel: BookmarkListViewModel
    private let disposeBag = DisposeBag()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        let inset: CGFloat = 16.0
        layout.estimatedItemSize = CGSize(width: view.frame.width - 32.0, height: 100.0)
        layout.sectionInset = UIEdgeInsets(top: 16.0, left: inset, bottom: inset, right: inset)
        layout.minimumLineSpacing = 16.0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .secondarySystemBackground
        collectionView.register(BookmarkCollectionViewCell.self, forCellWithReuseIdentifier: BookmarkCollectionViewCell.identifier)
        collectionView.dataSource = self
        
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        
        navigationItem.title = "즐겨찾기"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        bindViewModel()
        
        let rightButton = UIBarButtonItem(image: UIImage(systemName: "home"), style: .done, target: self, action: #selector(didTapSaveButton))
        navigationItem.rightBarButtonItem = rightButton
    }

    @objc func didTapSaveButton() {
        // Save 버튼이 눌렸을 때의 처리 로직
        print("Save button tapped")
    }
    
    private func bindViewModel() {
        let input = BookmarkListViewModel.Input(
            viewWillAppear: rx.sentMessage(#selector(viewWillAppear(_:))).map { _ in }
        )
        
        let output = viewModel.transform(input: input)
        
        output.bookmarks
            .drive(onNext: { [weak self] bookmarks in
                self?.bookmark = bookmarks
                self?.collectionView.reloadData()
            })
            .disposed(by: disposeBag)
    }
    
    init(dependency: Dependency) {
          self.viewModel = dependency.viewModel
          super.init(nibName: nil, bundle: nil)
      }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension BookmarkListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bookmark.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BookmarkCollectionViewCell.identifier, for: indexPath) as? BookmarkCollectionViewCell
        
        let bookmark = bookmark[indexPath.item]
        cell?.setup(from: bookmark)
        
        return cell ?? UICollectionViewCell()
    }
}

private extension BookmarkListViewController {
    func setupLayout() {
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

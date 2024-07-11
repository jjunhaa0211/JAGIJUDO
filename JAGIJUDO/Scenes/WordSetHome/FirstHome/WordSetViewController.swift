import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then

class WordSetViewController: UIViewController {
    struct Dependency {
        let viewModel: WordSetViewModel
    }
    
    let viewModel: WordSetViewModel
    private let disposeBag = DisposeBag()
    
    private let setTableView = UITableView().then {
        $0.register(WordSetTableViewCell.self, forCellReuseIdentifier: WordSetTableViewCell.identifier)
        $0.backgroundColor = .secondarySystemBackground
        $0.separatorStyle = .none
    }
    
    private let createButton = UIButton().then {
        $0.backgroundColor = .systemPink
        $0.setTitle("세트 추가하기", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.setTitleColor(.systemGray, for: .highlighted)
        $0.contentMode = .scaleToFill
        $0.titleLabel?.font = .systemFont(ofSize: 15, weight: .bold)
        $0.layer.cornerRadius = 8
        $0.layer.cornerCurve = .continuous
        $0.layer.shadowOffset = CGSize(width: 3, height: 3)
        $0.layer.masksToBounds = false
    }
    
    private let popUpView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 8
        $0.layer.cornerCurve = .continuous
        $0.layer.masksToBounds = false
    }
    
    private let popUpLabel = UILabel().then {
        $0.text = "세트 추가 버튼을 눌러 단어장을 생성해보세요!"
        $0.textColor = .black
        $0.textAlignment = .center
        $0.font = .systemFont(ofSize: 16, weight: .semibold)
    }
        
    init(dependency: Dependency) {
        self.viewModel = dependency.viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bind()
        setNavigationBar()
        
        print("WordSetViewController")
    }
        
    private func configureUI() {
        view.backgroundColor = _backgroundColor
        
        [
            setTableView,
            createButton,
            popUpView
        ].forEach { view.addSubview($0) }
        
        popUpView.addSubview(popUpLabel)
        
        setTableView.tableFooterView = UIView(frame: .init(x: 0, y: 0, width: view.frame.width, height: 80))
        
        setTableView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        createButton.snp.makeConstraints {
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(10)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-10)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            $0.height.equalTo(40)
        }
        
        popUpView.snp.makeConstraints {
            $0.height.equalTo(100)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-20)
            $0.bottom.equalTo(createButton.snp.top).offset(-20)
        }
        
        popUpLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.leading.equalToSuperview().offset(5)
            $0.trailing.equalToSuperview().offset(-5)
        }
    }
    
    private func setNavigationBar() {
        view.backgroundColor = .secondarySystemBackground
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        backBarButtonItem.tintColor = _titleColor
        navigationItem.backBarButtonItem = backBarButtonItem
        navigationController?.navigationBar.isHidden = false
        navigationItem.title = "자기주도"
    }
    
    private func bind() {
        setTableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        viewModel.wordSetList
            .bind(to: setTableView.rx.items(dataSource: viewModel.dataSource))
            .disposed(by: disposeBag)
        
        viewModel.wordSetList
            .bind(
                with: self,
                onNext: { vc, items in
                    vc.sceneInitialSet(count: items.count)
                }
            )
            .disposed(by: disposeBag)
        
        Observable.zip(setTableView.rx.modelSelected(WordSet.self), setTableView.rx.itemSelected)
            .bind(
                with: self,
                onNext: { vc, event in
                    vc.viewModel.modelSelected(tableView: vc.setTableView, model: event.0, indexPath: event.1)
                }
            )
            .disposed(by: disposeBag)
        
        setTableView.rx.modelDeleted(WordSet.self)
            .bind(
                with: viewModel,
                onNext: { viewModel, wordSet in
                    viewModel.delete(wordSet: wordSet)
                }
            )
            .disposed(by: disposeBag)
        
        setTableView.rx.itemMoved
            .bind(
                with: viewModel,
                onNext: { viewModel, indexPaths in
                    viewModel.move(source: indexPaths.sourceIndex, destination: indexPaths.destinationIndex)
                }
            )
            .disposed(by: disposeBag)
        
        createButton.rx.tap
            .bind(
                with: self,
                onNext: { vc, _ in
                    vc.viewModel.create(vc)
                    
                }
            )
            .disposed(by: disposeBag)
    }
    
    private func sceneInitialSet(count: Int) {
        if count == 0 {
            UIView.transition(with: popUpView, duration: 0.5, options: .transitionFlipFromBottom) { [weak self] in
                self?.popUpView.isHidden = false
            }
        } else {
            popUpView.isHidden = true
        }
    }
}

extension WordSetViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
       if scrollView.panGestureRecognizer.translation(in: scrollView).y < 0 {
          navigationController?.setNavigationBarHidden(true, animated: true)
       } else {
          navigationController?.setNavigationBarHidden(false, animated: true)
       }
    }
}

extension WordSetViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "삭제"
    }
}

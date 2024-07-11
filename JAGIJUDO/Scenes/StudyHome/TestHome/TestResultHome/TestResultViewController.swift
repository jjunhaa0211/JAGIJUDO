import UIKit
import RxSwift
import SnapKit

class TestResultViewController: UIViewController {
    struct Dependency {
        let viewModel: TestResultViewModel
    }
    
    let viewModel: TestResultViewModel
    private let disposeBag = DisposeBag()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = .systemFont(ofSize: 30, weight: .heavy)
        label.text = "결과"
        return label
    }()
    private let totalLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    private let okButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemPink
        button.setTitle("확인", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.contentMode = .scaleToFill
        button.titleLabel?.font = .systemFont(ofSize: 15, weight: .bold)
        button.layer.cornerRadius = 8
        button.layer.cornerCurve = .continuous
        button.layer.masksToBounds = false
        return button
    }()
    private let testResultCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
//        collectionView.isPagingEnabled = true
        collectionView.register(TestResultCollectionViewCell.self, forCellWithReuseIdentifier: TestResultCollectionViewCell.identifier)
        collectionView.backgroundColor = .secondarySystemBackground
        return collectionView
    }()
    
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
        
        print("TestResultViewController")
    }
    
    private func configureUI() {
        view.backgroundColor = .secondarySystemBackground
        
        [
            titleLabel,
            totalLabel,
            okButton,
            testResultCollectionView
        ].forEach {
            view.addSubview($0)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(15)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(10)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-10)
        }
        
        totalLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(5)
            $0.leading.trailing.equalTo(titleLabel)
        }
        
        testResultCollectionView.snp.makeConstraints {
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.top.equalTo(totalLabel.snp.bottom).offset(10)
            $0.bottom.equalTo(okButton.snp.top).offset(-10)
        }
        
        okButton.snp.makeConstraints {
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(10)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-10)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            $0.height.equalTo(40)
        }
    }
    
    private func bind() {
        totalLabel.text = "\(viewModel.total) 문제 중 \(viewModel.rightWords.count) 개 맞았습니다."
        
        viewModel.wordList
            .bind(to: testResultCollectionView.rx.items(dataSource: viewModel.dataSource))
            .disposed(by: disposeBag)
        
        okButton.rx.tap
            .bind(
                with: self,
                onNext: { vc, _ in
                    vc.viewModel.back(vc)
                }
            )
            .disposed(by: disposeBag)
        
        testResultCollectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
}

extension TestResultViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
}

import UIKit
import RxSwift
import SnapKit
import Then

class TestResultViewController: UIViewController {
    struct Dependency {
        let viewModel: TestResultViewModel
    }
    
    let viewModel: TestResultViewModel
    private let disposeBag = DisposeBag()
    private let titleLabel = UILabel().then {
        $0.textColor = .black
        $0.font = .systemFont(ofSize: 30, weight: .heavy)
        $0.text = "결과"
    }
    
    private let totalLabel = UILabel().then {
        $0.textColor = .black
        $0.font = .systemFont(ofSize: 20, weight: .bold)
    }
    
    private let okButton = UIButton().then {
        $0.backgroundColor = .systemPink
        $0.setTitle("확인", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.contentMode = .scaleToFill
        $0.titleLabel?.font = .systemFont(ofSize: 15, weight: .bold)
        $0.layer.cornerRadius = 8
        $0.layer.cornerCurve = .continuous
        $0.layer.masksToBounds = false
    }
    
    private let testResultCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        sendNotificationWithResult()
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
            .observe(on: MainScheduler.asyncInstance)
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
    
    private func sendNotificationWithResult() {
        DispatchQueue.main.async {
            let total = self.viewModel.total
            let correct = self.viewModel.rightWords.count
            let percentage = (Double(correct) / Double(total)) * 100

            let message: String
            if percentage == 100 {
                message = "정말 잘하셨습니다! 멋있어요"
            } else if percentage >= 70 {
                message = "조금만 더 노력하면 만점까지 갈 수 있어요"
            } else if percentage >= 50 {
                message = "아쉽지만 오늘 자기 전에 한번은 더 도전해주세요"
            } else if percentage >= 30 {
                message = "공부를 조금 더 해주세요 공부시간을 더 늘려주세요"
            } else {
                message = "넌 나가라"
            }

            let content = UNMutableNotificationContent()
            content.title = NSString.localizedUserNotificationString(forKey: "테스트 결과", arguments: nil)
            content.body = NSString.localizedUserNotificationString(forKey: message, arguments: nil)
            content.sound = UNNotificationSound.default

            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
            let request = UNNotificationRequest(identifier: "TestResult", content: content, trigger: trigger)
            let center = UNUserNotificationCenter.current()
            center.add(request) { (error) in
                if let error = error {
                    print("Error \(error.localizedDescription)")
                }
            }
            
            print(message)
        }
    }
}

extension TestResultViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
}

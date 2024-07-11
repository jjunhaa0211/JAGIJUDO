import UIKit
import RxSwift
import SnapKit
import Then

class TestViewController: UIViewController {
    struct Dependency {
        let viewModel: TestViewModel
    }
    
    let viewModel: TestViewModel
    private let disposeBag = DisposeBag()
    
    private let problemView = UIView().then {
        $0.layer.cornerRadius = 16
        $0.layer.cornerCurve = .continuous
        $0.backgroundColor = .systemPink
        $0.layer.masksToBounds = false
    }
    
    private let problemLabel = UILabel().then {
        $0.textColor = .white
        $0.textAlignment = .center
        $0.font = .systemFont(ofSize: 40, weight: .bold)
    }
    
    private let exampleStackView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fillEqually
        $0.alignment = .fill
        $0.spacing = 5
    }
    
    private let speakButton = UIButton().then {
        $0.setImage(_speaker, for: .normal)
        $0.contentMode = .scaleAspectFit
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
        bind()
        configureUI()
        setNavigationBar()
        
        print("TestViewController")
    }
    
    private func configureUI() {
        view.backgroundColor = .secondarySystemBackground
        
        [
            problemView,
            exampleStackView
        ].forEach { view.addSubview($0) }
        
        [
            problemLabel,
            speakButton
        ].forEach { problemView.addSubview($0) }
        
        problemView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(10)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-10)
            $0.bottom.equalTo(view.snp.centerY)
        }
        
        problemLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.leading.equalToSuperview().offset(5)
            $0.trailing.equalToSuperview().offset(-5)
        }
        
        speakButton.snp.makeConstraints {
            $0.trailing.bottom.equalToSuperview().offset(-5)
            $0.width.height.equalTo(45)
        }
        
        exampleStackView.snp.makeConstraints {
            $0.top.equalTo(problemView.snp.bottom).offset(10)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(10)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-10)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-10)
        }
    }
    
    private func bind() {
        viewModel.testObservable
            .bind(
                with: self,
                onNext: { vc, testWord in
                    if let testWord = testWord {
                        vc.setTestWords(testWord: testWord)
                    }
                }
            )
            .disposed(by: disposeBag)
        
        viewModel.words()
            .bind(
                with: self,
                onNext: { vc, words in
                    vc.viewModel.generateTestWords(words: words)
                }
            )
            .disposed(by: disposeBag)
        
        viewModel.isRight
            .bind(
                with: self,
                onNext: { vc, isRight in
                    vc.viewModel.testResultAlert(vc, testReuslt: isRight)
                }
            )
            .disposed(by: disposeBag)
        
        viewModel.title
            .bind(
                with: self,
                onNext: { vc, title in
                    vc.title = title
                }
            )
            .disposed(by: disposeBag)
        
        speakButton.rx.tap
            .bind(
                with: viewModel,
                onNext: { vm, _ in
                    vm.speak()
                }
            )
            .disposed(by: disposeBag)
    }
    
    private func setNavigationBar() {
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    private func setTestWords(testWord: TestWord) {
        problemLabel.text = "\(testWord.problem.definition)"
        
        if exampleStackView.subviews.count != testWord.examples.count + 1{
            (testWord.examples + [testWord.problem])
                .map { word -> UIButton in
                    let button = UIButton()
                    button.setTitle(word.meaning, for: .normal)
                    button.setTitleColor(.black, for: .normal)
                    button.backgroundColor = .white
                    button.layer.cornerRadius = 8
                    button.layer.cornerCurve = .continuous
                    button.layer.borderColor = _titleColor.cgColor
                    button.layer.borderWidth = 0.2
                    
                    button.rx.tap
                        .bind(
                            with: self,
                            onNext: { vc, _ in
                                vc.viewModel.exampleDidTap(meaning: button.titleLabel?.text)
                            }
                        )
                        .disposed(by: disposeBag)
                    
                    return button
                }
                .shuffled()
                .forEach { button in
                    exampleStackView.addArrangedSubview(button)
                }
        } else {
            (testWord.examples + [testWord.problem])
                .map {
                    $0.meaning
                }
                .shuffled()
                .enumerated()
                .forEach { (offset, element) in
                    if let button = exampleStackView.arrangedSubviews[offset] as? UIButton {
                        button.setTitle(element, for: .normal)
                    }
                }
        }
    }
}

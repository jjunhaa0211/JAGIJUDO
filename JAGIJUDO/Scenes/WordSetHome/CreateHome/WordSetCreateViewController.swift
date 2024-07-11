import UIKit
import RxSwift
import SnapKit
import Then

class WordSetCreateViewController: UIViewController {
    struct Dependency {
        let viewModel: WordSetCreateViewModel
    }
    
    let viewModel: WordSetCreateViewModel
    private let disposeBag = DisposeBag()
    
    private let createButton = UIButton().then {
        $0.backgroundColor = .systemPink
        $0.setTitle("추가", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.contentMode = .scaleToFill
        $0.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        $0.layer.cornerRadius = 8
        $0.layer.cornerCurve = .continuous

        $0.layer.masksToBounds = false
    }
    
    private let cancelButton = UIButton().then {
        $0.backgroundColor = .white
        $0.setTitle("취소", for: .normal)
        $0.setTitleColor(.systemPink, for: .normal)
        $0.contentMode = .scaleToFill
        $0.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        $0.layer.cornerRadius = 8
        $0.layer.cornerCurve = .continuous
        $0.layer.masksToBounds = false
    }
    
    private let titleLabel = UILabel().then {
        $0.text = "제목을 입력하세요"
        $0.textAlignment = .center
        $0.font = .systemFont(ofSize: 16, weight: .semibold)
    }
    
    private let titleTextField = UITextField().then {
        $0.borderStyle = .roundedRect
        $0.attributedPlaceholder = NSAttributedString(string: "제목을 입력하세요", attributes: [NSAttributedString.Key.foregroundColor : UIColor.systemGray])
        $0.backgroundColor = .white
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
        
        print("WordSetCreateViewController")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addNotificationObserver()
        titleTextField.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeNotificationObserver()
        titleTextField.resignFirstResponder()
    }
        
    private func configureUI() {
        view.backgroundColor = .secondarySystemBackground
        
        [
            titleLabel,
            titleTextField,
            createButton,
            cancelButton
        ].forEach { view.addSubview($0) }

        titleLabel.snp.makeConstraints {
            $0.top.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-10)
        }
        
        titleTextField.snp.makeConstraints {
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(5)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-5)
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
        }
        
        createButton.snp.makeConstraints {
            $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-10)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-10)
            $0.leading.equalTo(view.snp.centerX).offset(10)
        }
        
        cancelButton.snp.makeConstraints {
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(10)
            $0.bottom.equalTo(createButton)
            $0.trailing.equalTo(view.snp.centerX).offset(-10)
        }
    }
        
    private func bind() {
        createButton.rx.tap
            .bind(
                with: self,
                onNext: { vc, _ in
                    vc.viewModel.create(vc, title: vc.titleTextField.text)
                }
            )
            .disposed(by: disposeBag)
        
        cancelButton.rx.tap
            .bind(
                with: self,
                onNext: { vc, _ in
                    vc.viewModel.cancel(vc)
                }
            )
            .disposed(by: disposeBag)
        
        titleTextField.rx.controlEvent([.editingDidEndOnExit])
            .bind(
                with: self,
                onNext: { vc, _ in
                    vc.viewModel.create(vc, title: vc.titleTextField.text)
                }
            )
            .disposed(by: disposeBag)
    }
    
    private func addNotificationObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    private func removeNotificationObserver() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc
    private func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let height = keyboardFrame.cgRectValue.height - view.safeAreaInsets.bottom
            
            UIView.animate(withDuration: 0.3) { [unowned self] in
                createButton.snp.updateConstraints {
                    $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-10 - height)
                }
                view.layoutIfNeeded()
            }
        }
    }
    
    @objc
    private func keyboardWillHide(_ notification: Notification) {
        UIView.animate(withDuration: 0.3) { [unowned self] in
            createButton.snp.updateConstraints {
                $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-10)
            }
            view.layoutIfNeeded()
        }
    }
}

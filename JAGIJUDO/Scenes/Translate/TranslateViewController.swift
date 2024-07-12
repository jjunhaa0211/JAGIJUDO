/// 번역기 아직 연동 안됨
import SnapKit
import UIKit
import Alamofire

final public class TranslateViewController: UIViewController {
    
    struct Dependency {
        let viewModel: TranslateViewModel
    }
    
    private let viewModel: TranslateViewModel
    private var sourceLanguage: Language = .ko
    private var targetLanguage: Language = .en
    
    private lazy var sourceLanguageButton = UIButton().then {
        $0.setTitle(sourceLanguage.title, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 15.0, weight: .semibold)
        $0.setTitleColor(.label, for: .normal)
        $0.backgroundColor = .systemBackground
        $0.layer.cornerRadius = 9.0
        
        $0.addTarget(self, action: #selector(didTapSourceLanguageButton), for: .touchUpInside)
    }
    
    private lazy var targetLangugeButton = UIButton().then {
        $0.setTitle(targetLanguage.title, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 15.0, weight: .semibold)
        $0.setTitleColor(.label, for: .normal)
        $0.backgroundColor = .systemBackground
        $0.layer.cornerRadius = 9.0
        
        $0.addTarget(self, action: #selector(didTapTargetLanguageButton), for: .touchUpInside)
    }
    
    private lazy var buttonStackView: UIStackView = UIStackView().then {
        $0.distribution = .fillEqually
        $0.spacing = 8.0
        
        $0.addArrangedSubview(sourceLanguageButton)
        $0.addArrangedSubview(targetLangugeButton)
    }
    
    private lazy var resultBaseView = UIView().then {
        $0.backgroundColor = .white
    }
    
    private lazy var resultLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 23.0, weight: .bold)
        $0.textColor = UIColor.mainTintColor
        $0.text = "Hello"
        $0.numberOfLines = 0
    }
    
    private lazy var bookmarkButton = UIButton().then {
        $0.setImage(UIImage(systemName: "bookmark"), for: .normal)
    }
    
    @objc func didTapBookmarkButton() {
        guard
            let sourceText = sourceLabel.text,
            let translatedText = resultLabel.text,
            bookmarkButton.imageView?.image == UIImage(systemName: "bookmark") else { return }
        
        bookmarkButton.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
        
        let currentBookmarks: [Bookmark] = UserDefaults.standard.bookmarks
        let newBookmark = Bookmark(
            sourceLangue: sourceLanguage,
            translatedLanguage: targetLanguage,
            sourceText: sourceText,
            translatedText: translatedText
        )
        
        UserDefaults.standard.bookmarks = [newBookmark] + currentBookmarks
        
        print(UserDefaults.standard.bookmarks)
    }
    
    private lazy var copyButton = UIButton().then {
        $0.setImage(UIImage(systemName: "doc.on.doc"), for: .normal)
        $0.addTarget(self, action: #selector(didTapCopyButton), for: .touchUpInside)
    }
    
    @objc func didTapCopyButton() {
        UIPasteboard.general.string = resultLabel.text
    }
    
    private lazy var sourceLabelBaseButton = UIView().then {
        $0.backgroundColor = .systemBackground
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapSourceLabelBaseButton))
        view.addGestureRecognizer(tapGesture)
        
    }
    
    private lazy var sourceLabel = UILabel().then {
        $0.text = "텍스트 입력"
        $0.textColor = .tertiaryLabel
        $0.numberOfLines = 0
        $0.font = .systemFont(ofSize: 23.0, weight: .semibold)
    }
    
    init(dependency: Dependency) {
          self.viewModel = dependency.viewModel
          super.init(nibName: nil, bundle: nil)
      }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        bookmarkButton.addTarget(self, action: #selector(didTapBookmarkButton), for: .touchUpInside)
        
        view.backgroundColor = .secondarySystemBackground
        
        setupViews()
        
    }
}

extension TranslateViewController: SourceTextViewControllerDelegate {
    func didEnterText(_ sourceText: String) {
        if sourceText.isEmpty { return }
        
        sourceLabel.text = sourceText
        sourceLabel.textColor = .label
        
        bookmarkButton.setImage(UIImage(systemName: "bookmark"), for: .normal)
    }
}

private extension TranslateViewController {
    func setupViews() {
        [
            buttonStackView,
            resultBaseView,
            resultLabel,
            bookmarkButton,
            copyButton,
            sourceLabelBaseButton,
            sourceLabel
        ]
            .forEach { view.addSubview($0) }
        
        let defaultSpacing: CGFloat = 16.0
        
        buttonStackView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.equalToSuperview().inset(defaultSpacing)
            $0.trailing.equalToSuperview().inset(defaultSpacing)
            $0.height.equalTo(50.0)
        }
        
        resultBaseView.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.top.equalTo(buttonStackView.snp.bottom).offset(defaultSpacing)
            $0.bottom.equalTo(bookmarkButton.snp.bottom).offset(defaultSpacing)
        }
        
        resultLabel.snp.makeConstraints {
            $0.leading.equalTo(resultBaseView.snp.leading).inset(24.0)
            $0.trailing.equalTo(resultBaseView.snp.trailing).inset(24.0)
            $0.top.equalTo(resultBaseView.snp.top).inset(24.0)
        }
        
        bookmarkButton.snp.makeConstraints {
            $0.leading.equalTo(resultLabel.snp.leading)
            $0.top.equalTo(resultLabel.snp.bottom).offset(24.0)
            $0.width.height.equalTo(40.0)
        }
        
        copyButton.snp.makeConstraints {
            $0.leading.equalTo(bookmarkButton.snp.trailing).offset(8.0)
            $0.top.equalTo(bookmarkButton.snp.top)
            $0.width.height.equalTo(40.0)
        }
        
        sourceLabelBaseButton.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.top.equalTo(resultBaseView.snp.bottom).offset(defaultSpacing)
            $0.bottom.equalToSuperview().inset(tabBarController?.tabBar.frame.height ?? 0.0)
        }
        
        sourceLabel.snp.makeConstraints {
            $0.leading.equalTo(sourceLabelBaseButton.snp.leading).inset(24.0)
            $0.trailing.equalTo(sourceLabelBaseButton.snp.trailing).inset(24.0)
            $0.top.equalTo(sourceLabelBaseButton.snp.top).inset(24.0)
        }
    }
    
    @objc func didTapSourceLabelBaseButton() {
        let viewController = SourceTextViewController(delegate: self)
        present(viewController, animated: true)
    }
    
    @objc func didTapSourceLanguageButton() {
        didTapLanguageButton(type: .source)
    }
    
    @objc func didTapTargetLanguageButton() {
        didTapLanguageButton(type: .target)
    }
    
    func didTapLanguageButton(type: Type) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        Language.allCases.forEach { language in
            let action = UIAlertAction(title: language.title, style: .default) { [weak self] _ in
                switch type {
                case .source:
                    self?.sourceLanguage = language
                    self?.sourceLanguageButton.setTitle(language.title, for: .normal)
                case .target:
                    self?.targetLanguage = language
                    self?.targetLangugeButton.setTitle(language.title, for: .normal)
                }
            }
            alertController.addAction(action)
        }
        
        let cancelAction = UIAlertAction(title: "취소하기", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
    }
}

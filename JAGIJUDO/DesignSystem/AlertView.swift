import UIKit
import SnapKit
import Then

final class AlertView: UIView {
    static let shared = AlertView()
    
    private let alertView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 16.0
        $0.layer.cornerCurve = .continuous
    }
    
    private let alertLabel = UILabel().then {
        $0.textColor = .black
        $0.font = .systemFont(ofSize: 18.0, weight: .semibold)
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }
    
    private let subTitleLabel = UILabel().then {
        $0.textColor = .black
        $0.font = .systemFont(ofSize: 16.0, weight: .medium)
        $0.numberOfLines = 2
        $0.textAlignment = .center
    }
    
    private let backgroundView = UIView().then {
        $0.backgroundColor = .init(UIColor(white: 0, alpha: 0.4))
    }
    
    private lazy var backgroundButton = UIButton().then {
        $0.addTarget(self, action: #selector(okButtonDidTap), for: .touchUpInside)
        $0.backgroundColor = .clear
    }
    
    private lazy var okButton = UIButton().then {
        $0.addTarget(self, action: #selector(okButtonDidTap), for: .touchUpInside)
        $0.setTitle("확인", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.setTitleColor(.systemGray, for: .highlighted)
        $0.titleLabel?.font = .systemFont(ofSize: 16.0, weight: .semibold)
        $0.backgroundColor = .systemBlue
        $0.layer.cornerRadius = 8
        $0.layer.cornerCurve = .continuous
        $0.contentMode = .scaleAspectFit
    }
    
    private let checkMarkImageView = UIImageView().then {
        $0.image = UIImage(systemName: "checkmark.circle")?.withTintColor(.systemGreen, renderingMode: .alwaysOriginal)
        $0.contentMode = .scaleToFill
    }
    
    private let xMarkImageView = UIImageView().then {
        $0.image = UIImage(systemName: "xmark.circle")?.withTintColor(.systemRed, renderingMode: .alwaysOriginal)
        $0.contentMode = .scaleToFill
    }
    
    convenience private init() {
        self.init(frame: UIScreen.main.bounds)
    }
    
    required internal init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    class func show(_ text: String = "", _ subTitle: String = "") {
        DispatchQueue.main.async {
            shared.showAlert(text, subTitle)
        }
    }
    
    class func showCheckMark(_ text: String = "", _ subTitle: String = "") {
        DispatchQueue.main.async {
            shared.setCheckMarkImageView(text, subTitle)
        }
    }
    
    class func showXMark(_ text: String = "", _ subTitle: String = "") {
        DispatchQueue.main.async {
            shared.setXMarkImageView(text, subTitle)
        }
    }
    
    private func hiddenImageViews() {
        checkMarkImageView.isHidden = true
        xMarkImageView.isHidden = true
    }
    
    private func setCheckMarkImageView(_ text: String = "", _ subTitle: String = "") {
        hiddenImageViews()
        checkMarkImageView.isHidden = false
        checkMarkImageView.image = UIImage(systemName: "checkmark.circle")?.withTintColor(.systemGreen, renderingMode: .alwaysOriginal)
        alertLabel.text = text
        subTitleLabel.text = subTitle
        setUI()
        checkMarkAnimation()
    }
    
    private func setXMarkImageView(_ text: String = "", _ subTitle: String = "") {
        hiddenImageViews()
        xMarkImageView.isHidden = false
        xMarkImageView.image = UIImage(systemName: "xmark.circle")?.withTintColor(.systemRed, renderingMode: .alwaysOriginal)
        alertLabel.text = text
        subTitleLabel.text = subTitle
        setUI()
        xMarkAnimation()
    }
    
    private func showAlert(_ text: String = "", _ subTitle: String = "") {
        alertLabel.text = text
        subTitleLabel.text = subTitle
        setUI()
        defaultAnimation()
    }
    
    // MARK: - Animation
    
    private func defaultAnimation() {
        UIView.animate(withDuration: 0.3) {
            self.alpha = 1
        }
    }
    
    private func checkMarkAnimation() {
        UIView.animate(withDuration: 0.3) {
            self.alpha = 1
        } completion: { [weak self] isCompleted in
            if isCompleted, let checkMarkImageView = self?.checkMarkImageView {
                UIView.transition(with: checkMarkImageView, duration: 0.5, options: .transitionFlipFromRight) {
                    checkMarkImageView.image = UIImage(systemName: "checkmark.circle.fill")?.withTintColor(.systemGreen, renderingMode: .alwaysOriginal)
                }
            }
        }
    }
    
    private func xMarkAnimation() {
        UIView.animate(withDuration: 0.3) {
            self.alpha = 1
        } completion: { [weak self] isCompleted in
            if isCompleted, let xMarkImageView = self?.xMarkImageView {
                UIView.transition(with: xMarkImageView, duration: 0.5, options: .transitionFlipFromRight) {
                    xMarkImageView.image = UIImage(systemName: "xmark.circle.fill")?.withTintColor(.systemRed, renderingMode: .alwaysOriginal)

                }
            }
        }
    }
    
    private func setUI() {
        alpha = 0
        
        [
            backgroundView,
            alertView,
            alertLabel,
            subTitleLabel,
            backgroundButton,
            okButton,
            checkMarkImageView,
            xMarkImageView
        ].forEach { self.addSubview($0) }
        
        backgroundView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
        
        alertView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(300)
        }
        
        alertLabel.snp.makeConstraints {
            $0.center.equalTo(alertView)
            $0.leading.greaterThanOrEqualTo(alertView.snp.leading).offset(10)
            $0.trailing.lessThanOrEqualTo(alertView.snp.trailing).offset(-10)
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(alertLabel.snp.bottom).offset(10)
            $0.leading.equalTo(alertView.snp.leading).offset(10)
            $0.trailing.equalTo(alertView.snp.trailing).offset(-10)
            $0.bottom.lessThanOrEqualTo(okButton.snp.top).offset(-10)
        }
        
        backgroundButton.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
        
        okButton.snp.makeConstraints {
            $0.leading.equalTo(alertView.snp.leading).offset(30)
            $0.trailing.equalTo(alertView.snp.trailing).offset(-30)
            $0.bottom.equalTo(alertView.snp.bottom).offset(-10)
        }
        
        checkMarkImageView.snp.makeConstraints {
            $0.width.height.equalTo(50)
            $0.centerX.equalTo(alertView)
            $0.bottom.equalTo(alertLabel.snp.top).offset(-20)
        }
        
        xMarkImageView.snp.makeConstraints {
            $0.width.height.equalTo(50)
            $0.centerX.equalTo(alertView)
            $0.bottom.equalTo(alertLabel.snp.top).offset(-20)
        }
        
        let mainWindow = UIApplication.shared.windows.first ?? UIWindow()
        mainWindow.addSubview(self)
    }
}


extension AlertView {
    @objc
    private func okButtonDidTap() {
        self.removeFromSuperview()
    }
}

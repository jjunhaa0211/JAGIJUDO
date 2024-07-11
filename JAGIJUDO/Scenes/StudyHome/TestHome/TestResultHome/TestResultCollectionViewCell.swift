import UIKit
import SnapKit

class TestResultCollectionViewCell: UICollectionViewCell {
    static let identifier = "TestResultCollectionViewCellIdentifier"
    
    private let cardView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        view.layer.cornerCurve = .continuous
        view.backgroundColor = .white
        view.layer.masksToBounds = false
        return view
    }()
    private let completeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .heavy)
        return label
    }()
    private let definitionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 35, weight: .semibold)
        return label
    }()
    private let meaningLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .gray
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 30, weight: .semibold)
        return label
    }()
    private lazy var speakButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "speaker.wave.2")?.withTintColor(.black, renderingMode: .alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(speak), for: .touchUpInside)
        button.contentMode = .scaleAspectFit
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        AudioImpl.shared.stop()
    }
    
    private func configureUI() {
        backgroundColor = .secondarySystemBackground
        addSubview(cardView)
        
        cardView.addSubview(completeLabel)
        cardView.addSubview(definitionLabel)
        cardView.addSubview(meaningLabel)
        cardView.addSubview(speakButton)
        
        cardView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.equalToSuperview().offset(10)
            $0.trailing.equalToSuperview().offset(-10)
            $0.bottom.equalToSuperview().offset(-20)
        }
        
        completeLabel.snp.makeConstraints {
            $0.leading.trailing.equalTo(definitionLabel)
            $0.bottom.equalTo(definitionLabel.snp.top).offset(-30)
        }
        
        definitionLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(5)
            $0.trailing.equalToSuperview().offset(-5)
            $0.centerY.equalToSuperview()
        }
        
        meaningLabel.snp.makeConstraints {
            $0.leading.trailing.equalTo(definitionLabel)
            $0.top.equalTo(definitionLabel.snp.bottom).offset(10)
        }
        
        speakButton.snp.makeConstraints {
            $0.bottom.trailing.equalToSuperview().offset(-10)
            $0.width.height.equalTo(45)
        }
    }
    
    
    func setItem(item: Word, _ section: Int) {
        definitionLabel.text = item.definition
        meaningLabel.text = item.meaning
        
        if section == 0 {
            completeLabel.text = "틀렸어요"
            completeLabel.textColor = .systemRed
        } else {
            completeLabel.text = "맞았어요"
            completeLabel.textColor = .systemGreen
        }
    }
    
    @objc
    private func speak() {
        if let text = definitionLabel.text {
            AudioImpl.shared.stop()
            AudioImpl.shared.speak(text: text)
        }
    }
}

import UIKit
import Then
import SnapKit

class WordListTableViewCell: UITableViewCell {
    static let identifier = "WordListTableViewCellIdentifier"
        
    private let cardView = UIView().then {
        $0.layer.cornerRadius = 8
        $0.layer.cornerCurve = .continuous
        $0.backgroundColor = .white
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowRadius = 2
        $0.layer.shadowOpacity = 0.5
        $0.layer.shadowOffset = CGSize(width: 1, height: 1)
        $0.layer.masksToBounds = false
    }
    
    private let flipCardView = UIView().then {
        $0.isHidden = true
        $0.layer.cornerRadius = 8
        $0.layer.cornerCurve = .continuous
        $0.backgroundColor = .systemPink
        
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowRadius = 2
        $0.layer.shadowOpacity = 0.5
        $0.layer.shadowOffset = CGSize(width: 1, height: 1)
        $0.layer.masksToBounds = false
    }
    
    private let definitionLabel = UILabel().then {
        $0.textAlignment = .center
        $0.textColor = .black
        $0.font = .systemFont(ofSize: 20, weight: .bold)
    }
    
    private let flipDefinitionLabel = UILabel().then {
        $0.textAlignment = .center
        $0.textColor = .black
        $0.font = .systemFont(ofSize: 18, weight: .bold)
    }
    
    private let flipMeaningLabel = UILabel().then {
        $0.textAlignment = .center
        $0.textColor = .black
        $0.font = .systemFont(ofSize: 18, weight: .medium)
    }
    
    private let checkMarkImageView: UIImageView = {
        let imageView = UIImageView(image: _checkmark)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.isHidden = true
        return imageView
    }()
    
    private let xMarkImageView: UIImageView = {
        let imageView = UIImageView(image: _xmarkRed)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.isHidden = true
        return imageView
    }()
        
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
        self.backgroundColor = .secondarySystemBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    private func configureUI() {
        backgroundColor = _backgroundColor
        [
            cardView,
            flipCardView,
            checkMarkImageView,
            xMarkImageView
        ].forEach { self.addSubview($0) }
        
        cardView.addSubview(definitionLabel)
        
        flipCardView.addSubview(flipDefinitionLabel)
        flipCardView.addSubview(flipMeaningLabel)
        
        cardView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(2)
            $0.leading.equalToSuperview().offset(5)
            $0.trailing.equalToSuperview().offset(-5)
            $0.bottom.equalToSuperview().offset(-2)
            $0.height.equalTo(60)
        }
        
        flipCardView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(2)
            $0.leading.equalToSuperview().offset(5)
            $0.trailing.equalToSuperview().offset(-5)
            $0.bottom.equalToSuperview().offset(-2)
            $0.height.equalTo(60)
        }
        
        definitionLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.leading.equalToSuperview().offset(50)
            $0.trailing.equalToSuperview().offset(-50)
        }
        
        flipDefinitionLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(5)
            $0.leading.equalToSuperview().offset(50)
            $0.trailing.equalToSuperview().offset(-50)
        }
        
        flipMeaningLabel.snp.makeConstraints {
            $0.top.equalTo(flipDefinitionLabel.snp.bottom).offset(5)
            $0.leading.trailing.equalTo(flipDefinitionLabel)
        }
        
        checkMarkImageView.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-15)
            $0.top.equalToSuperview().offset(10)
            
            $0.width.height.equalTo(15)
        }
        
        xMarkImageView.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-15)
            $0.top.equalToSuperview().offset(10)
            
            $0.width.height.equalTo(15)
        }
    }
    
    func setItem(item: Word) {
        definitionLabel.text = item.definition
        flipDefinitionLabel.text = item.definition
        flipMeaningLabel.text = item.meaning
        
        setComplete(item.complete)
    }
    
    private func setComplete(_ complete: Int16) {
        switch complete {
        case 1:
            xMarkImageView.isHidden = false
            checkMarkImageView.isHidden = true
        case 2:
            xMarkImageView.isHidden = true
            checkMarkImageView.isHidden = false
        default:
            xMarkImageView.isHidden = true
            checkMarkImageView.isHidden = true
        }
    }
    
    // MARK: - Action
    
    func flip() {
        UIView.transition(with: cardView, duration: 0.3, options: .transitionCrossDissolve) { [weak self] in
            if let cardView = self?.cardView {
                cardView.isHidden = !cardView.isHidden
            }
        }
        
        UIView.transition(with: flipCardView, duration: 0.3, options: .transitionCrossDissolve) { [weak self] in
            if let flipCardView = self?.flipCardView {
                flipCardView.isHidden = !flipCardView.isHidden
            }
        }
    }
}

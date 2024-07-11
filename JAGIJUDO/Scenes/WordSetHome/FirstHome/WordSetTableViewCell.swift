import UIKit
import SnapKit
import Then

class WordSetTableViewCell: UITableViewCell {
    static let identifier = "WordSetTableViewCellIdentifier"
        
    private let cardView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 8
        $0.layer.cornerCurve = .continuous
        $0.layer.masksToBounds = false
    }
    
    private let titleLabel = UILabel().then {
        $0.textColor = .black
        $0.textAlignment = .left
        $0.font = .systemFont(ofSize: 30, weight: .bold)
    }
    
    private let dateLabel = UILabel().then {
        $0.textColor = .systemGray
        $0.textAlignment = .right
        $0.font = .systemFont(ofSize: 10)
    }
        
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Configure
    
    private func configureUI() {
        backgroundColor = .secondarySystemBackground
        
        addSubview(cardView)
        cardView.addSubview(titleLabel)
        cardView.addSubview(dateLabel)
        
        cardView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(5)
            $0.leading.equalToSuperview().offset(10)
            $0.trailing.equalToSuperview().offset(-10)
            $0.bottom.equalToSuperview().offset(-5)
            $0.height.equalTo(80)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(5)
            $0.leading.equalToSuperview().offset(10)
            $0.trailing.equalToSuperview().offset(-10)
        }
        
        dateLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-5)
            $0.bottom.equalToSuperview().offset(-5)
        }
    }
    
    func setItem(item: WordSet) {
        titleLabel.text = item.title
        dateLabel.text = DateHelper.shared.format(item.insertDate)
    }
}

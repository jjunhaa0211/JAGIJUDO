import SnapKit
import UIKit
import Then

final class BookmarkTextStackView: UIStackView {
    private let type: Type
    private let language: Language
    private let text: String
    
    private lazy var languageLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 13.0, weight: .medium)
        $0.textColor = type.color
        $0.text = language.title
    }
    
    private lazy var textLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16.0, weight: .bold)
        $0.textColor = type.color
        $0.text = text
        $0.numberOfLines = 0
    }
    
    init(language: Language, text: String, type: Type) {
        self.language = language
        self.text = text
        self.type = type
        
        super.init(frame: .zero)
        
        setup()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        axis = .vertical
        distribution = .equalSpacing
        spacing = 4.0
        [languageLabel, textLabel].forEach { addArrangedSubview($0) }
    }
}

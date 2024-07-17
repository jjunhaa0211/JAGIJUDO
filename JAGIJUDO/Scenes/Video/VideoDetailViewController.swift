import UIKit
import SnapKit
import Then
import AVKit

class VideoDetailViewController: UIViewController {
    private var data: [String: Any]
    private var playerViewController = AVPlayerViewController().then {
        $0.view.isAccessibilityElement = true
        // 비디오 설명을 접근성 라벨로 추가
        $0.view.accessibilityLabel = "비디오 재생 중, 자세한 내용은 아래 설명을 참고하세요."
    }
    private var player: AVPlayer?
    private var descriptionLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.font = UIFont.systemFont(ofSize: 16)
        $0.textColor = .darkGray
        $0.isAccessibilityElement = true
        // 설명 접근성 라벨 업데이트
        $0.accessibilityLabel = "비디오 설명"
    }
    private var messageTableView = UITableView().then {
        $0.register(MessageTableViewCell.self, forCellReuseIdentifier: "MessageCell")
        $0.isAccessibilityElement = true
        $0.accessibilityLabel = "대화 내용 테이블"
    }
    private var languageSwitch = UISwitch().then {
        $0.onTintColor = .systemPink
        $0.isAccessibilityElement = true
        $0.accessibilityLabel = "언어 전환 스위치"
        $0.accessibilityHint = "스위치를 눌러 언어를 전환합니다. 온 상태는 한국어, 오프 상태는 영어입니다."
    }
    private var isKorean: Bool = false

    init(data: [String: Any]) {
        self.data = data
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        setupConstraints()
        setupVideoPlayer()
        loadData()
    }

    private func setupViews() {
        view.addSubview(playerViewController.view)
        view.addSubview(descriptionLabel)
        view.addSubview(messageTableView)
        view.addSubview(languageSwitch)

        messageTableView.delegate = self
        messageTableView.dataSource = self
        languageSwitch.addTarget(self, action: #selector(toggleLanguage), for: .valueChanged)
    }

    private func setupConstraints() {
        playerViewController.view.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(view.frame.height / 3)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(playerViewController.view.snp.bottom).offset(8)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
        }

        languageSwitch.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(8)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
        
        messageTableView.snp.makeConstraints { make in
            make.top.equalTo(languageSwitch.snp.bottom).offset(8)
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }

    private func setupVideoPlayer() {
        if let urlString = data["videoURL"] as? String, let url = URL(string: urlString) {
            player = AVPlayer(url: url)
            playerViewController.player = player
            addChild(playerViewController)
            playerViewController.view.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height / 3)
            playerViewController.didMove(toParent: self)
            // 비디오에 대한 설명을 접근성 라벨에 추가
            playerViewController.view.accessibilityLabel = data["description"] as? String ?? "비디오 재생 중"
        }
    }

    private func loadData() {
        descriptionLabel.text = data["description"] as? String
        descriptionLabel.accessibilityLabel = data["description"] as? String ?? "비디오 설명이 없습니다."
        messageTableView.reloadData()
    }

    @objc private func toggleLanguage() {
        isKorean = languageSwitch.isOn
        messageTableView.reloadData()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        player?.play()
    }
}

extension VideoDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let key = isKorean ? "kr-messages" : "en-messages"
        return (data[key] as? [[String: String]])?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as! MessageTableViewCell
        let key = isKorean ? "kr-messages" : "en-messages"
        if let message = (data[key] as? [[String: String]])?[indexPath.row] {
            cell.configure(with: message)
        }
        return cell
    }
}

class MessageTableViewCell: UITableViewCell {
    var messageLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.textColor = .black
    }

    func configure(with message: [String: String]) {
        guard let sender = message["sender"], let text = message["message"] else { return }
        messageLabel.textAlignment = sender == "Person A" ? .left : .right
        messageLabel.text = text
        messageLabel.isAccessibilityElement = true
        // 각 메시지의 발신자와 내용을 명확하게 읽도록 설정
        messageLabel.accessibilityLabel = "\(sender)가 말했습니다: \(text)"
        messageLabel.snp.remakeConstraints { make in
            make.top.bottom.equalToSuperview().inset(10)
            if sender == "Person A" {
                make.left.equalToSuperview().inset(16)
                make.right.lessThanOrEqualToSuperview().inset(100)
            } else {
                make.right.equalToSuperview().inset(16)
                make.left.greaterThanOrEqualToSuperview().inset(100)
            }
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(messageLabel)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

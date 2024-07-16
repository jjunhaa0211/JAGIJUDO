import UIKit
import SnapKit
import Then
import AVKit

class VideoDetailViewController: UIViewController {
    private var data: [String: Any]
    private var playerViewController = AVPlayerViewController()
    private var player: AVPlayer?
    private var descriptionLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.font = UIFont.systemFont(ofSize: 16)
        $0.textColor = .darkGray
    }
    private var messageTableView = UITableView().then {
        $0.register(MessageTableViewCell.self, forCellReuseIdentifier: "MessageCell")
    }

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
        
        messageTableView.delegate = self
        messageTableView.dataSource = self
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
        
        messageTableView.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(8)
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
        }
    }

    private func loadData() {
        descriptionLabel.text = data["description"] as? String
        messageTableView.reloadData()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        player?.play()
    }
}

extension VideoDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (data["messages"] as? [[String: String]])?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as! MessageTableViewCell
        if let message = (data["messages"] as? [[String: String]])?[indexPath.row] {
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
//        messageLabel.text = "\(sender): \(text)"
        messageLabel.text = "\(text)"


        if sender == "Person A" {
            messageLabel.textAlignment = .left
            messageLabel.snp.remakeConstraints {
                $0.top.bottom.equalToSuperview().inset(10)
                $0.left.equalToSuperview().inset(16)
                $0.right.lessThanOrEqualToSuperview().inset(100)
            }
        } else {
            messageLabel.textAlignment = .right
            messageLabel.snp.remakeConstraints {
                $0.top.bottom.equalToSuperview().inset(10)
                $0.right.equalToSuperview().inset(16)
                $0.left.greaterThanOrEqualToSuperview().inset(100)
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

import UIKit
import SnapKit
import Then

final public class VideoViewController: UIViewController {
    
    struct Dependency {
        let viewModel: VideoViewModel
    }
    
    private var viewModel: VideoViewModel
    private var tableView = UITableView.init(frame: CGRect.zero, style: .grouped)
    private let sectionHeader = ["일상", "비지니스"]
    private let cellDataSource = [["아빠 상어를 만났을 때", "엄마 상어를 만났을 때", "아기 상어를 만났을 때"], ["상사에게 포커페이스를 유지할 때", "프로젝트가 하기 싫을 때"]]

    public override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationItem()
        setupTableView()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "강의"
    }

    func setupNavigationItem() {
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.backgroundColor = .white
            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
        } else {
            navigationController?.navigationBar.barTintColor = .white
        }
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "SettingCell")
        view.addSubview(tableView)
        
        setupConstraints()
        
        tableView.backgroundColor = .white
        
        tableView.rowHeight = 60.0
    }

    func setupConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    init(dependency: Dependency) {
        self.viewModel = dependency.viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension VideoViewController: UITableViewDelegate, UITableViewDataSource {

    public func numberOfSections(in tableView: UITableView) -> Int {
        return sectionHeader.count
    }

    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()

        let label = UILabel().then {
            $0.text = sectionHeader[section]
            $0.font = UIFont.systemFont(ofSize: 20, weight: .bold)
            $0.textColor = .black
        }

        headerView.addSubview(label)
        label.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.centerY.equalToSuperview()
        }

        return headerView
    }

    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44.0
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellDataSource[section].count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingCell", for: indexPath)

        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = cellDataSource[indexPath.section][indexPath.row]

        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let videoData = [
            "videoURL": "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
            "description": "Detailed description of the video.",
            "messages": [      
                ["sender": "Person A", "message": "Hello, how are you?"],
                ["sender": "Person B", "message": "I'm good, thanks! And you?"],
            ]
        ] as [String : Any]
        
        let detailVC = VideoDetailViewController(data: videoData)
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
}


class textViewcontroller: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .red
    }
}

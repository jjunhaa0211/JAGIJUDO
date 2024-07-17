import UIKit
import SnapKit
import Then

final public class VideoViewController: UIViewController {
    
    
    struct Dependency {
        let viewModel: VideoViewModel
    }
    
    private struct Constants {
        static let sectionTitles = ["일상", "비지니스"]
        static let cellHeight: CGFloat = 60.0
        static let headerHeight: CGFloat = 44.0
        static let headerFont = UIFont.systemFont(ofSize: 20, weight: .bold)
        static let cellIdentifier = "SettingCell"
    }
    
    private let viewModel: VideoViewModel
    private let tableView = UITableView(frame: .zero, style: .grouped)
    private let cellDataSource = [
        ["Just head back that way.", "What took you so long?"],
        ["Maybe there's another flight we can catch."]
    ]
    
    init(dependency: Dependency) {
        self.viewModel = dependency.viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        setupNavigationItem()
        setupTableView()
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "강의"
        view.isAccessibilityElement = false
    }
    
    private func setupNavigationItem() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.cellIdentifier)
        tableView.rowHeight = Constants.cellHeight
        tableView.backgroundColor = .systemBackground
        tableView.isAccessibilityElement = true
        tableView.accessibilityLabel = "강의 목록"
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension VideoViewController: UITableViewDelegate, UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return Constants.sectionTitles.count
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        let label = UILabel().then {
            $0.text = Constants.sectionTitles[section]
            $0.font = Constants.headerFont
            $0.textColor = .black
            $0.isAccessibilityElement = true
            $0.accessibilityLabel = "\(Constants.sectionTitles[section]) 섹션"
        }
        headerView.addSubview(label)
        label.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.centerY.equalToSuperview()
        }
        return headerView
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return Constants.headerHeight
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellDataSource[section].count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier, for: indexPath)
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = cellDataSource[indexPath.section][indexPath.row]
        cell.isAccessibilityElement = true
        cell.accessibilityLabel = "\(cell.textLabel?.text ?? "상세 항목")"
        cell.accessibilityHint = "탭하여 상세 정보 보기"
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let videoData = [
            [
                "videoURL": "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
                "description": "실제 있었던 일을 바탕으로 만들어진 오늘의 대화 상황은 기차역에서 벌어지는데요. 가처룰 탈 때 차량(car)과 좌석 번호를 알아야 하는데, 익숙하지 못한 외국인이 헤매고 있었죠. 방향과 위치를 가리키는 말을 알아볼까요?",
                "en-messages": [
                    ["sender": "Person A", "message": "Excuse me, can you help me?"],
                    ["sender": "Person A", "message": "I can't seem to find my seat."],
                    ["sender": "Person B", "message": "Sure, it looks like you're in car number 8"],
                    ["sender": "Person B", "message": "but this is car number 1"],
                    ["sender": "Person A", "message": "Oh, no wonder I can't find it"],
                    ["sender": "Person A", "message": "How do I get to car number 8"],
                    ["sender": "Person B", "message": "You'll need to walk all the way down the platform."],
                    ["sender": "Person A", "message": "I see. You mean, until i reach cat number 8,"],
                    ["sender": "Person A", "message": "right?"],
                    ["sender": "Person B", "message": "Coorrect. It's at the ohter end of the train"],
                    ["sender": "Person B", "message": "Just head back that way"]
                ],
                "kr-messages": [
                    ["sender": "Person A", "message": "실례합니다, 저 좀 도와주실 수 있나요?"],
                    ["sender": "Person A", "message": "제 자리를 찾을 수가 없네요."],
                    ["sender": "Person B", "message": "네, 8호차 같은데 지금 1호차에 계세요."],
                    ["sender": "Person B", "message": "그러니 찾지를 못하죠"],
                    ["sender": "Person A", "message": "아, 그래서 찾지 못했군요."],
                    ["sender": "Person A", "message": "8호차는 어떻게 가나요?"],
                    ["sender": "Person B", "message": "플랫폼 끝까지 걸어가셔야 합니다."],
                    ["sender": "Person A", "message": "알겠습니다. 8호차까지 계속 가면 되는 거죠?"],
                    ["sender": "Person A", "message": "그렇죠?"],
                    ["sender": "Person B", "message": "맞습니다. 기차의 다른 쪽 끝에 있어요."],
                    ["sender": "Person B", "message": "그쪽으로 돌아가세요."]
                ]
            ],
            [
                "videoURL": "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
                "description": "자신이 탈 기차를 겨우 제대로 탄 켈리는 기다리고 있던 일행인 줄리를 만납니다. '왜 이렇게 오래 걸렸는지'를 영어로 어떻게 물어보면 될까요?",
                "en-messages": [
                    ["sender": "Person A", "message": "There you are! What took you so long?"],
                    ["sender": "Person B", "message": "Sorry, I almost missed the train because I got on the wrong car."],
                    ["sender": "Person A", "message": "Oh no, really?"],
                    ["sender": "Person B", "message": "Yeah, but thankfully a lady helped me out. She told me I was on the wrong car and directed me to the right one"],
                    ["sender": "Person A", "message": "Nice! I'm glad you didn't miss the train"],
                    ["sender": "Person B", "message": "Me too. I was worried I'd have to wait for the next one"]
                ],
                "kr-messages": [
                    ["sender": "Person A", "message": "거기 있었네! 왜 이렇게 오래 걸렸어?"],
                    ["sender": "Person B", "message": "미안, 거의 기차를 놓칠 뻔 했어. 잘못된 칸에 탔거든."],
                    ["sender": "Person A", "message": "진짜? 오마이갓"],
                    ["sender": "Person B", "message": "응, 다행히 한 여자분이 도와줬어. 잘못된 칸에 탔다고 하시더니 맞는 칸을 알려주셨어"],
                    ["sender": "Person A", "message": "잘됐다! 기차를 놓치지 않아서 다행이야"],
                    ["sender": "Person B", "message": "나도 다행이라고 생각해. 다음 기차를 기다려야 할까 봐 걱정했어."]
                ]
            ],
            [
                "videoURL": "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
                "description": "여행에서 가장 황당한 경우 중 하나가 바로 악천후 등의 이유로 항공편이 취소되는 일 아닐까요? 오늘 대화는 다음 날 아침 회의에 참석하기 위해 하와이로 출장을 앞둔 두 사람의 이야기 입니다.",
                "en-messages": [
                    ["sender": "Person A", "message": "Emily, did you hear that? Our flight might get canceled due to the storm!"],
                    ["sender": "Person B", "message": "Oh no, seriously? We can't afford to miss this flight; we have that meeting tomorrow morning"],
                    ["sender": "Person A", "message": "I know, it's stressing me out."],
                    ["sender": "Person A", "message": "I've been looking forward to this trip for weeks."],
                    ["sender": "Person B", "message": "Let's call the airline and see if they can give us any updates."],
                    ["sender": "Person B", "message": "Maybe there's another flight we can catch."],
                    ["sender": "Person A", "message": "Good idea. I'll give them a ring right now"]
                ],
                "kr-messages": [
                    ["sender": "Person A", "message": "에밀리, 들었어? 폭풍 때문에 우리 비행기가 취소될 수도 있대!"],
                    ["sender": "Person B", "message": "진짜? 우리는 이 비행기를 놓칠 수 없어. 내일 아침에 회의가 있으니까"],
                    ["sender": "Person A", "message": "알아, 난 정말 스트레스 받아."],
                    ["sender": "Person A", "message": "나 이 여행 기다렸었는데 몇 주 동안."],
                    ["sender": "Person B", "message": "항공사에 전화해서 업데이트를 받아보자."],
                    ["sender": "Person B", "message": "다른 비행기를 잡을 수 있을지도 몰라."],
                    ["sender": "Person A", "message": "좋은 생각이야. 지금 전화해볼게."]
                ]
            ]
        ]
        let detailVC = VideoDetailViewController(data: videoData[indexPath.row])
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
}

class TextViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
    }
}

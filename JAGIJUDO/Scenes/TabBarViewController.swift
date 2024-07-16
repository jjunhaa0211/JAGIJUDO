import UIKit
import Then

final class TabBarViewController: UITabBarController {

    let translateViewControllerFactory: () -> TranslateViewController
    let wordSetViewControllerFactory: () -> WordSetViewController
    let bookmarkViewControllerFactory: () -> BookmarkListViewController
    let videoViewControllerFactory: () -> VideoViewController
    let audioViewControllerFactory: () -> AudioViewController

    init(
        translateViewControllerFactory: @escaping () -> TranslateViewController,
        wordSetViewControllerFactory: @escaping () -> WordSetViewController,
        bookmarkViewControllerFactory: @escaping () -> BookmarkListViewController,
        videoViewControllerFactory: @escaping () -> VideoViewController,
        audioViewControllerFactory: @escaping () -> AudioViewController
    ) {
        self.translateViewControllerFactory = translateViewControllerFactory
        self.wordSetViewControllerFactory = wordSetViewControllerFactory
        self.bookmarkViewControllerFactory = bookmarkViewControllerFactory
        self.videoViewControllerFactory = videoViewControllerFactory
        self.audioViewControllerFactory = audioViewControllerFactory
        
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBar.tintColor = .systemPink

        let translateViewController = translateViewControllerFactory().then {
            $0.tabBarItem = UITabBarItem(
                title: "번역",
                image: UIImage(systemName: "mic"),
                selectedImage: UIImage(systemName: "mic.fill")
            )
        }
        
        let wordSetViewController = wordSetViewControllerFactory().then {
            $0.tabBarItem = UITabBarItem(
                title: "단어장",
                image: UIImage(systemName: "book"),
                selectedImage: UIImage(systemName: "book.fill")
            )
        }
        
        let bookmarkViewController = bookmarkViewControllerFactory().then {
            $0.tabBarItem = UITabBarItem(
                title: "즐겨찾기",
                image: UIImage(systemName: "bookmark"),
                selectedImage: UIImage(systemName: "bookmark.fill")
            )
        }
        
        let videoViewController = videoViewControllerFactory().then {
            $0.tabBarItem = UITabBarItem(
                title: "강의",
                image: UIImage(systemName: "sparkles.tv"),
                selectedImage: UIImage(systemName: "sparkles.tv.fill")
            )
        }
        
        let audioViewController = audioViewControllerFactory().then {
            $0.tabBarItem = UITabBarItem(
                title: "대화",
                image: UIImage(systemName: "speaker"),
                selectedImage: UIImage(systemName: "speaker.fill")
            )
        }

        viewControllers = [
            translateViewController,
            wordSetViewController,
            bookmarkViewController,
            videoViewController,
            audioViewController
        ]
        self.selectedIndex = 0

        self.tabBar.backgroundColor = .systemBackground
    }
}

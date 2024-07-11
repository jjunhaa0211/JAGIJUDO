import UIKit
import Then

final class TabBarViewController: UITabBarController {

    let translateViewControllerFactory: () -> TranslateViewController
    let wordSetViewControllerFactory: () -> WordSetViewController
//    let bookmarkViewControllerFactory: () -> BookmarkListViewController

    init(
        translateViewControllerFactory: @escaping () -> TranslateViewController,
        wordSetViewControllerFactory: @escaping () -> WordSetViewController
    ) {
        self.translateViewControllerFactory = translateViewControllerFactory
        self.wordSetViewControllerFactory = wordSetViewControllerFactory
//        self.bookmarkViewControllerFactory = bookmarkViewControllerFactory
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

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

//        let bookmarkViewController = UINavigationController(rootViewController: bookmarkViewControllerFactory()).then {
//            $0.tabBarItem = UITabBarItem(
//                title: "즐겨찾기",
//                image: UIImage(systemName: "star"),
//                selectedImage: UIImage(systemName: "star.fill")
//            )
//        }

        viewControllers = [
            translateViewController,
            wordSetViewController
//            bookmarkViewController
        ]

        self.tabBar.backgroundColor = .systemBackground
    }
}

import UIKit

class AudioViewModel {
    struct Dependency {
        let coordinator: Coordinator
    }
    
    private let coordinator: Coordinator
    
    init(coordinator: Coordinator) {
        self.coordinator = coordinator
    }
    
    func dismiss(_ viewController: UIViewController) {
        coordinator.dismiss(viewController: viewController, animated: true)
    }
}

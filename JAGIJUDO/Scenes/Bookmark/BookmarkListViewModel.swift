import Foundation
import RxSwift
import RxCocoa

final class BookmarkListViewModel {
    
    struct Input {
        let viewWillAppear: Observable<Void>
    }
    
    struct Output {
        let bookmarks: Driver<[Bookmark]>
    }
    
    private let disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        let bookmarks = input.viewWillAppear
            .flatMapLatest { _ -> Observable<[Bookmark]> in
                return Observable.just(UserDefaults.standard.bookmarks)
            }
            .asDriver(onErrorJustReturn: [])
        
        return Output(bookmarks: bookmarks)
    }
}

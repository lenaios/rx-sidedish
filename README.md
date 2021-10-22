# rx-sidedish

## 요약
- 반찬 리스트와 상세 정보를 보여주는 iOS App
- 목표 : Reactive Programming를 기반으로 한 RxSwift, RxCocoa 라이브러리를 학습하고 적용해보기
- 기간 : 2021.08

## App Architecture
![image](https://user-images.githubusercontent.com/75113784/131440085-11136c74-2f0a-4a65-8ed2-dab8a7940f52.png)

## 주로 고민한 내용
반찬의 카테고리(main, soup, side)에 따라 각각 API를 호출하고, 카테고리 순서를 보장하면서 해당 section을 reload 하기

- 카테고리 순서를 보장하기 위해 초기화 시, 미리 `SectionModel` 생성한다.

```swift
// SideDishViewModel.swift

init(
  repositoryService: RepositoryServiceType = SideDishRepositoryService(sessionManager: SessionManager.shared)) {
  self.repositoryService = repositoryService
  // ...
  var sections: [SectionModel] = []
  Category.allCases.forEach { category in
    sections.append(.init(header: "", category: category, items: []))
  }
  self.sections = sections
}
```

- API를 호출 후 응답받을 때 카테고리의 index를 next 이벤트의 값으로 방출한다.

```swift
var sectionUpdated = PublishSubject<IndexSet>()

func load() {
  let endpoints: [Endpoint.Path] = [.main, .soup, .side]
  endpoints.enumerated().forEach { (index, path) in
    repositoryService.fetch(endpoint: path, decodingType: SideDishes.self)
      .subscribe(onNext: { [weak self] data in
        guard let self = self else { return }
        let items = data.body
        self.sections[index].header = self.sections[index].category.rawValue
        self.sections[index].items = items
        self.sectionUpdated.onNext(IndexSet(integer: index)) // here!!
      })
      .disposed(by: disposeBag)
  }
}
```

- 이벤트를 받으면 IndexSet에 해당하는 section을 reload 한다. 이 때, main.sync로 수행하지 않으면 crash가 발생한다.

```swift
// ViewController.swift

viewModel.sectionUpdated
  .subscribe(onNext: { [weak self] data in
    guard let self = self else { return }
    DispatchQueue.main.sync {
      self.tableView.reloadSections(data, with: .automatic)
    }
  })
  .disposed(by: disposeBag)
}
```

### Unit test

네트워크 layer의 객체를 protocol로 추상화하고 테스트를 위한 Stub 객체를 정의한다.
```swift
protocol SessionManagerType {
  func request(with request: URLRequest) -> Observable<Data>
}

protocol RepositoryServiceType {
  
  var sessionManager: SessionManagerType { get }
  
  func fetch<T: Decodable>(endpoint: Endpoint.Path, decodingType: T.Type) -> Observable<T>
}

class SideDishViewModelTests: XCTestCase {
  
  var session: SessionManagerStub!
  var service: RepositoryServiceStub!
  var viewModel: SideDishViewModel!
  
  override func setUpWithError() throws {
    session = SessionManagerStub()
    service = RepositoryServiceStub(sessionManager: session)
    viewModel = SideDishViewModel(repositoryService: service)
  }
  
  override func tearDownWithError() throws {
    session = nil
    service = nil
    viewModel = nil
  }
  
  func testExample() throws {

    // given
    let disposeBag = DisposeBag()
    let promise = expectation(description: "promise")
    promise.assertForOverFulfill = false

    viewModel.sectionUpdated.subscribe { _ in
      promise.fulfill()
    }.disposed(by: disposeBag)

    // when
    viewModel.load()
    
    // then
    XCTAssert(service.didFetch)
    wait(for: [promise], timeout: 5.0)
  }
}
```

- [TDD](https://github.com/lenaios/rx-sidedish/blob/main/Markdown/TDD.md)

## Trouble shooting

- 문제 : 네트워크로부터 받아온 데이터로 테이블뷰를 업데이트 할 때 비동기(async)로 처리하면 crash 발생

    ```swift
    viewModel.sectionUpdated
      .subscribe(onNext: { [weak self] section in
        guard let self = self else { return }
        DispatchQueue.main.async {
          self.tableView.reloadSections(section, with: .automatic)
        }
      })
      .disposed(by: disposeBag)

    // fatal error!!
    Thread 1: "Invalid update: invalid number of rows in section 2. 
    The number of rows contained in an existing section after the update (8) 
    must be equal to the number of rows contained in that section 
    before the update (0), plus or minus the number of rows inserted 
    or deleted from that section (0 inserted, 0 deleted) and plus or minus 
    the number of rows moved into or out of that section (0 moved in, 0 moved out)."
    ```

- 원인 : table view를 업데이트 하는 동안 data source(section, row)가 변경(update)되어서 오류가 발생한다.
- 해결 : main.sync로 처리하도록 수정해서 해결
- 고찰  
    `.sync` 메서드는 현재 queue의 작업을 멈추고(wait) 클로저를 실행한다.  
    (dispatch) main queue는 serial queue 이므로 한 번에 하나의 closure를 실행한다.  
    따라서, main serial queue에서 main.sync를 사용하면 앱이 서로의 작업이 끝나기만을 기다리는 deadlock에 걸리게 된다.  
    main queue가 아닌 경우에는 main.sync를 사용해야 하는 상황이 존재할 수 있다.  
    위와 같이 비동기로 받아온 데이터를 테이블뷰에 업데이트 할 때, 현재 작업(main이 아닌 URLSession이 만든 thread)을 block 하도록 해야 정상적으로 동작한다.

- [관련 학습 내용](https://velog.io/@lena_/Concurrency-Programming#sync-async)

## 학습거리

- [MVVM Pattern](https://github.com/lenaios/rx-sidedish/blob/main/Markdown/MVVM.md)
- [RxSwift, RxCocoa](https://github.com/lenaios/rx-sidedish/blob/main/Markdown/Rx.md)
- Stack View
- Content Hugging Priority, Content Compression Resistance Priority

## Screenshots
<img src="https://user-images.githubusercontent.com/75113784/130393456-acdf5139-4cb8-4048-94e9-86153a73fbb3.png" width="40%"> <img src="https://user-images.githubusercontent.com/75113784/130393443-6c28c196-305d-43e1-9aa9-a80001c712ff.png" width="40%">

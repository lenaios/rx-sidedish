# ReactiveX

An API for asynchronous programming with observable stream.

Reactive eXtension의 약자. RxSwift는 Swift를 위한 API.

## Reactive Programming

OOP, FP(Functional Programming)과 같이 하나의 패러다임이다.

가장 큰 특징은 반응형(Reactive)이라는 부분인데, Observer에 비유해 이해하면 쉽다.
어떤 데이터 값의 변화를 관찰하다가, 데이터에 변화가 생기면 변화에 따른 로직을 수행하는 것.

이는 비동기 처리와 관련이 높은데 예를 들면, 서버에 API로 데이터를 요청하고 응답받은 데이터에 따라 UI를 업데이트 해주어야 할 때, 우리는 일반적으로 비동기로 처리한다.

- 클로저를 사용해서 콜백함수로 구현하거나,
- didSet과 같은 property observer를 사용하거나,
- NotificationCenter를 활용할 수도 있다.

외부 라이브러리 없이도 위와 같은 내부 API를 사용해서 비동기 프로그래밍을 할 수 있다.

하지만 위 방법들을 사용하면 비동기 작업들이 실행되는 순서를 보장할 수 없고 따라서, side effect가 발생할 수도 있다.

또한, 하나의 패러다임이 아니기 때문에 전체적인 코드 흐름을 이해하기도 어렵다.

Rx는 Reactive Programming을 위한 라이브러리로, 비동기 처리를 위한 여러 도구들을 제공한다.

유사하게 비동기 프로그래밍을 위해 Apple에서 제공하는 프레임워크 Combine도 있다.
가장 큰 차이는 Combine은 iOS 13부터, RxSwift는 iOS 8부터 사용 가능하다.

## RxSwift

### Observable

구독이 시작되면 이벤트를 전달하는 object.

- next
- completed : completed 이벤트가 발생하면 sequence가 종료된다.
- error : error 이벤트도 마찬가지로 sequence가 종료된다.

한 번 sequence가 종료되면 그 sequence에서는 더 이상 이벤트가 방출되지 않는다.

observable은 subscriber가 없으면 발생한 이벤트를 전송하지 않는다.

- of, from, just
- create

### subscribe

- subscribe는 escaping closure를 파라미터로 받는다.
- dispose, disposable : 구독을 종료할 때 사용하는 dispose, 작성하지 않으면 memory leak이 발생할 수 있다. 간편하게 사용하기 위해 DisposableBag class가 지원된다.
bag에 담아두면 class가 deinit 될 때 구독도 함께 deallocated 된다.
- Empty, Never, Range
    - Empty는 next 이벤트를 방출하지 않는다. completed는 방출된다.
    - Never는 어떠한 이벤트도 방출하지 않는다. completd 조차도. 그래서 sequence가 종료되지도 않는다.

### Traits: Single, Maybe, Completable

### Subject

**PublishSubject**

- Observable이면서 Observer, next event 방출
- PublishSubject는 현재 나를 subscribe하는 subscriber들에게만 이벤트를 emit 한다.
- subscriber는 subscribe한 시점 이후에 발생되는 이벤트만 전달받는다.

**BehaviorSubject**

- PublishSubject와 유사하지만, **차이점은 반드시 초기값을 갖고 생성**된다.
- 따라서 구독자에게 구독 시점의 가장 최근 이벤트를 전달한다.

### Relay

relay는 subject의 wrapper

error를 방출할 수 없다. onNext 대신 accept를 쓰고 value만을 방출한다. : 스트림이 종료되지 않을 것을 보장한다.

구독 이후의 value만을 방출한다.

## RxCocoa

RxSwift는 Swift를 extension 한 것이기 때문에 UIKit, Cocoa에 대해 알지 못한다.

UIKit와 Cocoa를 확장한 것이 RxCocoa 라이브러리이다.

### Binder

RxCocoa에서 제공하는, subscribe와 유사하지만, error 이벤트를 받지 않는다.

Binder는 데이터를 받아서 처리하기만 한다. = Data Consumer

```swift
UILabel.rx.text: Binder<String?>
```

### Traits: Control Event, Control Property, Driver

traits는 UI 처리에 특화된 Observable, 데이터 생산자에 해당하며 데이터 소비자인 Binder와 반대 개념이다.

MainScheduler에서 실행된다.

**Control Property**
- Control Property는 Observable 이면서 Observer. ex) UITextField.rx.text
- 시퀀스를 공유한다. = Observable.share.replay(1): 가장 최근 value 전달

**Driver**
- Driver는 직접 생성하지 않는다. asDriver() 메서드로 Observable을 변환해야 한다.
- Driver는 시퀀스를 공유한다. = Observable.share()
- 모든 작업이 메인 스케줄러에서 처리된다. 에러를 전달하지 않는다.
- bind(to:) 대신 drive()로 바인딩해야한다.

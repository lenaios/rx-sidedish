# TDD
[raywenderlich - TDD](https://www.raywenderlich.com/books/ios-test-driven-development-by-tutorials/v1.0/chapters/3-tdd-app-setup)

- Create a test target and run unit tests.
- Write unit tests that verify data and state.
- Feel comfortable with the TDD methodology:
    - Given, when, then.
    - System under test (sut).
    - Red/green/refactor of writing tests, then fixing code.

test target 없이는 test를 실행할 수 없다.

test target은 test code를 포함한 바이너리로, test phase에서만 실행된다. test target은 앱과 같이 빌드되지만, app bundle에 포함되지는 않는다.

그래서 XCTest로 unit test 하기 위해서는 unit test bundle을 추가해야 한다.

TDD의 철학은 test를 일급 객체로 작성하는 것이다(as first-class code).

production code와 readability, naming, error handle, coding convention 등을 같은 기준으로 작성해야 한다.

## Adding a test target

생략.

## Figuring out what to test

The TDD process requires writing a test first. This means you have to determine the smallest unit of functionality.

TDD는 테스트 코드부터 작성한다. 즉, 기능의 가장 작은 단위(unit)를 결정해야 한다.

## Red-Green-Refactor

TDD에서 다음 양식을 반복적으로 수행하는 것을 뜻한다.

1. Write a test that fails (red).
2. Write the minimum amount of code so the test passes (green).
3. Clean up test(s) and code as needed (refactor).
4. Repeat the process until all the logic cases are covered.

실패하는 코드를 작성한다. 테스트를 통과할 수 있게 코드를 수정한다. 모든 케이스를 커버할 수 있게 이 과정을 반복한다.

## Test nomenclature

sut : system under test

- given : 초기 상태
- when : action 이후의 상태
- then : when 이후 기대되는 결과, 상태

## XCTest

> Use the XCTest framework to write unit tests for your Xcode projects that integrate seamlessly with Xcode's testing workflow.

XCTest는 유닛 테스트를 위한 프레임워크이다.

- `XCTest` : abstract base class
- `XCTestCase` : XCTest의 subclass
- `XCTestCase` 안에 test function, assert를 작성해서 단위 테스트를 할 수 있다.

 XCTest는 다른 XUnit(test framework의 통칭)과 달리, lifecycle method가 없다. test class 전체를 한 번에 실행한다.

`setUp()` and `tearDown()` 가 test method가 실행되기 전후 set up을 위해 사용된다.

- tearDown : XCTestCases가 모든 test가 완료될 때까지 deinit 되지 않기 때문에, 메모리 측면에서나 이후 테스트에 영향을 미치지 않기 위해 이전 상태로 되돌리는 것이 중요하다(test clean up).

## @testable

@testable [module] : internal 이상으로 선언된 객체에 test 목적으로 접근 가능하다. 

unit test는 별도의 target, module, bundle로 취급하기 때문에 프로덕션 코드에 접근하려면 @testable이 필요하다.

## UITest

unit test와 달리 실제 앱의 workflow를 test 해보는 것.

mock, stub이 필요없다. 모듈(프로덕션 코드)에 대해 알지 못한다. @testable 사용 불가능

unit test와 다르게 별도의 프로세스로 동작한다. (프로세스 2개 생성)

아래와 같이 앱의 lifecycle과 상관없이 프로세스를 시작, 종료할 수 있다.

```swift
let app = XCUIApplication()
app.launch()
app.terminate()
```

### API

- XCUIApplication : 앱을 실행, 종료할 수 있는 일종의 Proxy
- XCUIElement : UI 요소
- XCUIElementQuery : UIElement를 찾기 위한 query

### AccessibilityLabel, AccessibilityIdentifier

UIElement를 가져오기 위해 accessibilityLabel or accessibilityIdentifier를 사용한다.

둘의 차이는 사용 대상자의 차이이다. accessibilityIdentifier는 개발자 대상, accessibilityLabel는 최종 사용자를 대상으로 한 것이기 때문에 로컬라이징 될 수 있다.

유일한 UIElement 구하기 위해 사용되므로, unique 한 값을 가져야 한다.

```swift
button.accessibilityIdentifier = "button.plus"
app.buttons["button.plus"].tap()
```

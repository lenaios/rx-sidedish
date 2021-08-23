### MVC

- Controller : Model과 View를 모두 업데이트 할 수 있는 중심 역할
- View : 화면에 데이터만 표시하고, 컨트롤러에 제스처와 같은 이벤트를 보내는 역할
- Model : 앱 상태를 유지하기 위해 데이터를 읽고 쓰는 역할

### MVVM

![https://marcosantadev.com/wp-content/uploads/mvvm.jpg](https://marcosantadev.com/wp-content/uploads/mvvm.jpg)

- Model은 데이터 변경에 대한 알림(notification)을 보낼 수 있지만, 다른 클래스와 직접 통신하지 않는다.
- View Model은 Model과 communication 하며, 데이터를 Controller에 노출한다.
- View Controller는 View의 생명 주기를 처리하고, 데이터를 UI 구성 요소에 바인딩할 때 View Model, View와 통신한다.
- View는 이벤트가 발생하면 컨트롤러에게 알린다(notify).

MVVM의 Controller는 MVC의 Controller과 같이 더 이상 Model을 관리하지 않는다.

오직 View Model에 의해 View를 업데이트 하기만 한다.

View Model은 Controller와 분리되어, 뷰의 lifecycle을 신경쓰지 않고 비즈니스 로직만을 갖게 된다.

View Model은 View와도 분리되어 UI와 관련된(UIKit, AppKit) 내용을 포함하지 않으므로 presenter layer와 관계 없이 재사용 될 수 있다.

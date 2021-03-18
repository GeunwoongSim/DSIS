<h1><center> 디스이즈 - 동아대학교 스마트 캠퍼스 애플리케이션</center></h1>

<img src="README_IMG/AppIcon.png" width="250">


## API

### [Alamofire](https://github.com/Alamofire/Alamofire)

- JSON 으로 서버로 부터 정보를 받아올 때 사용
- 서버에서 이미지 파일의 data를 받아올 때 사용

~~~swift
Alamofire.request(URL).responseJSON{(response in 
	guard let data = response.data else { return }
	do{
		let info = try JSONDecoder().decode(Info.self, from: data)
	} catch let error{
		print("ERROR = \(error)")
	}
)}

let parameters: [String : Any] = [
  "year": "\(self.year)"
]
Alamofire.request(URL,method: .post, parameters: parameters).responseString { response in }

Alamofire.request(URL).responseData(completionHandler: {(data) in
	guard let data = data.data else { return }
	DispatchQueue.main.async{
    self.imageView.image = UIImage(data: data)
  }
})

~~~

### [Kanna](https://github.com/tid-kijyun/Kanna)

- Alamofire로 HTML을 받아와서 XPath로 접근 할때 사용

~~~swift
if let doc = try? Kanna.HTML(html: html, encoding: String.Encoding.utf8){
	let nameTag: String = doc.xpath("//*[@id=' ']")[0].text ?? ""
}
~~~

### [Reachability](https://github.com/ashleymills/Reachability.swift)

- 데이터, Wifi 연결확인

~~~swift
private func reachabilityCheck(){ //네트워크 확인
  //네트워크 확인 - wifi인지, 데이터 사용인지, 아무것도 안킨 상태인지
  NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)
  do{
    print("노티실행")
    try reachability.startNotifier()
  }catch{
    print("could not start reachability notifier")
  }
}
//네트워크 확인 오픈소스
@objc func reachabilityChanged(note: Notification) { 
  let reachability = note.object as! Reachability
  switch reachability.connection {
    case .wifi:
    	print("Reachable via WiFi")
    	self.versionCheck() //버전 확인
    case .cellular:
    	print("Reachable via Cellular")
    	self.versionCheck() //버전 확인
    case .unavailable:
    	print("Network not reachable")
	    //기본 AlertView
  	  let AlertView = UIAlertController(title: "알림", message: "인터넷 연결상태가 좋지 않습니다.\n확인 후 다시 이용해주세요.", preferredStyle: UIAlertController.Style.alert)
  	  let OK = UIAlertAction(title: "확인", style: UIAlertAction.Style.default) { (_: UIAlertAction) -> Void in
				print("확인")
				self.reachabilityChanged(note: note)
			}
    	AlertView.addAction(OK)
    	self.present(AlertView, animated: true, completion: nil)
    default :
    	break
  }
}
~~~


## Timetable

2017.03 ~ 2018.12 프로토타입 개발

2019.03 ~ 2020.01 프로젝트 진행

2020.01 최종 테스트 진행

2020.02.05 App Store 출시

2021.01.22 App Store 판매중단 


## Screen Shots
<img src="README_IMG/StoreImage.png" width="250"><img src="README_IMG/MainHome.png" width="250"><img src="README_IMG/StudentInfo.png" width="250">

<img src="README_IMG/ThisStopIs.png" width="250"><img src="README_IMG/Timetable.png" width="250">




## 좋았던점

1. 처음으로 스토어에 제출하고 출시해본 애플리케이션이었다.
2. 대부분의 소스를 혼자 구성해서 아쉬운점이 많았지만 혼자서 여러 소스를 작성했기 때문에 부족한 점을 확실히 느낄 수 있었고 여러 시도를 해봐서 경험에 있어서는 좋았던거 같다.
3. iOS애플리케이션 공부를 시작하고 3개월이 되지않은 시점부터 시작한 프로젝트라 많은 것을 배우게 해준 프로젝트다.


## 아쉬운점 

1. swiftLint를 쓰고 싶었는데 못썼다
2. 싱글톤 패턴조차 모르고 작성한 어플이라 지금 다시 돌아보니 싱글톤을 사용할 수 있었으면 각 뷰간의 정보 전달이 더 편하고 좋았을거 같다
3. 레이아웃 구성에 있어 오토레이아웃을 모르고 소스를 작성해서 각 화면에 대해서 유동적으로 UI를 구성하려고 이 변수 저 변수를 사용한게 아쉽다
4. 이전까지 혼자 공부하면서 뷰 하나에 소스 하나를 매칭시켜서 작성했어서 소스의 재사용성이 너무 낮고 컨트롤러가 너무 비대해졌다
5. 대부분의 소스를 혼자 작성해서 피드백을 받을 수 없었던 점과 많은 정보를 익힐 수 없었던게 아쉽다
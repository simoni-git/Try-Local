# 🗺️ 이거해봄 [KAKAO x 한국관광공사  2025 관광데이터 활용 공모전 ]

> **AI가 만드는 나만의 성주 여행 코스**

![Swift](https://img.shields.io/badge/Swift-5.0-orange) ![iOS](https://img.shields.io/badge/iOS-14.0+-blue) ![MVVM](https://img.shields.io/badge/Architecture-MVVM-green) ![Award](https://img.shields.io/badge/Award-카카오+한국관광공사-yellow)

<p align="center">
  <img src="https://github.com/simoni-git/Try-Local/blob/main/screenshot/Simulator%2520Screenshot%2520-%2520iPhone%252016%2520Pro%2520Max%2520-%25202025-09-10%2520at%252000.32.51.png?raw=true" width="250">
  <img src="https://github.com/simoni-git/Try-Local/blob/main/screenshot/Simulator%2520Screenshot%2520-%2520iPhone%252016%2520Pro%2520Max%2520-%25202025-09-10%2520at%252000.35.23.png?raw=true" width="250">
  <img src="https://github.com/simoni-git/Try-Local/blob/main/screenshot/Simulator%2520Screenshot%2520-%2520iPhone%252016%2520Pro%2520Max%2520-%25202025-09-10%2520at%252000.37.00.png?raw=true" width="250">
</p>

<p align="center">
  <img src="https://github.com/simoni-git/Try-Local/blob/main/screenshot/Simulator%2520Screenshot%2520-%2520iPhone%252016%2520Pro%2520Max%2520-%25202025-09-10%2520at%252000.38.30.png?raw=true" width="250">
  <img src="https://github.com/simoni-git/Try-Local/blob/main/screenshot/Simulator%2520Screenshot%2520-%2520iPhone%252016%2520Pro%2520Max%2520-%25202025-09-10%2520at%252000.39.18.png?raw=true" width="250">
  <img src="https://github.com/simoni-git/Try-Local/blob/main/screenshot/Simulator%2520Screenshot%2520-%2520iPhone%252016%2520Pro%2520Max%2520-%25202025-09-29%2520at%252021.54.18.png?raw=true" width="250">
</p>

## 📖 프로젝트 소개

**이거해봄**은 경상북도 성주 지역의 관광명소, 카페, 체험지를 AI가 분석하여 **맞춤형 여행 코스**를 자동으로 생성해주는 iOS 앱입니다.  
출발지와 숙소 위치만 입력하면, 생성형 AI가 최적의 동선을 계산하여 효율적인 여행 계획을 제공합니다.

### 🏆 수상 내역
**카카오 + 한국관광공사 주관 공공데이터 활용 경진대회 출품작**

### 💡 개발 배경

**문제 인식**
- 지역 관광 정보가 흩어져 있어 여행 계획 수립이 어려움
- 최적의 동선을 고려한 여행 코스 짜기가 시간 소모적
- 성주 지역 관광 활성화를 위한 디지털 솔루션 필요

**해결 방안**
- **공공데이터 활용**: 성주 지역 관광명소 데이터 통합
- **AI 기반 경로 생성**: 출발지·숙소·관광지 기반 최적 동선 자동 계산
- **직관적 지도 UI**: MapKit으로 경로를 시각적으로 표현

---

## ✨ 주요 기능

| 기능 | 설명 |
|------|------|
| 🗺️ **관광지 데이터 통합** | API 연동으로 성주 지역 관광명소, 카페, 체험지 정보 제공 |
| 🤖 **AI 맞춤형 경로 생성** | 사용자 입력(출발지, 숙소, 관광지) 기반 최적 동선 자동 계산 |
| 📍 **실시간 지도 시각화** | MapKit으로 방문 순서에 따른 마커 및 폴리라인 표시 |
| ⭐ **즐겨찾기 관리** | 관심 있는 관광지를 북마크하여 개인화된 여행 계획 수립 |
| 🎯 **카테고리 분류** | 관광명소, 카페, 체험지 등 카테고리별 정보 탐색 |

---

## 🛠 Tech Stack

### **Core Technologies**
- **Swift** - iOS 네이티브 개발
- **UIKit + Storyboard** - UI 구현
- **MVVM Architecture** - 비즈니스 로직 분리

### **Networking & Data**
- **Alamofire** - RESTful API 통신
- **MapKit** - 지도 표시 및 경로 시각화
- **Combine** - 반응형 데이터 바인딩

### **Key Features**
- **AI Integration** - 서버 기반 최적 경로 생성
- **Public Data API** - 성주 지역 관광 데이터 연동
- **Real-time UI Updates** - 클로저 기반 실시간 UI 갱신

---

## 🎯 핵심 기능 구현

### **1. 관광지 데이터 통합 시스템**
- API 연동을 통한 성주 지역 관광지 데이터 수집
- 카테고리별 분류 (관광명소, 카페, 체험지)
- CollectionView 기반 카드 UI로 직관적 표출

### **2. AI 기반 맞춤형 경로 생성**
**사용자 입력**
- 출발지 위치
- 숙소 위치 (1박 2일 여행 시)
- 방문 희망 관광지 선택

**서버 처리**
- 생성형 AI가 최적 방문 순서 계산
- 거리, 이동 시간, 관광 소요 시간 고려
- 효율적인 동선 알고리즘 적용

**결과 시각화**
- MapKit으로 경로를 지도에 표시
- 방문 순서에 따른 번호 마커
- 경로를 연결하는 폴리라인

### **3. 즐겨찾기 시스템**
- 사용자별 관광지 북마크 기능
- 즐겨찾기한 장소 기반 경로 생성
- 개인화된 여행 계획 수립 지원

---

## 🔑 기술적 도전과 해결

### 1️⃣ **탭바 컨트롤러 공통 데이터 주입 문제**

**배경**  
각 탭(홈, 여행, 마이페이지)마다 공통적으로 `token`과 `userName` 필요

**문제**  
- 각 탭이 독립적으로 생성되어 초기화 시 데이터 전달 어려움
- NavigationController로 감싸진 뷰컨트롤러에 접근 필요
- 탭 전환 시에도 일관된 인증 정보 유지 필요

**해결**
```swift
private func injectTokenToChildVCs() {
    guard let token = token, let userName = userName else { return }
    
    // 모든 탭의 뷰컨트롤러 순회
    for vc in viewControllers ?? [] {
        if let nav = vc as? UINavigationController {
            // 각 탭의 최상위 뷰컨트롤러에 ViewModel 주입
            if let homeVC = nav.topViewController as? HomeVC {
                homeVC.vm = HomeVM(token: token, userName: userName)
            } else if let journeyVC = nav.topViewController as? JourneyVC {
                journeyVC.vm = JourneyVM(token: token, userName: userName)
            } else if let myPageVC = nav.topViewController as? MyPageVC {
                myPageVC.vm = MyPageVM(token: token, userName: userName)
            }
        }
    }
}
```

**성과**  
✅ UITabBarController의 모든 자식 뷰컨트롤러에 동적으로 데이터 주입  
✅ 탭 전환 시에도 일관된 사용자 상태 유지  
✅ 코드 재사용성 및 유지보수성 향상

---

### 2️⃣ **실시간 UI 갱신 문제**

**배경**  
서버에서 AI 경로 생성 결과를 받아온 후 화면 업데이트 필요

**문제**  
- 데이터 변경 사항을 뷰가 즉시 감지하지 못함
- 사용자가 수동으로 새로고침해야 최신 데이터 확인 가능
- 비동기 데이터 처리와 UI 업데이트 타이밍 불일치

**해결**
```swift
// ViewModel에서 클로저 정의
var onDataUpdated: (() -> Void)?

func fetchRouteData() {
    // API 호출 후 데이터 갱신
    alamofireManager.request(...) { [weak self] result in
        self?.routeData = result
        self?.onDataUpdated?()  // 클로저 호출
    }
}

// ViewController에서 구독
vm.onDataUpdated = { [weak self] in
    DispatchQueue.main.async {
        self?.collectionView1.reloadData()
        self?.collectionView2.reloadData()
        self?.collectionView3.reloadData()
        self?.collectionView4.reloadData()
        self?.updateTravelUI()
    }
}
```

**성과**  
✅ 클로저 기반 데이터 바인딩으로 실시간 UI 갱신  
✅ DispatchQueue.main.async로 UI 스레드 안전성 확보  
✅ 서버 응답 즉시 화면 반영으로 UX 개선

---

### 3️⃣ **MapKit 경로 시각화**

**배경**  
AI가 생성한 방문 순서를 사용자가 직관적으로 이해할 수 있도록 지도 표현

**구현**  
- **마커 표시**: 방문 순서에 따른 번호 마커 (1번, 2번, ...)
- **폴리라인 렌더링**: 경로를 선으로 연결하여 동선 시각화
- **최적화된 정렬**: 서버에서 받은 순서대로 마커 배치

**성과**  
✅ 복잡한 여행 경로를 한눈에 파악 가능  
✅ 직관적인 UI로 사용자 만족도 향상  
✅ MapKit 활용 경험 축적

---

## 🏆 핵심 성과 및 학습

### 기술적 성과 ✅
- **AI 통합**: 백엔드 AI 서버와 iOS 클라이언트 효과적 연동
- **데이터 바인딩**: 클로저 기반 실시간 UI 갱신 패턴 구현
- **복잡한 화면 구조**: 탭바 + 네비게이션 + 동적 데이터 주입 처리
- **MapKit 시각화**: 경로 마커 및 폴리라인 렌더링

### 개인 성장 🎯
- **MVVM 패턴 심화**: 복잡한 데이터 흐름과 상태 관리 경험
- **API 설계 이해**: 서버-클라이언트 통신 과정에서 RESTful API 이해도 향상
- **UX 중심 사고**: 사용자 입장에서 직관적인 여행 계획 경험 설계
- **앱 아키텍처**: 전체 앱 구조를 이해하고 설계하는 능력 강화
- **공공 가치**: 지역 관광 활성화에 기여하는 기술 솔루션 개발 경험

---

## 💭 회고 (Retrospective)

### 잘한 점 ✅
- **AI 통합**: 복잡한 서버 연동을 성공적으로 구현
- **실시간 UI**: 클로저 기반 데이터 바인딩 패턴 적용
- **사용자 중심 설계**: 직관적인 지도 UI로 여행 계획 경험 개선
- **공공 가치**: 지역 관광 활성화에 기여하는 앱 완성

### 아쉬운 점 📝
- 성주 지역만 지원 (타 지역 확장 필요)
- 오프라인 모드 미지원
- 실제 네비게이션 기능 부재

### 다음 프로젝트에 적용할 점 🎯
- Combine/Async-Await으로 비동기 처리 고도화
- 다른 지역으로 확장 가능한 아키텍처 설계
- 실시간 교통 정보 반영
- Widget 추가로 빠른 여행 정보 접근

---

## 🔗 Links

- **GitHub Repository**: [simoni-git/igeohaebom](https://github.com/simoni-git/igeohaebom)
- **App Store**: [다운로드 링크 추가 예정]
- **경진대회**: 카카오 + 한국관광공사 주관

---

## 👤 Author

**고민수 (Minsu Go)**
- 📧 Email: gms5889@naver.com
- 💼 GitHub: [@simoni-git](https://github.com/simoni-git)
- 📝 Blog: [네이버 블로그](https://blog.naver.com/gms5889)

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

이 프로젝트가 도움이 되셨다면 ⭐️ Star를 눌러주세요!

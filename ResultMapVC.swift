//
//  MapRouteVC.swift
//  Try-Local
//
//  Created by 시모니의 맥북 on 8/27/25.
//

import UIKit
import MapKit
import Combine

class ResultMapVC: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var removeBtn: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var day1SubView: UIView!
    @IBOutlet weak var day2SubView: UIView!
    var selectedAnnotationView: MKAnnotationView?
    var vm: ResultMapVM!
    var homeVM: HomeVM!
    private var cancellables = Set<AnyCancellable>()
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.collectionViewLayout = createLayout()
        // ✅ 페이징 효과 설정 (가로 스크롤용)
        collectionView.isPagingEnabled = false  // 먼저 끄고
        collectionView.decelerationRate = .fast
        collectionView.showsHorizontalScrollIndicator = false
        configureUI()
        // VM의 데이터 갱신 콜백 연결
        vm.onDataUpdated = { [weak self] in
            print("콜백 호출")
            self?.configureUI()
            self?.collectionView.reloadData()
        }
        
        vm.$backBtnIsHidden
            .receive(on: RunLoop.main)
            .sink { [weak self] shouldHide in
                self?.navigationItem.hidesBackButton = shouldHide
            }
            .store(in: &cancellables)
    }
    
    private func configureUI(){
        titleLabel.font = UIFont(name: "PretendardGOV-Bold", size: 16)
        titleLabel.text = vm.titleLabelText
        day1SubView.layer.cornerRadius = 8
        day2SubView.layer.cornerRadius = 8
        day1SubView.isHidden = vm.daySubViewIsHidden
        day2SubView.isHidden = vm.daySubViewIsHidden
        removeBtn.isHidden = vm.removeBtnIsHidden
        
        setupMapRegion()
        addMarkers()
    }
    
    private func setupMapRegion() {
        let coordinate = CLLocationCoordinate2D(latitude: 35.9194, longitude: 128.2822)
        let span = MKCoordinateSpan(latitudeDelta: 0.15, longitudeDelta: 0.15) // 줌 레벨 (숫자 작을수록 확대)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        
        mapView.setRegion(region, animated: true)
        
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        let collectionViewWidth = UIScreen.main.bounds.width
        let horizontalInset: CGFloat = 24
        let peekWidth: CGFloat = 16
        let itemWidth = collectionViewWidth - horizontalInset * 2 - peekWidth * 2
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(itemWidth),
                                              heightDimension: .absolute(100))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(itemWidth),
                                               heightDimension: .absolute(100))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 8
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: horizontalInset + peekWidth, bottom: 0, trailing: horizontalInset + peekWidth)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        // ✅ 핵심: 가로 스크롤 설정
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.scrollDirection = .horizontal  // 이게 핵심!
        layout.configuration = config
        
        return layout
    }
    
    // 3. 페이징 효과를 위한 추가 메서드
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let collectionViewWidth = UIScreen.main.bounds.width
        let horizontalInset: CGFloat = 24
        let peekWidth: CGFloat = 16
        let itemWidth = collectionViewWidth - horizontalInset * 2 - peekWidth * 2
        let cellWidthIncludingSpacing = itemWidth + 8
        
        let estimatedIndex = targetContentOffset.pointee.x / cellWidthIncludingSpacing
        let index = velocity.x > 0 ? ceil(estimatedIndex) : floor(estimatedIndex)
        
        targetContentOffset.pointee.x = index * cellWidthIncludingSpacing
        
        print("📐 페이징 계산: estimatedIndex=\(estimatedIndex), finalIndex=\(index), targetOffset=\(targetContentOffset.pointee.x)")
    }
    
    private func addMarkers() {
//        guard let vm = vm else { return }
//        mapView.removeAnnotations(mapView.annotations)
//        
//        var coordinates: [CLLocationCoordinate2D] = []
//        var count = 1 // 마커 번호 시작
//        
//        // day1/day2 배열이 비어있는지 확인
//        let isOvernight = !vm.namesDay1.isEmpty || !vm.namesDay2.isEmpty
//        
//        if isOvernight {
//            // day1 마커
//            for i in 0..<vm.namesDay1.count {
//                guard let lat = Double(vm.latitudesDay1[i]),
//                      let lon = Double(vm.longitudesDay1[i]) else { continue }
//                let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
//                coordinates.append(coordinate)
//                
//                let annotation = MKPointAnnotation()
//                annotation.coordinate = coordinate
//                annotation.title = "\(count)"
//                count += 1
//                mapView.addAnnotation(annotation)
//            }
//            
//            // day2 마커
//            for i in 0..<vm.namesDay2.count {
//                guard let lat = Double(vm.latitudesDay2[i]),
//                      let lon = Double(vm.longitudesDay2[i]) else { continue }
//                let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
//                coordinates.append(coordinate)
//                
//                let annotation = MKPointAnnotation()
//                annotation.coordinate = coordinate
//                annotation.title = "\(count)"
//                count += 1
//                mapView.addAnnotation(annotation)
//            }
//        } else {
//            // 당일치기 → 통합 배열 기준
//            for i in 0..<vm.names.count {
//                guard let lat = Double(vm.latitudes[i]),
//                      let lon = Double(vm.longitudes[i]) else { continue }
//                let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
//                coordinates.append(coordinate)
//                
//                let annotation = MKPointAnnotation()
//                annotation.coordinate = coordinate
//                annotation.title = "\(count)"
//                count += 1
//                mapView.addAnnotation(annotation)
//            }
//        }
//        
//        // 폴리라인
//        let polyline = MKPolyline(coordinates: coordinates, count: coordinates.count)
//        mapView.addOverlay(polyline)
        
        guard let vm = vm else { return }
        mapView.removeAnnotations(mapView.annotations)
        
        var coordinates: [CLLocationCoordinate2D] = []
        var count = 1 // 마커 번호 시작
        
        // day1/day2 배열이 비어있는지 확인
        let isOvernight = !vm.namesDay1.isEmpty || !vm.namesDay2.isEmpty
        // ✅ 둘 다 비어있는지 체크
        if vm.names.isEmpty {
            print("모두비어있음 다시 Fetch 불러보기. submissionID: \(vm.submissionID ?? 999)")
            
            vm.fetchRoute(submissionID: vm.submissionID ?? 999)
            
        } else {
            //둘다 비어있진 않음.
            if isOvernight {
                // day1 마커
                for i in 0..<vm.namesDay1.count {
                    guard let lat = Double(vm.latitudesDay1[i]),
                          let lon = Double(vm.longitudesDay1[i]) else { continue }
                    let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
                    coordinates.append(coordinate)
                    
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = coordinate
                    annotation.title = "\(count)"
                    count += 1
                    mapView.addAnnotation(annotation)
                }
                
                // day2 마커
                for i in 0..<vm.namesDay2.count {
                    guard let lat = Double(vm.latitudesDay2[i]),
                          let lon = Double(vm.longitudesDay2[i]) else { continue }
                    let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
                    coordinates.append(coordinate)
                    
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = coordinate
                    annotation.title = "\(count)"
                    count += 1
                    mapView.addAnnotation(annotation)
                }
            } else {
                // 당일치기 → 통합 배열 기준
                for i in 0..<vm.names.count {
                    guard let lat = Double(vm.latitudes[i]),
                          let lon = Double(vm.longitudes[i]) else { continue }
                    let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
                    coordinates.append(coordinate)
                    
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = coordinate
                    annotation.title = "\(count)"
                    count += 1
                    mapView.addAnnotation(annotation)
                }
            }
            
            // 폴리라인
            let polyline = MKPolyline(coordinates: coordinates, count: coordinates.count)
            mapView.addOverlay(polyline)
            
        }
    
    }
    
    //MARK: - Action func
    
    @IBAction func tapRemoveBtn(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "경로를 삭제할까요?",
                                      message: nil,
                                      preferredStyle: .alert)
        
        let yesAction = UIAlertAction(title: "예", style: .destructive) { _ in
            self.vm.deleteRoute(submissionID: self.vm.submissionID ?? 1) { [weak self] success in
                guard let self = self else { return }
                print("지워버릴 서브미션 아이디는 => \(String(describing: vm.submissionID))")
                // ✅ Alert 먼저 닫기
                self.dismiss(animated: true) {
                    
                    guard let tabBarController = self.tabBarController,
                          let nav = tabBarController.viewControllers?[1] as? UINavigationController,
                          let journeyVC = self.storyboard?.instantiateViewController(withIdentifier: "JourneyVC") as? JourneyVC
                    else { return }
                    
                    journeyVC.vm = JourneyVM(token: self.vm.token, userName: self.vm.userName ?? "")
                    journeyVC.homeVM = self.homeVM
                    
                    // ✅ 화면 강제 갱신
                    journeyVC.loadViewIfNeeded()
                    
                    // ✅ nav stack 교체 및 탭 이동은 딜레이 후 실행
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                        nav.setViewControllers([journeyVC], animated: false)
                        tabBarController.selectedIndex = 1
                        print("➡️ 삭제 후 JourneyVC 교체 완료")
                    }
                }
            }
        }
        
        let noAction = UIAlertAction(title: "아니오", style: .cancel, handler: nil)
        
        alert.addAction(yesAction)
        alert.addAction(noAction)
        
        present(alert, animated: true, completion: nil)
        
        
        
    }
    
    
}


// MARK: - 개선된 CollectionView 관련 (스크롤 연동 추가)
extension ResultMapVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return vm.names.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ResultMapCell", for: indexPath) as? ResultMapCell else {
            return UICollectionViewCell()
        }
        
        let cornerRadius: CGFloat = cell.subView.frame.height / 2
        cell.titleLabel.font = UIFont(name: "PretendardGOV-Bold", size: 16)
        cell.adressLabel.font = UIFont(name: "PretendardGOV-Medium", size: 12)
        cell.subView.layer.cornerRadius = cornerRadius
        cell.subView.clipsToBounds = true
        cell.layer.cornerRadius = 8
        
        // 뷰모델 데이터 넣기
        if let vm = self.vm {
            let index = indexPath.item
            if index < vm.names.count {
                let order = index + 1
                cell.titleLabel.text = "\(order). \(vm.names[index])"
            }
            if index < vm.addresses.count {
                cell.adressLabel.text = vm.addresses[index]
            }
            if index < vm.types.count {
                let type = vm.types[index]
                cell.categoryLabel.text = type
                
                switch type {
                case "관광":
                    cell.subView.backgroundColor = UIColor(hex: "#D977DE")
                case "체험":
                    cell.subView.backgroundColor = UIColor(hex: "#5C3800")
                case "숙소":
                    cell.subView.backgroundColor = UIColor(hex: "#52A4E7")
                case "카페":
                    cell.subView.backgroundColor = UIColor(hex: "#E7AC52")
                default:
                    cell.subView.backgroundColor = .lightGray
                }
            }
            if index < vm.imgURLs.count, let url = URL(string: vm.imgURLs[index]) {
                cell.img.kf.indicatorType = .activity
                cell.img.kf.setImage(
                    with: url,
                    placeholder: UIImage(systemName: "house.fill"),
                )
                cell.img.contentMode = .scaleAspectFill
                cell.img.clipsToBounds = true
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width - 48
        return CGSize(width: width, height: 100)
    }
    
    // MARK: - 셀 선택 시 디테일 화면만 (맵 이동 제거)
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = indexPath.item
        
        print("🔘 셀 선택: 인덱스 \(index) - 디테일 화면 표시")
        
        // 선택한 셀 가져오기 (디테일 화면만 표시)
        if let cell = collectionView.cellForItem(at: indexPath) as? ResultMapCell {
            let category = cell.categoryLabel.text ?? ""
            
            // 디테일 화면 로직
            switch category {
            case "체험":
                showDetailVC(type: "ExperienceDetailVC", vmType: "ExperienceDetailVM", index: index)
            case "카페":
                showDetailVC(type: "CafeDetailVC", vmType: "CafeDetailVM", index: index)
            case "관광":
                showDetailVC(type: "LocationDetailVC", vmType: "LocationDetailVM", index: index)
            default:
                print("그 외 선택되었습니다")
            }
        }
    }
    
    // MARK: - 디테일 화면 공통 함수 (중복 코드 제거)
    private func showDetailVC(type: String, vmType: String, index: Int) {
        guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: type) else { return }
        
        // VM 생성 및 할당
        let targetName = vm.names[index]
        
        switch vmType {
        case "ExperienceDetailVM":
            let nextVM = ExperienceDetailVM(token: vm.token, targetName: targetName)
            (nextVC as? ExperienceDetailVC)?.vm = nextVM
            showDetailWithLoading(nextVC: nextVC, nextVM: nextVM, targetName: targetName)
            
        case "CafeDetailVM":
            let nextVM = CafeDetailVM(token: vm.token, targetName: targetName)
            (nextVC as? CafeDetailVC)?.vm = nextVM
            showDetailWithLoading(nextVC: nextVC, nextVM: nextVM, targetName: targetName)
            
        case "LocationDetailVM":
            let nextVM = LocationDetailVM(token: vm.token, targetName: targetName)
            (nextVC as? LocationDetailVC)?.vm = nextVM
            showDetailWithLoading(nextVC: nextVC, nextVM: nextVM, targetName: targetName)
            
        default:
            break
        }
    }
    
    private func showDetailWithLoading(nextVC: UIViewController, nextVM: Any, targetName: String) {
        guard let loadingVC = storyboard?.instantiateViewController(withIdentifier: "LoadingVC") as? LoadingVC else { return }
        loadingVC.modalPresentationStyle = .overFullScreen
        present(loadingVC, animated: false) {
            
            // API 호출 (각 VM에 맞는 메서드 호출)
            if let experienceVM = nextVM as? ExperienceDetailVM {
                experienceVM.getDetailInfoAPI(name: targetName) {
                    self.handleDetailAPIResponse(loadingVC: loadingVC, nextVC: nextVC, isEmpty: experienceVM.name.isEmpty)
                }
            } else if let cafeVM = nextVM as? CafeDetailVM {
                cafeVM.getDetailInfoAPI(name: targetName) {
                    self.handleDetailAPIResponse(loadingVC: loadingVC, nextVC: nextVC, isEmpty: cafeVM.name.isEmpty)
                }
            } else if let locationVM = nextVM as? LocationDetailVM {
                locationVM.getDetailInfoAPI(name: targetName) {
                    self.handleDetailAPIResponse(loadingVC: loadingVC, nextVC: nextVC, isEmpty: locationVM.name.isEmpty)
                }
            }
        }
    }
    
    private func handleDetailAPIResponse(loadingVC: LoadingVC, nextVC: UIViewController, isEmpty: Bool) {
        DispatchQueue.main.async {
            loadingVC.dismiss(animated: false) {
                if isEmpty {
                    let alert = UIAlertController(title: "오류", message: "데이터를 불러오지 못했습니다.\n다시 한 번 시도해 주세요.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "확인", style: .default))
                    self.present(alert, animated: true)
                } else {
                    nextVC.modalPresentationStyle = .pageSheet
                    self.present(nextVC, animated: false)
                }
            }
        }
    }
    
    // MARK: - 🆕 스크롤 완료 시 맵 초점 이동
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print("🔄 관성 스크롤 완료 - 함수 호출됨!")
        print("   스크롤뷰 타입: \(type(of: scrollView))")
        updateMapFocusFromScroll()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        print("🔄 드래그 완료 - 함수 호출됨! (관성: \(decelerate))")
        if !decelerate {
            print("🔄 드래그 완료 (관성 없음)")
            updateMapFocusFromScroll()
        }
    }
    
    // 추가: 스크롤 시작할 때도 감지
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        print("🔄 스크롤 시작!")
    }
    
    // 스크롤 기반 맵 초점 이동 함수 (페이징 효과 고려)
    private func updateMapFocusFromScroll() {
        print("🚀 updateMapFocusFromScroll 함수 시작")
        
        // 컬렉션뷰인지 확인
        guard collectionView != nil else {
            print("❌ collectionView가 nil입니다")
            return
        }
        
        // 페이징 효과를 고려한 중앙 셀 인덱스 계산
        let collectionViewWidth = collectionView.bounds.width
        let contentOffsetX = collectionView.contentOffset.x
        let horizontalInset: CGFloat = 24
        let peekWidth: CGFloat = 16
        let itemWidth = collectionViewWidth - horizontalInset * 2 - peekWidth * 2
        
        print("📊 레이아웃 정보:")
        print("   collectionViewWidth: \(collectionViewWidth)")
        print("   contentOffsetX: \(contentOffsetX)")
        print("   itemWidth: \(itemWidth)")
        
        // 현재 중앙에 있는 셀의 인덱스 계산
        let adjustedOffset = contentOffsetX + (horizontalInset + peekWidth)
        let currentIndex = Int(round(adjustedOffset / (itemWidth + 8))) // 8은 interGroupSpacing
        
        print("📱 [스크롤 감지] contentOffset: \(contentOffsetX), 계산된 중앙 인덱스: \(currentIndex)")
        
        // VM 확인
        guard let vm = vm else {
            print("❌ vm이 nil입니다")
            return
        }
        
        // 인덱스 범위 체크
        guard currentIndex >= 0 && currentIndex < vm.names.count else {
            print("❌ 인덱스 범위 초과: \(currentIndex), 전체 개수: \(vm.names.count)")
            return
        }
        
        print("✅ 화면 가운데 셀 인덱스: \(currentIndex)")
        
        // 맵 초점 이동 (인덱스 + 1을 타이틀로 가진 마커 찾기)
        moveMapFocusToMarker(withTitle: currentIndex + 1)
    }
    
    // 특정 타이틀을 가진 마커로 맵 초점 이동
    private func moveMapFocusToMarker(withTitle title: Int) {
        let targetTitle = "\(title)"
        
        print("🎯 타겟 마커 찾는 중: '\(targetTitle)'")
        
        // 타이틀이 일치하는 마커 찾기
        if let targetAnnotation = mapView.annotations.first(where: { annotation in
            guard let point = annotation as? MKPointAnnotation,
                  let annotationTitle = point.title else { return false }
            print("   - 마커 확인: '\(annotationTitle ?? "nil")'")
            return annotationTitle == targetTitle
        }) {
            // 확대된 지도 영역 설정
            let span = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
            let region = MKCoordinateRegion(center: targetAnnotation.coordinate, span: span)
            mapView.setRegion(region, animated: true)
            
            // 마커 선택
            mapView.selectAnnotation(targetAnnotation, animated: true)
            
            print("✅ 마커 타이틀 '\(targetTitle)'로 맵 이동 완료!")
        } else {
            print("❌ 타이틀 '\(targetTitle)'인 마커를 찾을 수 없습니다.")
            print("   현재 존재하는 마커들:")
            mapView.annotations.forEach { annotation in
                if let point = annotation as? MKPointAnnotation {
                    print("   - \(point.title ?? "nil")")
                }
            }
        }
    }
}

// MARK: - 🆕 개선된 MapKit 관련 (맵 선택 시 컬렉션뷰 연동)
extension ResultMapVC: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else { return nil }
        
        let identifier = "marker"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = false
            annotationView?.displayPriority = .required
        } else {
            annotationView?.annotation = annotation
        }
        
        var index = 0
        var type = "today"
        
        if let point = annotation as? MKPointAnnotation {
            // day1
            if let i = vm.latitudesDay1.firstIndex(where: { Double($0) == point.coordinate.latitude }) {
                type = "day1"
                index = i + 1
            }
            // day2
            else if let i = vm.latitudesDay2.firstIndex(where: { Double($0) == point.coordinate.latitude }) {
                type = "day2"
                index = vm.latitudesDay1.count + i + 1
            }
            // 당일치기
            else if let i = vm.latitudes.firstIndex(where: { Double($0) == point.coordinate.latitude }) {
                type = "today"
                index = i + 1
            }
        }
        
        annotationView?.image = markerImage(forIndex: index, type: type, isSelected: false)
        annotationView?.tag = index - 1
        annotationView?.centerOffset = CGPoint(x: 0, y: -15)
        
        return annotationView
    }
    
    func markerImage(forIndex index: Int, type: String, isSelected: Bool) -> UIImage? {
        let size = CGSize(width: 30, height: 30)
        let label = UILabel(frame: CGRect(origin: .zero, size: size))
        label.text = "\(index)"
        label.textAlignment = .center
        label.textColor = .black
        label.layer.cornerRadius = size.width / 2
        label.layer.masksToBounds = true
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor.black.cgColor
        
        // day1 마지막 마커만 색상 변경
        if type == "day1" && index == vm.latitudesDay1.count {
            label.backgroundColor = UIColor(hex: "#52A4E7")
        } else {
            switch type {
            case "day1":
                label.backgroundColor = UIColor(hex: "#E7AC52")
            case "day2":
                label.backgroundColor = UIColor(hex: "#C58585")
            default:
                label.backgroundColor = UIColor(hex: "#E7AC52")
            }
        }
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        label.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let polyline = overlay as? MKPolyline {
            let renderer = MKPolylineRenderer(polyline: polyline)
            renderer.strokeColor = UIColor.black
            renderer.lineWidth = 1
            renderer.lineDashPattern = [2, 4]
            return renderer
        }
        return MKOverlayRenderer()
    }
    
    // MARK: - 🆕 맵 선택 시 컬렉션뷰 스크롤 (부드러운 애니메이션)
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let index = view.tag
        guard index >= 0 && index < vm.names.count else { return }
        
        let indexPath = IndexPath(item: index, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        // 아무 동작 없음
    }
}

//MARK: - CollectionView Cell
class ResultMapCell: UICollectionViewCell {
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var adressLabel: UILabel!
    @IBOutlet weak var subView: UIView!
    @IBOutlet weak var categoryLabel: UILabel!
}

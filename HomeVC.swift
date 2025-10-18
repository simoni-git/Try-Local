//
//  MainVC.swift
//  TryLocal
//
//  Created by 시모니의 맥북 on 6/17/25.
//

import UIKit
import Alamofire
import Kingfisher


class HomeVC: UIViewController {
    
    @IBOutlet weak var topViewLabel1: UILabel!
    @IBOutlet weak var topViewLabel2: UILabel!
    @IBOutlet weak var topViewLabel3: UILabel!
    @IBOutlet weak var makeWayBtn: UIButton!
    @IBOutlet weak var titleLabel1: UILabel!
    @IBOutlet weak var titleLabel2: UILabel!
    @IBOutlet weak var titleLabel3: UILabel!
    @IBOutlet weak var titleLabel4: UILabel!
    @IBOutlet weak var collectionView1: UICollectionView!
    @IBOutlet weak var collectionView2: UICollectionView!
    @IBOutlet weak var collectionView3: UICollectionView!
    @IBOutlet weak var collectionView4: UICollectionView!
    var vm: HomeVM!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        vm = HomeVM(token: vm.token, userName: vm.userName)
        configure()
        
    }
    
    private func configure() {
        let collectionViews = [collectionView1, collectionView2, collectionView3, collectionView4]
        for collectionView in collectionViews {
            collectionView?.dataSource = self
            collectionView?.delegate = self
        }
        // ✅ 데이터 갱신되면 UI 업데이트
        vm.onDataUpdated = { [weak self] in
            DispatchQueue.main.async {
                print("데이터 갱신! UI 업데이트 onDataUpdated() 호출")
                self?.collectionView1.reloadData()
                self?.collectionView2.reloadData()
                self?.collectionView3.reloadData()
                self?.collectionView4.reloadData()
                self?.updateTravelUI()
            }
        }
        configureUI()
        vm.getHomeInfoAPI()
    }
    
    private func configureUI() {
        topViewLabel1.font = UIFont(name: "PretendardGOV-Bold", size: 20)
        topViewLabel2.font = UIFont(name: "PretendardGOV-Medium", size: 16)
        topViewLabel3.font = UIFont(name: "PretendardGOV-SemiBold", size: 24)
        makeWayBtn.layer.cornerRadius = 8
        // 버튼 그림자 스타일 적용
        makeWayBtn.layer.shadowColor = UIColor.black.cgColor   // 그림자 색상
        makeWayBtn.layer.shadowOpacity = 0.7                   // 그림자 투명도 (0 ~ 1)
        makeWayBtn.layer.shadowOffset = CGSize(width: 0, height: 2) // 그림자 위치
        makeWayBtn.layer.shadowRadius = 4                      // 그림자 번짐 정도
        makeWayBtn.layer.masksToBounds = false                 // 그림자가 잘리지 않게 설정
        
        titleLabel1.font = UIFont(name: "PretendardGOV-SemiBold", size: 16)
        titleLabel2.font = UIFont(name: "PretendardGOV-SemiBold", size: 16)
        titleLabel3.font = UIFont(name: "PretendardGOV-SemiBold", size: 16)
        titleLabel4.font = UIFont(name: "PretendardGOV-SemiBold", size: 16)
        
        self.navigationItem.backButtonTitle = ""
        self.navigationController?.navigationBar.tintColor = .black
    }
    
    
    private func updateTravelUI() {
        if vm.myTravelItems.isEmpty {
            // 여행 없음
            topViewLabel3.text = "여행 계획을 짜볼까요?"
            makeWayBtn.setTitle("+ AI와 함께 나만의 경로 생성하기", for: .normal)
            
        } else if let travel = vm.myTravelItems.first {
            // 여행 있음
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            
            if let startDate = formatter.date(from: travel.date.start_date) {
                let today = Date()
                let calendar = Calendar.current
                let diff = calendar.dateComponents([.day], from: today, to: startDate).day ?? 0
                
                if diff > 0 {
                    topViewLabel3.text = "성주와 가까워지기, D-\(diff)"
                } else if diff == 0 {
                    topViewLabel3.text = "성주와 가까워지기, D-Day"
                } else {
                    topViewLabel3.text = "여행 계획을 짜볼까요?"
                }
            }
            
            // 버튼 텍스트 (기간 표시)
            let start = travel.date.start_date.replacingOccurrences(of: "-", with: ".")
            let end = travel.date.end_date.split(separator: "-").dropFirst().joined(separator: ".")
            makeWayBtn.setTitle("\(start) - \(end)", for: .normal)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("배열 안에 갯수는 => \(vm.myTravelItems.count)")
        vm.getHomeInfoAPI()
        updateTravelUI()
    }
    
    
    //MARK: - Action func
    @IBAction func tapMakeWayBtn(_ sender: UIButton) {
        guard let tabBarController = self.tabBarController else { return }
        // B 탭 (index = 1) 가져오기
        if let nav = tabBarController.viewControllers?[1] as? UINavigationController {
            
            if vm.myTravelItems.isEmpty {
                // 기본 여정(JourneyVC) 띄우기
                if let journeyVC = storyboard?.instantiateViewController(withIdentifier: "JourneyVC") as? JourneyVC {
                    journeyVC.vm = JourneyVM(token: vm.token, userName: vm.userName)
                    nav.setViewControllers([journeyVC], animated: false)
                }
                
            } else {
                // 지도(ResultMapVC) 띄우기
                if let mapVC = storyboard?.instantiateViewController(withIdentifier: "ResultMapVC") as? ResultMapVC {
                    mapVC.vm = ResultMapVM(token: vm.token)
                    mapVC.vm.submissionID = vm.myTravelItems[0].submission_id
                    mapVC.vm.titleLabelText = vm.myTravelItems[0].name
                    // 버튼 클릭 직후 서버 데이터 가져오기
                    mapVC.vm.fetchRoute(submissionID: vm.myTravelItems[0].submission_id)
                    nav.setViewControllers([mapVC], animated: false)
                }
            }
            
            // 탭 이동
            tabBarController.selectedIndex = 1
        }
    }
    
}

//MARK: - CollectionView 관련
extension HomeVC: UICollectionViewDelegateFlowLayout , UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionView1 {
            return vm.doThisItems.count
        } else if collectionView == collectionView2 {
            return vm.eatThisItems.count
        } else if collectionView == collectionView3 {
            return vm.goHereItems.count
        } else if collectionView == collectionView4 {
            return vm.eventItems.count
        }
        return 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionViewCell", for: indexPath) as? HomeCollectionViewCell else {
            return UICollectionViewCell()
        }
        // 이미지 크기 통일용 processor
        let processor = ResizingImageProcessor(referenceSize: CGSize(width: 140, height: 120), mode: .aspectFill)
        
        // 이미지뷰 설정
        cell.imageView.contentMode = .scaleAspectFill
        cell.imageView.clipsToBounds = true
        cell.imageView.layer.cornerRadius = 8
        
        // 컬렉션뷰별 데이터 연결
        if collectionView == collectionView1 {
            let item = vm.doThisItems[indexPath.item]
            cell.titleLabel.text = item.name
            cell.subLabel.text = item.experiences.joined(separator: ", ")
            cell.titleLabel.font = UIFont(name: "PretendardGOV-Medium", size: 12)
            cell.subLabel.font = UIFont(name: "PretendardGOV-Medium", size: 10)
            cell.imageView.kf.setImage(
                with: URL(string: item.image),
                options: [
                    .processor(processor),
                    .scaleFactor(UIScreen.main.scale),
                    .transition(.fade(0.3)),
                    .cacheOriginalImage
                ]
            )
            cell.imageView.layer.cornerRadius = 8
            
        } else if collectionView == collectionView2 {
            let item = vm.eatThisItems[indexPath.item]
            cell.titleLabel.text = item.name
            cell.subLabel.text = item.address
            cell.titleLabel.font = UIFont(name: "PretendardGOV-Medium", size: 12)
            cell.subLabel.font = UIFont(name: "PretendardGOV-Medium", size: 10)
            cell.imageView.kf.setImage(
                with: URL(string: item.image),
                options: [
                    .processor(processor),
                    .scaleFactor(UIScreen.main.scale),
                    .transition(.fade(0.3)),
                    .cacheOriginalImage
                ]
            )
            
        } else if collectionView == collectionView3 {
            let item = vm.goHereItems[indexPath.item]
            cell.titleLabel.text = item.name
            cell.subLabel.text = item.address
            cell.titleLabel.font = UIFont(name: "PretendardGOV-Medium", size: 12)
            cell.subLabel.font = UIFont(name: "PretendardGOV-Medium", size: 10)
            cell.imageView.kf.setImage(
                with: URL(string: item.image),
                options: [
                    .processor(processor),
                    .scaleFactor(UIScreen.main.scale),
                    .transition(.fade(0.3)),
                    .cacheOriginalImage
                ]
            )
            
        } else if collectionView == collectionView4 {
            let item = vm.eventItems[indexPath.item]
            cell.titleLabel.text = item.name
            cell.subLabel.text = item.period
            cell.titleLabel.font = UIFont(name: "PretendardGOV-Medium", size: 12)
            cell.subLabel.font = UIFont(name: "PretendardGOV-Medium", size: 10)
            cell.imageView.kf.setImage(
                with: URL(string: item.image),
                options: [
                    .processor(processor),
                    .scaleFactor(UIScreen.main.scale),
                    .transition(.fade(0.3)),
                    .cacheOriginalImage
                ]
            )
        }
        
        cell.layer.cornerRadius = 8
        cell.layer.masksToBounds = true
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let cell = collectionView.cellForItem(at: indexPath) as? HomeCollectionViewCell else { return }
        let titleLabelText = cell.titleLabel.text ?? "없음"
        
        
        if collectionView == collectionView1 {
            guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "ExperienceDetailVC") as? ExperienceDetailVC else { return }
            let nextVM = ExperienceDetailVM(token: vm.token , targetName: titleLabelText)
            nextVC.vm = nextVM
            
            // ✅ LoadingVC 표시
            guard let loadingVC = storyboard?.instantiateViewController(withIdentifier: "LoadingVC") as? LoadingVC else { return }
            loadingVC.modalPresentationStyle = .overFullScreen
            present(loadingVC, animated: false) {
                
                // API 호출
                nextVM.getDetailInfoAPI(name: titleLabelText) {
                    
                    DispatchQueue.main.async {
                        // 로딩 모달 닫기
                        loadingVC.dismiss(animated: false) {
                            
                            // API 성공 여부 확인
                            if nextVM.name.isEmpty {
                                // ❌ 데이터 없으면 Alert 표시
                                let alert = UIAlertController(title: "오류", message: "데이터를 불러오지 못했습니다.\n다시 한 번 시도해 주세요.", preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "확인", style: .default))
                                self.present(alert, animated: true)
                            } else {
                                // ✅ 성공 시 DetailVC push
                                self.navigationController?.pushViewController(nextVC, animated: true)
                            }
                            
                        }
                    }
                }
            }
        } else if collectionView == collectionView2 {
            guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "CafeDetailVC") as? CafeDetailVC else { return }
            let nextVM = CafeDetailVM(token: vm.token, targetName: titleLabelText)
            nextVC.vm = nextVM
            
            // ✅ LoadingVC 표시
            guard let loadingVC = storyboard?.instantiateViewController(withIdentifier: "LoadingVC") as? LoadingVC else { return }
            loadingVC.modalPresentationStyle = .overFullScreen
            present(loadingVC, animated: false) {
                
                // API 호출
                nextVM.getDetailInfoAPI(name: titleLabelText) {
                    
                    DispatchQueue.main.async {
                        // 로딩 모달 닫기
                        loadingVC.dismiss(animated: false) {
                            
                            // API 성공 여부 확인
                            if nextVM.name.isEmpty {
                                // ❌ 데이터 없으면 Alert 표시
                                let alert = UIAlertController(title: "오류", message: "데이터를 불러오지 못했습니다.\n다시 한 번 시도해 주세요.", preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "확인", style: .default))
                                self.present(alert, animated: true)
                            } else {
                                // ✅ 성공 시 DetailVC push
                                self.navigationController?.pushViewController(nextVC, animated: true)
                            }
                            
                        }
                    }
                }
            }
        } else if collectionView == collectionView3 {
            guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "LocationDetailVC") as? LocationDetailVC else { return }
            let nextVM = LocationDetailVM(token: vm.token, targetName: titleLabelText)
            nextVC.vm = nextVM
            
            // ✅ LoadingVC 표시
            guard let loadingVC = storyboard?.instantiateViewController(withIdentifier: "LoadingVC") as? LoadingVC else { return }
            loadingVC.modalPresentationStyle = .overFullScreen
            present(loadingVC, animated: false) {
                
                // API 호출
                nextVM.getDetailInfoAPI(name: titleLabelText) {
                    
                    DispatchQueue.main.async {
                        // 로딩 모달 닫기
                        loadingVC.dismiss(animated: false) {
                            
                            // API 성공 여부 확인
                            if nextVM.name.isEmpty {
                                // ❌ 데이터 없으면 Alert 표시
                                let alert = UIAlertController(title: "오류", message: "데이터를 불러오지 못했습니다.\n다시 한 번 시도해 주세요.", preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "확인", style: .default))
                                self.present(alert, animated: true)
                            } else {
                                // ✅ 성공 시 DetailVC push
                                self.navigationController?.pushViewController(nextVC, animated: true)
                            }
                            
                        }
                    }
                }
            }
        } else if collectionView == collectionView4 {
            guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "FastivalDetailVC") as? FastivalDetailVC else { return }
            let nextVM = FastivalDetailVM(token: vm.token, targetName: titleLabelText)
            nextVC.vm = nextVM
            
            // ✅ LoadingVC 표시
            guard let loadingVC = storyboard?.instantiateViewController(withIdentifier: "LoadingVC") as? LoadingVC else { return }
            loadingVC.modalPresentationStyle = .overFullScreen
            present(loadingVC, animated: false) {
                
                // API 호출
                nextVM.getDetailInfoAPI(name: titleLabelText) {
                    
                    DispatchQueue.main.async {
                        // 로딩 모달 닫기
                        loadingVC.dismiss(animated: false) {
                            
                            // API 성공 여부 확인
                            if nextVM.name.isEmpty {
                                // ❌ 데이터 없으면 Alert 표시
                                let alert = UIAlertController(title: "오류", message: "데이터를 불러오지 못했습니다.\n다시 한 번 시도해 주세요.", preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "확인", style: .default))
                                self.present(alert, animated: true)
                            } else {
                                // ✅ 성공 시 DetailVC push
                                self.navigationController?.pushViewController(nextVC, animated: true)
                            }
                            
                        }
                    }
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 185, height: 180)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 12 // 셀 간 좌우 간격
    }
    
}

class HomeCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subLabel: UILabel!
}

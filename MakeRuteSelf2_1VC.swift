//
//  MakeRuteSelf2_1VC.swift
//  TryLocal
//
//  Created by 시모니의 맥북 on 8/4/25.
//

import UIKit
import Combine

class MakeRuteSelf2_1VC: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var questionLabel1: UILabel!
    @IBOutlet weak var questionLabel2: UILabel!
    @IBOutlet weak var startPlaceLabel: UILabel!
    @IBOutlet weak var searchAdressBtn: UIButton!
    @IBOutlet weak var addPlaceBtn: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var makeRuteBtn: UIButton!
    var vm: MakeRuteSelf2_1VM!
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        configure()
        
    }
    
    private func configure() {
        configureUI()
        bind()
    }
    
    private func configureUI() {
        titleLabel.font = UIFont(name: "PretendardGOV-Bold", size: 28)
        questionLabel1.font = UIFont(name: "PretendardGOV-Bold", size: 12)
        questionLabel2.font = UIFont(name: "PretendardGOV-Bold", size: 12)
        startPlaceLabel.font = UIFont(name: "PretendardGOV-Thin", size: 16)
        searchAdressBtn.layer.cornerRadius = 8
        addPlaceBtn.layer.borderWidth = 1
        addPlaceBtn.layer.borderColor = UIColor.black.cgColor
        addPlaceBtn.layer.cornerRadius = 8
        makeRuteBtn.layer.cornerRadius = 8
        self.navigationItem.backButtonTitle = ""
        self.navigationController?.navigationBar.tintColor = .black
    }
    
    private func bind() {
            // startAdresse + selectedPlaces 변화 감지해서 버튼 show/hide
            Publishers.CombineLatest(vm.$startAdress, vm.$selectedPlaces)
                .receive(on: DispatchQueue.main)
                .sink { [weak self] adresse, places in
                    self?.makeRuteBtn.isHidden = adresse.isEmpty || places.isEmpty
                }
                .store(in: &cancellables)
        }
    
    // ✅ fetchRouteDetail + 화면 전환을 하나의 함수로 분리
    private func fetchAndNavigate(loadingVC: UIViewController) {
        self.vm.fetchRouteDetail(submissionID: self.vm.submissionID) { [weak self] in
            guard let self = self else { return }
            print("fetchRouteDetail 완료 → 지도 뿌리기 준비")
            
            // ✅ 로딩VC 닫고 ResultMapVC로 이동
            loadingVC.dismiss(animated: false) {
                guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "ResultMapVC") as? ResultMapVC else { return }
                let nextVM = ResultMapVM(token: self.vm.token)
                nextVM.daySubViewIsHidden = true
                
                // ✅ fetchRouteDetail에서 업데이트된 selectedPlaces 사용
                nextVM.names = self.vm.selectedPlaces.map { $0.name ?? "" }
                nextVM.latitudes = self.vm.selectedPlaces.map { "\($0.latitude ?? 0)" }
                nextVM.longitudes = self.vm.selectedPlaces.map { "\($0.longitude ?? 0)" }
                nextVM.addresses = self.vm.selectedPlaces.map { $0.address ?? "" }
                nextVM.imgURLs = self.vm.selectedPlaces.map { $0.image ?? "" }
                nextVM.types = self.vm.selectedPlaces.map { $0.type_label ?? "" }
                nextVM.orders = self.vm.selectedPlaces.map { "\($0.order ?? 0)" }
                nextVM.submissionID = self.vm.submissionID
                nextVM.titleLabelText = "나의 여정"
                nextVM.backBtnIsHidden = true
                nextVC.vm = nextVM
                
                self.navigationController?.pushViewController(nextVC, animated: true)
            }
        }
    }
    
    //MARK: - Action func
    @IBAction func tapSearchAdressBtn(_ sender: UIButton) {
        // 주소 찾기
        guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "SearchAdressVC") as? SearchAdressVC else { return }
        nextVC.vm = SearchAdressVM()
        nextVC.startAdressDelegate = self
        nextVC.modalPresentationStyle = .pageSheet
        present(nextVC, animated: true)
    }
    
    @IBAction func tapAddPlaceBtn(_ sender: UIButton) {
        // 장소 추가하기 (네이게이션뷰 X , 모달 풀스크린으로 하고 정보를 가지고 다시 이 뷰로 돌아와야함.)
        guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "Makeruteself_AddPlaceVC") as? Makeruteself_AddPlaceVC else { return }
        nextVC.vm = Makeruteself_AddPlaceVM()
        nextVC.vm.token = vm.token
        nextVC.vm.selectedItems = vm.selectedPlaces
        nextVC.delegate = self
        nextVC.modalPresentationStyle = .fullScreen
        present(nextVC, animated: true)
    }
    
    @IBAction func tapMakeRuteBtn(_ sender: UIButton) {
//   
//        // ✅ LoadingVC 표시
//        guard let loadingVC = storyboard?.instantiateViewController(withIdentifier: "RouteLodingVC") as? RouteLodingVC else { return }
//        loadingVC.modalPresentationStyle = .overFullScreen
//        present(loadingVC, animated: false) {
//            
//            self.vm.settingRouteAPI(submissionID: self.vm.submissionID,
//                                    startAddress: self.vm.startAdress,
//                                    places: self.vm.selectedPlaceNames,
//                                    startDate: self.vm.startDate,
//                                    endDate: self.vm.endDate,
//                                    token: self.vm.token) { [weak self] in
//                guard let self = self else { return }
//                
//                self.vm.gptAnswerRouteAPI(submissionID: self.vm.submissionID,
//                                          username: self.vm.userName,
//                                          q1: self.vm.q1,
//                                          q2: self.vm.q2,
//                                          q3: nil,
//                                          startDate: self.vm.startDate,
//                                          endDate: self.vm.endDate) { [weak self] _ in
//                    guard let self = self else { return }
//                    print("gptAnswerRouteAPI 완료 → fetchRouteDetail 호출")
//                    
//                    self.vm.fetchRouteDetail(submissionID: self.vm.submissionID) {
//                        print("fetchRouteDetail 완료 → 지도 뿌리기 준비")
//                        
//                        // ✅ 로딩VC 닫고 ResultMapVC로 이동
//                        loadingVC.dismiss(animated: false) {
//                            guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "ResultMapVC") as? ResultMapVC else { return }
//                            let nextVM = ResultMapVM(token: self.vm.token)
//                            nextVM.daySubViewIsHidden = true  // 안보이게.
//                            
//                            nextVM.names = self.vm.selectedPlaces.map { $0.name ?? "" }
//                            nextVM.latitudes = self.vm.selectedPlaces.map { "\($0.latitude ?? 0)" }
//                            nextVM.longitudes = self.vm.selectedPlaces.map { "\($0.longitude ?? 0)" }
//                            nextVM.addresses = self.vm.selectedPlaces.map { $0.address ?? "" }
//                            nextVM.imgURLs = self.vm.selectedPlaces.map { $0.image ?? "" }
//                            nextVM.types = self.vm.selectedPlaces.map { $0.type_label ?? "" }
//                            nextVM.orders = self.vm.selectedPlaces.map { "\($0.order ?? 0)" }
//                            nextVM.submissionID = self.vm.submissionID
//                            nextVM.titleLabelText = "나의 여정"
//                            nextVM.backBtnIsHidden = true
//                            nextVC.vm = nextVM
//                            
//                            self.navigationController?.pushViewController(nextVC, animated: true)
//                        }
//                    }
//                }
//            }
//        }
        
        // ✅ LoadingVC 표시
           guard let loadingVC = storyboard?.instantiateViewController(withIdentifier: "RouteLodingVC") as? RouteLodingVC else { return }
           loadingVC.modalPresentationStyle = .overFullScreen
           present(loadingVC, animated: false) {
               
               self.vm.settingRouteAPI(submissionID: self.vm.submissionID,
                                       startAddress: self.vm.startAdress,
                                       places: self.vm.selectedPlaceNames,
                                       startDate: self.vm.startDate,
                                       endDate: self.vm.endDate,
                                       token: self.vm.token) { [weak self] in
                   guard let self = self else { return }
                   
                   self.vm.gptAnswerRouteAPI(submissionID: self.vm.submissionID,
                                             username: self.vm.userName,
                                             q1: self.vm.q1,
                                             q2: self.vm.q2,
                                             q3: nil,
                                             startDate: self.vm.startDate,
                                             endDate: self.vm.endDate) { [weak self] response in
                       guard let self = self else { return }
                       
                       // ✅ gptAnswerRouteAPI 결과 체크
                       if response != nil {
                           // 성공: 바로 fetchRouteDetail 호출
                           print("gptAnswerRouteAPI 완료 → fetchRouteDetail 호출")
                           self.fetchAndNavigate(loadingVC: loadingVC)
                       } else {
                           // 실패: 10초 후 재시도
                           print("gptAnswerRouteAPI 에러 발생 → 20초 후 fetchRouteDetail 재시도")
                           DispatchQueue.main.asyncAfter(deadline: .now() + 20) { [weak self] in
                               self?.fetchAndNavigate(loadingVC: loadingVC)
                           }
                       }
                   }
               }
           }
        
    }
    
    
    
}

extension MakeRuteSelf2_1VC: UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return vm.selectedPlaces.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MakeRuteCollectionViewCell", for: indexPath) as? MakeRuteCollectionViewCell else {
            return UICollectionViewCell()
        }
        let item = vm.selectedPlaces[indexPath.item]
            
            // ✅ 라벨 세팅
            cell.placeLabel.text = item.name
            cell.categoryLabel.text = item.type_label
            
            // ✅ type_label에 따른 색상
            switch item.type_label {
            case "체험":
                cell.subView.backgroundColor = UIColor(hex: "#5C3800")
            case "관광":
                cell.subView.backgroundColor = UIColor(hex: "#D977DE")
            default:
                cell.subView.backgroundColor = UIColor(hex: "#E7AC52")
            }
        
        cell.placeLabel.font = UIFont(name: "PretendardGOV-Bold", size: 16)
        cell.categoryLabel.font = UIFont(name: "PretendardGOV-Bold", size: 8)
        cell.subView.layer.cornerRadius = 12
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 1.0
        cell.layer.cornerRadius = 8
        cell.layer.masksToBounds = true
        
        return cell
    }
    
    // 셀 크기 지정
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        return CGSize(width: width, height: 48)
    }
    
    // 세로 간격 (라인 간격)
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    
}

//MARK: - Delegate패턴
extension MakeRuteSelf2_1VC: sendStartAdressDelegate{
    func sendStartAdress(adress: String) {
        self.startPlaceLabel.text = adress
        vm.startAdress = adress
    }
}

extension MakeRuteSelf2_1VC: AddPlaceDelegate{
    func didSelectPlaces(_ places: [getFullListRouteItem]) {
        // ✅ 받은 데이터를 VM에 저장
        vm.selectedPlaces = places
        
        // ✅ 컬렉션뷰 리로드
        collectionView.reloadData()
    }
    
    
}

class MakeRuteCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var subView: UIView!
    @IBOutlet weak var categoryLabel: UILabel!
}


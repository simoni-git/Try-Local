//
//  MakeruteSelf2_2VC.swift
//  TryLocal
//
//  Created by 시모니의 맥북 on 8/5/25.
//

import UIKit
import Combine

class MakeRuteSelf2_2VC: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var questionLabel1: UILabel!
    @IBOutlet weak var questionLabel2: UILabel!
    @IBOutlet weak var questionLabel3: UILabel!
    @IBOutlet weak var startPointLabel: UILabel!
    @IBOutlet weak var basecampPointLabel: UILabel!
    @IBOutlet weak var searchAdressBtn1: UIButton!
    @IBOutlet weak var searchAdressBtn2: UIButton!
    @IBOutlet weak var addPlaceBtn: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var makeRuteBtn: UIButton!
    var vm: MakeRuteSelf2_2VM!
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
        questionLabel3.font = UIFont(name: "PretendardGOV-Bold", size: 12)
        startPointLabel.font = UIFont(name: "PretendardGOV-Thin", size: 16)
        basecampPointLabel.font = UIFont(name: "PretendardGOV-Thin", size: 16)
        searchAdressBtn1.layer.cornerRadius = 8
        searchAdressBtn2.layer.cornerRadius = 8
        addPlaceBtn.layer.borderWidth = 1
        addPlaceBtn.layer.borderColor = UIColor.black.cgColor
        addPlaceBtn.layer.cornerRadius = 8
        makeRuteBtn.layer.cornerRadius = 8
        self.navigationItem.backButtonTitle = ""
        self.navigationController?.navigationBar.tintColor = .black
    }
    
    private func bind() {
        Publishers.CombineLatest3(vm.$startAdress, vm.$selectedPlaces, vm.$restPointAdress)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] adresse, places, rest in
                self?.makeRuteBtn.isHidden = adresse.isEmpty || places.isEmpty || rest.isEmpty
            }
            .store(in: &cancellables)
    }
    
    //MARK: - Action func
    
    @IBAction func tapSearchAdressBtn1(_ sender: UIButton) {
        // 주소 찾기
        guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "SearchAdressVC") as? SearchAdressVC else { return }
        nextVC.vm = SearchAdressVM()
        nextVC.startAdressDelegate = self
        nextVC.modalPresentationStyle = .pageSheet
        present(nextVC, animated: true)
    }
    
    @IBAction func tapSearchAdressBtn2(_ sender: UIButton) {
        // 주소 찾기
        guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "SearchAdressVC") as? SearchAdressVC else { return }
        nextVC.vm = SearchAdressVM()
        nextVC.restPointAdressDelegate = self
        nextVC.vm.isStartAdressMode = false
        nextVC.modalPresentationStyle = .pageSheet
        present(nextVC, animated: true)
    }
    
    @IBAction func tapAddPlaceBtn(_ sender: UIButton) {
        // 장소 추가하기 (네이게이션뷰 X , 모달 풀스크린으로 하고 정보를 가지고 다시 이 뷰로 돌아와야함.)
        guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "Makeruteself_AddPlaceVC") as? Makeruteself_AddPlaceVC else { return }
        nextVC.vm = Makeruteself_AddPlaceVM()
        nextVC.vm.token = vm.token
        nextVC.vm.selectedItems = vm.selectedPlaces
        nextVC.vm.isTodayRoute = false
        nextVC.delegate = self
        nextVC.modalPresentationStyle = .fullScreen
        present(nextVC, animated: true)
    }
    
    @IBAction func tapMakeRuteBtn(_ sender: UIButton) {

        // ✅ 로딩 모달 띄우기
        guard let loadingVC = storyboard?.instantiateViewController(withIdentifier: "RouteLodingVC") as? RouteLodingVC else { return }
        loadingVC.modalPresentationStyle = .overFullScreen
        present(loadingVC, animated: false) {
            
            // 1. AI로 최적 경로 요청
            self.vm.settingRouteAPI(
                submissionID: self.vm.submissionID,
                startAddress: self.vm.startAdress,
                restPointAdress: self.vm.restPointAdress,
                places: self.vm.selectedPlaceNames,
                startDate: self.vm.startDate,
                endDate: self.vm.endDate,
                token: self.vm.token
            ) { [weak self] in
                guard let self = self else { return }
                
                // 2. GPT 최적 경로 API 호출
                self.vm.gptAnswerRouteAPI(
                    submissionID: self.vm.submissionID,
                    username: self.vm.userName,
                    q1: self.vm.q1,
                    q2: self.vm.q2,
                    q3: nil,
                    startDate: self.vm.startDate,
                    endDate: self.vm.endDate
                ) {
                    print("✅ gptAnswerRouteAPI 성공! selectedPlaces 개수: \(self.vm.selectedPlaces.count)")
                    
                    // 3. 1박2일 상세 조회 API
                    self.vm.fetchOvernightRoute(submissionID: self.vm.submissionID) {
                        print("day1 갯수 =>\(self.vm.namesDay1.count), day2 갯수 => \(self.vm.namesDay2.count), 통합갯수 => \(self.vm.names.count)")
                        
                        // ✅ 로딩 모달 닫고 ResultMapVC로 이동
                        loadingVC.dismiss(animated: false) {
                            guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "ResultMapVC") as? ResultMapVC else { return }
                            let nextVM = ResultMapVM(token: self.vm.token)
                            nextVC.vm = nextVM
                            nextVM.daySubViewIsHidden = false // day1/day2 서브뷰 보이기
                            
                            // Day1 데이터
                            nextVM.namesDay1 = self.vm.namesDay1
                            nextVM.latitudesDay1 = self.vm.latitudesDay1
                            nextVM.longitudesDay1 = self.vm.longitudesDay1
                            nextVM.addressesDay1 = self.vm.addressesDay1
                            nextVM.imgURLsDay1 = self.vm.imgURLsDay1
                            nextVM.typesDay1 = self.vm.typesDay1
                            nextVM.ordersDay1 = self.vm.ordersDay1
                            
                            // Day2 데이터
                            nextVM.namesDay2 = self.vm.namesDay2
                            nextVM.latitudesDay2 = self.vm.latitudesDay2
                            nextVM.longitudesDay2 = self.vm.longitudesDay2
                            nextVM.addressesDay2 = self.vm.addressesDay2
                            nextVM.imgURLsDay2 = self.vm.imgURLsDay2
                            nextVM.typesDay2 = self.vm.typesDay2
                            nextVM.ordersDay2 = self.vm.ordersDay2
                            
                            // 통합 데이터
                            nextVM.names = self.vm.names
                            nextVM.latitudes = self.vm.latitudes
                            nextVM.longitudes = self.vm.longitudes
                            nextVM.addresses = self.vm.addresses
                            nextVM.imgURLs = self.vm.imgURLs
                            nextVM.types = self.vm.types
                            nextVM.orders = self.vm.orders
                            
                            nextVM.submissionID = self.vm.submissionID
                            nextVM.titleLabelText = "나의 여정"
                            nextVM.backBtnIsHidden = true
                            nextVC.vm = nextVM
                            self.navigationController?.pushViewController(nextVC, animated: true)
                        }
                    }
                }
            }
        }
        
        
    }
    
}




extension MakeRuteSelf2_2VC: UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
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
extension MakeRuteSelf2_2VC: sendStartAdressDelegate{
    func sendStartAdress(adress: String) {
        self.startPointLabel.text = adress
        vm.startAdress = adress
    }
}
extension MakeRuteSelf2_2VC: sendRestPointAdressDelegate{
    func sendRestPointAdress(adress: String) {
        self.basecampPointLabel.text = adress
        vm.restPointAdress = adress
    }
    
}
extension MakeRuteSelf2_2VC: AddPlaceDelegate{
    func didSelectPlaces(_ places: [getFullListRouteItem]) {
        // ✅ 받은 데이터를 VM에 저장
        vm.selectedPlaces = places
        
        // ✅ 컬렉션뷰 리로드
        collectionView.reloadData()
    }
    
    
}

//
//  MakeUserSearchFarmAdressVC.swift
//  TryLocal
//
//  Created by 시모니의 맥북 on 6/6/25.
//

//import UIKit
//import Combine
//
//class MakeUser_4p_SearchFarmAdressVC: UIViewController {
//    
//    @IBOutlet weak var adressTextField: UITextField!
//    @IBOutlet weak var leftLabel: UILabel!
//    @IBOutlet weak var centerLabel: UILabel!
//    @IBOutlet weak var rightLabel: UILabel!
//    @IBOutlet weak var tableView: UITableView!
//    @IBOutlet weak var searchBtn: UIButton!
//    var vm: MakeUserVM!
//    private var bag = Set<AnyCancellable>()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        tableView.dataSource = self
//        tableView.delegate = self
//        configure()
//    }
//    
//    private func configure() {
//        configureUI()
//        setupTapToDismissKeyboard()
//        vm.$addressList
//            .receive(on: RunLoop.main)
//            .sink { [weak self] _ in
//                self?.tableView.reloadData()
//            }
//            .store(in: &bag)
//    }
//    
//    private func configureUI() {
//        leftLabel.font = UIFont(name: "PretendardGOV-SemiBold", size: 12)
//        centerLabel.font = UIFont(name: "PretendardGOV-SemiBold", size: 12)
//        rightLabel.font = UIFont(name: "PretendardGOV-SemiBold", size: 12)
//        searchBtn.layer.cornerRadius = 8
//    }
//    
//   
//    
//    //MARK: - keyBoard 관련
//    private func setupTapToDismissKeyboard() {
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
//        tapGesture.cancelsTouchesInView = false
//        view.addGestureRecognizer(tapGesture)
//    }
//    
//    @objc private func dismissKeyboard() {
//        view.endEditing(true)
//    }
//    
//    //MARK: - Action func
//    @IBAction func tapSearchBtn(_ sender: UIButton) {
//        //주소 API 돌리기.
//        guard let text = adressTextField.text else { return }
//        vm.searchAddressList_API(keyword: text) { jusos in
//            for juso in jusos {
//                print("도로명: \(juso.roadAddr), 지번: \(juso.jibunAddr), 우편번호: \(juso.zipNo)")
//            }
//        }
//    }
//    
//}
//
////MARK: - TabelView 관련
//extension MakeUser_4p_SearchFarmAdressVC: UITableViewDelegate, UITableViewDataSource {
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "AdressCell", for: indexPath) as? AdressCell else {
//            return UITableViewCell()
//        }
//        cell.loadNameLabel.font = UIFont(name: "PretendardGOV-SemiBold", size: 12)
//        cell.numberLabel.font = UIFont(name: "PretendardGOV-Regular", size: 12)
//        cell.adressLabel.font = UIFont(name: "PretendardGOV-Regular", size: 10)
//        cell.numberLabel.font = UIFont(name: "PretendardGOV-Regular", size: 12)
//        
//        let juso = vm.addressList[indexPath.row]
//        cell.numberLabel.text = "\(indexPath.row + 1)"
//        cell.loadNameLabel.text = juso.roadAddr
//        cell.adressLabel.text = "[지번] \(juso.jibunAddr)"
//        cell.postNumberLabel.text = juso.zipNo
//        return cell
//    }
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return vm.addressList.count
//    }
//    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 60
//    }
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let selectedJuso = vm.addressList[indexPath.row]
//        vm.selectedRoadAddress = selectedJuso.roadAddr  // 도로명 주소 저장
//        
//        print("선택된 도로명 주소: \(vm.selectedRoadAddress)")
//        
//        // 필요하면 키보드 내리기, 화면 닫기 등 처리 가능
//        view.endEditing(true)
//        tableView.deselectRow(at: indexPath, animated: true)
//        self.dismiss(animated: true, completion: nil)
//    }
//    
//}
//
//class AdressCell: UITableViewCell {
//    @IBOutlet weak var numberLabel: UILabel!
//    @IBOutlet weak var loadNameLabel: UILabel!
//    @IBOutlet weak var adressLabel: UILabel!
//    @IBOutlet weak var postNumberLabel: UILabel!
//}
//‼️ 7월 말 회의 결과 농부용 회원가입은 사용하지 않기로 결정, 해당 뷰 컨트롤러는 사용하지 않기에 주석처리함(8/4)

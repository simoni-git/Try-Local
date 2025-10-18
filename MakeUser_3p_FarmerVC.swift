//
//  MakeUser_3p_FarmerVC.swift
//  TryLocal
//
//  Created by 시모니의 맥북 on 5/28/25.
//

//import UIKit
//import Combine
//
//class MakeUser_3p_FarmerVC: UIViewController {
//    
//    @IBOutlet weak var titleLabel: UILabel!
//    @IBOutlet weak var farmNameLabel: UILabel!
//    @IBOutlet weak var addressLabel: UILabel!
//    @IBOutlet weak var farmAddressLabel: UILabel!
//    @IBOutlet weak var addressSubView: UIView!
//    @IBOutlet weak var farmNameTextField: UITextField!
//    @IBOutlet weak var searchAddressBtn: UIButton!
//    @IBOutlet weak var continueBtn: UIButton!
//    var vm: MakeUserVM!
//    var bag = Set<AnyCancellable>()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        configure()
//        
//    }
//    
//    private func configure() {
//        configureUI()
//        bindNotification()
//        setupTapToDismissKeyboard()
//        vm.$continueBtnIsHidden_3p_Farmer
//            .receive(on: RunLoop.main)
//            .assign(to: \.isHidden, on: continueBtn)
//            .store(in: &self.bag)
//        vm.$selectedRoadAddress
//            .receive(on: RunLoop.main)
//            .sink { [weak self] newAddress in
//                self?.farmAddressLabel.text = newAddress
//                self?.vm.checkIsEmptyFarmInfo()
//            }
//            .store(in: &bag)
//    }
//    
//    private func configureUI() {
//        titleLabel.font = UIFont(name: "PretendardGOV-Bold", size: 28)
//        farmNameLabel.font = UIFont(name: "PretendardGOV-Bold", size: 12)
//        addressLabel.font = UIFont(name: "PretendardGOV-Bold", size: 12)
//        farmAddressLabel.font = UIFont(name: "PretendardGOV-Regular", size: 16)
//        farmNameTextField.layer.cornerRadius = 8
//        farmNameTextField.layer.borderWidth = 1
//        farmNameTextField.layer.borderColor = UIColor.black.cgColor
//        farmNameTextField.text = vm.farmName ?? ""
//        addressSubView.layer.cornerRadius = 8
//        addressSubView.layer.borderWidth = 1
//        addressSubView.layer.borderColor = UIColor.black.cgColor
//        farmAddressLabel.text? = vm.selectedRoadAddress ?? ""
//        searchAddressBtn.layer.cornerRadius = 8
//        continueBtn.layer.cornerRadius = 8
//        searchAddressBtn.titleLabel?.adjustsFontSizeToFitWidth = true
//        searchAddressBtn.titleLabel?.minimumScaleFactor = 0.5
//        searchAddressBtn.titleLabel?.numberOfLines = 1
//        self.navigationItem.backButtonTitle = ""
//        self.navigationController?.navigationBar.tintColor = .black
//        
//    }
//    
//    //MARK: - Notification 관련
//    private func bindNotification() {
//        NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: farmNameTextField)
//            .compactMap{ ($0.object as? UITextField)?.text }
//            .sink { [weak self] newText in
//                self?.vm.farmName = newText
//                self?.vm.checkIsEmptyFarmInfo()
//            }
//            .store(in: &self.bag)
//    }
//    
//    // MARK: - keyBoard 관련
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
//    @IBAction func tapSearchAddressBtn(_ sender: UIButton) {
//        print("MakeUser_3p_FarmerVC SearchAddressBtn - tapped")
//        guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "MakeUser_4p_SearchFarmAdressVC") as? MakeUser_4p_SearchFarmAdressVC else { return }
//        nextVC.vm = self.vm
//        nextVC.modalPresentationStyle = .pageSheet
//        present(nextVC, animated: true)
//    }
//    
//    
//    
//    @IBAction func tapContinueBtn(_ sender: UIButton) {
//        print("MakeUser_3p_FarmerVC continueBtn - tapped")
//        
//        guard let nextVC = storyboard?.instantiateViewController(withIdentifier: "MakeUser_5p_FarmerVC") as? MakeUser_5p_FarmerVC else { return }
//        nextVC.vm = self.vm
//        navigationController?.pushViewController(nextVC, animated: true)
//    }
//    
//}
//‼️ 7월 말 회의 결과 농부용 회원가입은 사용하지 않기로 결정, 해당 뷰 컨트롤러는 사용하지 않기에 주석처리함(8/4)

//
//  MakeUser_5p_FarmerVC.swift
//  TryLocal
//
//  Created by 시모니의 맥북 on 6/7/25.
//

//import UIKit
//import Combine
//
//class MakeUser_5p_FarmerVC: UIViewController {
//    
//    @IBOutlet weak var titleLabel: UILabel!
//    @IBOutlet weak var nameLabel: UILabel!
//    @IBOutlet weak var businessStartDateLabel: UILabel!
//    @IBOutlet weak var businessNumberLabel: UILabel!
//    @IBOutlet weak var errorDateLabel: UILabel!
//    @IBOutlet weak var errorBusinessNumberLabel: UILabel!
//    @IBOutlet weak var nameTextField: UITextField!
//    @IBOutlet weak var dateTextField: UITextField!
//    @IBOutlet weak var numberTextField: UITextField!
//    @IBOutlet weak var continueBtn: UIButton!
//    
//    var vm: MakeUserVM!
//    private var bag = Set<AnyCancellable>()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        configure()
//        
//    }
//    
//    private func configure() {
//        confiogureUI()
//        bindNotification()
//        keyBoardSetting()
//        vm.$continueBtnIsHidden_5p_Farmer
//            .receive(on: RunLoop.main)
//            .assign(to: \.isHidden, on: continueBtn)
//            .store(in: &self.bag)
//        
//        // 중복확인 API 호출은 isvalidCEO 변화 감지 유지
//        vm.$isvalidCEO
//            .compactMap { $0 }  // nil 제거
//            .removeDuplicates()
//            .sink { [weak self] isValid in
//                guard let self = self else { return }
//                if isValid, let bno = self.vm.farmBusinessNumber {
//                    self.vm.checkDuplicateBusinessNumber_API(bno)
//                } else {
//                    DispatchQueue.main.async {
//                        self.errorBusinessNumberLabel.text = "유효하지 않은 사업자입니다"
//                        self.errorBusinessNumberLabel.textColor = .red
//                    }
//                }
//            }
//            .store(in: &bag)
//        
//        // 세 가지 상태를 한번에 보고 버튼 텍스트와 색상 처리
//        Publishers.CombineLatest3(
//            vm.$continueBtnIsHidden_5p_Farmer,
//            vm.$isvalidCEO.compactMap { $0 },
//            vm.$isDuplicateBusinessNumber.compactMap { $0 }
//        )
//        .receive(on: RunLoop.main)
//        .sink { [weak self] isHidden, isValidCEO, isDuplicate in
//            guard let self = self else { return }
//            guard !isHidden else { return } // 버튼이 보이지 않으면 처리하지 않음
//            
//            if isValidCEO {
//                if isDuplicate {
//                    // 유효하지만 중복된 경우
//                    self.errorBusinessNumberLabel.text = "이미 가입된 농가입니다"
//                    self.errorBusinessNumberLabel.textColor = .red
//                    self.nameTextField.isEnabled = true
//                    self.dateTextField.isEnabled = true
//                    self.numberTextField.isEnabled = true
//                    self.continueBtn.setTitle("인증하기", for: .normal)
//                    self.continueBtn.backgroundColor = UIColor.black
//                } else {
//                    // 유효하고 중복없음
//                    self.errorBusinessNumberLabel.text = "등록 가능한 농가입니다"
//                    self.errorBusinessNumberLabel.textColor = .blue
//                    self.nameTextField.isEnabled = false
//                    self.dateTextField.isEnabled = false
//                    self.numberTextField.isEnabled = false
//                    self.continueBtn.setTitle("계속하기", for: .normal)
//                    self.continueBtn.backgroundColor = UIColor(hex: "#E7AC52")
//                }
//            } else {
//                // 유효하지 않음
//                self.errorBusinessNumberLabel.text = "유효하지 않은 사업자입니다"
//                self.errorBusinessNumberLabel.textColor = .red
//                self.continueBtn.setTitle("인증하기", for: .normal)
//                self.continueBtn.backgroundColor = UIColor.black
//            }
//        }
//        .store(in: &bag)
//        
//    }
//    
//    private func confiogureUI() {
//        titleLabel.font = UIFont(name: "PretendardGOV-Bold", size: 28)
//        nameLabel.font = UIFont(name: "PretendardGOV-Bold", size: 12)
//        businessStartDateLabel.font = UIFont(name: "PretendardGOV-Bold", size: 12)
//        businessNumberLabel.font = UIFont(name: "PretendardGOV-Bold", size: 12)
//        errorDateLabel.font = UIFont(name: "PretendardGOV-Thin", size: 12)
//        errorBusinessNumberLabel.font = UIFont(name: "PretendardGOV-Thin", size: 12)
//
//        nameTextField.layer.cornerRadius = 8
//        nameTextField.layer.borderWidth = 1
//        nameTextField.layer.borderColor = UIColor.black.cgColor
//        nameTextField.text = vm.farmCEOname ?? ""
//        
//        dateTextField.layer.cornerRadius = 8
//        dateTextField.layer.borderWidth = 1
//        dateTextField.layer.borderColor = UIColor.black.cgColor
//        dateTextField.text = vm.farmOpenDate ?? ""
//        
//        numberTextField.layer.cornerRadius = 8
//        numberTextField.layer.borderWidth = 1
//        numberTextField.layer.borderColor = UIColor.black.cgColor
//        numberTextField.text = vm.farmBusinessNumber ?? ""
//        
//        continueBtn.backgroundColor = .black
//        continueBtn.layer.cornerRadius = 8
//    }
//    
//    //MARK: - Notification 관련
//    private func bindNotification() {
//        NotificationCenter.default
//            .publisher(for: UITextField.textDidChangeNotification, object: nameTextField)
//            .compactMap { ($0.object as? UITextField)?.text }
//            .sink { [weak self] newText in
//                self?.vm.farmCEOname = newText
//                print("현재 입력된 사업자명 : \(String(describing: newText))")
//                self?.vm.checkCEOInfo()
//            }
//            .store(in: &self.bag)
//        
//        NotificationCenter.default
//            .publisher(for: UITextField.textDidChangeNotification, object: dateTextField)
//            .compactMap { ($0.object as? UITextField)?.text }
//            .sink { [weak self] newText in
//                self?.vm.farmOpenDate = newText
//                print("현재 입력된 개업일자 : \(String(describing: newText))")
//                self?.vm.checkCEOInfo()
//            }
//            .store(in: &self.bag)
//        
//        NotificationCenter.default
//            .publisher(for: UITextField.textDidChangeNotification, object: numberTextField)
//            .compactMap { ($0.object as? UITextField)?.text }
//            .sink { [weak self] newText in
//                self?.vm.farmBusinessNumber = newText
//                print("현재 입력된 사업자번호 : \(String(describing: newText))")
//                self?.vm.checkCEOInfo()
//            }
//            .store(in: &self.bag)
//        
//    }
//    
//    // MARK: - keyBoard 관련
//    private func keyBoardSetting() {
//        setupKeyboardObservers()
//        setupTapToDismissKeyboard()
//    }
//    
//    private func setupKeyboardObservers() {
//        NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
//            .sink { [weak self] notification in
//                self?.keyboardWillShow(notification: notification)
//            }
//            .store(in: &self.bag)
//        
//        NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)
//            .sink { [weak self] _ in
//                self?.keyboardWillHide()
//            }
//            .store(in: &self.bag)
//    }
//    
//    private func keyboardWillShow(notification: Notification) {
//        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
//        
//        let keyboardTopY = view.frame.height - keyboardFrame.height
//        let pw2TextFieldBottomY = numberTextField.convert(numberTextField.bounds, to: view).maxY
//        
//        if pw2TextFieldBottomY > keyboardTopY {
//            let offset = pw2TextFieldBottomY - keyboardTopY + 20 // 20은 여유 공간
//            view.frame.origin.y = -offset
//        }
//    }
//    
//    private func keyboardWillHide() {
//        view.frame.origin.y = 0
//    }
//    
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
//    @IBAction func tapContinueBtn(_ sender: UIButton) {
//        if continueBtn.titleLabel?.text == "인증하기" {
//            print("tapContinueBtn - called 현재 상태는 인증하기 입니다")
//            guard let b_no = vm.farmBusinessNumber, let start_dt = vm.farmOpenDate , let p_nm = vm.farmCEOname else { return }
//            vm.validateBusinessInfo_API(b_no: b_no, start_dt: start_dt, p_nm: p_nm)
//            
//            
//        } else if continueBtn.titleLabel?.text == "계속하기"{
//            print("tapContinueBtn - called 현재 상태는 계속하기 입니다")
//            
//            guard let userType = vm.userType , let id = vm.id, let pw = vm.pw , let farmName = vm.farmName , let farmAdress = vm.selectedRoadAddress , let farmCEOname = vm.farmCEOname , let openDate = vm.farmOpenDate , let farmBusinessNumber = vm.farmBusinessNumber else { return }
//            vm.signUp_farmer_API(userType: userType, accountID: id, password: pw, farmName: farmName, farmAdress: farmAdress, farmCEOName: farmCEOname, openDate: openDate, businessRegNumber: farmBusinessNumber)
//            guard let nextVC = storyboard?.instantiateViewController(withIdentifier: "MakeUserCompleteVC") as? MakeUserCompleteVC else { return }
//            navigationController?.pushViewController(nextVC, animated: true)
//        } else {
//            return
//        }
//    }
//    
//}
//‼️ 7월 말 회의 결과 농부용 회원가입은 사용하지 않기로 결정, 해당 뷰 컨트롤러는 사용하지 않기에 주석처리함(8/4)

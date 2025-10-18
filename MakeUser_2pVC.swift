//
//  MakeUser_2pVC.swift
//  TryLocal
//
//  Created by 시모니의 맥북 on 5/24/25.
//

import UIKit
import Combine

class MakeUser_2pVC: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var pwLabel: UILabel!
    @IBOutlet weak var pw2Label: UILabel!
    @IBOutlet weak var errorIdLabel: UILabel!
    @IBOutlet weak var errorPwLabel: UILabel!
    @IBOutlet weak var errorPw2Label: UILabel!
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var pwTextField: UITextField!
    @IBOutlet weak var pw2TextField: UITextField!
    @IBOutlet weak var checkExistBtn: UIButton!
    @IBOutlet weak var continueBtn: UIButton!
    var vm: MakeUserVM!
    private var bag = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        vm = MakeUserVM()
        configure()
        
    }
    
    private func configure() {
        configureUI()
        bindNotification()
        keyBoardSetting()
        vm.$isEnabeldExistIDBtn_2p
            .receive(on: RunLoop.main)
            .sink { [weak self] isEmpty in
                let isEnabled = isEmpty // 빈 값이면 버튼 비활성화
                
                self?.checkExistBtn.isEnabled = isEnabled
                self?.checkExistBtn.backgroundColor = isEnabled ? UIColor(hex: "E7AC52") : UIColor(hex: "B8B8B8")
            }
            .store(in: &self.bag)
        
        vm.$continueBtnIsHidden_2p
            .receive(on: RunLoop.main)
            .assign(to: \.isHidden, on: continueBtn)
            .store(in: &self.bag)
        vm.userType = .customer
    }
    
    private func configureUI() {
        errorPw2Label.isHidden = true
        titleLabel.font = UIFont(name: "PretendardGOV-Bold", size: 28)
        idLabel.font = UIFont(name: "PretendardGOV-Bold", size: 12)
        pwLabel.font = UIFont(name: "PretendardGOV-Bold", size: 12)
        pw2Label.font = UIFont(name: "PretendardGOV-Bold", size: 12)
        errorIdLabel.font = UIFont(name: "PretendardGOV-Thin", size: 12)
        errorPwLabel.font = UIFont(name: "PretendardGOV-Thin", size: 12)
        errorPw2Label.font = UIFont(name: "PretendardGOV-Thin", size: 12)
        idTextField.layer.borderWidth = 1
        idTextField.layer.borderColor = UIColor.black.cgColor
        idTextField.layer.cornerRadius = 8
        idTextField.text = vm.id ?? ""
        pwTextField.layer.borderWidth = 1
        pwTextField.layer.borderColor = UIColor.black.cgColor
        pwTextField.layer.cornerRadius = 8
        pwTextField.text = vm.pw ?? ""
        pw2TextField.layer.borderWidth = 1
        pw2TextField.layer.borderColor = UIColor.black.cgColor
        pw2TextField.layer.cornerRadius = 8
        pw2TextField.text = vm.pw2 ?? ""
        checkExistBtn.layer.cornerRadius = 8
        continueBtn.layer.cornerRadius = 8
        
        self.navigationItem.backButtonTitle = ""
        self.navigationController?.navigationBar.tintColor = .black
    }
    
    // MARK: - Notification 관련
    private func bindNotification() {
        NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: idTextField)
            .compactMap { ($0.object as? UITextField)?.text }
            .sink { [weak self] newText in
                self?.vm.id = newText
                print("현재 입력된 ID : \(String(describing: newText))")
                self?.vm.checkIsEmptyID()
                self?.vm.checkIsEmptyID_PW()
            }
            .store(in: &self.bag)
        
        NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: pwTextField)
            .compactMap { ($0.object as? UITextField)?.text }
            .sink { [weak self] newText in
                self?.vm.pw = newText
                print("현재 입력된 PW : \(String(describing: newText))")
                self?.vm.checkIsEmptyID_PW()
            }
            .store(in: &self.bag)
        
        NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: pw2TextField)
            .compactMap { ($0.object as? UITextField)?.text }
            .sink { [weak self] newText in
                self?.vm.pw2 = newText
                print("현재 입력된 PW2 : \(String(describing: newText))")
                self?.vm.checkIsEmptyID_PW()
            }
            .store(in: &self.bag)
    }
    
    // MARK: - keyBoard 관련
    private func keyBoardSetting() {
        setupKeyboardObservers()
        setupTapToDismissKeyboard()
    }
    
    private func setupKeyboardObservers() {
        NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
            .sink { [weak self] notification in
                self?.keyboardWillShow(notification: notification)
            }
            .store(in: &self.bag)
        
        NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)
            .sink { [weak self] _ in
                self?.keyboardWillHide()
            }
            .store(in: &self.bag)
    }
    
    private func keyboardWillShow(notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        
        let keyboardTopY = view.frame.height - keyboardFrame.height
        let pw2TextFieldBottomY = pw2TextField.convert(pw2TextField.bounds, to: view).maxY
        
        if pw2TextFieldBottomY > keyboardTopY {
            let offset = pw2TextFieldBottomY - keyboardTopY + 20 // 20은 여유 공간
            view.frame.origin.y = -offset
        }
    }
    
    private func keyboardWillHide() {
        view.frame.origin.y = 0
    }
    
    private func setupTapToDismissKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    //MARK: - Action func
    @IBAction func tapContinueBtn(_ sender: UIButton) {
        print("MakeUser_2pVC continueBtn - tapped")
        pwTextField.layer.borderColor = UIColor.black.cgColor
        errorPwLabel.textColor = .black
        pw2TextField.layer.borderColor = UIColor.black.cgColor
        errorPw2Label.isHidden = true
        
        if checkExistBtn.isEnabled == true { return }
        
        // 비밀번호 유효성 검사
        guard vm.isPwValid() else {
            print("비밀번호 유효성검사 불통과")
            pwTextField.layer.borderColor = UIColor.red.cgColor
            errorPwLabel.textColor = .red
            return
        }
        
        // 비밀번호 일치 검사
        guard vm.isPasswordMatched() else {
            print("비밀번호 일치검사 불통과")
            pw2TextField.layer.borderColor = UIColor.red.cgColor
            errorPw2Label.isHidden = false
            
            return
        }
        
        if vm.userType == .customer {
            // UserType 이 고객일 경우 MakeUser_3p_CustomerVC 로 이동
            guard let nextVC = storyboard?.instantiateViewController(identifier: "MakeUser_3p_CustomerVC") as? MakeUser_3p_CustomerVC else { return }
            nextVC.vm = self.vm
            navigationController?.pushViewController(nextVC, animated: true)
        }
//        else if vm.userType == .farmer {
//            // UserType 이 농부일 경우 MakeUser_3p_FarmerVC 로 이동
//            guard let nextVC = storyboard?.instantiateViewController(identifier: "MakeUser_3p_FarmerVC") as? MakeUser_3p_FarmerVC else { return }
//            nextVC.vm = self.vm
//            navigationController?.pushViewController(nextVC, animated: true)
//        }
    }
    
    @IBAction func tapCheckExistBtn(_ sender: UIButton) {
        print("tapIsExistBtn - tapped")
        idTextField.layer.borderColor = UIColor.black.cgColor
        errorIdLabel.textColor = .black
        
        guard vm.isIdValid() else {
            print("아이디 유효성검사 불통과")
            idTextField.layer.borderColor = UIColor.red.cgColor
            errorIdLabel.textColor = .red
            return
        }
        
        guard let id = vm.id else { return }
        vm.checkAccountID_API(accountID: id) {[weak self] exists in
            DispatchQueue.main.async {
                if exists {
                    // ❌ 중복된 아이디가 있음 → 입력 허용
                    self?.checkExistBtn.isEnabled = true
                    self?.idTextField.isEnabled = true
                    self?.errorIdLabel.text = "이미 사용 중인 아이디입니다."
                    self?.errorIdLabel.textColor = .red
                    self?.idTextField.layer.borderColor = UIColor.red.cgColor
                } else {
                    // ✅ 사용 가능한 아이디 → 입력 막기
                    self?.vm.isEnabeldExistIDBtn_2p = false
                    self?.idTextField.isEnabled = false
                    self?.idTextField.backgroundColor = UIColor(hex: "E6E6E6")
                    self?.errorIdLabel.text = "사용 가능한 아이디입니다."
                    self?.errorIdLabel.textColor = .blue
                    self?.idTextField.layer.borderColor = UIColor.black.cgColor
                    
                }
            }
        }
    }
    
}



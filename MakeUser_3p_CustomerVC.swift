//
//  makeupUser_3pVC.swift
//  TryLocal
//
//  Created by 시모니의 맥북 on 5/24/25.
//

import UIKit
import Combine

class MakeUser_3p_CustomerVC: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var nicNameLabel: UILabel!
    @IBOutlet weak var errorNicNameLabel: UILabel!
    @IBOutlet weak var nicNameTextField: UITextField!
    @IBOutlet weak var checkExistBtn: UIButton!
    @IBOutlet weak var continueBtn: UIButton!
    var vm: MakeUserVM!
    var bag = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        
    }
    
    private func configure() {
        configureUI()
        setupTapToDismissKeyboard()
        bindNotification()
        vm.$isEnabeldExistNicknameBtn_3p_Customer
            .receive(on: RunLoop.main)
            .sink { [weak self] isEmpty in
                let isEnabled = isEmpty // 빈 값이면 버튼 비활성화
                
                self?.checkExistBtn.isEnabled = isEnabled
                self?.checkExistBtn.backgroundColor = isEnabled ? UIColor(hex: "E7AC52") : UIColor(hex: "B8B8B8")
            }
            .store(in: &self.bag)
        
        vm.$continueBtnIsHidden_3p_Customer
            .receive(on: RunLoop.main)
            .assign(to: \.isHidden, on: continueBtn)
            .store(in: &self.bag)
    }
    
    private func configureUI() {
        titleLabel.font = UIFont(name: "PretendardGOV-Bold", size: 28)
        nicNameLabel.font = UIFont(name: "PretendardGOV-Bold", size: 12)
        errorNicNameLabel.font = UIFont(name: "PretendardGOV-Thin", size: 12)
        nicNameTextField.layer.cornerRadius = 8
        nicNameTextField.layer.borderWidth = 1
        nicNameTextField.layer.borderColor = UIColor.black.cgColor
        nicNameTextField.text = vm.nickName ?? ""
        checkExistBtn.layer.cornerRadius = 8
        continueBtn.layer.cornerRadius = 8
    }
    
    //MARK: - Notification 관련
    private func bindNotification() {
        NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: nicNameTextField)
            .compactMap{ ($0.object as? UITextField)?.text }
            .sink { [weak self] newText in
                self?.vm.nickName = newText
                self?.vm.checkIsEmptyNickName()
            }
            .store(in: &self.bag)
    }
    
    //MARK: - keyBoard 관련
    private func setupTapToDismissKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    //MARK: - Action func
    @IBAction func tapCheckExistBtn(_ sender: UIButton) {
        guard let userType = vm.userType , let nickName = vm.nickName else { return }
        
        guard vm.isNickNameValid() else {
            print("닉네임 유효성검사 불통과")
            nicNameTextField.layer.borderColor = UIColor.red.cgColor
            errorNicNameLabel.text = "닉네임은 한글로 2글자 이상이여야 합니다."
            errorNicNameLabel.textColor = .red
            return
        }
        
        vm.checkUserNickName_API(userType: userType.rawValue, nickName: nickName) { [weak self] exists in
            DispatchQueue.main.async {
                if exists {
                   //이미 사용중인 닉네임일때
                    self?.nicNameTextField.isEnabled = true
                    //self?.checkExistBtn.isEnabled = true
                    self?.vm.isEnabeldExistNicknameBtn_3p_Customer = true
                    self?.nicNameTextField.layer.borderColor = UIColor.red.cgColor
                    self?.errorNicNameLabel.text = "이미 사용중인 닉네임입니다."
                    self?.errorNicNameLabel.textColor = .red
                } else {
                   // 사용 가능한 닉네임일때
                    self?.nicNameTextField.isEnabled = false
                    self?.vm.isEnabeldExistNicknameBtn_3p_Customer = false
                    self?.nicNameTextField.layer.borderColor = UIColor.black.cgColor
                    self?.errorNicNameLabel.text = "사용 가능한 닉네임입니다."
                    self?.errorNicNameLabel.textColor = .blue
                    self?.nicNameTextField.backgroundColor = UIColor(hex: "E6E6E6")
                }
            }
        }
        
    }
    
    @IBAction func tapContinueBtn(_ sender: UIButton) {
        if self.vm.isEnabeldExistNicknameBtn_3p_Customer == true { return }
        print("ddddd")
        guard let userType = vm.userType ,let id = vm.id , let pw = vm.pw , let nickName = vm.nickName else { return }
        vm.signUp_tourist_API(userType: userType, accountID: id, password: pw, name: nickName)
        
        guard let nextVC = storyboard?.instantiateViewController(withIdentifier: "MakeUserCompleteVC") as? MakeUserCompleteVC else { return }
        navigationController?.pushViewController(nextVC, animated: true)
       
    }
    
    
}

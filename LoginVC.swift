//
//  LoginVC.swift
//  TryLocal
//
//  Created by 시모니의 맥북 on 5/29/25.
//

import UIKit
import Combine

class LoginVC: UIViewController {
    
    @IBOutlet weak var titleLabel1: UILabel!
    @IBOutlet weak var titleLabel2: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var pwLabel: UILabel!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var pwTextField: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    
    var vm: LoginVM!
    var bag = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        vm = LoginVM()
        configure()
        
    }
    
    private func configure() {
        configureUI()
        bindNotification()
        keyBoardSetting()
        vm.$loginBtnIsHidden
            .receive(on: RunLoop.main)
            .assign(to: \.isHidden, on: loginBtn)
            .store(in: &self.bag)
        
        vm.$loginFailed
            .receive(on: RunLoop.main)
            .sink { [weak self] failed in
                self?.errorLabel.isHidden = !failed
            }
            .store(in: &bag)
    }
    
    private func configureUI() {
        titleLabel1.font = UIFont(name: "PretendardGOV-Bold", size: 28)
        titleLabel2.font = UIFont(name: "PretendardGOV-Bold", size: 20)
        idLabel.font = UIFont(name: "PretendardGOV-Bold", size: 12)
        pwLabel.font = UIFont(name: "PretendardGOV-Bold", size: 12)
        errorLabel.font = UIFont(name: "PretendardGOV-Thin", size: 12)
        idTextField.layer.cornerRadius = 8
        idTextField.layer.borderWidth = 1
        idTextField.layer.borderColor = UIColor.black.cgColor
        pwTextField.layer.cornerRadius = 8
        pwTextField.layer.borderWidth = 1
        pwTextField.layer.borderColor = UIColor.black.cgColor
        loginBtn.layer.cornerRadius = 8
    }
    
    private func bindNotification() {
        NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: idTextField)
            .compactMap{ ($0.object as? UITextField)?.text }
            .sink { [weak self] newText in
                self?.vm.loginID = newText
                self?.vm.checkIsEmptyLoginID_PW()
            }
            .store(in: &self.bag)
        
        NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: pwTextField)
            .compactMap{ ($0.object as? UITextField)?.text }
            .sink { [weak self] newText in
                self?.vm.loginPW = newText
                self?.vm.checkIsEmptyLoginID_PW()
            }
            .store(in: &self.bag)
    }
    
    // MARK: - 키보드관련
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
        let pw2TextFieldBottomY = pwTextField.convert(pwTextField.bounds, to: view).maxY
        
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
    @IBAction func tapLoginBtn(_ sender: UIButton) {
        guard let id = vm.loginID, let pw = vm.loginPW else { return }
        vm.loginAPI(accountID: id, password: pw) { [weak self] in
            guard let self = self else { return }
            
            // 새로운 스토리보드의 탭바 컨트롤러를 루트뷰로 설정
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            // TabBarController 또는 HomeVC가 포함된 NavigationController를 가져옴
            guard let tabBarVC = storyboard.instantiateViewController(withIdentifier: "MainTabBarController") as? MainTabBarController else {
                return
            }
            
            // ✅ 로그인에서 받은 토큰을 탭바 컨트롤러에 전달
            tabBarVC.token = self.vm.token
            tabBarVC.userName = self.vm.userName
            
            // 창 전체를 해당 탭바 컨트롤러로 교체
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let sceneDelegate = windowScene.delegate as? UIWindowSceneDelegate,
               let window = sceneDelegate.window {
                window?.rootViewController = tabBarVC
                window?.makeKeyAndVisible()
            }
        }
    }
    
}

//
//  Mp_UnsubscribeDetailVC.swift
//  Try-Local
//
//  Created by 시모니의 맥북 on 8/14/25.
//

import UIKit
import Combine

class Mp_UnsubscribeDetailVC: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var middleLabel: UILabel!
    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var unsubscribeBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var textView: UITextView!
    var vm: Mp_UnsubscribeDetailVM!
    private var bag = Set<AnyCancellable>()
    @Published var unsubscribeBtnIsHidden: Bool = true
    
    let options = [
        "원하는 정보가 없어요.",
        "서비스 이용이 불편해요.",
        "서비스 사용법을 모르겠어요.",
        "별로 사용할 일이 없어요.",
        "기타"
    ]
    
    var isDropdownVisible = false
    let cellHeight: CGFloat = 48
    
    // 현재 선택된 옵션 저장
    private var selectedOption: String? {
        didSet {
            // 선택 옵션을 VM의 reason에 바로 반영
            if selectedOption == "기타" {
                vm.reason = textView.text.trimmingCharacters(in: .whitespacesAndNewlines)
            } else {
                vm.reason = selectedOption ?? ""
            }
            validateUnsubscribeButton()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        tableView.delegate = self
        tableView.dataSource = self
        textView.delegate = self
        
    }
    
    private func configure() {
        configureUI()
        setupTapToDismissKeyboard()
    }
    
    private func configureUI() {
        titleLabel.font = UIFont(name: "PretendardGOV-Bold", size: 28)
        middleLabel.font = UIFont(name: "PretendardGOV-Medium", size: 16)
        menuBtn.layer.cornerRadius = 8
        menuBtn.layer.borderWidth = 1
        menuBtn.layer.borderColor = UIColor.systemGray.cgColor
        unsubscribeBtn.layer.cornerRadius = 8
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.cornerRadius = 8
        
        tableView.isHidden = true
        tableView.layer.borderWidth = 1
        tableView.layer.borderColor = UIColor.lightGray.cgColor
        tableView.layer.cornerRadius = 8
        tableView.clipsToBounds = true
        textView.isHidden = true
        
        textView.text = "기타 사유를 알려주세요."
        textView.textColor = .lightGray
        
        unsubscribeBtn.isHidden = true
        
    }
    
    // 버튼 활성화 조건 검증
    private func validateUnsubscribeButton() {
        if let option = selectedOption {
            if option == "기타" {
                // 텍스트뷰에 내용이 한 글자라도 있으면 버튼 보이기
                let trimmedText = textView.text.trimmingCharacters(in: .whitespacesAndNewlines)
                unsubscribeBtn.isHidden = trimmedText.isEmpty || textView.textColor == .lightGray
            } else {
                // 기타 외의 옵션은 무조건 버튼 보이기
                unsubscribeBtn.isHidden = false
            }
        } else {
            unsubscribeBtn.isHidden = true
        }
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
    @IBAction func tapMenuBtn(_ sender: UIButton) {
        isDropdownVisible.toggle()
        
        // 테이블뷰 높이 변경 + 애니메이션
        tableView.isHidden = false
        tableViewHeight.constant = isDropdownVisible ? CGFloat(options.count) * cellHeight : 0
        
        UIView.animate(withDuration: 0.25, animations: {
            self.view.layoutIfNeeded()
        }) { _ in
            if !self.isDropdownVisible {
                self.tableView.isHidden = true
            }
        }
    }
    
    @IBAction func tapUnsubscribeBtn(_ sender: UIButton) {
        print("탈퇴이유는 => \(vm.reason)")
        let alertController = UIAlertController(title: "", message: "회원탈퇴가 완료되었습니다.", preferredStyle: .alert)
            let okBtn = UIAlertAction(title: "확인", style: .default) { [weak self] _ in
                guard let self = self else { return }
                self.vm.deleteAccount(reason: self.vm.reason, token: self.vm.token) {
                    DispatchQueue.main.async {
                        // StartVC로 돌아가기
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        guard let startVC = storyboard.instantiateViewController(withIdentifier: "StartVC") as? StartVC else { return }
                        let navVC = UINavigationController(rootViewController: startVC)
                        
                        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                           let sceneDelegate = windowScene.delegate as? UIWindowSceneDelegate,
                           let window = sceneDelegate.window {
                            window?.rootViewController = navVC
                            window?.makeKeyAndVisible()
                        }
                    }
                }
            }
            alertController.addAction(okBtn)
            present(alertController, animated: true)
    }
    
}

//MARK: - Extextion
extension Mp_UnsubscribeDetailVC: UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DropdownCell") as? DropdownCell else {
            return UITableViewCell()
        }
        cell.optionLabel.text = options[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedOption = options[indexPath.row]   // ✅ 클래스 프로퍼티에 대입
        menuBtn.setTitle(options[indexPath.row], for: .normal)
        tapMenuBtn(menuBtn) // 목록 닫기
        // "기타" 선택 여부에 따라 textView 표시/숨김
        if selectedOption == "기타" {
            textView.isHidden = false
        } else {
            textView.isHidden = true
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
}

//MARK: - TextView Delegate
extension Mp_UnsubscribeDetailVC: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "기타 사유를 알려주세요."
            textView.textColor = .lightGray
        }
        validateUnsubscribeButton()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .lightGray {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if selectedOption == "기타" {
            vm.reason = textView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        validateUnsubscribeButton()
    }
    
}

class DropdownCell: UITableViewCell {
    @IBOutlet weak var optionLabel: UILabel!
    
}

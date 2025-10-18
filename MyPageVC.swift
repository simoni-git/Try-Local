//
//  MyPageVC.swift
//  TryLocal
//
//  Created by 시모니의 맥북 on 8/11/25.
//

import UIKit

class MyPageVC: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var logoutBtn: UIButton!
    @IBOutlet weak var unsubscribeBtn: UIButton!
    var vm: MyPageVM!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        vm = MyPageVM(token: vm.token, userName: vm.userName)
        configure()
       
    }
    
    private func configure() {
        titleLabel.text = "\(vm.userName) 님 안녕하세요 :)"
        titleLabel.font = UIFont(name: "PretendardGOV-Bold", size: 28)
        self.navigationItem.backButtonTitle = ""
        self.navigationController?.navigationBar.tintColor = .black
    }
    
    //MARK: - Action func
    
    @IBAction func tapLogoutBtn(_ sender: Any) {
        // 로그아웃
        let alert = UIAlertController(title: "로그아웃을 원하시나요?", message: nil, preferredStyle: .alert)
        let okBtn = UIAlertAction(title: "로그아웃", style: .default) { [weak self] _ in
            // 로그아웃 api 호출 후 메인화면으로 돌아가야함
            self?.vm.logout {
                DispatchQueue.main.async {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    guard let startVC = storyboard.instantiateViewController(withIdentifier: "StartVC") as? StartVC else { return }

                    // StartVC를 NavigationController 안에 넣기
                    let navVC = UINavigationController(rootViewController: startVC)

                    // 메인 스레드에서 루트 교체
                    DispatchQueue.main.async {
                        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                           let sceneDelegate = windowScene.delegate as? UIWindowSceneDelegate,
                           let window = sceneDelegate.window {
                            window?.rootViewController = navVC
                            window?.makeKeyAndVisible()
                        }
                    }
                }
            }
        }
        
        
        let cancelBtn = UIAlertAction(title: "취소", style: .cancel)
        okBtn.setValue(UIColor.red, forKey: "titleTextColor")
        alert.addAction(okBtn)
        alert.addAction(cancelBtn)
        present(alert, animated: true)
    }
    
    @IBAction func tapUnsubscribeBtn(_ sender: Any) {
        // 회원탈퇴
        guard let nextVC = storyboard?.instantiateViewController(identifier: "Mp_UnsubscribeVC") as? Mp_UnsubscribeVC else { return }
        let nextVM = Mp_UnsubscribeVM()
        nextVM.token = vm.token
        nextVC.vm = nextVM
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    
    
}

extension MyPageVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MyPageCell") as? MyPageCell else {
            return UITableViewCell()
        }
        let index = indexPath.row
        cell.titleLabel.text = ["나의 찜 목록 확인하기", "나의 발자취 돌아보기"][index]
        cell.titleLabel.font = UIFont(name: "PretendardGOV-Regular", size: 16)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        if index == 0 {
            // 나의 찜 목록 확인하기로 이동
            guard let nextVC = storyboard?.instantiateViewController(identifier: "Mp_BookMarkVC") as? Mp_BookMarkVC else { return }
            
                let nextVM = Mp_BookMarkVM(token: self.vm.token)
                nextVC.vm = nextVM // ✅ 뷰모델 주입
                DispatchQueue.main.async {
                    self.navigationController?.pushViewController(nextVC, animated: true)
                }
            
        } else if index == 1 {
            // 나의 발자취 돌아보기로 이동
            guard let nextVC = storyboard?.instantiateViewController(identifier: "Mp_FootPrintVC") as? Mp_FootPrintVC else { return }
            vm.getFootPrintAPI { [weak self] items in
                guard let self = self else { return }
                let nextVM = Mp_FootPrintVM(token: self.vm.token)
                nextVM.items = items
                nextVC.vm = nextVM   // ✅ 뷰모델 주입
                
                DispatchQueue.main.async {
                    self.navigationController?.pushViewController(nextVC, animated: true)
                }
            }
            
        }
    }
}

class MyPageCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var img: UIImageView!
    
}

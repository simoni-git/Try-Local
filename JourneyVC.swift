//
//  JourneyVC.swift
//  TryLocal
//
//  Created by 시모니의 맥북 on 7/29/25.
//

import UIKit

class JourneyVC: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var middleLabel: UILabel!
    @IBOutlet weak var makeTravelBtn: UIButton!
    var vm: JourneyVM!
    var homeVM: HomeVM!
    override func viewDidLoad() {
        super.viewDidLoad()
        if vm == nil {
            vm = JourneyVM(token: homeVM.token, userName: homeVM.userName)
        }
        configure()
    }
    
    private func configure() {
        configureUI()
        reperenceHomeVM()
        print("저니저니저니 ~!~!~!~!!~")
    }
    
    private func configureUI() {
        titleLabel.font = UIFont(name: "PretendardGOV-Bold", size: 20)
        middleLabel.font = UIFont(name: "PretendardGOV-Bold", size: 16)
        makeTravelBtn.layer.cornerRadius = 8
        self.navigationItem.backButtonTitle = ""
        self.navigationController?.navigationBar.tintColor = .black
        
        
    }
    
    func reperenceHomeVM() {
        // 탭바에서 A탭(HomeVC)을 찾아서 VM 참조
        if let homeNav = self.tabBarController?.viewControllers?[0] as? UINavigationController,
           let homeVC = homeNav.viewControllers.first as? HomeVC {
            self.homeVM = homeVC.vm
           
        }
        
        // 여정탭(NavigationController) 가져오기
        guard let tabBarController = self.tabBarController,
              let secondNav = tabBarController.viewControllers?[1] as? UINavigationController else { return }
        
        if homeVM.myTravelItems.isEmpty {
            configureUI()
        } else {
            // 배열에 값이 있으면 ResultMapVC를 B탭 루트로 설정
            if let mapVC = storyboard?.instantiateViewController(withIdentifier: "ResultMapVC") as? ResultMapVC {
                mapVC.vm = ResultMapVM(token: homeVM.token)
                mapVC.vm.submissionID = homeVM.myTravelItems[0].submission_id
                mapVC.vm.titleLabelText = homeVM.myTravelItems[0].name
                mapVC.vm.fetchRoute(submissionID: homeVM.myTravelItems[0].submission_id)
                mapVC.vm.userName = homeVM.userName
                secondNav.setViewControllers([mapVC], animated: false)
            }
        }
        
        // B탭 선택
        tabBarController.selectedIndex = 1
    }
    
    //MARK: - Action func
    @IBAction func tapMakeTravelBtn(_ sender: UIButton) {
        guard let nextVC = storyboard?.instantiateViewController(withIdentifier: "MakeRoute1VC") as? MakeRoute1VC else { return }
        nextVC.vm = MakeRoute1VM()
        nextVC.vm.token = vm.token
        nextVC.vm.userName = vm.userName
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
}

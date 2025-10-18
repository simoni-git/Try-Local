//
//  MakeUser-1P.swift
//  TryLocal
//
//  Created by 시모니의 맥북 on 5/22/25.
//

//import UIKit
//import Combine
//
//class MakeUser_1pVC: UIViewController {
//    
//    @IBOutlet weak var titleLabel1: UILabel!
//    @IBOutlet weak var titleLabel2: UILabel!
//    @IBOutlet weak var customerSubView: UIView!
//    @IBOutlet weak var farmerSubView: UIView!
//    @IBOutlet weak var customerBtn: UIButton!
//    @IBOutlet weak var farmerBtn: UIButton!
//    @IBOutlet weak var continueBtn: UIButton!
//    
//    var vm: MakeUserVM!
//    private var bag = Set<AnyCancellable>()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        vm = MakeUserVM()
//        configure()
//        
//    }
//    
//    private func configure() {
//        configureUI()
//        
//    }
//    
//    private func configureUI() {
//        titleLabel1.font = UIFont(name: "PretendardGOV-Bold", size: 28)
//        titleLabel2.font = UIFont(name: "PretendardGOV-Bold", size: 20)
//        customerSubView.layer.borderWidth = 1
//        customerSubView.layer.borderColor = UIColor.black.cgColor
//        customerSubView.layer.cornerRadius = 8
//        farmerSubView.layer.borderWidth = 1
//        farmerSubView.layer.borderColor = UIColor.black.cgColor
//        farmerSubView.layer.cornerRadius = 8
//        continueBtn.layer.cornerRadius = 8
//        self.navigationItem.backButtonTitle = ""
//        self.navigationController?.navigationBar.tintColor = .black  
//        
//    }
//    
//    private func changeSubViewColor() {
//        continueBtn.isHidden = false
//        if vm.userType == .customer {
//            customerSubView.backgroundColor = UIColor(hex: "#E7AC52")
//            farmerSubView.backgroundColor = .clear
//        } else if vm.userType == .farmer {
//            farmerSubView.backgroundColor =  UIColor(hex: "#E7AC52")
//            customerSubView.backgroundColor = .clear
//        }
//    }
//    
//    @IBAction func tapCustomerBtn(_ sender: UIButton) {
//        //관광객으로 가입하기
//        print("관광객으로 가입하기 버튼이 눌렸어요")
//        vm.userType = .customer
//        changeSubViewColor()
//        
//    }
//    
//    
//    @IBAction func tapFarmerBtn(_ sender: UIButton) {
//        //농부로 가입하기
//        print("농부로 가입하기 버튼이 눌렸어요")
//        vm.userType = .farmer
//        changeSubViewColor()
//        
//    }
//    
//    @IBAction func tapContinueBtn(_ sender: UIButton) {
//        print("MakeUser_1pVC - tapContinueBtn Tapped")
//        
//        guard let nextVC = storyboard!.instantiateViewController(withIdentifier: "MakeUser_2pVC") as? MakeUser_2pVC else { return }
//        nextVC.vm = self.vm
//        self.navigationController?.pushViewController(nextVC, animated: true)
//        
//    }
//    
//}
//‼️ 7월 말 회의 결과 농부용 회원가입은 사용하지 않기로 결정, 해당 뷰 컨트롤러는 사용하지 않기에 주석처리함(8/4)

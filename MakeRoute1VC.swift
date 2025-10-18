//
//  MakeRute1VC.swift
//  TryLocal
//
//  Created by 시모니의 맥북 on 7/30/25.
//

import UIKit

class MakeRoute1VC: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var firstBtn: UIButton!
    @IBOutlet weak var secondBtn: UIButton!
    var vm: MakeRoute1VM!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        
    }
    
    private func configureUI() {
        titleLabel.font = UIFont(name: "PretendardGOV-Bold", size: 28)
        firstBtn.layer.borderWidth = 1
        firstBtn.layer.borderColor = UIColor.black.cgColor
        firstBtn.layer.cornerRadius = 8
        secondBtn.layer.borderWidth = 1
        secondBtn.layer.borderColor = UIColor.black.cgColor
        secondBtn.layer.cornerRadius = 8
        self.navigationItem.backButtonTitle = ""
        self.navigationController?.navigationBar.tintColor = .black
    }
    
    //MARK: - action func
    @IBAction func tapFirstBtn(_ sender: UIButton) {
        // 짜여진 경로대로 여행하기 (1)
        guard let nextVC = storyboard?.instantiateViewController(withIdentifier: "MakeRoute2VC") as? MakeRoute2VC else { return }
        
        vm.q1 = 1
        nextVC.vm = MakeRoute2VM()
        nextVC.vm.token = vm.token
        nextVC.vm.q1 = vm.q1
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @IBAction func tapSecondBtn(_ sender: UIButton) {
        // 직접 짠 경로대로 여행하기 (2)
        guard let nextVC = storyboard?.instantiateViewController(withIdentifier: "MakeRuteSelf1VC") as? MakeRuteSelf1VC else { return }
        vm.q1 = 2
        nextVC.vm = MakeRuteSelf1VM()
        nextVC.vm.token = vm.token
        nextVC.vm.q1 = vm.q1
        nextVC.vm.userName = vm.userName
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    
}

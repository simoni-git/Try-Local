//
//  MakeRute2VC.swift
//  TryLocal
//
//  Created by 시모니의 맥북 on 7/30/25.
//

import UIKit

class MakeRoute2VC: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var firstBtn: UIButton!
    @IBOutlet weak var secondBtn: UIButton!
    var vm: MakeRoute2VM!
    
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
    
    //MARK: - ACtion func
    @IBAction func tapFirstBtn(_ sender: UIButton) {
        // 일자별 여행코스 (1)
        guard let nextVC = storyboard?.instantiateViewController(withIdentifier: "MakeRoute3_1VC") as? MakeRoute3_1VC else { return }
        vm.q2 = 1
        nextVC.vm = MakeRoute3_1VM()
        nextVC.vm.token = vm.token
        nextVC.vm.q1 = vm.q1
        nextVC.vm.q2 = vm.q2
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @IBAction func tapSecondBtn(_ sender: UIButton) {
        // 주제별 여행코스 (2)
        guard let nextVC = storyboard?.instantiateViewController(withIdentifier: "MakeRute3_2VC") as? MakeRute3_2VC else { return }
        vm.q2 = 2
        nextVC.vm = MakeRoute3_2VM()
        nextVC.vm.token = vm.token
        nextVC.vm.q1 = vm.q1
        nextVC.vm.q2 = vm.q2
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    
}

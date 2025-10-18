//
//  MakeRuteSelf1VC.swift
//  TryLocal
//
//  Created by 시모니의 맥북 on 8/4/25.
//

import UIKit

class MakeRuteSelf1VC: UIViewController {
    
    @IBOutlet weak var titleLabel1: UILabel!
    @IBOutlet weak var titleLabel2: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var firstBtn: UIButton!
    @IBOutlet weak var secondBtn: UIButton!
    var vm: MakeRuteSelf1VM!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    private func configure() {
        configureUI()
    }
    
    private func configureUI() {
        titleLabel1.font = UIFont(name: "PretendardGOV-Bold", size: 28)
        titleLabel2.font = UIFont(name: "PretendardGOV-Bold", size: 12)
        datePicker.minimumDate = Date()
        datePicker.maximumDate = Calendar.current.date(byAdding: .day, value: 730, to: Date())
        firstBtn.layer.borderWidth = 1
        firstBtn.layer.borderColor = UIColor.black.cgColor
        firstBtn.layer.cornerRadius = 8
        secondBtn.layer.borderWidth = 1
        secondBtn.layer.borderColor = UIColor.black.cgColor
        secondBtn.layer.cornerRadius = 8
        self.navigationItem.backButtonTitle = ""
        self.navigationController?.navigationBar.tintColor = .black
    }
    
    //MARK: - Action func
    @IBAction func tapFirstBtn(_ sender: UIButton) {
        // 당일치기 코스(1)
        vm.q2 = 1
        vm.todayDateFormatter(selectDate: datePicker.date)
        
        guard let nextVC = storyboard?.instantiateViewController(withIdentifier: "MakeRuteSelf2_1VC") as? MakeRuteSelf2_1VC else { return }
        nextVC.vm = MakeRuteSelf2_1VM()
        nextVC.vm.token = vm.token
        nextVC.vm.q1 = vm.q1
        nextVC.vm.q2 = vm.q2
        nextVC.vm.startDate = vm.startDate
        nextVC.vm.endDate = vm.endDate
        nextVC.vm.userName = vm.userName
        
        vm.sendRouteRequest(q1: vm.q1, q2: vm.q2, q3: nil, startDate: vm.startDate, endDate: vm.endDate) {
            [weak self] in
            nextVC.vm.submissionID = self?.vm.submissionID ?? 0
            self?.navigationController?.pushViewController(nextVC, animated: true)
        }
        
    }
    
    @IBAction func tapSecondBtn(_ sender: UIButton) {
        // 1박 2일 코스(2)
        vm.q2 = 2
        vm.overnightDateFormatter(selectDate: datePicker.date)
        
        guard let nextVC = storyboard?.instantiateViewController(withIdentifier: "MakeRuteSelf2_2VC") as? MakeRuteSelf2_2VC else { return }
        nextVC.vm = MakeRuteSelf2_2VM()
        nextVC.vm.token = vm.token
        nextVC.vm.q1 = vm.q1
        nextVC.vm.q2 = vm.q2
        nextVC.vm.startDate = vm.startDate
        nextVC.vm.endDate = vm.endDate
        nextVC.vm.userName = vm.userName
        
        vm.sendRouteRequest(q1: vm.q1, q2: vm.q2, q3: nil, startDate: vm.startDate, endDate: vm.endDate) {
            [weak self] in
            nextVC.vm.submissionID = self?.vm.submissionID ?? 0
            self?.navigationController?.pushViewController(nextVC, animated: true)
        }
        
    }
    
    
    
    
    
    
    
}

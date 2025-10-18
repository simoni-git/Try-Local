//
//  MakeRute3_2VC.swift
//  TryLocal
//
//  Created by 시모니의 맥북 on 8/4/25.
//

import UIKit

class MakeRute3_2VC: UIViewController {
    
    @IBOutlet weak var titleLabel1: UILabel!
    @IBOutlet weak var titleLabel2: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var firstBtn: UIButton!
    @IBOutlet weak var secondBtn: UIButton!
    @IBOutlet weak var thirdBtn: UIButton!
    var vm: MakeRoute3_2VM!
    
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
        thirdBtn.layer.borderWidth = 1
        thirdBtn.layer.borderColor = UIColor.black.cgColor
        thirdBtn.layer.cornerRadius = 8
        self.navigationItem.backButtonTitle = ""
        self.navigationController?.navigationBar.tintColor = .black
    }
    
    //MARK: - Action func
    
    @IBAction func tapFirstBtn(_ sender: UIButton) {
        vm.q3 = 1
        vm.todayDateFormatter(selectDate: datePicker.date)
        vm.sendRouteRequest(q1: vm.q1, q2: vm.q2, q3: vm.q3, startDate: vm.startDate, endDate: vm.endDate) { [weak self] in
            guard let self = self else { return }
            
            let nextVM = ResultMapVM(token: vm.token)
            nextVM.names = self.vm.names
            nextVM.latitudes = self.vm.latitudes
            nextVM.longitudes = self.vm.longitudes
            nextVM.addresses = self.vm.addresses
            nextVM.imgURLs = self.vm.imgURLs
            nextVM.types = self.vm.types
            nextVM.orders = self.vm.orders
            nextVM.submissionID = self.vm.submissionID
            nextVM.titleLabelText = "성주로 떠나는 시간여행"
            nextVM.backBtnIsHidden = true
            // 다음 VC로 전달
            DispatchQueue.main.async {
                guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "ResultMapVC") as? ResultMapVC else { return }
                nextVC.vm = nextVM
                self.navigationController?.pushViewController(nextVC, animated: true)
            }
        }
    }
    
    
    @IBAction func tapSecondBtn(_ sender: UIButton) {
        vm.q3 = 2
        vm.todayDateFormatter(selectDate: datePicker.date)
        vm.sendRouteRequest(q1: vm.q1, q2: vm.q2, q3: vm.q3, startDate: vm.startDate, endDate: vm.endDate) { [weak self] in
            guard let self = self else { return }
            
            let nextVM = ResultMapVM(token: vm.token)
            nextVM.names = self.vm.names
            nextVM.latitudes = self.vm.latitudes
            nextVM.longitudes = self.vm.longitudes
            nextVM.addresses = self.vm.addresses
            nextVM.imgURLs = self.vm.imgURLs
            nextVM.types = self.vm.types
            nextVM.orders = self.vm.orders
            nextVM.submissionID = self.vm.submissionID
            nextVM.titleLabelText = "둘이 걷고 싶은 치유의 길"
            nextVM.backBtnIsHidden = true
            // 다음 VC로 전달
            DispatchQueue.main.async {
                guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "ResultMapVC") as? ResultMapVC else { return }
                nextVC.vm = nextVM
                self.navigationController?.pushViewController(nextVC, animated: true)
            }
        }
    }
    
    @IBAction func tapThirdBtn(_ sender: UIButton) {
        vm.q3 = 3
        vm.todayDateFormatter(selectDate: datePicker.date)
        vm.sendRouteRequest(q1: vm.q1, q2: vm.q2, q3: vm.q3, startDate: vm.startDate, endDate: vm.endDate) { [weak self] in
            guard let self = self else { return }
            
            let nextVM = ResultMapVM(token: vm.token)
            nextVM.names = self.vm.names
            nextVM.latitudes = self.vm.latitudes
            nextVM.longitudes = self.vm.longitudes
            nextVM.addresses = self.vm.addresses
            nextVM.imgURLs = self.vm.imgURLs
            nextVM.types = self.vm.types
            nextVM.orders = self.vm.orders
            nextVM.submissionID = self.vm.submissionID
            nextVM.titleLabelText = "함께라서 더 즐거운 여행"
            nextVM.backBtnIsHidden = true
            // 다음 VC로 전달
            DispatchQueue.main.async {
                guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "ResultMapVC") as? ResultMapVC else { return }
                nextVC.vm = nextVM
                self.navigationController?.pushViewController(nextVC, animated: true)
            }
        }
    }
    
    
}

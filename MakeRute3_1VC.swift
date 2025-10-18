//
//  MakeRute3VC.swift
//  TryLocal
//
//  Created by 시모니의 맥북 on 7/30/25.
//

import UIKit

class MakeRoute3_1VC: UIViewController {
    
    @IBOutlet weak var titleLabel1: UILabel!
    @IBOutlet weak var titleLabel2: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var firstBtn: UIButton!
    @IBOutlet weak var secondBtn: UIButton!
    var vm: MakeRoute3_1VM!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        //당일치기
        vm.q3 = 1
        vm.todayDateFormatter(selectDate: datePicker.date)
        vm.sendRouteRequest(q1: vm.q1, q2: vm.q2, q3: vm.q3, startDate: vm.startDate, endDate: vm.endDate) { [weak self] in
            guard let self = self else { return }
            print(" 서브미션아이디!!! \(vm.submissionID)")
            vm.fetchRoute(submissionID: vm.submissionID)
            let nextVM = ResultMapVM(token: vm.token)
            nextVM.names = self.vm.names
            nextVM.latitudes = self.vm.latitudes
            nextVM.longitudes = self.vm.longitudes
            nextVM.addresses = self.vm.addresses
            nextVM.imgURLs = self.vm.imgURLs
            nextVM.types = self.vm.types
            nextVM.orders = self.vm.orders
            nextVM.submissionID = self.vm.submissionID
            nextVM.titleLabelText = "성주 당일치기 코스"
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
        //1박2일
        vm.q3 = 2
        vm.overnightDateFormatter(selectDate: datePicker.date)

        vm.sendRouteRequest(q1: vm.q1, q2: vm.q2, q3: vm.q3, startDate: vm.startDate, endDate: vm.endDate) { [weak self] in
            guard let self = self else { return }
            vm.fetchRoute(submissionID: vm.submissionID)
            let nextVM = ResultMapVM(token: vm.token)
            nextVM.daySubViewIsHidden = false  // day1/day2 서브뷰 보이기

            if let routeOvernight = self.vm.routeOvernight,
               // 서버에서 받은 1박2일 데이터를 VM에 저장
               let dayRoutes = routeOvernight.routes {
                for (day, items) in dayRoutes  {  // ✅ routesByDay → routes
                    for item in items {
                        switch day {
                        case "day1":
                            nextVM.namesDay1.append(item.name)
                            nextVM.latitudesDay1.append(String(item.latitude))
                            nextVM.longitudesDay1.append(String(item.longitude))
                            nextVM.addressesDay1.append(item.address)
                            nextVM.imgURLsDay1.append(item.image_url ?? "")
                            nextVM.typesDay1.append(item.type_label)
                            nextVM.ordersDay1.append(String(item.order))
                        case "day2":
                            nextVM.namesDay2.append(item.name)
                            nextVM.latitudesDay2.append(String(item.latitude))
                            nextVM.longitudesDay2.append(String(item.longitude))
                            nextVM.addressesDay2.append(item.address)
                            nextVM.imgURLsDay2.append(item.image_url ?? "")
                            nextVM.typesDay2.append(item.type_label)
                            nextVM.ordersDay2.append(String(item.order))
                        default:
                            break
                        }
                    }
                }
            }

            // 컬렉션뷰용 배열 합치기
            nextVM.names = nextVM.namesDay1 + nextVM.namesDay2
            nextVM.latitudes = nextVM.latitudesDay1 + nextVM.latitudesDay2
            nextVM.longitudes = nextVM.longitudesDay1 + nextVM.longitudesDay2
            nextVM.addresses = nextVM.addressesDay1 + nextVM.addressesDay2
            nextVM.imgURLs = nextVM.imgURLsDay1 + nextVM.imgURLsDay2
            nextVM.types = nextVM.typesDay1 + nextVM.typesDay2
            nextVM.orders = nextVM.ordersDay1 + nextVM.ordersDay2
            nextVM.submissionID = self.vm.submissionID
            nextVM.titleLabelText = "성주 1박2일 코스"
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

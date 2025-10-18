//
//  Mp_UnsubscribeVC.swift
//  TryLocal
//
//  Created by 시모니의 맥북 on 8/12/25.
//

import UIKit

class Mp_UnsubscribeVC: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var middleLabel: UILabel!
    @IBOutlet weak var unsubscribeBtn: UIButton!
    var vm: Mp_UnsubscribeVM!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        
    }
    
    private func configureUI() {
        titleLabel.font = UIFont(name: "PretendardGOV-Bold", size: 28)
        middleLabel.font = UIFont(name: "PretendardGOV-Medium", size: 16)
        unsubscribeBtn.layer.cornerRadius = 8
        self.navigationItem.backButtonTitle = ""
        self.navigationController?.navigationBar.tintColor = .black
    }
    
    @IBAction func tapUnsubscribeBtn(_ sender: UIButton) {
        guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "Mp_UnsubscribeDetailVC") as? Mp_UnsubscribeDetailVC else { return }
        let nextVM = Mp_UnsubscribeDetailVM()
        nextVM.token = vm.token 
        nextVC.vm = nextVM
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
}

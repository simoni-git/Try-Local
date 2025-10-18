//
//  MakeUserCompleteVC.swift
//  TryLocal
//
//  Created by 시모니의 맥북 on 5/27/25.
//

import UIKit

class MakeUserCompleteVC: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var completeBtn: UIButton!
    
    override func viewDidLoad() {
        configureUI()
    }
    
    private func configureUI() {
        titleLabel.font = UIFont(name: "PretendardGOV-Bold", size: 28)
        completeBtn.layer.cornerRadius = 8
        self.navigationItem.hidesBackButton = true
    }
    
    @IBAction func tapCompleteBtnBtn(_ sender: UIButton) {
        navigationController?.popToRootViewController(animated: true)
    }
    
}

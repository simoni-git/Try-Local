//
//  ViewController.swift
//  TryLocal
//
//  Created by 시모니의 맥북 on 5/22/25.
//

import UIKit

class StartVC: UIViewController {

    @IBOutlet weak var titleLabel1: UILabel!
    @IBOutlet weak var titleLabel2: UILabel!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var makeUserBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    private func configureUI() {
        titleLabel1.font = UIFont(name: "PretendardGOV-Medium", size: 28)
        titleLabel2.font = UIFont(name: "PretendardGOV-Bold", size: 28)
        loginBtn.titleLabel?.font = UIFont(name: "PretendardGOV-Bold", size: 16)
        makeUserBtn.titleLabel?.font = UIFont(name: "PretendardGOV-Bold", size: 16)
        loginBtn.backgroundColor = UIColor(hex: "#E7AC52")
        loginBtn.layer.cornerRadius = 8
        makeUserBtn.tintColor = UIColor(hex: "#E7AC52")
        makeUserBtn.layer.cornerRadius = 8
        self.navigationItem.backButtonTitle = ""
        self.navigationController?.navigationBar.tintColor = .black  
    }
    
    //MARK: - Action func
    @IBAction func tapLoginBtn(_ sender: UIButton) {
        //로그인버튼 클릭시
        guard let nextVC = storyboard?.instantiateViewController(withIdentifier: "LoginVC") as? LoginVC else { return }
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    
    @IBAction func tapMakeUserBtn(_ sender: UIButton) {
        //회원가입버튼 클릭시(7월말 회의 결과 농부 로그인은 사용하지 않기로 결정.)
        guard let nextVC = storyboard?.instantiateViewController(withIdentifier: "MakeUser_2pVC") as? MakeUser_2pVC else { return }
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
}

//MARK: - UIColor Hex
extension UIColor {
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var hexFormatted = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if hexFormatted.hasPrefix("#") {
            hexFormatted.remove(at: hexFormatted.startIndex)
        }

        var rgbValue: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgbValue)

        let r = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
        let g = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
        let b = CGFloat(rgbValue & 0x0000FF) / 255.0

        self.init(red: r, green: g, blue: b, alpha: alpha)
    }
}



//
//  LoadingVC.swift
//  Try-Local
//
//  Created by 시모니의 맥북 on 8/25/25.
//

import UIKit

//일반 로딩화면
class LoadingVC: UIViewController {
    
    @IBOutlet weak var loadingImg: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 애니메이션 이미지 배열 지정
        loadingImg.animationImages = [
            UIImage(named: "FetchLoading1")!,
            UIImage(named: "FetchLoading2")!,
            UIImage(named: "FetchLoading3")!,
            UIImage(named: "FetchLoading4")!
        ]
        // 4장 × 0.5초 = 2초 걸림
        loadingImg.animationDuration = 2.0
        loadingImg.animationRepeatCount = 0
        loadingImg.startAnimating()
        
    }
    
}


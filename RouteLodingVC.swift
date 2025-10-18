//
//  RouteLodingVC.swift
//  Try-Local
//
//  Created by 시모니의 맥북 on 9/5/25.
//

import UIKit
import Kingfisher

class RouteLodingVC: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var leftBtn: UIButton!
    @IBOutlet weak var rightBtn: UIButton!
    @IBOutlet weak var subView: UIView!
    @IBOutlet weak var QLabel: UILabel!
    @IBOutlet weak var subLineView: UIView!
    @IBOutlet weak var Alabel: UILabel!
    @IBOutlet weak var middleLabel: UILabel!
    @IBOutlet weak var countMentLabel: UILabel!
    
    private let viewModel = RouteLodingVM()
    private var currentIndex: Int = 0
    private var loadingTimer: Timer?
    private var elapsedSeconds: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setupImageViewConstraints()
        setupButtonActions()
        updateUI()
        startLoadingTimer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
           super.viewWillDisappear(animated)
           stopLoadingTimer()
       }
    
    private func setupImageViewConstraints() {
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.contentMode = .scaleAspectFill // 정사각형으로 채우기
        imgView.clipsToBounds = true // 넘치는 부분 잘라내기
        NSLayoutConstraint.activate([
            imgView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imgView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imgView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            
            // ✅ 정사각형: height == width
            imgView.heightAnchor.constraint(equalTo: view.widthAnchor)
        ])
    }
    
    private func configureUI() {
        titleLabel.font = UIFont(name: "PretendardGOV-Bold", size: 16)
        placeLabel.font = UIFont(name: "PretendardGOV-SemiBold", size: 18)
        QLabel.font = UIFont(name: "PretendardGOV-Medium", size: 18)
        Alabel.font = UIFont(name: "PretendardGOV-Regular", size: 18)
        middleLabel.font = UIFont(name: "PretendardGOV-Regular", size: 12)
        countMentLabel.font = UIFont(name: "PretendardGOV-Regular", size: 12)
        
        subView.layer.cornerRadius = 8
    }
    
    private func setupButtonActions() {
        leftBtn.addTarget(self, action: #selector(leftButtonTapped), for: .touchUpInside)
        rightBtn.addTarget(self, action: #selector(rightButtonTapped), for: .touchUpInside)
    }
    
    // MARK - Loading Timer
        private func startLoadingTimer() {
            elapsedSeconds = 0
            updateLoadingLabel()
            
            loadingTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
                guard let self = self else { return }
                self.elapsedSeconds += 1
                self.updateLoadingLabel()
            }
        }
        
        private func stopLoadingTimer() {
            loadingTimer?.invalidate()
            loadingTimer = nil
        }
        
        private func updateLoadingLabel() {
            countMentLabel.text = String(format: "현재 %02d초 로딩중", elapsedSeconds)
        }
    
    @objc private func leftButtonTapped() {
        if currentIndex > 0 {
            currentIndex -= 1
            updateUI()
        }
    }
    
    @objc private func rightButtonTapped() {
        if currentIndex < viewModel.loadingItems.count - 1 {
            currentIndex += 1
            updateUI()
        }
    }
    
    private func updateUI() {
        let item = viewModel.loadingItems[currentIndex]
        
        // 이미지 로드 (Kingfisher)
        if let url = URL(string: item.imgURL) {
            imgView.kf.setImage(
                with: url,
                placeholder: UIImage(systemName: "photo"),
                options: [
                    .transition(.fade(0.2)),
                    .cacheOriginalImage
                ]
            )
        }
        
        // 라벨 업데이트
        placeLabel.text = item.name
        QLabel.text = "Q. \(item.Q)"
        Alabel.text = "A. \(item.A)"
        
        // 버튼 활성화/비활성화
        leftBtn.isEnabled = currentIndex > 0
        rightBtn.isEnabled = currentIndex < viewModel.loadingItems.count - 1
        
        // 버튼 스타일 변경 (선택사항)
        leftBtn.alpha = leftBtn.isEnabled ? 1.0 : 0.3
        rightBtn.alpha = rightBtn.isEnabled ? 1.0 : 0.3
    }
    
}

//
//  Mp_BookMarkVC.swift
//  TryLocal
//
//  Created by 시모니의 맥북 on 8/12/25.
//

import UIKit
import Kingfisher

class Mp_BookMarkVC: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    var vm: Mp_BookMarkVM!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        titleLabel.font = UIFont(name: "PretendardGOV-Bold", size: 16)
        vm.getFavoriteList { [weak self] items in
            guard let self = self else { return }
            self.vm.routeItems = items
            self.collectionView.reloadData()
        }
    }
    
}

extension Mp_BookMarkVC: UICollectionViewDataSource , UICollectionViewDelegate , UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        vm.routeItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Mp_BookMarkCell", for: indexPath) as? Mp_BookMarkCell else {
            return UICollectionViewCell()
        }
        let item = vm.routeItems[indexPath.item]   // ✅ 데이터 가져오기
        // 이미지 크기 통일용 processor
        let processor = ResizingImageProcessor(referenceSize: CGSize(width: 76, height: 76), mode: .aspectFill)
        // 이미지뷰 설정
        cell.imageView.contentMode = .scaleAspectFill
        cell.imageView.clipsToBounds = true
        
        // 데이터 매핑
        cell.placeLabel.text = item.name ?? ""
        cell.categoryLabel.text = item.type_label ?? ""
        cell.explanationLabel.text = item.description ?? ""
        cell.imageView.kf.setImage(
            with: URL(string: item.image ?? ""),
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(0.3)),
                .cacheOriginalImage
            ]
        )
        cell.imageView.layer.cornerRadius = 8
        
        if item.type_label == "체험" {
            cell.subView.backgroundColor = UIColor(hex: "#5C3800")
        } else if item.type_label == "관광" {
            cell.subView.backgroundColor = UIColor(hex: "#D977DE")
        } else if item.type_label == "카페" {
            cell.subView.backgroundColor = UIColor(hex: "#E7AC52")
        }
        
        
        cell.placeLabel.font = UIFont(name: "PretendardGOV-Bold", size: 16)
        cell.categoryLabel.font = UIFont(name: "PretendardGOV-Medium", size: 8)
        cell.explanationLabel.font = UIFont(name: "PretendardGOV-SemiBold", size: 12)
        cell.subView.layer.cornerRadius = 8
        
        cell.moreInfoButtonTapped = { [weak self] in
            guard let self = self else { return }
            
            if item.type_label == "체험" {
                guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "ExperienceDetailVC") as? ExperienceDetailVC else { return }
                
                let nextVM = ExperienceDetailVM(token: vm.token, targetName: item.name ?? "")
                nextVC.vm = nextVM
                
                // ✅ LoadingVC 표시
                guard let loadingVC = storyboard?.instantiateViewController(withIdentifier: "LoadingVC") as? LoadingVC else { return }
                loadingVC.modalPresentationStyle = .overFullScreen
                present(loadingVC, animated: false) {
                    
                    // API 호출
                    nextVM.getDetailInfoAPI(name: item.name ?? "") {
                        
                        DispatchQueue.main.async {
                            // 로딩 모달 닫기
                            loadingVC.dismiss(animated: false) {
                                
                                // API 성공 여부 확인
                                if nextVM.name.isEmpty {
                                    // ❌ 데이터 없으면 Alert 표시
                                    let alert = UIAlertController(title: "오류", message: "데이터를 불러오지 못했습니다.\n다시 한 번 시도해 주세요.", preferredStyle: .alert)
                                    alert.addAction(UIAlertAction(title: "확인", style: .default))
                                    self.present(alert, animated: true)
                                } else {
                                    // ✅ 성공 시 모달로 DetailVC 띄우기
                                    nextVM.onDismiss = { [weak self] in
                                        guard let self = self else { return }
                                        self.vm.getFavoriteList { [weak self] items in
                                            guard let self = self else { return }
                                            self.vm.routeItems = items
                                            self.collectionView.reloadData()
                                        }
                                    }
                                    nextVC.modalPresentationStyle = .pageSheet
                                    self.present(nextVC, animated: false)
                                }
                                
                            }
                        }
                    }
                }
                
            } else if item.type_label == "관광" {
                guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "LocationDetailVC") as? LocationDetailVC else { return }
                let nextVM = LocationDetailVM(token: vm.token, targetName: item.name ?? "")
                nextVC.vm = nextVM
                
                // ✅ LoadingVC 표시
                guard let loadingVC = storyboard?.instantiateViewController(withIdentifier: "LoadingVC") as? LoadingVC else { return }
                loadingVC.modalPresentationStyle = .overFullScreen
                present(loadingVC, animated: false) {
                    
                    // API 호출
                    nextVM.getDetailInfoAPI(name: item.name ?? "") {
                        
                        DispatchQueue.main.async {
                            // 로딩 모달 닫기
                            loadingVC.dismiss(animated: false) {
                                
                                // API 성공 여부 확인
                                if nextVM.name.isEmpty {
                                    // ❌ 데이터 없으면 Alert 표시
                                    let alert = UIAlertController(title: "오류", message: "데이터를 불러오지 못했습니다.\n다시 한 번 시도해 주세요.", preferredStyle: .alert)
                                    alert.addAction(UIAlertAction(title: "확인", style: .default))
                                    self.present(alert, animated: true)
                                } else {
                                    // ✅ 성공 시 모달로 DetailVC 띄우기
                                    nextVM.onDismiss = { [weak self] in
                                        guard let self = self else { return }
                                        self.vm.getFavoriteList { [weak self] items in
                                            guard let self = self else { return }
                                            self.vm.routeItems = items
                                            self.collectionView.reloadData()
                                        }
                                    }
                                    nextVC.modalPresentationStyle = .pageSheet
                                    self.present(nextVC, animated: false)
                                }
                                
                            }
                        }
                    }
                }
                
            } else if item.type_label == "카페" {
                guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "CafeDetailVC") as? CafeDetailVC else { return }
                let nextVM = CafeDetailVM(token: vm.token, targetName: item.name ?? "")
                nextVC.vm = nextVM
                
                // ✅ LoadingVC 표시
                guard let loadingVC = storyboard?.instantiateViewController(withIdentifier: "LoadingVC") as? LoadingVC else { return }
                loadingVC.modalPresentationStyle = .overFullScreen
                present(loadingVC, animated: false) {
                    
                    // API 호출
                    nextVM.getDetailInfoAPI(name: item.name ?? "") {
                        
                        DispatchQueue.main.async {
                            // 로딩 모달 닫기
                            loadingVC.dismiss(animated: false) {
                                
                                // API 성공 여부 확인
                                if nextVM.name.isEmpty {
                                    // ❌ 데이터 없으면 Alert 표시
                                    let alert = UIAlertController(title: "오류", message: "데이터를 불러오지 못했습니다.\n다시 한 번 시도해 주세요.", preferredStyle: .alert)
                                    alert.addAction(UIAlertAction(title: "확인", style: .default))
                                    self.present(alert, animated: true)
                                } else {
                                    // ✅ 성공 시 DetailVC push
                                    // ✅ 성공 시 모달로 DetailVC 띄우기
                                    nextVM.onDismiss = { [weak self] in
                                        guard let self = self else { return }
                                        self.vm.getFavoriteList { [weak self] items in
                                            guard let self = self else { return }
                                            self.vm.routeItems = items
                                            self.collectionView.reloadData()
                                        }
                                    }
                                    nextVC.modalPresentationStyle = .pageSheet
                                    self.present(nextVC, animated: false)
                                }
                                
                            }
                        }
                    }
                }
                
            }else if item.type_label == "축제" {
                guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "FastivalDetailVC") as? FastivalDetailVC else { return }
                let nextVM = FastivalDetailVM(token: vm.token, targetName: item.name ?? "")
                nextVC.vm = nextVM
                
                // ✅ LoadingVC 표시
                guard let loadingVC = storyboard?.instantiateViewController(withIdentifier: "LoadingVC") as? LoadingVC else { return }
                loadingVC.modalPresentationStyle = .overFullScreen
                present(loadingVC, animated: false) {
                    
                    // API 호출
                    nextVM.getDetailInfoAPI(name: item.name ?? "") {
                        
                        DispatchQueue.main.async {
                            // 로딩 모달 닫기
                            loadingVC.dismiss(animated: false) {
                                
                                // API 성공 여부 확인
                                if nextVM.name.isEmpty {
                                    // ❌ 데이터 없으면 Alert 표시
                                    let alert = UIAlertController(title: "오류", message: "데이터를 불러오지 못했습니다.\n다시 한 번 시도해 주세요.", preferredStyle: .alert)
                                    alert.addAction(UIAlertAction(title: "확인", style: .default))
                                    self.present(alert, animated: true)
                                } else {
                                    // ✅ 성공 시 모달로 DetailVC 띄우기
                                    nextVM.onDismiss = { [weak self] in
                                        guard let self = self else { return }
                                        self.vm.getFavoriteList { [weak self] items in
                                            guard let self = self else { return }
                                            self.vm.routeItems = items
                                            self.collectionView.reloadData()
                                        }
                                    }
                                    nextVC.modalPresentationStyle = .pageSheet
                                    self.present(nextVC, animated: false)
                                }
                                
                            }
                        }
                    }
                }
                
            }
            
        }
        
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 1.0
        cell.layer.cornerRadius = 8
        cell.layer.masksToBounds = true
        
        return cell
    }
    
    // 셀 크기 지정
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        return CGSize(width: width, height: 100)
    }
    
    // 세로 간격 (라인 간격)
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
}



class Mp_BookMarkCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var subView: UIView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var moreInfoBtn: UIButton!
    @IBOutlet weak var explanationLabel: UILabel!
    
    // ✅ 클로저 선언 (외부에서 정의 가능하게)
    var moreInfoButtonTapped: (() -> Void)?
    
    @IBAction func tapMoreInfoBtn(_ sender: UIButton) {
        print("클로저 호출")
        moreInfoButtonTapped?()
    }
    
}

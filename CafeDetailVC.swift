//
//  CafeDetailVC.swift
//  TryLocal
//
//  Created by 시모니의 맥북 on 7/29/25.
//

import UIKit
import Kingfisher
import Combine

class CafeDetailVC: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var detailInfoLabel: UILabel!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var explanationLabel: UILabel!
    
    @IBOutlet weak var itemTitle1: UILabel!
    @IBOutlet weak var itemTitle2: UILabel!
    @IBOutlet weak var itemTitle3: UILabel!
    @IBOutlet weak var itemTitle4: UILabel!
    @IBOutlet weak var itemTitle5: UILabel!
    
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var callNumLabel: UILabel!
    @IBOutlet weak var coffeeInfoLabel: UILabel!
    @IBOutlet weak var parkingInfoLabel: UILabel!
    @IBOutlet weak var discountInfoLabel: UILabel!
    
    var vm: CafeDetailVM!
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        presentationController?.delegate = self
        configureUI()
        
    }
    
    private func configureUI() {
        titleLabel.font = UIFont(name: "PretendardGOV-Bold", size: 16)
        detailInfoLabel.font = UIFont(name: "PretendardGOV-Bold", size: 16)
        explanationLabel.font = UIFont(name: "PretendardGOV-SemiBold", size: 14)
        
        for label in [itemTitle1, itemTitle2, itemTitle3 , itemTitle4, itemTitle5] {
            label?.font = UIFont(name: "PretendardGOV-SemiBold", size: 14)
        }
        
        for label in [ addressLabel, callNumLabel, coffeeInfoLabel , parkingInfoLabel, discountInfoLabel] {
            label?.font = UIFont(name: "PretendardGOV-SemiBold", size: 14)
        }
        
        self.titleLabel.text = self.vm.name
        self.explanationLabel.text = self.vm.descriptionText
        self.addressLabel.text = self.vm.address
        self.callNumLabel.text = self.vm.contact
        self.coffeeInfoLabel.text = self.vm.coffee
        self.parkingInfoLabel.text = self.vm.parking
        self.discountInfoLabel.text = "🌟 \(self.vm.sales)"
        self.collectionView.reloadData()
        
        vm.$isFavorite
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isFav in
                // 옵셔널 처리: nil이면 false로 간주
                let imageName = (isFav ?? false) ? "heart.fill" : "heart"
                self?.likeBtn.setImage(UIImage(systemName: imageName), for: .normal)
            }
            .store(in: &cancellables)
        
        vm.$likeBtnIsHidden
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isHidden in
                self?.likeBtn.isHidden = isHidden
            }
            .store(in: &cancellables)
    }
    
    //MARK: - Action func
    @IBAction func tapLikeBtn(_ sender: UIButton) {
        //좋아요 버튼
        vm.plusFavoriteAPI(name: vm.name)
    }
    
}

extension CafeDetailVC: UICollectionViewDataSource , UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return vm.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DetailCell", for: indexPath) as? DetailCell else {
            return UICollectionViewCell()
        }
        
        // ✅ 이미지 크기 통일용 processor
        let processor = ResizingImageProcessor(referenceSize: CGSize(width: collectionView.frame.width, height: collectionView.frame.height), mode: .aspectFill)
        
        let imageUrl = vm.images[indexPath.item]
        if let url = URL(string: imageUrl) {
            cell.img.kf.setImage(
                with: url,
                placeholder: UIImage(named: "placeholder"),
                options: [
                    .processor(processor),
                    .scaleFactor(UIScreen.main.scale),
                    .transition(.fade(0.3)),
                    .cacheOriginalImage
                ]
            )
        }
        
        // 페이지 라벨
        cell.countLabel.text = "\(indexPath.item + 1)/\(vm.images.count)"
        cell.countLabel.font = UIFont(name: "PretendardGOV-SemiBold", size: 8)
        
        // 이미지뷰 속성
        cell.img.contentMode = .scaleAspectFill
        cell.img.clipsToBounds = true
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        // 컬렉션뷰 프레임 기준으로 정확히 설정
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}

extension CafeDetailVC: UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        // 모달이 스와이프 또는 시스템 방식으로 닫혔을 때 호출
        vm.onDismiss?()
    }
}

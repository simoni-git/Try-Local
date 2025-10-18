//
//  LocationDetailVC.swift
//  TryLocal
//
//  Created by 시모니의 맥북 on 6/28/25.
//

import UIKit
import Kingfisher
import Combine

class LocationDetailVC: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var detailInfoLabel: UILabel!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var explanationLabel: UILabel!
    
    @IBOutlet weak var itemTitle1: UILabel!
    @IBOutlet weak var itemTitle2: UILabel!
    @IBOutlet weak var itemTitle3: UILabel!
    
    @IBOutlet weak var adressLabel: UILabel!
    @IBOutlet weak var callNumLabel: UILabel!
    @IBOutlet weak var linkLabel: UILabel!
    
    var vm: LocationDetailVM!
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        presentationController?.delegate = self
        configure()
    }
    
    private func configure() {
        configureUI()
        setupLinkLabel()
        
    }
    
    private func configureUI() {
        titleLabel.font = UIFont(name: "PretendardGOV-Bold", size: 16)
        detailInfoLabel.font = UIFont(name: "PretendardGOV-Bold", size: 16)
        explanationLabel.font = UIFont(name: "PretendardGOV-SemiBold", size: 14)
        
        for label in [itemTitle1, itemTitle2, itemTitle3] {
            label?.font = UIFont(name: "PretendardGOV-SemiBold", size: 14)
        }
        
        for label in [ adressLabel, callNumLabel, linkLabel] {
            label?.font = UIFont(name: "PretendardGOV-SemiBold", size: 14)
        }
        
        titleLabel.text = self.vm.name
        explanationLabel.text = self.vm.descriptionText
        adressLabel.text = self.vm.address
        callNumLabel.text = self.vm.contact
        linkLabel.text = self.vm.link
        collectionView.reloadData()
        
        // ✅ 구독: isFavorite 값이 바뀔 때 버튼 이미지 갱신
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
    
    private func setupLinkLabel() {
        let fullText = "\(vm.link)"
        
        let attributed = NSMutableAttributedString(string: fullText)
        
        if let range = fullText.range(of: fullText) {
            let nsRange = NSRange(range, in: fullText)
            attributed.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: nsRange)
            attributed.addAttribute(.foregroundColor, value: UIColor.systemBlue, range: nsRange)
        }
        
        linkLabel.attributedText = attributed
        linkLabel.isUserInteractionEnabled = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleLabelTap(_:)))
        linkLabel.addGestureRecognizer(tap)
    }
    
    //MARK: - action func
    @IBAction func tapLikeBtn(_ sender: UIButton) {
        //좋아요버튼
        vm.plusFavoriteAPI(name: vm.name)
    }
    
    //MARK: - @objc func
    @objc func handleLabelTap(_ gesture: UITapGestureRecognizer) {
        guard let label = gesture.view as? UILabel,
              let text = label.attributedText?.string else { return }
        
        let linkText = "\(vm.link)"
        guard let range = text.range(of: linkText) else { return }
        let nsRange = NSRange(range, in: text)
        
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: label.bounds.size)
        let textStorage = NSTextStorage(attributedString: label.attributedText!)
        
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        textContainer.lineFragmentPadding = 0
        textContainer.maximumNumberOfLines = label.numberOfLines
        textContainer.lineBreakMode = label.lineBreakMode
        
        let locationOfTouch = gesture.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        let textContainerOffset = CGPoint(
            x: (label.bounds.size.width - textBoundingBox.size.width) / 2 - textBoundingBox.origin.x,
            y: (label.bounds.size.height - textBoundingBox.size.height) / 2 - textBoundingBox.origin.y
        )
        let locationInTextContainer = CGPoint(
            x: locationOfTouch.x - textContainerOffset.x,
            y: locationOfTouch.y - textContainerOffset.y
        )
        
        let characterIndex = layoutManager.characterIndex(
            for: locationInTextContainer,
            in: textContainer,
            fractionOfDistanceBetweenInsertionPoints: nil
        )
        
        if NSLocationInRange(characterIndex, nsRange) {
            print("✅ 주소클릭됨")
            if let url = URL(string: "\(vm.link)") {
                UIApplication.shared.open(url)
            }
        }
    }
    
}

extension LocationDetailVC: UICollectionViewDataSource , UICollectionViewDelegate , UICollectionViewDelegateFlowLayout {
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

extension LocationDetailVC: UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        // 모달이 스와이프 또는 시스템 방식으로 닫혔을 때 호출
        vm.onDismiss?()
    }
}


//
//  Mp_FootPrintVC.swift
//  Try-Local
//
//  Created by 시모니의 맥북 on 8/25/25.
//

import UIKit

class Mp_FootPrintVC: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    var vm: Mp_FootPrintVM!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        configure()
    }
    
    private func configure() {
        titleLabel.font = UIFont(name: "PretendardGOV-Bold", size: 16)
        self.navigationItem.backButtonTitle = ""
        self.navigationController?.navigationBar.tintColor = .black
    }
    
    
}

extension Mp_FootPrintVC: UICollectionViewDataSource , UICollectionViewDelegate , UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return vm.pastItems.count   // ✅ 변경
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FootPrintCell", for: indexPath) as? FootPrintCell else {
            return UICollectionViewCell()
        }
       
        let item = vm.pastItems[indexPath.row]
        
        cell.countLabel.text = "\(indexPath.row + 1)"
        cell.nameLabel.text = item.name
        cell.periodLabel.text = item.date
        cell.countLabel.font = UIFont(name: "PretendardGOV-SemiBold", size: 12)
        cell.nameLabel.font = UIFont(name: "PretendardGOV-Regular", size: 12)
        cell.periodLabel.font = UIFont(name: "PretendardGOV-Regular", size: 10)
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let nextVC = storyboard?.instantiateViewController(withIdentifier: "ResultMapVC") as? ResultMapVC else { return }
        let item = vm.pastItems[indexPath.row]
        let submissionID = item.sumbission_id
        nextVC.vm = ResultMapVM(token: vm.token)
        nextVC.vm.submissionID = submissionID
        nextVC.vm.fetchRoute(submissionID: submissionID)
        nextVC.vm.titleLabelText = "\(vm.pastItems[indexPath.row].name)"
        nextVC.vm.removeBtnIsHidden = true
        navigationController?.pushViewController(nextVC, animated: true)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        return CGSize(width: width, height: 60)
    }
    
    
}

class FootPrintCell: UICollectionViewCell {
    @IBOutlet weak var countLabel : UILabel!
    @IBOutlet weak var nameLabel : UILabel!
    @IBOutlet weak var periodLabel : UILabel!
}


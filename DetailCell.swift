//
//  DetailCell.swift
//  Try-Local
//
//  Created by 시모니의 맥북 on 8/19/25.
//

import UIKit

class DetailCell: UICollectionViewCell {
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var subView: UIView!
    @IBOutlet weak var countLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // overlayView 기본 설정
        subView.layer.cornerRadius = 8
        subView.backgroundColor = UIColor.white
    }
    
}

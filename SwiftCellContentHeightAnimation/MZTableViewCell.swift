//
//  MZTableViewCell.swift
//  SwiftCellContentHeightAnimation
//
//  Created by Monster on 2017-01-25.
//  Copyright © 2017 Monster. All rights reserved.
//

import UIKit

class MZTableViewCell: UITableViewCell {

    @IBOutlet weak var pictureView: MZHomeTableCellPictureView!
    
    @IBOutlet weak var detailView: MZTableCellDetailView!
    
    var showMore : Bool?{
        didSet{
            if showMore == false{
                detailView.heightCons.constant = 0
                seeMoreButton.setTitle("See more", for: .normal)
                
                UIView.animate(withDuration: 0.2, animations: {
                    self.detailView.alpha = 0
                }, completion: { (finished) in
                    self.detailView.isHidden = true
                })
                
            }else{
                detailView.heightCons.constant = 150
                seeMoreButton.setTitle("Close", for: .normal)
                detailView.isHidden = false
                
                detailView.alpha = 0
                UIView.animate(withDuration: 0.2, animations: {
                    self.detailView.alpha = 1
                })
            }
        }
    }
    
    weak var parentTableView : UITableView?
    
    @IBOutlet weak var seeMoreButton: UIButton!
    
    @IBAction func seeMoreDetail(_ sender: UIButton) {
        
        self.showMore = !self.showMore!
        
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.3, animations: {
            self.parentTableView?.beginUpdates()
            
            self.parentTableView?.endUpdates()
        }, completion: nil)
        
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}

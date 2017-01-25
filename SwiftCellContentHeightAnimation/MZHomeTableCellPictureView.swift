//
//  MZTableViewDetailView.swift
//  SwiftCellContentHeightAnimation
//
//  Created by Monster on 2017-01-25.
//  Copyright © 2017 Monster. All rights reserved.
//

import UIKit

let ImageViewOutterMargin = CGFloat(12)

let ImageViewInnerMargin = CGFloat(3)

let ImageViewWidth = UIScreen.main.bounds.width - 2 * ImageViewOutterMargin

let ImageViewItemWidth = (ImageViewWidth - 2 * ImageViewInnerMargin) / 3


class MZHomeTableCellPictureView: UIView{
    
    @IBOutlet weak var heightCons: NSLayoutConstraint!
    
    var images = [UIImage](){
        didSet{
            calcViewSize()
        }
    }
    var imageViews = [UIImageView]()

    //weak var tableViewDelegate : PresentImagePreviewVCDelegate?
    
    // Calculate the photoView size by how many photos the user posted.
    private func calcViewSize() {
        // if single image, use the width/height of the image and multiplier to determine
        // the width/height of the image view.
        if images.count == 1 {
            
            //the maximum width of the image cannot exceed 3/4 of the cell
            let maxWidth = 3 * self.frame.width / 4
            let maxHeight : CGFloat = 250
            
            var ivWidth : CGFloat = 0
            var ivHeight : CGFloat = 0
            
            let image = images[0]
            let width = image.size.width
            let height = image.size.height
                
            if width >= height{
                let ratio = height / width
                // image width is the bigger side, compare it to our max width
                if width > maxWidth{
                    ivWidth = maxWidth
                }else{
                    ivWidth = width
                }
                ivHeight = ivWidth * ratio
            }else{
                let ratio = width / height
                // image height is the bigger side, compare it to max height
                if height > maxHeight{
                    ivHeight = maxHeight
                }else{
                    ivHeight = height
                }
                ivWidth = ivHeight * ratio
            }
            
            let v = subviews[0]
            v.frame = CGRect(x: 0,
                             y: ImageViewOutterMargin,
                             width: ivWidth,
                             height: ivHeight)
            heightCons.constant = v.frame.height + ImageViewOutterMargin
        } else {
            let v = subviews[0]
            v.frame = CGRect(x: 0,
                             y: ImageViewOutterMargin,
                             width: ImageViewItemWidth,
                             height: ImageViewItemWidth)
            heightCons.constant = calcPictureViewSize(count: images.count).height
        }
        
        // now after we decieded the size of imageView, we load images from firebase server.
        
//        addGestures()
        loadImages()
        
        
    }
    
    private var photos: [Dictionary<String, Any>]?
    
    override func awakeFromNib() {
        setupUI()
    }
    
//    func addGestures(){
//        
//        for iv in subviews as! [UIImageView]{
//            
//            let tap = UITapGestureRecognizer(target: self, action: #selector(tapImageView))
//            
//            iv.addGestureRecognizer(tap)
//        }
//        
//    }
    
    func calcPictureViewSize(count: Int?) -> CGSize {
        
        if count == 0 || count == nil {
            return CGSize()
        }

        let row = (count! - 1) / 3 + 1

        var height = ImageViewOutterMargin
        height += CGFloat(row) * ImageViewItemWidth
        height += CGFloat(row - 1) * ImageViewInnerMargin
        
        return CGSize(width: ImageViewWidth, height: height)
    }
    
    
    func loadImages(){
        for v in subviews {
            v.isHidden = true
        }
        
        var index = 0
        var record = 0
        for iv in imageViews{
            
            if iv.tag == index{
                if record >= images.count{
                    break
                }
                // 4 images are special.
                // we want the imageView to dsiplay like
                // ** **
                // ** **
                
                // instead of
                // ** ** **
                // **
                
                iv.image = images[record]
                
                if index == 1 && images.count == 4 {
                    index += 1
                }
                iv.isHidden = false
                
                index += 1
                record += 1
            }
        }
    }
    
//    func tapImageView(tap : UITapGestureRecognizer){
//        
//        let iv = tap.view
//        
//        let selectedIndex = iv!.tag
//        
//        var highQualityImageUrls = [String]()
//        var imageViews = [UIImageView]()
//        
//        // now we obtain all the high quality image urls from the dictionary.
//        for photo in photoModels {
//            if photo.lowQualityUrlString != nil && photo.highQualityUrlString != nil{
//                
//                highQualityImageUrls.append(photo.highQualityUrlString!)
//                
//                imageViews.append(photo.imageView!)
//            }
//            
//        }
//        
//        let imagePreviewController = ImagePreviewPageViewController(imageViews : imageViews,
//                                                                    urlStrings : highQualityImageUrls,
//                                                                    selectedIndex : selectedIndex)
//        
//        tableViewDelegate?.presentVC(vc: imagePreviewController)
//    }
}

extension MZHomeTableCellPictureView {
    
    // the reason I created 9 imageviews first is because we
    // do not want to setup up the view dynamically, since it
    // would take some time and the user might see the lagging
    // effect.
    // ---- In order to solve this problem, we simply created the
    //      view first, then set the isHidden attributes.
    
    fileprivate func setupUI() {
        
        backgroundColor = superview?.backgroundColor
        
        clipsToBounds = true
        
        let count = 3
        let rect = CGRect(x: 0,
                          y: ImageViewOutterMargin,
                          width: ImageViewItemWidth,
                          height: ImageViewItemWidth)
        
        for i in 0..<count * count {
            
            let iv = UIImageView()
            
            iv.tag = i
            iv.contentMode = .scaleAspectFill
            iv.clipsToBounds = true
            
            let row = CGFloat(i / count)
            let col = CGFloat(i % count)
            
            let xOffset = col * (ImageViewItemWidth + ImageViewInnerMargin)
            let yOffset = row * (ImageViewItemWidth + ImageViewInnerMargin)
            
            iv.frame = rect.offsetBy(dx: xOffset, dy: yOffset)
            
            addSubview(iv)
            imageViews.append(iv)
            
            iv.isUserInteractionEnabled = true

            
        }
    }
    
}

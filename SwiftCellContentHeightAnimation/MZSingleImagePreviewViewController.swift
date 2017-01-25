//
//  MZSingleImagePreviewViewController.swift
//  SwiftCellContentHeightAnimation
//
//  Created by Monster on 2017-01-25.
//  Copyright © 2017 Monster. All rights reserved.
//

import UIKit

class MZSingleImagePreviewViewController : UIViewController{
    
    var index = 0
    var image : UIImage?
    var imageView = UIImageView()
    
    fileprivate var imageUrlString : String?
    fileprivate var scrollView: UIScrollView?
    fileprivate var imageContainerView = UIView()
    
    init(image : UIImage){
        self.image = image
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        setupUI()
    }
    
    
}

extension MZSingleImagePreviewViewController : UIScrollViewDelegate{
    
    func setupUI(){
        setupView()
        
    }
    
    func setupView(){
        self.scrollView = UIScrollView(frame: self.view.bounds)
        self.scrollView!.bouncesZoom = true
        self.scrollView!.maximumZoomScale = 2.5
        self.scrollView!.isMultipleTouchEnabled = true
        self.scrollView!.delegate = self
        self.scrollView!.scrollsToTop = false
        self.scrollView!.showsHorizontalScrollIndicator = false
        self.scrollView!.showsVerticalScrollIndicator = false
        self.scrollView!.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.scrollView!.delaysContentTouches = false
        self.scrollView!.canCancelContentTouches = true
        self.scrollView!.alwaysBounceVertical = false
        self.view.addSubview(self.scrollView!)
        
        self.imageContainerView.clipsToBounds = true
        self.scrollView!.addSubview(self.imageContainerView)
        
        self.imageView.backgroundColor = UIColor(white: 1.0, alpha: 0.5)
        self.imageView.clipsToBounds = true
        
        self.imageView.image = image
        self.resizeImageView()
        
        // setup progressView
        
        self.imageContainerView.addSubview(self.imageView)
        
        let doubleTap = UITapGestureRecognizer.init(target: self, action: #selector(MZSingleImagePreviewViewController.doubleTap(tap:)))
        
        doubleTap.numberOfTapsRequired = 2
        
        self.view.addGestureRecognizer(doubleTap)
        
        
    }
    
}

// Mark : - Image handling
extension MZSingleImagePreviewViewController {
    
    
    func resizeImageView() {
        self.imageContainerView.frame = CGRect(x:0, y:0, width: self.view.frame.width, height: self.imageContainerView.bounds.height)
        let image = self.imageView.image!
        
        
        if image.size.height / image.size.width > self.view.bounds.height / self.view.bounds.width {
            
            let height = floor(image.size.height / (image.size.width / self.view.bounds.width))
            var originFrame = self.imageContainerView.frame
            originFrame.size.height = height
            self.imageContainerView.frame = originFrame
        } else {
            var height = image.size.height / image.size.width * self.view.frame.width
            if height < 1 || height.isNaN {
                height = self.view.frame.height
            }
            height = floor(height)
            var originFrame = self.imageContainerView.frame
            originFrame.size.height = height
            self.imageContainerView.frame = originFrame
            self.imageContainerView.center = CGPoint(x:self.imageContainerView.center.x, y:self.view.bounds.height / 2)
        }
        
        if self.imageContainerView.frame.height > self.view.frame.height && self.imageContainerView.frame.height - self.view.frame.height <= 1 {
            
            var originFrame = self.imageContainerView.frame
            originFrame.size.height = self.view.frame.height
            self.imageContainerView.frame = originFrame
        }
        
        self.scrollView?.contentSize = CGSize(width: self.view.frame.width, height: max(self.imageContainerView.frame.height, self.view.frame.height))
        self.scrollView?.scrollRectToVisible(self.view.bounds, animated: false)
        self.scrollView?.alwaysBounceVertical = self.imageContainerView.frame.height > self.view.frame.height
        self.imageView.frame = self.imageContainerView.bounds
        
    }
}

// Mark : - Event Handling.
extension MZSingleImagePreviewViewController{
    
    func doubleTap(tap:UITapGestureRecognizer) {
        if (self.scrollView!.zoomScale > 1.0) {
            // 状态还原
            self.scrollView!.setZoomScale(1.0, animated: true)
        } else {
            let touchPoint = tap.location(in: self.imageView)
            let newZoomScale = self.scrollView!.maximumZoomScale
            let xsize = self.view.frame.size.width / newZoomScale
            let ysize = self.view.frame.size.height / newZoomScale
            
            self.scrollView!.zoom(to: CGRect(x: touchPoint.x - xsize/2, y: touchPoint.y-ysize/2, width: xsize, height: ysize), animated: true)
        }
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageContainerView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let offsetX = (scrollView.frame.width > scrollView.contentSize.width) ? (scrollView.frame.width - scrollView.contentSize.width) * 0.5 : 0.0;
        let offsetY = (scrollView.frame.height > scrollView.contentSize.height) ? (scrollView.frame.height - scrollView.contentSize.height) * 0.5 : 0.0;
        self.imageContainerView.center = CGPoint(x: scrollView.contentSize.width * 0.5 + offsetX, y: scrollView.contentSize.height * 0.5 + offsetY);
    }
    
}

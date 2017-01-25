//
//  MZImagePreviewAnimator.swift
//  SwiftCellContentHeightAnimation
//
//  Created by Monster on 2017-01-25.
//  Copyright © 2017 Monster. All rights reserved.
//

import UIKit

class MZImagePreviewAnimator: NSObject, UIViewControllerTransitioningDelegate {
    
    var imageViews : [UIImageView]?
    var selectedIndex : Int = 0
    
    var isPresenting : Bool = false
    var fromImageView : UIImageView?
    
    init(imageViews : [UIImageView], selectedIndex : Int) {
        self.imageViews = imageViews
        self.selectedIndex = selectedIndex
    }
    
}

extension MZImagePreviewAnimator : UIViewControllerAnimatedTransitioning{
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        self.isPresenting = true
        return self
        
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        self.isPresenting = false
        return self
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        if isPresenting{
            self.presentTransition(transitionContext: transitionContext)
        }else{
            self.dissmissTransition(transitionContext: transitionContext)
        }
        
    }
    
    func presentTransition(transitionContext : UIViewControllerContextTransitioning){
        
        let container = transitionContext.containerView
        container.backgroundColor = UIColor.black
        
        let dummyIV = self.createDummyImageView()
        let parentIV = self.imageViews![selectedIndex]
        
        dummyIV.frame = container.convert(parentIV.frame, from: parentIV.superview)
        
        container.addSubview(dummyIV)
        
        let toView = transitionContext.view(forKey: UITransitionContextViewKey.to)
        toView?.alpha = 0
        
        let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from)
        fromView?.removeFromSuperview()
        
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext), animations: {
            dummyIV.frame = self.presentRectWithImageView(imageView: dummyIV)
            toView?.alpha = 1
            
        }) { (finished) in
            //            UIView.animate(withDuration: self.transitionDuration(using: transitionContext), animations: {
            //                toView?.alpha = 1
            //            }, completion: { (finished) in
            container.addSubview(toView!)
            dummyIV.removeFromSuperview()
            
            transitionContext.completeTransition(true)
            //            })
        }
        
    }
    
    func dissmissTransition(transitionContext : UIViewControllerContextTransitioning){
        
        let container = transitionContext.containerView
        container.backgroundColor = UIColor.clear
        
        let toView = transitionContext.view(forKey: UITransitionContextViewKey.to)
        container.addSubview(toView!)
        
        let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from)
        
        let dummyIV = self.createDummyImageView()
        dummyIV.frame = container.convert(fromImageView!.frame, from: fromImageView!.superview)
        dummyIV.alpha = 1
        
        container.addSubview(dummyIV)
        
        fromView?.removeFromSuperview()
        
        let parentIV = imageViews![selectedIndex]
        
        let targetRect = container.convert(parentIV.frame, from: parentIV.superview)
        
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext), animations: {
            dummyIV.frame = targetRect
        }) { (finished) in
            dummyIV.removeFromSuperview()
            transitionContext.completeTransition(true)
            
            
        }
        
    }
    
    func createDummyImageView() -> UIImageView{
        
        let iv = UIImageView()
        
        iv.image = imageViews![selectedIndex].image!
        
        iv.contentMode = UIViewContentMode.scaleAspectFill
        iv.clipsToBounds = true
        
        return iv
    }
    
    func presentRectWithImageView(imageView : UIImageView) -> CGRect{
        
        let image = imageView.image
        
        if image == nil{
            return imageView.frame
        }
        
        let screenSize = UIScreen.main.bounds.size
        var imageSize = screenSize
        
        imageSize.height = image!.size.height * imageSize.width / image!.size.width
        
        var rect = CGRect(x: 0, y: 0, width : imageSize.width, height : imageSize.height)
        
        if imageSize.height < screenSize.height{
            rect.origin.y = (screenSize.height - imageSize.height) * 0.5
        }
        
        return rect
        
    }
    
    
}

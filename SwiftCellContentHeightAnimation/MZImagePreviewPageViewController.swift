//
//  MZImagePreviewPageViewController.swift
//  SwiftCellContentHeightAnimation
//
//  Created by Monster on 2017-01-25.
//  Copyright © 2017 Monster. All rights reserved.
//


import UIKit

class MZImagePreviewPageViewController: UIViewController{
    
    var transitionAnimator   : MZImagePreviewAnimator?
    var pageViewController   : UIPageViewController?
    var pageControl          : UIPageControl?
    var parentImageViews     : [UIImageView]?
    var imageCount          : Int = 0
    
    
    // the imageView that user is currently viewing at.
    var currentImageView     : UIImageView?
    
    // the index of pages the user is currently viewing at.
    var selectedIndex        : Int = 0
    
    init(imageViews : [UIImageView], imageCount : Int, selectedIndex : Int){
        
        self.parentImageViews = imageViews
        self.imageCount = imageCount
        self.selectedIndex = selectedIndex
        self.pageViewController = UIPageViewController(transitionStyle: .scroll,
                                                       navigationOrientation: .horizontal,
                                                       options: [UIPageViewControllerOptionInterPageSpacingKey: 20])
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
}

extension MZImagePreviewPageViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource{
    
    func setupUI(){
        
        setupPageViewController()
        
        // set up transition animator
        self.modalPresentationStyle = .custom
        self.transitionAnimator = MZImagePreviewAnimator(imageViews : parentImageViews!, selectedIndex : selectedIndex)
        self.transitioningDelegate = transitionAnimator
        
    }
    
    func setupPageViewController(){
        
        self.view.backgroundColor = UIColor.black
        self.pageViewController!.dataSource = self
        self.pageViewController!.delegate = self
        self.pageViewController!.view.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height);
        
        let singleImagePreviewVC = createSinglePreviewControllerWithIndex(index: self.selectedIndex)
        
        self.pageViewController!.setViewControllers([singleImagePreviewVC], direction: .forward, animated: true, completion: nil)
        
        
        self.addChildViewController(pageViewController!)
        self.view.addSubview(pageViewController!.view)
        self.didMove(toParentViewController: self)
        
        currentImageView = singleImagePreviewVC.imageView
        
        pageControl = UIPageControl()
        pageControl?.numberOfPages = imageCount
        pageControl?.currentPage = selectedIndex
        var center = self.view.center
        center.y = self.view.bounds.size.height - 50
        pageControl?.center = center
        
        self.view.addSubview(pageControl!)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissVC))
        self.view.addGestureRecognizer(tap)
        
    }
    
    func createSinglePreviewControllerWithIndex(index: Int) -> MZSingleImagePreviewViewController{
        
        //print(highQualityImageUrls![index])
        var i = index
        
        if parentImageViews![index].image == nil{
            i += 1
        }
        
        let vc = MZSingleImagePreviewViewController(image: (parentImageViews![i].image)!)
        vc.index = index
        
        return vc
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        let castVC = viewController as! MZSingleImagePreviewViewController
        
        let index = castVC.index
        
        let check = index - 1
        
        if check < 0{
            return nil
        }
        
        return self.createSinglePreviewControllerWithIndex(index: check)
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        let castVC = viewController as! MZSingleImagePreviewViewController
        
        let index = castVC.index
        
        let check = index + 1
        
        if check >= imageCount{
            return nil
        }
        
        return self.createSinglePreviewControllerWithIndex(index: check)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let vc = pageViewController.viewControllers?[0] as! MZSingleImagePreviewViewController
        self.selectedIndex = vc.index
        pageControl?.currentPage = vc.index
        currentImageView = vc.imageView
        
    }
    
}

extension MZImagePreviewPageViewController{
    
    func dismissVC(){
        
        transitionAnimator?.fromImageView = currentImageView
        transitionAnimator?.selectedIndex = selectedIndex

        self.dismiss(animated: true, completion: nil)
        
    }
}

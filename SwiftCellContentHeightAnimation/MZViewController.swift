//
//  ViewController.swift
//  SwiftCellContentHeightAnimation
//
//  Created by Monster on 2017-01-25.
//  Copyright © 2017 Monster. All rights reserved.
//

import UIKit

class MZViewController: UIViewController {

    var tableView: UITableView?
    
    fileprivate let cellIdentifier = "MZTableViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

}

extension MZViewController{
    
    func setupUI(){
        
        setupNavigationBar()
        
        setUpTableView()
    }
    
    func setupNavigationBar(){
        
        let newNavigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 64))
        newNavigationBar.tintColor = .darkGray
        let newNavigationItem = UINavigationItem()
        
        let titleLabel = UILabel()
        titleLabel.textAlignment = .center
        titleLabel.frame = CGRect(x: 0, y: 0, width: 100, height: 40) as CGRect
        titleLabel.text = "MZTableView"
        titleLabel.textColor = .darkGray
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: UIFontWeightSemibold)
        
        newNavigationItem.titleView = titleLabel
        newNavigationBar.setItems([newNavigationItem], animated: false)
        
        newNavigationBar.layer.borderWidth = 1.5
        newNavigationBar.layer.borderColor = UIColor(netHex: 0xe9e9e9).cgColor
        
        self.view.addSubview(newNavigationBar)
        
    }
    
    func setUpTableView() {
        
        tableView = UITableView(frame: CGRect(x: 0, y: 64, width : view.bounds.width, height : view.bounds.height - 64), style: .plain)
        tableView?.register(UINib.init(nibName: "MZTableViewCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
        
        tableView?.rowHeight = UITableViewAutomaticDimension
        tableView?.estimatedRowHeight = 300
        
        tableView?.scrollIndicatorInsets = tableView!.contentInset
        tableView?.separatorStyle = .none
        tableView?.delegate = self
        tableView?.dataSource = self
        
        self.view.addSubview(tableView!)
    }
    
}

extension MZViewController : UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 9
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var i = indexPath.row
        
        var image = UIImage(named: "test_image")
        var images = [UIImage]()
        
        if indexPath.row == 1{
            i -= 1
            image = UIImage(named: "test_image2")
        }

        for _ in 0...i{
            if let image = image{
                images.append(image)
            }
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! MZTableViewCell
        
        cell.pictureView.images = images
        cell.parentTableView = self.tableView
        
        if cell.showMore == nil{
            cell.showMore = false
        }
        
        return cell
    }
}

extension MZViewController : UITableViewDelegate{
        
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
    
        
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
}

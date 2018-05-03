//
//  InfoVC.swift
//  YoTransport
//
//  Created by Nishant on 17/09/16.
//  Copyright © 2016 9spl. All rights reserved.
//

import UIKit

class InfoVC: UIViewController, UIScrollViewDelegate, UIPageViewControllerDelegate {
    
    // MARK:- Variable Declaration -
    @IBOutlet weak var scrInfo: UIScrollView!
    @IBOutlet weak var ctrlPagingControl: UIPageControl!
    
    var bolIsPageControlUsed: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    override func viewDidLayoutSubviews() {
        self.setupUI()
    }
    //MARK: - SetUp UI -
    func setupUI()
    {
        self.tabBarController?.tabBar.isHidden = true
        for index in 0..<arrInfoPage.count {
            let imgIntro = UIImageView(image: UIImage(named: arrInfoPage[index] as! String))
            imgIntro.frame.origin.x = self.scrInfo.frame.size.width * CGFloat(index)
            imgIntro.frame.size = self.scrInfo.frame.size
            imgIntro.contentMode = UIViewContentMode.scaleToFill
            self.scrInfo.addSubview(imgIntro)
        }
        self.scrInfo.contentSize = CGSize(width: (self.scrInfo.frame.size.width * CGFloat(arrInfoPage.count)), height: self.scrInfo.frame.size.height)
        self.ctrlPagingControl.numberOfPages = arrInfoPage.count
        self.ctrlPagingControl.currentPage = 0
    }
    //MARK: - UIScrollView delegate -
    func scrollViewDidScroll(_ sender: UIScrollView) {
        if self.bolIsPageControlUsed {
            return
        }
        let pageWidth: CGFloat = self.scrInfo.frame.size.width
        let intCurrPage = floor((self.scrInfo.contentOffset.x - pageWidth / 2) / pageWidth) + 1
        self.ctrlPagingControl.currentPage = Int(intCurrPage)
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
    {
        self.bolIsPageControlUsed = false
    }
    // MARK: - Page Change -
    @IBAction func changePage(_ sender: AnyObject) {
        let intCurrPage = self.ctrlPagingControl.currentPage
        var frame = self.scrInfo.frame
        frame.origin.x = frame.size.width * CGFloat(intCurrPage)
        self.scrInfo.scrollRectToVisible(frame, animated: true)
        self.bolIsPageControlUsed = true
    }
    //MARK: - @IBActions -
    //Back
    @IBAction func btnClickedBack(_ sender: UIButton) {
        self.navigationController!.popViewController(animated: true)
    }
}

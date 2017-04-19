//
//  InfoViewController.swift
//  InfoDeck
//
//  Created by AINSLIE YUEN on 4/19/17.
//  Copyright © 2017 Aroopy. All rights reserved.
//
// Usage:
// This is just a ViewController with an email button, a close button and a scroll-page-controller
// that scrolls through info pages.
// In the Main Storyboard - need to give both the PageViewController and PageContentViewController 
// a storyboardID so that this class can find and instantiate them.

import UIKit
import Foundation
import MessageUI

class InfoViewController: UIViewController {
    var pageVC: UIPageViewController!
    
    // the count of pageTitles, pageImageNames and pageAttributedStrings have to be all identical
    let pageTitles = ["","",""]
    let pageImageNames = ["mockUpTablet", "mockUpPillow", "mockUpiPhone"]
    var pageAttributedStrings = [NSMutableAttributedString()]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Create the attributed strings ... before we create the PageViewController as we need the zeroth element
        // to initialise the PageViewController!! :-)
        let attributedString1 = NSMutableAttributedString(string: "Follow us on Instagram @aroopyapp\n\nFor help please tap the email button below.")
        attributedString1.addAttribute(NSLinkAttributeName, value: "https://www.instagram.com/aroopyapp", range: NSMakeRange(23, 10))
        let attributedString2 = NSMutableAttributedString(string: "Hello World")
        let attributedString3 = NSMutableAttributedString(string: "Stranger things have happened")
        
        pageAttributedStrings.removeAll()
        pageAttributedStrings.append( attributedString1 )
        pageAttributedStrings.append( attributedString2 )
        pageAttributedStrings.append( attributedString3 )
        
        createPageViewController()
        setupPageControl()
    }
}
extension InfoViewController: UIPageViewControllerDataSource {
    // MARK: - Setting up UIPageViewController
    fileprivate func createPageViewController(){
        let pageController = self.storyboard!.instantiateViewController(withIdentifier: "PageViewController") as! UIPageViewController
        pageController.dataSource = self
    
        if( pageImageNames.count > 0 ){
            let firstController = getItemController(0)!
            let startingViewControllers: NSArray = [firstController]
            
            pageController.setViewControllers( (startingViewControllers as! [UIViewController]), direction: UIPageViewControllerNavigationDirection.forward, animated: false, completion: nil)
        }
        pageVC = pageController
        
        let close_button_space = CGFloat( 75 ) // this is offset from top (30) plus size of button (45)
        pageVC.view.frame = CGRect( x: 0,y: close_button_space, width: self.view.frame.size.width, height: self.view.frame.size.height - close_button_space - 45 ) //added space for the bottom lock icon
        
        addChildViewController( pageVC )
        self.view.addSubview(pageVC.view)
        pageVC.didMove(toParentViewController: self)
    }
    
    fileprivate func setupPageControl(){
        let appearance = UIPageControl.appearance()
        appearance.pageIndicatorTintColor = UIColor.blue
        appearance.currentPageIndicatorTintColor = UIColor.cyan
    }
    
    // MARK: - UIPageViewControllerDataSource
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let itemController = viewController as! PageContentViewController
        if itemController.pageIndex > 0 {
            return getItemController( itemController.pageIndex - 1)
        }
        return nil
    }
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let itemController = viewController as! PageContentViewController
        if itemController.pageIndex + 1 < pageImageNames.count {
            return getItemController( itemController.pageIndex + 1)
        }
        return nil
    }
    fileprivate func getItemController( _ pageIndex: Int ) -> PageContentViewController? {
        if pageIndex < pageImageNames.count {
            let pageContentVC = self.storyboard!.instantiateViewController(withIdentifier: "PageContentViewController") as! PageContentViewController
            pageContentVC.pageIndex = pageIndex
            pageContentVC.imageFileName = pageImageNames[ pageIndex ]
            pageContentVC.titleText = pageTitles[ pageIndex ]
            pageContentVC.attributedString = pageAttributedStrings[ pageIndex ]
            return( pageContentVC )
        }
        return nil
    }
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return pageImageNames.count
    }
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
}

extension InfoViewController: MFMailComposeViewControllerDelegate {
    // MARK: Email functions
    @IBAction func sendEmailButtonTapped(_ sender: AnyObject) {
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        mailComposerVC.setToRecipients(["hello@world.com"])
        mailComposerVC.setSubject("Help!")
        mailComposerVC.setMessageBody("", isHTML: false)
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let alert = UIAlertController(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: MFMailComposeViewControllerDelegate
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}

//
//  PageContentViewController.swift
//  InfoDeck
//
//  Created by AINSLIE YUEN on 4/19/17.
//  Copyright © 2017 Aroopy. All rights reserved.
//

import UIKit

class PageContentViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    var pageIndex = 0
    var imageFileName: String = "" {
        didSet {
            if let imageView = imageView {
                imageView.image = UIImage( named: imageFileName )
            }
        }
    }
    var titleText: String = "" {
        didSet {
            if let _ = titleLabel {
                titleLabel.text = titleText
            }
        }
    }
    var attributedString: NSMutableAttributedString = NSMutableAttributedString() {
        didSet {
            if let _ = textView {
                textView.attributedText = attributedString
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageView.image = UIImage( named: imageFileName )
        self.titleLabel.text = titleText
        self.textView.attributedText = attributedString
        self.textView.isSelectable = true
    }
}

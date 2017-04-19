//
//  ViewController.swift
//  InfoDeck
//
//  Created by AINSLIE YUEN on 4/19/17.
//  Copyright © 2017 Aroopy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func unwindToMainVC( _ sender: UIStoryboardSegue ){
        print("Unwind to MainVC using Unwind Segue!")
    }
}


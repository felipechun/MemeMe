//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Felipe Chun on 7/7/20.
//  Copyright © 2020 Felipe Chun. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {
    
    var meme: Meme!
    
    @IBOutlet weak var MemeDetailImageView: UIImageView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        self.MemeDetailImageView!.image = meme.memedImage
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
}

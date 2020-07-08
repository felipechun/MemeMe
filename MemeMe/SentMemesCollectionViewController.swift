//
//  SentMemesCollectionViewController.swift
//  MemeMe
//
//  Created by Felipe Chun on 7/7/20.
//  Copyright © 2020 Felipe Chun. All rights reserved.
//

import UIKit



class SentMemesCollectionViewController: UICollectionViewController {
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let space: CGFloat = 1.0
        let width = (view.frame.size.width - (space * 2)) / 3.0
//        let height = (view.frame.size.height - (space * 2)) / 3.0
        
        
        flowLayout.minimumLineSpacing = space
        flowLayout.minimumInteritemSpacing = space
        flowLayout.itemSize = CGSize(width: width, height: width)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        collectionView.reloadData()
    }
    

    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemeCollectionCell", for: indexPath) as! MemeCollectionViewCell
        let meme = memes[(indexPath as NSIndexPath).row]
    
        // Configure the cell
        cell.memeCollectionImageView?.image = meme.memedImage
    
        return cell
    }

    // MARK: UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let memeDetailVC = storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        memeDetailVC.meme = memes[(indexPath as NSIndexPath).row]
        navigationController?.pushViewController(memeDetailVC, animated: true)
    }

    @IBAction func createMemeSegue(_ sender: Any) {
        let createMemeVC = storyboard!.instantiateViewController(withIdentifier: "CreateMemeViewController") as! CreateMemeViewController
        show(createMemeVC, sender: self)
    }

}

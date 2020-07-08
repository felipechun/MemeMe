//
//  SentMemesTableViewController.swift
//  MemeMe
//
//  Created by Felipe Chun on 7/7/20.
//  Copyright © 2020 Felipe Chun. All rights reserved.
//

import UIKit

class SentMemesTableViewController: UITableViewController {
    
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "memeCell", for: indexPath)
        let meme = memes[(indexPath as NSIndexPath).row]

        cell.textLabel?.text = "\(meme.topText) \(meme.bottomText)"
        cell.imageView?.image = meme.memedImage
        
        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let memeDetailVC = storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        memeDetailVC.meme = memes[(indexPath as NSIndexPath).row]
        navigationController?.pushViewController(memeDetailVC, animated: true)
    }
    
    
    // MARK: - Navigation
     
     @IBAction func createMemeSegue(_ sender: Any) {
        let createMemeVC = storyboard!.instantiateViewController(withIdentifier: "CreateMemeViewController") as! CreateMemeViewController        
        show(createMemeVC, sender: self)
     }
     
    

}

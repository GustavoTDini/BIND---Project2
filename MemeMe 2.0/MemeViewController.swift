//
//  MemeViewController.swift
//  MemeMe 2.0
//
//  Created by Gustavo Dini on 23/01/19.
//  Copyright © 2019 Gustavo Dini. All rights reserved.
//

import Foundation
import UIKit

class MemeViewController: UIViewController {
    
    var meme: Meme!
    
    var navBar: UINavigationBar!
    var shareButton: UIBarButtonItem!
    var returnButton: UIBarButtonItem!
    
    
    @IBOutlet weak var memeImageView: UIImageView!
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navBar = self.navigationController?.navigationBar
        shareButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.action, target: self, action: #selector(shareMeme))
        returnButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(doneAndReturn))
        self.navigationItem.rightBarButtonItem  = shareButton
        self.navigationItem.leftBarButtonItem = returnButton
        self.navigationItem.title = nil
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        
        self.memeImageView!.image = meme.memedImage
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    @IBAction func shareMeme(_ sender: Any) {
        let memeImage = memeImageView.image!
        let shareView = UIActivityViewController(activityItems: [memeImage], applicationActivities: [])
        shareView.completionWithItemsHandler = {(activity, completed, items, error) in
            if completed{
                self.dismiss(animated: true, completion: nil)
            }
        }
        present(shareView, animated: true)
    }
    
    @IBAction func doneAndReturn(_ sender: Any) {
        self.tabBarController?.tabBar.isHidden = false
        self.dismiss(animated: true, completion: {})
        self.navigationController!.popToRootViewController(animated: true)
    }
    
    
    
    @IBAction func EditMeme(_ sender: Any) {
        let memeCreatorViewController = self.storyboard!.instantiateViewController(withIdentifier: "MemeCreatorViewController") as! MemeCreatorViewController
        
        memeCreatorViewController.id = self.meme.id
        memeCreatorViewController.editingCurrentMeme = true
        
        self.navigationController!.pushViewController(memeCreatorViewController, animated: true)
    }
    
}

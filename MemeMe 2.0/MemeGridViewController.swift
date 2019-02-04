//
//  MemeGridViewControler.swift
//  MemeMe 2.0
//
//  Created by Gustavo Dini on 21/01/19.
//  Copyright © 2019 Gustavo Dini. All rights reserved.
//

import UIKit

class MemeGridViewController: UICollectionViewController{
    
    @IBOutlet weak var addMemeButton: UIBarButtonItem!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    //memes = appDelegate.memes
    
    var memes: [Meme] {
        return (UIApplication.shared.delegate as! AppDelegate).memes
    }
    
    //Refreshes table
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        self.collectionView!.reloadData()
        print ("Memes Count = ", self.memes.count)
        print(self.memes)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let space: CGFloat = 1.0
        var dimension: CGFloat!
        if (UIDevice.current.orientation == UIDeviceOrientation.portrait){
           dimension = (min(view.frame.size.width, view.frame.size.height) - (2 * space)) / 2.0
        } else if (UIDevice.current.orientation == UIDeviceOrientation.landscapeLeft || UIDevice.current.orientation == UIDeviceOrientation.landscapeRight){
            dimension = (min(view.frame.size.width, view.frame.size.height) - (2 * space)) / 3.0
        }
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let memeCell = collectionView.dequeueReusableCell(withReuseIdentifier: "memeCollectionCell", for: indexPath)  as! MemeGridCell
        let meme = self.memes[(indexPath as NSIndexPath).row]
        
        memeCell.memeCellImageView?.image = meme.memedImage
        
        return memeCell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath:IndexPath) {
        
        let memeViewController = self.storyboard!.instantiateViewController(withIdentifier: "MemeViewController") as! MemeViewController
        
        memeViewController.meme = self.memes[(indexPath as NSIndexPath).row]
        
        self.navigationController!.pushViewController(memeViewController, animated: true)
    }
    
    @IBAction func segueForMemeEditor(_ sender: Any) {
        let memeCreatorViewController = self.storyboard!.instantiateViewController(withIdentifier: "MemeCreatorViewController") as! MemeCreatorViewController
        
        memeCreatorViewController.editingCurrentMeme = false
        
        self.navigationController!.pushViewController(memeCreatorViewController, animated: true)
    }

}


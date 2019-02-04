//
//  MemeListViewController.swift
//  MemeMe 2.0
//
//  Created by Gustavo Dini on 21/01/19.
//  Copyright © 2019 Gustavo Dini. All rights reserved.
//

import UIKit

class MemeListViewController: UIViewController{

    @IBOutlet weak var addMemeButton: UIBarButtonItem!
    @IBOutlet weak var memeTable: UITableView!
    
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var memes: [Meme] {
        return (UIApplication.shared.delegate as! AppDelegate).memes
    }
    
    //Refreshes table
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.memeTable!.reloadData()
        print ("Memes Count = ", self.memes.count)
        print(self.memes)
    }
    
    @IBAction func segueForMemeEditor(_ sender: Any) {
        let memeCreatorViewController = self.storyboard!.instantiateViewController(withIdentifier: "MemeCreatorViewController") as! MemeCreatorViewController
        
        memeCreatorViewController.editingCurrentMeme = false
        
        self.navigationController!.pushViewController(memeCreatorViewController, animated: true)
    }
}

extension MemeListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.memes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        print(self.memes)
        let memeCell = tableView.dequeueReusableCell(withIdentifier: "memeTableCell")  as! MemeListCell
        let meme = self.memes[(indexPath as NSIndexPath).row]
        print(meme)
        
        memeCell.topMemeLabel?.text = meme.topText
        memeCell.bottonMemeLabel?.text = meme.bottomText
        memeCell.memeCellImageView?.image = meme.memedImage
        
        return memeCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let memeViewController = self.storyboard!.instantiateViewController(withIdentifier: "MemeViewController") as! MemeViewController
        
        memeViewController.meme = self.memes[(indexPath as NSIndexPath).row]
        
        self.navigationController!.pushViewController(memeViewController, animated: true)
    }

}


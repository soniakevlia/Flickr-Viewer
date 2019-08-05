//
//  ViewController.swift
//  FlickerViewer
//
//  Created by Yury Chumak on 05/07/2019.
//  Copyright © 2019 Yury Chumak. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    
    @IBOutlet weak var mainCollectionView: UICollectionView!
    @IBOutlet weak var searchTextField: UITextField!

    var imageArray = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainCollectionView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func searchForImage(_ sender: Any) {
        searchTextField.resignFirstResponder()
        //let disableMyButton = sender as? UIButton
        
        let flickr: FlickrHelper = FlickrHelper()
        
        if !searchTextField.text!.isEmpty{
            flickr.searchFlickrForString(searchStr: searchTextField.text!, completion: {(searchString: String!, flickrPhotos: NSMutableArray!, images: NSMutableArray!, error: NSError?) -> () in
            
                DispatchQueue.main.async {
                    //disableMyButton!.isEnabled = false

                    self.imageArray.removeAll()
                    self.imageArray = images as! [UIImage]
                    //self.mainCollectionView.reloadSections(IndexSet(integer: 0))
                    self.mainCollectionView.reloadData()
                }
    
            })
            //DispatchQueue.main.async {
              //  disableMyButton!.isEnabled = true
            //}
        }
       
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = mainCollectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewCell", for: indexPath) as! CollectionViewCell
        cell.displayContent(image: self.imageArray[indexPath.row])
        return cell
    }
}


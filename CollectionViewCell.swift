//
//  CollectionViewCell.swift
//  FlickerViewer
//
//  Created by Yury Chumak on 04/08/2019.
//  Copyright © 2019 Yury Chumak. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var bookImage: UIImageView!
    
    func displayContent(image: UIImage){
        bookImage.image = image
       // bookLabel.text = title
        
    }

    
}

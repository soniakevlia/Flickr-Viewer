//
//  FlickerHelper.swift
//  FlickerViewer
//
//  Created by Yury Chumak on 05/07/2019.
//  Copyright © 2019 Yury Chumak. All rights reserved.
//

import UIKit

class FlickrHelper: NSObject {
    class func URLForSearchString(searchString:String) -> String{
        let apiKey:String = "5b3b6809155885e40b98a371d32a9e58"
        let search:String = searchString.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        let perpage:Int = 100
        return "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(apiKey)&format=json&nojsoncallback=1&text=\(search)&per_page=\(perpage)&extras=url_o"
    }
    
    class func URLForFlickrPhoto(photo:FlickrPhoto, size:String) -> String{
        var _size:String = size
        if _size.isEmpty{
            _size =  "m"
        }
        return "http://farm" + String(photo.farm) + ".staticflickr.com/" + String(photo.server) + "/" + String(photo.photoID) + "_" + String(photo.secret) + "_" + String(_size) + ".jpg"
    }
    
    func searchFlickrForString(searchStr: String, completion:@escaping(_ searchString:String?, _ flickerPhotos:NSMutableArray?, _ images: NSMutableArray?, _ error:NSError?) ->()){
        let searchURL:String = FlickrHelper.URLForSearchString(searchString: searchStr)
        
        let queue = DispatchQueue.global(qos: .userInitiated)
        queue.async {
            var searchResultString:String! = nil

            do{
                searchResultString =  try String(contentsOf: NSURL(string: searchURL)! as URL, encoding: String.Encoding.utf8)
            }
            catch {
                print(error)
            }
            
            // Parse JSON
            let jsonData: NSData! = searchResultString.data(using: String.Encoding.utf8, allowLossyConversion: false) as NSData?
            var resultDict: NSDictionary! = nil
            do{
                resultDict = try JSONSerialization.jsonObject(with: jsonData as Data) as? NSDictionary
            }
            catch{
                print(error)
            }
            let images: NSMutableArray = NSMutableArray()
            let resultArray: NSArray = (resultDict.object(forKey: "photos") as AnyObject).object(forKey: "photo") as! NSArray
            let flickrPhotots: NSMutableArray = NSMutableArray()
            //var count:Int = 0
            for photoObject in resultArray{
                let photoDict:NSDictionary = photoObject as!  NSDictionary
                let flickrPhoto:FlickrPhoto = FlickrPhoto()
                //print(photoDict)
                flickrPhoto.farm = photoDict.object(forKey: "farm") as? Int
                flickrPhoto.server = photoDict.object(forKey: "server") as? String
                flickrPhoto.secret = photoDict.object(forKey: "secret") as? String
                flickrPhoto.photoID = (photoDict.object(forKey: "id") as! String)
                
                let searchURL: String = FlickrHelper.URLForFlickrPhoto(photo: flickrPhoto, size: "m")
                var imageData:NSData! = nil
                do {
                    imageData = try NSData.init(contentsOf: URL.init(string: searchURL)!, options: [])
                }
                catch {
                    print(error)
                    continue
                }
                let image: UIImage? = UIImage(data: imageData as Data)
                
                flickrPhoto.image = image
                images.add(image as Any)
                flickrPhotots.add(flickrPhoto)
                completion(searchStr, flickrPhotots, images, nil)

                //count+=1
            }


       }
        
    }
}

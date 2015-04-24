//
//  ViewController.swift
//  HBCollectionView
//
//  Created by hobert.lu@dji.com on 15/4/23.
//  Copyright (c) 2015年 hobert.lu@dji.com. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var hbcollectionView: UICollectionView!
    var hbUrlArray: Array<String>! = []
    var webCacheDictionary: [Int:NSData]! = [:]
    var currentIndex = -1;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.registerCellWithReuseIdentifier("HBCollectionView")
        self.hbcollectionView.collectionViewLayout = HBCollectionViewLayout();
        hbUrlArray = ["http://163.com", "http://sohu.com", "http://sina.com", "http://cnn.com", "http://bbs.com", "http://kbs.com", "http://taobao.com", "http://www.tmall.com", "http://jd.com", "http://www.amazon.cn"]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func registerCellWithReuseIdentifier(identifier: String) {
        // Register cell classes
        let nib: UINib? = UINib(nibName: "HBCollectionView", bundle: nil);
        self.hbcollectionView!.registerNib(nib, forCellWithReuseIdentifier: identifier)
    }
    
    func requestWebData() {
            
        for index in currentIndex-1...currentIndex+1 {
            
            if index >= 0 && index < hbUrlArray.count {
                if (webCacheDictionary[index] == nil) {
                    var request:NSURLRequest = NSURLRequest(URL: NSURL(string: hbUrlArray[index])!)
                    NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue(), completionHandler: { [weak self] (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
                        
                        NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                            if let strongSelf = self {
                                strongSelf.webCacheDictionary[index] = data
                                
                                if index == strongSelf.currentIndex {
                                    strongSelf.hbcollectionView.reloadItemsAtIndexPaths([NSIndexPath(index: strongSelf.currentIndex)])
                                }
                            }
                            return
                        })
                    
                    })
                }
            }

        }
        
    }
    
    // MARK: - UICollectionViewDelegate
    func collectionView(collectionView: UICollectionView, didEndDisplayingCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        currentIndex = indexPath.row
        requestWebData()
    }
    
    // MARK: - UICollectionViewDataSource
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        var cell: HBCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("HBCollectionView", forIndexPath: indexPath) as! HBCollectionViewCell
        
        cell.nameLabel.text = "fuckyou" + String(indexPath.row)
        var request: NSMutableURLRequest = NSMutableURLRequest()
//        request.URL = NSURL(string: hbUrlArray[indexPath.row])
//        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData
//        request.timeoutInterval = 60
//        request.HTTPShouldHandleCookies = false
//        request.HTTPMethod = "GET"
        cell.webView.loadData(webCacheDictionary[indexPath.row], MIMEType: "text/html", textEncodingName: nil, baseURL: nil)
        
        return cell
    }
    

}


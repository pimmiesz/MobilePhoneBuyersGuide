//
//  ViewController.swift
//  MobilePhoneBuyersGuide
//
//  Created by Patchariya Piyaaromrat on 27/8/2562 BE.
//  Copyright © 2562 SCB. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
  @IBOutlet var mCollectionView: UICollectionView!
  @IBOutlet var priceLabel: UILabel!
  @IBOutlet var ratingLabel: UILabel!
  var mobile: MobileElement?
  @IBOutlet var titleItem: UINavigationItem!
  @IBOutlet var detailLabel: UILabel!
  let mFeed = FeedData()
  var pic: Picture!
  var id = ""
  override func viewDidLoad() {
    super.viewDidLoad()
    if let mb = mobile{
      detailLabel.text = mb.mobileDatumDescription
      titleItem.title = mb.name
      priceLabel.text = "Price: $ \(mb.price)"
      ratingLabel.text = "Rating: \(mb.rating)"
      id = String(mb.id)
    }
    feedData()
    
  }
  
  private func feedData() {
    let _url = "https://scb-test-mobile.herokuapp.com/api/mobiles/\(id)/images//"
    mFeed.getPicture(url: _url) { result in
      self.pic = result
      self.mCollectionView.reloadData()
    }
  }
  func isValidUrl(url: String) -> Bool {
    let head1 = "((http|https)://)"
    let head = "([(w|W)]{3}+\\.)?"
    let tail = "\\.+[A-Za-z]{2,3}+(\\.)?+(/(.)*)?"
    let urlRegEx = head1 + head + "+(.)+" + tail
    let httpTest = NSPredicate(format:"SELF MATCHES %@", urlRegEx)
    return httpTest.evaluate(with: url)
  }
  
  func link(url:String) -> String{
    var successUrl = url
    if !isValidUrl(url: url){
      successUrl = "http://\(url)"
    }
    return successUrl
    
  }
}

extension DetailViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return self.pic?.count ?? 0
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as? MobileCollectionViewCell else {
      return UICollectionViewCell()
    }
    print(link(url: pic[indexPath.row].url))
    cell.imageView.loadImageUrl(link(url: pic[indexPath.row].url))
    
    return cell
  }
}

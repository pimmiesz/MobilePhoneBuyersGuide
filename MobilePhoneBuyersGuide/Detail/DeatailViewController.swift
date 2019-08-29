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
    feedData()
    if let mb = mobile{
      detailLabel.text = mb.mobileDatumDescription
      titleItem.title = mb.name
      priceLabel.text = "Price: $ \(mb.price)"
      ratingLabel.text = "Rating: \(mb.rating)"
      id = String(mb.id)
    }
    
  }
  
  private func feedData() {
    let _url = "https://scb-test-mobile.herokuapp.com/api/mobiles/\(id)/images//"
    mFeed.getPicture(url: _url) { result in
      self.pic = result
      self.mCollectionView.reloadData()
    }
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
    cell.imageView.loadImageUrl(pic[indexPath.row].url)
    
    return cell
  }
}

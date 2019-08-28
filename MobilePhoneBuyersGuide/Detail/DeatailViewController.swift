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
    let price = "Price: $ "
    let rating = "Rating: "
    var pic: Picture!
    var id = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        detailLabel.text = mobile?.mobileDatumDescription
        titleItem.title = mobile?.name
        priceLabel.text = price + String(mobile!.price)
        ratingLabel.text = rating + String(mobile!.rating)
        id = String(mobile!.id)
        feedData()
    }

    func feedData() {
        let _url = "https://scb-test-mobile.herokuapp.com/api/mobiles/\(id)/images//"
        mFeed.getPicture(url: _url) { result in
            self.pic = result
            self.mCollectionView.reloadData()
        }
    }
}

extension DetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = self.pic?.count {
            return count
        } else {
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as? MobileCollectionViewCell
        cell?.imageView.loadImageUrl(pic[indexPath.row].url)

        return cell!
    }
}

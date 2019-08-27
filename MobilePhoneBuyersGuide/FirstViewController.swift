//
//  FirstViewController.swift
//  MobilePhoneBuyersGuide
//
//  Created by Patchariya Piyaaromrat on 27/8/2562 BE.
//  Copyright © 2562 SCB. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {
    let mFeed = FeedData()
    var info: MobileData!
    
    
    @IBOutlet weak var navigation: UINavigationItem!
    @IBOutlet var mTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        feedData()
    }

    func feedData() {
        let _url = "https://scb-test-mobile.herokuapp.com/api/mobiles/"
        mFeed.getData(url: _url) { result in
            self.info = result
            self.mTableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail",
            
            let viewController = segue.destination as? DetailViewController,
            let selected = sender as? MobileData {
            viewController.mobile = selected
            print(selected)
            
        }
    }
}

extension FirstViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = self.info?.count {
            return count
        } else{
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let price = "Price: $ "
        let rating = "Rating: "
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? MobileTableViewCell
        cell?.nameLabel.text = info[indexPath.row].brand
        cell?.descriptionLabel.text = info[indexPath.row].mobileDatumDescription
        cell?.priceLabel.text = price+String(info[indexPath.row].price)
        cell?.ratingLabel.text  = rating+String(info[indexPath.row].rating)
        cell?.img.loadImageUrl(info[indexPath.row].thumbImageURL)
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDetail", sender: info[indexPath.row])
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension UIImageView{
    func loadImageUrl(_ urlString:String) {
        self.af_setImage(withURL: URL(string: urlString)!)
        
    }
    
    
}

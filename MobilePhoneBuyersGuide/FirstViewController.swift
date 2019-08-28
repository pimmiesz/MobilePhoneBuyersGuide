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
    var favInfo: [MobileElement] = []

    @IBAction func sortBtn(_ sender: Any) {
        showAlert()
    }
    @IBOutlet var navigation: UINavigationItem!
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
            let selected = sender as? MobileElement {
            print("selectd \(selected)")
            viewController.mobile = selected
        }
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "Sort", message: nil, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Price low to high", style: .default, handler: { (_) in
            self.info.sort(by: { (first, second) -> Bool in
                first.price<second.price
            })
            self.mTableView.reloadData()
        }))
        
        alert.addAction(UIAlertAction(title: "Price high to low", style: .default, handler: { (_) in
            self.info.sort(by: { (first, second) -> Bool in
                first.price>second.price
            })
            self.mTableView.reloadData()
        }))
        
        alert.addAction(UIAlertAction(title: "Rating", style: .default, handler: { (_) in
            self.info.sort(by: { (first, second) -> Bool in
                first.rating>second.rating
            })
            self.mTableView.reloadData()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: { (_) in
         
        }))
        self.present(alert, animated: true, completion: nil)
    }
}

extension FirstViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = self.info?.count {
            return count
        } else {
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let price = "Price: $ "
        let rating = "Rating: "
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? MobileTableViewCell
        cell?.firstVc = self
        cell?.favorite()
        cell?.nameLabel.text = info[indexPath.row].name
        cell?.descriptionLabel.text = info[indexPath.row].mobileDatumDescription
        cell?.priceLabel.text = price + String(info[indexPath.row].price)
        cell?.ratingLabel.text = rating + String(info[indexPath.row].rating)
        cell?.img.loadImageUrl(info[indexPath.row].thumbImageURL)

        return cell!
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDetail", sender: info[indexPath.row])
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func addFavorite(cell: UITableViewCell) {
        let favCell = mTableView.indexPath(for: cell)
        print("fav \(String(describing: favCell))")
        let index = favCell?.row
        print(info[(favCell?.row)!])
        favInfo.append((info?[index!])!)
        print(favInfo)
    }
}

extension UIImageView {
    func loadImageUrl(_ urlString: String) {
        af_setImage(withURL: URL(string: urlString)!)
    }
}

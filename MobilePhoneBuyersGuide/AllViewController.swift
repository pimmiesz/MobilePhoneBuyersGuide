//
//  FirstViewController.swift
//  MobilePhoneBuyersGuide
//
//  Created by Patchariya Piyaaromrat on 27/8/2562 BE.
//  Copyright © 2562 SCB. All rights reserved.
//

import UIKit

class AllViewController: UIViewController {
  let mFeed = FeedData()
  var info: MobileData!
  var favInfo: [MobileElement] = []
  var allInfo: [MobileElement] = []
  var id:[Int] = []
  var isSelected:Bool = false
  
  @IBOutlet weak var favoriteBtn: UIButton!
  @IBOutlet weak var allBtn: UIButton!
  @IBAction func sortBtn(_ sender: Any) {
    showAlert()
  }
  @IBOutlet var navigation: UINavigationItem!
  @IBOutlet var mTableView: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    feedData()
    favoriteBtn.addTarget(self, action: #selector(tapFav), for: .touchUpInside)
    allBtn.addTarget(self, action: #selector(tapAll), for: .touchUpInside)
    
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
  
  @objc func tapFav(){
    info = favInfo
    mTableView.reloadData()
    isSelected = true
    allBtn.setTitleColor(UIColor.lightGray, for: .normal)
    favoriteBtn.setTitleColor(UIColor.black, for: .normal)
    
  }
  @objc func tapAll(){
    //      info = allInfo
    feedData()
    mTableView.reloadData()
    isSelected = false
    allBtn.setTitleColor(UIColor.black, for: .normal)
    favoriteBtn.setTitleColor(UIColor.lightGray, for: .normal)
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
    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
      
    }))
    self.present(alert, animated: true, completion: nil)
  }
}

extension AllViewController: UITableViewDataSource, UITableViewDelegate {
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
    if isSelected == true{
      cell?.starBtn.isHidden = true
    } else{
      cell?.starBtn.isHidden = false
    }
    
    return cell!
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    performSegue(withIdentifier: "showDetail", sender: info[indexPath.row])
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
  func addFavorite(cell: UITableViewCell,isFav:Bool) {
    let favCell = mTableView.indexPath(for: cell)
    let index = favCell?.row
    UserDefaults.standard.removeObject(forKey: "id")
    if isFav == true {
      id.append(self.info[index!].id)
      UserDefaults.standard.set(id, forKey: "id")
    } else{
      var index = id.index(of: self.info[index!].id)
      id.remove(at: index!)
      UserDefaults.standard.set(id, forKey: "id")
    }
    id = UserDefaults.standard.value(forKey: "id") as! [Int]
    favInfo.removeAll()
    for i in id{
      favInfo.append(((info?[i-1])!))
    }
  }
  
}

extension UIImageView {
  func loadImageUrl(_ urlString: String) {
    af_setImage(withURL: URL(string: urlString)!)
  }
}

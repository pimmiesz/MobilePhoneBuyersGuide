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
  var idList:[Int] = []
  var isSelected:Bool = false
  var cellVc: MobileTableViewCell?
  
  @IBOutlet weak var favoriteBtn: UIButton!
  @IBOutlet weak var allBtn: UIButton!
  @IBOutlet var navigation: UINavigationItem!
  @IBOutlet var mTableView: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    feedData()
    favoriteBtn.addTarget(self, action: #selector(tapFav), for: .touchUpInside)
    allBtn.addTarget(self, action: #selector(tapAll), for: .touchUpInside)
  }
  
  @IBAction func sortBtn(_ sender: Any) {
    showAlert()
  }
  
  func feedData() {
    let _url = "https://scb-test-mobile.herokuapp.com/api/mobiles/"
    mFeed.getData(url: _url) { result in
      self.info = result
      self.setFavorite(idList: self.idList, bool: true)
      self.allInfo = self.info
      //self.setFavorite(idList: self.idList, info: self.allInfo, bool: true)
      
//      self.mTableView.reloadData()
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
    info = info.filter { $0.isfav == true }
    mTableView.reloadData()
    isSelected = true
    allBtn.setTitleColor(UIColor.lightGray, for: .normal)
    favoriteBtn.setTitleColor(UIColor.black, for: .normal)
    
  }
  @objc func tapAll(){
    info = allInfo
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
      self.allInfo.sort(by: { (first, second) -> Bool in
        first.price<second.price
      })
      self.mTableView.reloadData()
    }))
    
    alert.addAction(UIAlertAction(title: "Price high to low", style: .default, handler: { (_) in
      self.info.sort(by: { (first, second) -> Bool in
        first.price>second.price
      })
      self.allInfo.sort(by: { (first, second) -> Bool in
        first.price>second.price
      })
      
      self.mTableView.reloadData()
    }))
    
    alert.addAction(UIAlertAction(title: "Rating", style: .default, handler: { (_) in
      self.info.sort(by: { (first, second) -> Bool in
        first.rating>second.rating
      })
      self.allInfo.sort(by: { (first, second) -> Bool in
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
    return self.info?.count ?? 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? MobileTableViewCell else {
      return UITableViewCell()
    }
    let bool = info[indexPath.row].isfav
    cell.allVc = self
    cell.nameLabel.text = info[indexPath.row].name
    cell.descriptionLabel.text = info[indexPath.row].mobileDatumDescription
    cell.priceLabel.text = "Price: $ \(info[indexPath.row].price)"
    cell.ratingLabel.text = "Rating: \(info[indexPath.row].rating)"
    cell.img.loadImageUrl(info[indexPath.row].thumbImageURL)
    cell.starBtn.isHidden = isSelected
    cell.setImageButton(isfav: bool)
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    performSegue(withIdentifier: "showDetail", sender: info[indexPath.row])
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return true
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if (editingStyle == .delete) {
      let id = favInfo[indexPath.row].id
      favInfo.remove(at: indexPath.row)
      info = favInfo
      var index = 0
      while(index < allInfo.count) {
        if id == allInfo[index].id {
          allInfo[index].isfav = false
          let index = idList.firstIndex(of: self.allInfo[index].id)
          idList.remove(at: index ?? 0)
          UserDefaults.standard.removeObject(forKey: "id")
          UserDefaults.standard.set(idList, forKey: "id")
        }
        index+=1
      }
     
      mTableView.reloadData()
    }
  }
  
  func addFavorite(cell: UITableViewCell,isFav:Bool) {
    let favCell = mTableView.indexPath(for: cell)
    let index = favCell?.row
    UserDefaults.standard.removeObject(forKey: "id")
    UserDefaults.standard.synchronize()
    if isFav {
      self.info?[index ?? 0].isfav = true
      self.allInfo[index ?? 0].isfav = true
      idList.append(self.info?[index ?? 0].id ?? 0)
      UserDefaults.standard.removeObject(forKey: "id")
      UserDefaults.standard.synchronize()
      UserDefaults.standard.set(idList, forKey: "id")
      self.setFavorite(idList: self.idList, bool: true)
     
    } else {
      self.info?[index ?? 0].isfav = false
      self.allInfo[index ?? 0].isfav = false
      let index = idList.firstIndex(of: self.info[index!].id)
      idList.remove(at: index ?? 0)
      UserDefaults.standard.removeObject(forKey: "id")
      UserDefaults.standard.set(idList, forKey: "id")

    }
    let filtered = info.filter { $0.isfav == true }
    favInfo = filtered
    mTableView.reloadData()
  }
  
  func setFavorite(idList:[Int],bool:Bool) {
    
    self.idList = UserDefaults.standard.value(forKey: "id") as? [Int] ?? []
    print("idList\(self.idList)")
//    var filtered: [MobileElement]
    
    for id in idList {
      var index = 0
      while(index < self.info.count) {
        if id == self.info[index].id {
          self.info[index].isfav = bool
           self.allInfo[index].isfav = bool
        }
        index+=1
      }
    }
    mTableView.reloadData()
  }

  
}

extension UIImageView {
  func loadImageUrl(_ urlString: String) {
    if let url = URL(string: urlString) {
      af_setImage(withURL: url)
    }
  }
}

//
//  MobileTableViewCell.swift
//  MobilePhoneBuyersGuide
//
//  Created by Patchariya Piyaaromrat on 27/8/2562 BE.
//  Copyright © 2562 SCB. All rights reserved.
//

import UIKit

class MobileTableViewCell: UITableViewCell {
  
  @IBOutlet weak var descriptionLabel: UILabel!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var priceLabel: UILabel!
  @IBOutlet weak var ratingLabel: UILabel!
  @IBOutlet weak var img: UIImageView!
  @IBOutlet weak var starBtn: UIButton!
  var firstVc:AllViewController?
  var imageStar:UIImage!
  var isTapped:Bool = false
  
  func favorite(){
    starBtn.addTarget(self, action: #selector(tap), for: .touchUpInside)
  }
  
  @objc func tap(){
    if isTapped == false{
      imageStar = UIImage(named: "star-tap.png")
      starBtn.setImage(imageStar, for: .normal)
      isTapped = true
    } else{
      imageStar = UIImage(named: "star.png")
      starBtn.setImage(imageStar, for: .normal)
      isTapped = false
    }
    firstVc?.addFavorite(cell: self,isFav:isTapped)
  }
  
}

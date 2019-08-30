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
  var allVc: AllViewController?
  var isTapped: Bool = false
  
  
  @IBAction func tap(_ sender: UIButton) {
    isTapped = !isTapped
    allVc?.addFavorite(cell: self, isFav: isTapped)
    
  }
  func setImageButton (isfav:Bool){
    let imageStar: UIImage?
    if isfav {
      imageStar = UIImage(named: "star-tap.png")
    } else{
      imageStar = UIImage(named: "star.png")
    }
    if let imageStar = imageStar {
      starBtn.setImage(imageStar, for: .normal)
    }
  }
  
  
  
}

//
//  FeedData.swift
//  MobilePhoneBuyersGuide
//
//  Created by Patchariya Piyaaromrat on 27/8/2562 BE.
//  Copyright © 2562 SCB. All rights reserved.
//

import Alamofire
import AlamofireImage
import Foundation
class FeedData {
  func getData(url: String, completion: @escaping (MobileData) -> Void) {
    AF.request(URL(string: url)!, method: .get).responseJSON { response in
      switch response.result {
      case let .success(value):
        //                print(value)
        do {
          print("success feed")
          let decoder = JSONDecoder()
          let result = try decoder.decode(MobileData.self, from: response.data!)
          completion(result)
          //                    print("sucess api \(response.description)")
        } catch let error {
          print("error case success")
          print(error)
        }
        break
      case let .failure(error):
        print("error case failure")
        print(error)
        break
      }
    }
  }
  
  func getPicture(url: String, completion: @escaping (Picture) -> Void) {
    AF.request(URL(string: url)!, method: .get).responseJSON { response in
      switch response.result {
      case let .success(value):
        //                print(value)
        do {
          print("success feed")
          let decoder = JSONDecoder()
          let result = try decoder.decode(Picture.self, from: response.data!)
          completion(result)
          //                    print("sucess api \(response.description)")
        } catch let error {
          print("error case success")
          print(error)
        }
        break
      case let .failure(error):
        print("error case failure")
        print(error)
        break
      }
    }
  }
  
}

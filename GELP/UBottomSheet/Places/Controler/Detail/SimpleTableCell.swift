//
//  SimpleTableCell.swift
//  UBottomSheet
//
//  Created by ugur on 9.09.2018.
//  Copyright © 2018 otw. All rights reserved.
//

import UIKit
import Cosmos

struct SimpleTableCellViewModel {
    let images: [UIImage]?
    let title: String
   let place : Place?
}

class SimpleTableCell: UITableViewCell {

//    @IBOutlet weak var _imageView: UIImageView!
    @IBOutlet weak var _titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var _addressLabel: UILabel!
   @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var phoneNumberBtn: UIButton!
    @IBOutlet weak var cosmo: CosmosView!
   var images : [UIImage]?
   
    override func awakeFromNib() {
        super.awakeFromNib()
         collectionView.dataSource = self
//        _imageView.layer.cornerRadius = _imageView.frame.height/2
//        _imageView.layer.borderWidth = 1
//        _imageView.layer.borderColor = UIColor.lightGray.cgColor
      
    }
    
    func configure(model: SimpleTableCellViewModel){
        _titleLabel.text = model.title
      images = model.images
        _addressLabel.text = model.place?.address
        phoneNumberBtn.setTitle(model.place?.phoneNumber, for: .normal)
      if let rating = model.place?.rating{
         cosmo.rating = rating
      }
//        imageView?.image = model.image
    }


}

extension SimpleTableCell : UICollectionViewDataSource{
   func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      return (self.images?.count)!
   }
   
   func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionImageCell", for: indexPath) as! ImageCollectionViewCell
      cell.image.image = self.images![indexPath.row]
      
      return cell
   }
}


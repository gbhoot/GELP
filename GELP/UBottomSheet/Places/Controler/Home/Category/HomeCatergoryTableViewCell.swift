//
//  HomeCatergoryTableViewCell.swift
//  UBottomSheet
//
//  Created by Kim Do on 11/8/18.
//  Copyright © 2018 otw. All rights reserved.
//

import UIKit

class HomeCatergoryTableViewCell: UITableViewCell {

   @IBOutlet weak var collectionView: UICollectionView!
   let catergories = ["Restaurant", "Store", "Casino", "Gym", "Car Repair", "Lodging", "Political", "All"]
   let keys = ["restaurant", "store", "casino", "gym", "car_repair", "lodging", "political", ""]
   var index = 0
   
   var delegate: PassData?
   override func awakeFromNib() {
      super.awakeFromNib()
      collectionView.dataSource = self
      collectionView.delegate   = self
      
   }

   override func setSelected(_ selected: Bool, animated: Bool) {
      super.setSelected(selected, animated: animated)

      // Configure the view for the selected state
   }
}

extension HomeCatergoryTableViewCell : UICollectionViewDataSource{
   func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      return 8
   }

   func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCatergoryColletionCell", for: indexPath) as! HomeCategoryCollectionViewCell

      cell.label.text = catergories[indexPath.row]

      // Configure the cell

      return cell
   }
   
   func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      print("Clicked")
      let type :String = keys[index + indexPath.row]
      delegate?.moveToMapVC(type: type)
   }
}

extension HomeCatergoryTableViewCell : UICollectionViewDelegateFlowLayout{

   //  layout
   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      let yourWidth = collectionView.bounds.width / 2.0
      let yourHeight = yourWidth / 2.0

      return CGSize(width: yourWidth, height: yourHeight)
   }

   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
      return UIEdgeInsets.zero
   }

   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
      return 0
   }

   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
      return 0
   }
}

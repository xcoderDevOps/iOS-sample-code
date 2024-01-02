//
//  NotificationHeaderView.swift
//  CargoXpress
//
//  Created by Alpesh Desai on 13/01/21.
//  Copyright © 2021 Rushkar. All rights reserved.
//

import UIKit

class NotificationHeaderView: UIView {

    @IBOutlet weak var collectionView: UICollectionView!
    var arrayData = [MyPlaceData]()
    var completion:((_ data:MyPlaceData)->())?
    var selectedData = MyPlaceData()
    
    
    func setupCollectionView(selected:MyPlaceData, _ completion:((_ data:MyPlaceData)->())?) {
        collectionView.delegate = self
        collectionView.dataSource = self
        self.selectedData = selected
        self.completion = completion
        let nib = UINib(nibName: "NotificationHeaderCell", bundle: nil)
        self.collectionView.register(nib, forCellWithReuseIdentifier: "NotificationHeaderCell")
        callGetPlaceList { (data) in
            self.arrayData = data
            let general = MyPlaceData()
            general.Name = "General"
            self.arrayData.insert(general, at: 0)
            self.collectionView.reloadData()
        }
        
    }
}

extension NotificationHeaderView : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayData.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NotificationHeaderCell", for: indexPath) as! NotificationHeaderCell
        let obj = arrayData[indexPath.item]
        cell.lblTitle.text = obj.Name
        if selectedData.Id == obj.Id {
            cell.bgView.borderColor = UIColor.blueColor()
            cell.bgView.borderWidth = 1.0
            cell.lblTitle.textColor = UIColor.blueColor()
        } else {
            cell.bgView.borderColor = UIColor.clear
            cell.bgView.borderWidth = 0.0
            cell.lblTitle.textColor = UIColor.black
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedData = arrayData[indexPath.item]
        self.collectionView.reloadData()
        if self.completion != nil {
            self.completion!(arrayData[indexPath.item])
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var size = arrayData[indexPath.item].Name.size(withAttributes: [NSAttributedString.Key.font: UIFont(name: "AvenirNext-Medium", size: 17.0)!])
        size.width = CGFloat(ceilf(Float(size.width + 16)))
        size.height = 50
        return size
    }
}

//
//  SocialConnectCollectionViewCell.swift
//  KiranBedi
//
//  Created by Aditya Bonthu on 09/05/18.
//  Copyright © 2018 Aditya Bonthu. All rights reserved.
//

import UIKit

class SocialConnectCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var backView: UIView?
    @IBOutlet var socialNameLabel: UILabel?
    
    internal static func dequeue(fromCollectionView collectionView: UICollectionView, atIndexPath indexPath: IndexPath) -> SocialConnectCollectionViewCell {
        guard let cell: SocialConnectCollectionViewCell = collectionView.dequeueReusableCell(indexPath: indexPath) else {
            fatalError("*** Failed to dequeue CollectionCell ***")
        }
        return cell
    }
    
//    var setSelected : Bool? {
//        didSet {
//            if setSelected == true {
//                backView?.backgroundColor = UIColor(red:0.00, green:0.68, blue:0.94, alpha:1.0)
//                backView?.layer.cornerRadius = 15.0
//                socialNameLabel?.textColor = UIColor.white
//            } else {
//                backView?.backgroundColor = UIColor.white
//                backView?.layer.cornerRadius = 15.0
//                socialNameLabel?.textColor = UIColor.black
//            }
//        }
//    }
}

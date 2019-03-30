//
//  CommomCollectionViewCell.swift
//  Sabitha_Indra_Reddy
//
//  Created by Aditya Bonthu on 11/09/18.
//  Copyright © 2018 Aditya Bonthu. All rights reserved.
//

import UIKit

class CommomCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var commonLabel: UILabel?
    @IBOutlet var sselectionView: UIView?
    
    var setSelected : Bool? {
        didSet {
            if setSelected == true {
                sselectionView?.backgroundColor = Colors.DeepSaffron
            } else {
                sselectionView?.backgroundColor = .clear
            }
        }
    }
}

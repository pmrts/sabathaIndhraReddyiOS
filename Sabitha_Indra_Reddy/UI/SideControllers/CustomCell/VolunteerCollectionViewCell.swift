//
//  VolunteerCollectionViewCell.swift
//  KiranBedi
//
//  Created by Aditya Bonthu on 09/04/18.
//  Copyright © 2018 Aditya Bonthu. All rights reserved.
//

import UIKit

class VolunteerCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var selectionButton: UIButton?
    @IBOutlet var optionLabel: UILabel?
    
    internal static func dequeue(fromCollectionView collectionView: UICollectionView, atIndexPath indexPath: IndexPath) -> VolunteerCollectionViewCell {
        guard let cell: VolunteerCollectionViewCell = collectionView.dequeueReusableCell(indexPath: indexPath) else {
            fatalError("*** Failed to dequeue CollectionCell ***")
        }
        return cell
    }
    
}

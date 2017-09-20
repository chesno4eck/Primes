//
//  CollectionViewCell.swift
//  numbers
//
//  Created by Алиев Д.Ю. on 24/08/2017.
//  Copyright © 2017 TENZOR. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
	
	@IBOutlet var label: UILabel!
	
	func setup(text: String) {
		self.label.text = text
		
		self.selectedBackgroundView = UIView(frame: self.contentView.bounds)
		self.selectedBackgroundView!.backgroundColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
	}
}

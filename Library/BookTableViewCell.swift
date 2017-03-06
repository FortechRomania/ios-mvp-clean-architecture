//
//  BookTableViewCell.swift
//  Library
//
//  Created by Cosmin Stirbu on 2/23/17.
//  Copyright © 2017 Fortech. All rights reserved.
//

import UIKit

class BookTableViewCell: UITableViewCell, BookCellView {
	
	@IBOutlet weak var bookTitleLabel: UILabel!
	@IBOutlet weak var bookAuthorLabel: UILabel!
	@IBOutlet weak var bookReleaseDateLabel: UILabel!
	
	
	func display(title: String) {
		bookTitleLabel.text = title
	}
	
	func display(author: String) {
		bookAuthorLabel.text = author
	}
	
	func display(releaseDate: String) {
		bookReleaseDateLabel.text = releaseDate
	}
	
}

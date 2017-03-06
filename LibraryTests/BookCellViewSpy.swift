//
//  BookCellViewSpy.swift
//  Library
//
//  Created by Cosmin Stirbu on 2/27/17.
//  Copyright © 2017 Fortech. All rights reserved.
//

import Foundation
@testable import Library

class BookCellViewSpy: BookCellView {
	var displayedTitle = ""
	var displayedAuthor = ""
	var displayedReleaseDate = ""
	
	func display(title: String) {
		displayedTitle = title
	}
	
	func display(author: String) {
		displayedAuthor = author
	}
	
	func display(releaseDate: String) {
		displayedReleaseDate = releaseDate
	}
}

//
//  AddBookPresenterStub.swift
//  Library
//
//  Created by Cosmin Stirbu on 2/28/17.
//  Copyright © 2017 Fortech. All rights reserved.
//

import Foundation
@testable import Library

class AddBookPresenterStub: AddBookPresenter {
	var router: AddBookViewRouter
	
	init (router: AddBookViewRouter) {
		self.router = router
	}
	
	var maximumReleaseDate = Date()
	
	func addButtonPressed(parameters: AddBookParameters) { }
	
	func cancelButtonPressed() { }
}

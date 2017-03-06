//
//  AddBookViewRouter.swift
//  Library
//
//  Created by Cosmin Stirbu on 2/24/17.
//  Copyright © 2017 Fortech. All rights reserved.
//

import Foundation

protocol AddBookViewRouter: ViewRouter {
	func dismiss()
}

class AddBookViewRouterImplementation: AddBookViewRouter {
	fileprivate weak var addBookViewController: AddBookViewController?
	
	init(addBookViewController: AddBookViewController) {
		self.addBookViewController = addBookViewController
	}
	
	// MARK: - AddBookRouter
	
	func dismiss() {
		addBookViewController?.dismiss(animated: true, completion: nil)
	}
}

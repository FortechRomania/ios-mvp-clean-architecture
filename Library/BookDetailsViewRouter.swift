//
//  BookDetailsViewRouter.swift
//  Library
//
//  Created by Cosmin Stirbu on 2/23/17.
//  Copyright © 2017 Fortech. All rights reserved.
//

import Foundation

protocol BookDetailsViewRouter: ViewRouter {
	func dismissView()
}

class BookDetailsViewRouterImplementation: BookDetailsViewRouter {
	fileprivate weak var bookDetailsTableViewController: BookDetailsTableViewController?
	
	init(bookDetailsTableViewController: BookDetailsTableViewController) {
		self.bookDetailsTableViewController = bookDetailsTableViewController
	}
	
	func dismissView() {
		let _ = bookDetailsTableViewController?.navigationController?.popViewController(animated: true)
	}
}

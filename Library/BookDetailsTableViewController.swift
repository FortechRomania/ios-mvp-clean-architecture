//
//  BookDetailsTableViewController.swift
//  Library
//
//  Created by Cosmin Stirbu on 2/23/17.
//  Copyright © 2017 Fortech. All rights reserved.
//

import UIKit

class BookDetailsTableViewController: UITableViewController, BookDetailsView {
	var presenter: BookDetailsPresenter!
	var configurator: BookDetailsConfigurator!
	
	// MARK: - IBOutlets
	@IBOutlet weak var idLabel: UILabel!
	@IBOutlet weak var isbnLabel: UILabel!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var authorLabel: UILabel!
	@IBOutlet weak var pagesLabel: UILabel!
	@IBOutlet weak var releaseDateLabel: UILabel!
	@IBOutlet weak var deleteButton: UIBarButtonItem!
	
	// MARK: - UIViewController
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		configurator.configure(bookDetailsTableViewController: self)
		presenter.viewDidLoad()
	}
	
	// MARK: IBAction
	
	@IBAction func deleteButtonPressed(_ sender: Any) {
		presenter.deleteButtonPressed()
	}
	
	// MARK: - BookDetailsView
	
	func displayScreenTitle(title: String) {
		self.title = title
	}
	
	func display(id: String) {
		idLabel.text = id
	}
	
	func display(isbn: String) {
		isbnLabel.text = isbn
	}
	
	func display(title: String) {
		titleLabel.text = title
	}
	
	func display(author: String) {
		authorLabel.text = author
	}
	
	func display(pages: String) {
		pagesLabel.text = pages
	}
	
	func display(releaseDate: String) {
		releaseDateLabel.text = releaseDate
	}
	
	func displayDeleteBookError(title: String, message: String) {
		presentAlert(withTitle: title, message: message)
	}
	
	func updateCancelButtonState(isEnabled enabled: Bool) {
		deleteButton.isEnabled = enabled
	}
	
}

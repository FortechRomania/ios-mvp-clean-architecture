//
//  BooksTableViewController.swift
//  Library
//
//  Created by Cosmin Stirbu on 2/23/17.
//  Copyright © 2017 Fortech. All rights reserved.
//

import UIKit

class BooksTableViewController: UITableViewController, BooksView {
	var configurator = BooksConfiguratorImplementation()
	var presenter: BooksPresenter!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		configurator.configure(booksTableViewController: self)
		presenter.viewDidLoad()
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		presenter.router.prepare(for: segue, sender: sender)
	}
	
	// MARK: - IBAction
	
	@IBAction func addButtonPressed(_ sender: Any) {
		presenter.addButtonPressed()
	}
	
	// MARK: - UITableViewDataSource
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return presenter.numberOfBooks
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "BookTableViewCell", for: indexPath) as! BookTableViewCell
		presenter.configure(cell: cell, forRow: indexPath.row)
		
		return cell
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		presenter.didSelect(row: indexPath.row)
	}
	
	override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		return presenter.canEdit(row: indexPath.row)
	}
	
	override func tableView(_ tableView: UITableView,
	                        titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
		return presenter.titleForDeleteButton(row: indexPath.row)
	}
	
	override func tableView(_ tableView: UITableView,
	                        commit editingStyle: UITableViewCellEditingStyle,
	                        forRowAt indexPath: IndexPath) {
		presenter.deleteButtonPressed(row: indexPath.row)
	}
	
	// MARK: - BooksView
	
	func refreshBooksView() {
		tableView.reloadData()
	}
	
	func displayBooksRetrievalError(title: String, message: String) {
		presentAlert(withTitle: title, message: message)
	}
	
	func deleteAnimated(row: Int) {
		tableView.deleteRows(at: [IndexPath(row: row, section:0)], with: .automatic)
	}
	
	func endEditing() {
		tableView.setEditing(false, animated: true)
	}
	
	func displayBookDeleteError(title: String, message: String) {
		presentAlert(withTitle: title, message: message)
	}
}

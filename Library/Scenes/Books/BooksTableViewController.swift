//
//  BooksTableViewController.swift
//  Library
//
//  Created by Cosmin Stirbu on 2/23/17.
//  MIT License
//
//  Copyright (c) 2017 Fortech
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

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

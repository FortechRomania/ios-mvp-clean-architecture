//
//  AddBookViewController.swift
//  Library
//
//  Created by Cosmin Stirbu on 2/24/17.
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

class AddBookViewController: UIViewController, AddBookView {
	var presenter: AddBookPresenter!
	var configurator: AddBookConfigurator!
	
	// MARK: - IBOutlets
	
	@IBOutlet weak var saveButton: UIBarButtonItem!
	@IBOutlet weak var cancelButton: UIBarButtonItem!
	@IBOutlet weak var isbnTextField: UITextField!
	@IBOutlet weak var titleTextField: UITextField!
	@IBOutlet weak var authorTextField: UITextField!
	@IBOutlet weak var pagesTextField: UITextField!
	@IBOutlet weak var releaseDatePicker: UIDatePicker!
	
	// MARK: - UIViewController
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		configurator.configure(addBookViewController: self)
		releaseDatePicker.maximumDate = presenter.maximumReleaseDate
	}
	
	// MARK: - IBActions
	
	@IBAction func saveButtonPressed(_ sender: Any) {
		let addBookParameters = AddBookParameters(isbn: isbnTextField.textOrEmptyString,
		                                          title: titleTextField.textOrEmptyString,
		                                          author: authorTextField.textOrEmptyString,
		                                          releaseDate: releaseDatePicker.date,
		                                          pages: Int(pagesTextField.textOrEmptyString) ?? 0)
		// Validation on the pages input could be done by a "Validator" class
		// Or by the presenter - in which case we should pass it the actual string
		presenter.addButtonPressed(parameters: addBookParameters)
	}
	
	@IBAction func cancelButtonPressed(_ sender: Any) {
		presenter.cancelButtonPressed()
	}
	
	// MARK: - AddBookView
	
	func updateCancelButtonState(isEnabled enabled: Bool) {
		cancelButton.isEnabled = enabled
	}
	
	func updateAddButtonState(isEnabled enabled: Bool) {
		saveButton.isEnabled = enabled
	}
	
	func displayAddBookError(title:String, message: String) {
		presentAlert(withTitle: title, message: message)
	}
}

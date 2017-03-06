//
//  AddBookViewController.swift
//  Library
//
//  Created by Cosmin Stirbu on 2/24/17.
//  Copyright © 2017 Fortech. All rights reserved.
//

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

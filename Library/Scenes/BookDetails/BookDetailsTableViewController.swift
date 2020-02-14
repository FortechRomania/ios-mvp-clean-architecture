//
//  BookDetailsTableViewController.swift
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

//
//  BookDetailsConfigurator.swift
//  Library
//
//  Created by Cosmin Stirbu on 2/23/17.
//  Copyright © 2017 Fortech. All rights reserved.
//

import Foundation

protocol BookDetailsConfigurator {
	func configure(bookDetailsTableViewController: BookDetailsTableViewController)
}

class BookDetailsConfiguratorImplementation: BookDetailsConfigurator {
	
	let book: Book
	
	init(book: Book) {
		self.book = book
	}
	
	func configure(bookDetailsTableViewController: BookDetailsTableViewController) {
		let apiClient = ApiClientImplementation(urlSessionConfiguration: URLSessionConfiguration.default,
		                                        completionHandlerQueue: OperationQueue.main)
		let apiBooksGateway = ApiBooksGatewayImplementation(apiClient: apiClient)
		let viewContext = CoreDataStackImplementation.sharedInstance.persistentContainer.viewContext
		let coreDataBooksGateway = CoreDataBooksGateway(viewContext: viewContext)
		
		let booksGateway = CacheBooksGateway(apiBooksGateway: apiBooksGateway,
		                                     localPersistenceBooksGateway: coreDataBooksGateway)
		
		let deleteProgrammeUseCase = DeleteBookUseCaseImplementation(booksGateway: booksGateway)
		let router = BookDetailsViewRouterImplementation(bookDetailsTableViewController: bookDetailsTableViewController)
		
		let presenter = BookDetailsPresenterImplementation(view: bookDetailsTableViewController,
		                                     book: book,
		                                     deleteBookUseCase: deleteProgrammeUseCase,
		                                     router: router)
		
		
		bookDetailsTableViewController.presenter = presenter
	}
}

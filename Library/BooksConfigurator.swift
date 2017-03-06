//
//  BooksConfigurator.swift
//  Library
//
//  Created by Cosmin Stirbu on 2/23/17.
//  Copyright © 2017 Fortech. All rights reserved.
//

import Foundation

protocol BooksConfigurator {
	func configure(booksTableViewController: BooksTableViewController)
}

class BooksConfiguratorImplementation: BooksConfigurator {
	
	func configure(booksTableViewController: BooksTableViewController) {
		let apiClient = ApiClientImplementation(urlSessionConfiguration: URLSessionConfiguration.default,
		                                        completionHandlerQueue: OperationQueue.main)
		let apiBooksGateway = ApiBooksGatewayImplementation(apiClient: apiClient)
		let viewContext = CoreDataStackImplementation.sharedInstance.persistentContainer.viewContext
		let coreDataBooksGateway = CoreDataBooksGateway(viewContext: viewContext)
		
		let booksGateway = CacheBooksGateway(apiBooksGateway: apiBooksGateway,
		                                     localPersistenceBooksGateway: coreDataBooksGateway)
		
		let displayBooksUseCase = DisplayBooksListUseCaseImplementation(booksGateway: booksGateway)
		let deleteBookUseCase = DeleteBookUseCaseImplementation(booksGateway: booksGateway)
		let router = BooksViewRouterImplementation(booksTableViewController: booksTableViewController)
		
		let presenter = BooksPresenterImplementation(view: booksTableViewController,
		                               displayBooksUseCase: displayBooksUseCase,
		                               deleteBookUseCase: deleteBookUseCase,
		                               router: router)
		
		booksTableViewController.presenter = presenter
	}
}

//
//  AddBookConfigurator.swift
//  Library
//
//  Created by Cosmin Stirbu on 2/24/17.
//  Copyright © 2017 Fortech. All rights reserved.
//

import Foundation

protocol AddBookConfigurator {
	func configure(addBookViewController: AddBookViewController)
}

class AddBookConfiguratorImplementation: AddBookConfigurator {
	var addBookPresenterDelegate: AddBookPresenterDelegate?
	
	init(addBookPresenterDelegate: AddBookPresenterDelegate?) {
		self.addBookPresenterDelegate = addBookPresenterDelegate
	}
	
	func configure(addBookViewController: AddBookViewController) {
		let apiClient = ApiClientImplementation(urlSessionConfiguration: URLSessionConfiguration.default,
		                                        completionHandlerQueue: OperationQueue.main)
		let apiBooksGateway = ApiBooksGatewayImplementation(apiClient: apiClient)
		let viewContext = CoreDataStackImplementation.sharedInstance.persistentContainer.viewContext
		let coreDataBooksGateway = CoreDataBooksGateway(viewContext: viewContext)
		
		let booksGateway = CacheBooksGateway(apiBooksGateway: apiBooksGateway,
		                                     localPersistenceBooksGateway: coreDataBooksGateway)
		
		let addBookUseCase = AddBookUseCaseImplementation(booksGateway: booksGateway)
		let router = AddBookViewRouterImplementation(addBookViewController: addBookViewController)
		
		let presenter = AddBookPresenterImplementation(view: addBookViewController, addBookUseCase: addBookUseCase, router: router, delegate: addBookPresenterDelegate)
		
		addBookViewController.presenter = presenter
	}
}

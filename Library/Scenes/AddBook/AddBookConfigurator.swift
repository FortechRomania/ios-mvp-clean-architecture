//
//  AddBookConfigurator.swift
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

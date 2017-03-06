//
//  DisplayBooksUseCaseStub.swift
//  Library
//
//  Created by Cosmin Stirbu on 2/27/17.
//  Copyright © 2017 Fortech. All rights reserved.
//

import Foundation
@testable import Library

class DisplayBooksUseCaseStub: DisplayBooksUseCase {
	var resultToBeReturned: Result<[Book]>!
	
	func displayBooks(completionHandler: @escaping (Result<[Book]>) -> Void) {
		completionHandler(resultToBeReturned)
	}
}

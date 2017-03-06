//
//  AddBookViewRouterSpy.swift
//  Library
//
//  Created by Cosmin Stirbu on 2/28/17.
//  Copyright © 2017 Fortech. All rights reserved.
//

import Foundation
@testable import Library

class AddBookViewRouterSpy: AddBookViewRouter {
	var didCallDismiss = false
	
	func dismiss() {
		didCallDismiss = true
	}
}

//
//  NSError.swift
//  Library
//
//  Created by Cosmin Stirbu on 2/28/17.
//  Copyright © 2017 Fortech. All rights reserved.
//

import Foundation

extension NSError {
	static func createError(withMessage message: String) -> NSError {
		return NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: message])
	}
}

//
//  Result.swift
//  Library
//
//  Created by Cosmin Stirbu on 2/28/17.
//  Copyright © 2017 Fortech. All rights reserved.
//

import Foundation
@testable import Library

extension Result: Equatable { }

public func ==<T>(lhs: Result<T>, rhs: Result<T>) -> Bool {
	// Shouldn't be used for PRODUCTION enum comparison. Good enough for unit tests.
	return String(stringInterpolationSegment: lhs) == String(stringInterpolationSegment: rhs)
}

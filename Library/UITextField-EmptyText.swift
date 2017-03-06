//
//  UITextField-EmptyText.swift
//  Library
//
//  Created by Cosmin Stirbu on 2/25/17.
//  Copyright © 2017 Fortech. All rights reserved.
//

import UIKit

extension UITextField {
	var textOrEmptyString: String {
		return text ?? ""
	}
}

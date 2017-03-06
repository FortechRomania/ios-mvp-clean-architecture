//
//  UIViewController-Alert.swift
//  Library
//
//  Created by Cosmin Stirbu on 2/25/17.
//  Copyright © 2017 Fortech. All rights reserved.
//

import UIKit

extension UIViewController {
	
	func presentAlert(withTitle title:String, message: String) {
		let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
		
		present(alert, animated: true, completion: nil)
	}
	
}

//
//  ViewRouter.swift
//  Library
//
//  Created by Cosmin Stirbu on 2/23/17.
//  Copyright © 2017 Fortech. All rights reserved.
//

import UIKit

protocol ViewRouter {
	func prepare(for segue: UIStoryboardSegue, sender: Any?)
}

extension ViewRouter {
	func prepare(for segue: UIStoryboardSegue, sender: Any?) { }
}

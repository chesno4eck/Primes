//
//  SupportEntyties.swift
//  numbers
//
//  Created by Алиев Д.Ю. on 04/08/2017.
//  Copyright © 2017 TENZOR. All rights reserved.
//

import UIKit

class ADAlerts {
	class func showOkAlert(on vc: UIViewController, title: String, text: String) {
		let alert = UIAlertController(title: title, message: text, preferredStyle: .alert)
		let action = UIAlertAction(title: "OK", style: .default, handler: nil)
		alert.addAction(action)
		vc.present(alert, animated: true, completion: nil)
	}
}

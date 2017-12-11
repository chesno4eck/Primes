//
//  ErrorHandler.swift
//  numbers
//
//  Created by Алиев Д.Ю. on 18/09/2017.
//  Copyright © 2017 TENZOR. All rights reserved.
//

import UIKit

class ErrorHandler {
	
	static func normalize(_ maxNumber: String?, vc: UIViewController) -> Int? {
		guard maxNumber != nil && !maxNumber!.isEmpty else {
			AlertsHelper.showOkAlert(on: vc, title: "Нет числа", text: "Пожалуйста, введите целое положительное число")
			return nil
		}
		guard let number = Int(maxNumber!) else {
			AlertsHelper.showOkAlert(on: vc, title: "Так не пойдет", text: "\"\(maxNumber!)\" - это не число")
			return nil
		}
		guard number > 2 else {
			AlertsHelper.showOkAlert(on: vc, title: "Число слишком маленькое", text: "Пожалуйста, введите число больше чем 2")
			return nil
		}
		guard number < 20000001 else {
			AlertsHelper.showOkAlert(on: vc, title: "Число слишком большое", text: "Пожалуйста, введите число меньше чем 20.000.000")
			return nil
		}
		return number
	}
}

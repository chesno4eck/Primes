//
//  ErrorHandler.swift
//  numbers
//
//  Created by Алиев Д.Ю. on 18/09/2017.
//  Copyright © 2017 TENZOR. All rights reserved.
//

import UIKit

class ErrorHandler {
	
	static func normalize(_ fromNumber: String?, _ toNumber: String?, vc: UIViewController) -> (Int, Int)? {
		guard toNumber != nil && !toNumber!.isEmpty && fromNumber != nil && !fromNumber!.isEmpty else {
			AlertsHelper.showOkAlert(on: vc, title: "Нет числа", text: "Пожалуйста, введите целое положительное число")
			return nil
		}
		guard let toNumberInt = Int(toNumber!), let fromNumberInt = Int(fromNumber!) else {
			AlertsHelper.showOkAlert(on: vc, title: "Так не пойдет", text: "Это не число")
			return nil
		}
		guard fromNumberInt < toNumberInt else {
			AlertsHelper.showOkAlert(on: vc, title: "Так не пойдет", text: "Левое число должно быть меньше правого")
			return nil
		}
		guard toNumberInt > 2 && fromNumberInt >= 0 else {
			AlertsHelper.showOkAlert(on: vc, title: "Число слишком маленькое", text: "Пожалуйста, введите число больше чем 2")
			return nil
		}
		guard toNumberInt < 20000001 && fromNumberInt < 20000001 else {
			AlertsHelper.showOkAlert(on: vc, title: "Число слишком большое", text: "Пожалуйста, введите число меньше чем 20.000.000")
			return nil
		}
		return (toNumberInt, toNumberInt)
	}
}

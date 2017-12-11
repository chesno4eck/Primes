//
//  ErrorHandler.swift
//  numbers
//
//  Created by Алиев Д.Ю. on 18/09/2017.
//  Copyright © 2017 TENZOR. All rights reserved.
//

import UIKit

enum PrimesError: Error {
	case noNumber
	case badNumber(text: String)
	case toSmall
	case toBig
}

class ErrorHandler {
	
	static func getNumber(from text: String) throws -> Int {
		guard !text.isEmpty else {
			throw PrimesError.noNumber
		}
		
		guard let number = Int(text) else {
			throw PrimesError.badNumber(text: text)
		}
		
		guard number > 2 else {
			throw PrimesError.toSmall
		}
		
		guard number < 20000001 else {
			throw PrimesError.toBig
		}
		
		return number
	}
	
	static func show(_ error: Error, on vc: UIViewController) {
		
		switch error {
			
		case PrimesError.noNumber:
			AlertsHelper.showOkAlert(on: vc, title: "Нет числа", text: "Пожалуйста, введите целое положительное число")
			
		case PrimesError.badNumber(let text):
			AlertsHelper.showOkAlert(on: vc, title: "Так не пойдет", text: "\"\(text)\" - это не число")
			
		case PrimesError.toSmall:
			AlertsHelper.showOkAlert(on: vc, title: "Число слишком маленькое", text: "Пожалуйста, введите число больше чем 2")
			
		case PrimesError.toBig:
			AlertsHelper.showOkAlert(on: vc, title: "Число слишком большое", text: "Пожалуйста, введите число меньше чем 20.000.000")
			
		default:
			AlertsHelper.showOkAlert(on: vc, title: "Ошибка", text: "Что-то пошло не  так :(")
		}
	}
}


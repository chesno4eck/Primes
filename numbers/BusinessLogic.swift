//
//  BusinessLogic.swift
//  numbers
//
//  Created by Алиев Д.Ю. on 13/09/2017.
//  Copyright © 2017 TENZOR. All rights reserved.
//

import UIKit

class PrimesGenerator: UIViewController {
	
	static func primes(maxNumber: String?, vc: UIViewController) -> [Int] {
		
		guard let n = ErrorHandler.normalize(maxNumber, vc: vc) else {
			return []
		}
		
		
		var numbers: [Bool] = Array(repeating: true, count: n - 2)
		for i in 2..<n - 2 {
			guard numbers[i] == true else { continue }
			for multiple in stride(from: 2 * i, to: n - 2, by: i) {
				numbers[multiple] = false
			}
		}
		
		numbers[0] = false
		numbers[1] = false
		
		return numbers.enumerated().filter {
			$0.element == true
			}.map{$0.offset}
		
		//old algorithm (not-bool array)
		/**
		var numbers = [Int](2 ..< n)
		for i in 0..<n - 2 {
			let prime = numbers[i]
			guard prime > 0 else { continue }
			for multiple in stride(from: 2 * prime - 2, to: n - 2, by: prime){
				numbers[multiple] = 0
			}
		}
		return numbers.filter{ $0 > 0 }
		*/
	}
	
}

class ArrayFinder: UIViewController {

	static func index(of number: Int, in array: [Int]) -> IndexPath {
		
		func findNeib(for number: Int, in array: [Int]) -> Int {
			if array.count < 2 {
				return array[0]
			}
			let pivot = array[array.count / 2]
			if number < pivot {
				let newArray = Array(array[0 ..< array.count / 2])
				return findNeib(for: number, in: newArray)
			} else {
				let newArray = Array(array[array.count / 2 ..< array.count])
				return findNeib(for: number, in: newArray)
			}
		}
		
		let neib = findNeib(for: number, in: array)
		let index = array.index(of: neib) ?? 0
		
		return IndexPath(item: index, section: 0)
	}

}

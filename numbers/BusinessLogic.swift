//
//  BusinessLogic.swift
//  numbers
//
//  Created by Алиев Д.Ю. on 13/09/2017.
//  Copyright © 2017 TENZOR. All rights reserved.
//

import UIKit

class PrimesGenerator {
	
	static func primes(maxNumber: String) throws -> [Int] {
		
		let n = try ErrorHandler.getNumber(from: maxNumber)
		
		var numbers = [Bool](repeating: true, count: n + 1)
		
		numbers[0] = false
		numbers[1] = false
		
		for i in 0...n {
			guard numbers[i] == true else { continue }
			for multiple in stride(from: 2 * i, to: n + 1, by: i) {
				numbers[multiple] = false
			}
		}
		
		return numbers.enumerated().filter {
			$0.element == true
			}.map{ $0.offset }
	}
	
}

class ArrayFinder {

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

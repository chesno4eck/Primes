//
//  ViewController.swift
//  numbers
//
//  Created by Алиев Д.Ю. on 02/08/2017.
//  Copyright © 2017 TENZOR. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	@IBOutlet private var input: UITextField!
	@IBOutlet fileprivate var activityIndicator: UIActivityIndicatorView!
	@IBOutlet fileprivate var collectionView: UICollectionView!
	@IBOutlet var searchBar: UISearchBar!
	@IBOutlet var startButton: UIButton!
	
	fileprivate var primes: [Int] = []
	
	override func viewDidLoad() {
		super.viewDidLoad()
		title = "Поиск простых чисел"
		searchBar.isHidden = true
		
		let collectionViewTap = UITapGestureRecognizer(target: self, action: #selector(self.hideKeyboard))
		collectionView.addGestureRecognizer(collectionViewTap)
	}
	
	@objc fileprivate func hideKeyboard() {
		view.endEditing(true)
	}
	
	@IBAction fileprivate func calculateAndPrint(_ sender: Any) {
		hideKeyboard()
		activityIndicator.startAnimating()
		startButton.isEnabled = false
		
		defer {
			DispatchQueue.main.async {
				self.activityIndicator.stopAnimating()
				self.startButton.isEnabled = true
			}
		}
		DispatchQueue.global(qos: .userInteractive).async {
			guard self.input.text != nil && !self.input.text!.isEmpty else {
				DispatchQueue.main.async {
					ADAlerts.showOkAlert(on: self, title: "Нет числа", text: "Пожалуйста, введите целое положительное число")
				}
				return
			}
			guard let number = Int(self.input.text!) else {
				DispatchQueue.main.async {
					ADAlerts.showOkAlert(on: self, title: "Так не пойдет", text: "\"\(self.input.text!)\" - это не число")
				}
				return
			}
			guard number > 2 else {
				DispatchQueue.main.async {
					ADAlerts.showOkAlert(on: self, title: "Число слишком маленькое", text: "Пожалуйста, введите число больше чем 2")
				}
				return
			}
			guard number < 20000001 else {
				DispatchQueue.main.async {
					ADAlerts.showOkAlert(on: self, title: "Число слишком большое", text: "Пожалуйста, введите число меньше чем 20.000.000")
				}
				return
			}
			
			self.primes = PrimesGenerator.primes(n: number)
			
			DispatchQueue.main.async {
				self.searchBar.isHidden = false
				self.collectionView.reloadData()
			}
		}
	}

	
}

extension ViewController: UITextFieldDelegate {
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		calculateAndPrint(self)
		return true
	}
}

extension ViewController: UICollectionViewDataSource {
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return primes.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
		cell.label.text = String(primes[indexPath.row])
		return cell
	}
}

extension ViewController: UISearchBarDelegate {
	
	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		
		guard let numbet = Int(searchText) else {
			return
		}
		DispatchQueue.global(qos: .userInteractive).async {
			let indexPath = ArrayFinder.index(of: numbet, in: self.primes)
			DispatchQueue.main.async {
				self.collectionView.scrollToItem(at: indexPath, at: .top, animated: true)
				self.collectionView.cellForItem(at: indexPath)?.backgroundColor = #colorLiteral(red: 1, green: 0.5603725531, blue: 0.4931687404, alpha: 1)
			}
		}
	}
	
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		hideKeyboard()
	}
}



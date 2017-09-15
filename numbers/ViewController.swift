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
	@IBOutlet fileprivate var searchBar: UISearchBar!
	@IBOutlet fileprivate var startButton: UIButton!
	@IBOutlet fileprivate var collectionViewBottomConstraint: NSLayoutConstraint!
	
	fileprivate var primes: [Int] = []
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupUI()
		setupObserversAndRecognizers()
	}
	
	private func setupUI() {
		title = "Поиск простых чисел"
		searchBar.isHidden = true
		input.becomeFirstResponder()

		input.keyboardType = .numberPad
		searchBar.keyboardType = .numberPad
	}
	
	private func setupObserversAndRecognizers() {
		let collectionViewTap = UITapGestureRecognizer(target: self, action: #selector(self.hideKeyboard))
		collectionView.addGestureRecognizer(collectionViewTap)
		
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
	}
	
	
	@IBAction fileprivate func calculateAndPrint(_ sender: Any) {
		startActivity()
		
		DispatchQueue.global(qos: .userInteractive).async {
			guard self.input.text != nil && !self.input.text!.isEmpty else {
				DispatchQueue.main.async {
					ADAlerts.showOkAlert(on: self, title: "Нет числа", text: "Пожалуйста, введите целое положительное число")
				}
				self.endActivity()
				return
			}
			guard let number = Int(self.input.text!) else {
				DispatchQueue.main.async {
					ADAlerts.showOkAlert(on: self, title: "Так не пойдет", text: "\"\(self.input.text!)\" - это не число")
				}
				self.endActivity()
				return
			}
			guard number > 2 else {
				DispatchQueue.main.async {
					ADAlerts.showOkAlert(on: self, title: "Число слишком маленькое", text: "Пожалуйста, введите число больше чем 2")
				}
				self.endActivity()
				return
			}
			guard number < 20000001 else {
				DispatchQueue.main.async {
					ADAlerts.showOkAlert(on: self, title: "Число слишком большое", text: "Пожалуйста, введите число меньше чем 20.000.000")
				}
				self.endActivity()
				return
			}
			
			self.primes = PrimesGenerator.primes(n: number)
			
			DispatchQueue.main.async {
				self.endActivity()
				self.searchBar.isHidden = false
				self.collectionView.reloadData()
			}
		}
	}

	private func startActivity() {
		hideKeyboard()
		activityIndicator.startAnimating()
		startButton.isEnabled = false
	}

	private func endActivity() {
		self.startButton.isEnabled = true
		self.activityIndicator.stopAnimating()
	}
	
	private let bottomConstraintConstant: CGFloat = 8
	
	func keyboardWillShow(notification: NSNotification) {
		if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
			collectionViewBottomConstraint.constant = keyboardSize.height + bottomConstraintConstant
		}
	}
	
	func keyboardWillHide(_ : NSNotification) {
		collectionViewBottomConstraint.constant = bottomConstraintConstant
	}
	
	@objc fileprivate func hideKeyboard() {
		view.endEditing(true)
	}
}


extension ViewController: UICollectionViewDataSource {
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return primes.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
		if primes.count > indexPath.row {
			cell.label.text = String(primes[indexPath.row])
		}
		cell.selectedBackgroundView = UIView(frame: cell.contentView.bounds)
		cell.selectedBackgroundView!.backgroundColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
		
		return cell
	}
}


extension ViewController: UITextFieldDelegate {
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		calculateAndPrint(self)
		return true
	}
}


extension ViewController: UISearchBarDelegate {
	
	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		
		guard let number = Int(searchText) else {
			return
		}
		guard number > 1 else {
			return
		}
		DispatchQueue.global(qos: .userInteractive).async {
			let indexPath = ArrayFinder.index(of: number, in: self.primes)
			DispatchQueue.main.async {
				self.collectionView.allowsMultipleSelection = false
				self.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .top)
				if number != self.primes[indexPath.row] && indexPath.row < self.collectionView.numberOfItems(inSection: 0) - 1 {
					self.collectionView.allowsMultipleSelection = true
					self.collectionView.selectItem(at: IndexPath(row: indexPath.row + 1, section: 0), animated: true, scrollPosition: UICollectionViewScrollPosition.init(rawValue: 0))
				}
			}
		}
	}
	
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		hideKeyboard()
	}
}

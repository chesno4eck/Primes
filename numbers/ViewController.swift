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
	
	
	@IBAction fileprivate func onClickFindButton(_ sender: Any) {
		findPrimes()
	}

	fileprivate func findPrimes() {
		startActivity()
		
		guard let inputText = self.input.text else {
			return
		}
		
		DispatchQueue.global(qos: .userInitiated).async {
			do {
				let primesLocal = try PrimesGenerator.primes(maxNumber: inputText)
				
				DispatchQueue.main.async {
					self.endActivity()
					
					if !primesLocal.isEmpty {
						self.primes = primesLocal
						self.searchBar.isHidden = false
						self.collectionView.reloadData()
					}
				}

			} catch {
				ErrorHandler.show(error, on: self)
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
	
	@objc func keyboardWillShow(notification: NSNotification) {
		if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
			collectionViewBottomConstraint.constant = keyboardSize.height + bottomConstraintConstant
		}
	}
	
	@objc func keyboardWillHide(_ : NSNotification) {
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
		
		cell.setup(text: String(primes[indexPath.row]))
		
		return cell
	}
}


extension ViewController: UITextFieldDelegate {
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		findPrimes()
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

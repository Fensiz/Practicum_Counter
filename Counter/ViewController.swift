//
//  ViewController.swift
//  Counter
//
//  Created by Симонов Иван Дмитриевич on 03.11.2024.
//

import UIKit

class ViewController: UIViewController {
	// MARK: - Outlets
	@IBOutlet private weak var redButton: UIButton!
	@IBOutlet private weak var blueButton: UIButton!
	@IBOutlet private weak var counterLabel: UILabel!
	@IBOutlet private weak var textLog: UITextView!
	@IBOutlet private weak var containerView: UIView!
	
	// MARK: - Properties
	private var counterValue = 0 {
		didSet {
			counterLabel.text = String(counterValue)
		}
	}
	
	// MARK: - Lifecycle Methods
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setCornerRadius()
		setTextViewTransparency()
	}
	
	// MARK: - Setup Methods
	private func setCornerRadius() {
		// Рассчитываем радиус кнопок относительно текущей ширины экрана
		let buttonRadius = (view.frame.width -
							view.safeAreaInsets.left -
							view.safeAreaInsets.right - 140) / 6
		redButton.layer.cornerRadius = buttonRadius
		blueButton.layer.cornerRadius = buttonRadius
	}
	
	private func setTextViewTransparency() {
		// Добавляем градиент для прозрачности верхней части textView
		let gradientLayer = CAGradientLayer()
		gradientLayer.frame = containerView.bounds
		gradientLayer.colors = [
			UIColor.clear.cgColor,
			UIColor.white.withAlphaComponent(1.0).cgColor
		]
		gradientLayer.locations = [0, 0.25] // 25% прозрачности
		containerView.layer.mask = gradientLayer
	}
	
	// MARK: - Action Methods
	@IBAction func redButAction(_ sender: Any) {
		updateCounter(by: 1)
	}
	
	@IBAction func blueButAction(_ sender: Any) {
		guard counterValue > 0 else {
			// перенос строки добавлен, чтобы избежать глюков скрола
			// при автопереносе длинной строки
			// [нужна подсказка, как решить эту пробему правильно]
			textLogAppendText("Попытка уменьшить\nзначение счётчика\nниже 0")
			return
		}
		updateCounter(by: -1)
	}
	
	@IBAction func resetButAction(_ sender: Any) {
		resetCounter()
	}
	
	// MARK: - Helper Methods
	private func updateCounter(by value: Int) {
		// обновляем счетчик
		setCounter(
			value: counterValue + value,
			withMsg: "Значение изменено на \(value)"
		)
	}
	
	private func resetCounter() {
		// сбрасываем счетчик
		setCounter(
			value: 0,
			withMsg: "Значение сброшено"
		)
	}
	
	private func setCounter(value: Int, withMsg message: String) {
		// Логируем изменение и задаем значение счетчика
		textLogAppendText(message)
		counterValue = value
	}
	
	private func textLogAppendText(_ text: String) {
		// Добавляем текст и прокручиваем вниз
		textLog.text.append("[\(timestamp)]\n\(text)\n")
		let range = NSRange(location: textLog.text.count - 1, length: 1)
		textLog.scrollRangeToVisible(range)
	}
	
	private var timestamp: String {
		let dateFormatter = DateFormatter()
		// Формат даты и времени
		dateFormatter.dateFormat = "dd MM yyyy HH:mm:ss"
		// Возвращаем текущую дату и время в строковом формате
		return dateFormatter.string(from: Date())
	}
}

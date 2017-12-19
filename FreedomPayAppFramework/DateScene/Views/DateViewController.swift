//
//  DateViewController.swift
//  FreedomPayAppFramework
//
//  Created by Michael on 12/18/17.
//  Copyright © 2017 Michael. All rights reserved.
//

import Foundation
import UIKit

protocol DateView: class {
    func updateView(viewModel: DateViewModel)
}

class DateViewController: UIViewController, DateView, UITextFieldDelegate {
    
    lazy var doneButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(submitForm))
    
    let interactor: DateViewControllerInteractor
    
    let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        return stackView
    }()
    
    let labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 3.0
        return stackView
    }()
    
    let spacerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    lazy var textField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "Required"
        tf.backgroundColor = .white
        tf.delegate = self
        tf.inputView = UIView()
        tf.addTarget(self, action: #selector(self.editingDidBegin(_:)), for: UIControlEvents.editingDidBegin)
        return tf
    }()
    
    let expirationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Expiry Date"
        label.font = UIFont.systemFont(ofSize: 10)
        return label
    }()
    
    lazy var datePicker: DatePickerView = {
        let picker = DatePickerView(frame: .zero)
        picker.datePicker.delegate = self.interactor
        picker.datePicker.dataSource = self.interactor.dataSource
        picker.isHidden = true
        picker.doneButton.action = #selector(trySubmitDate)
        return picker
    }()
    
    init(interactor: DateViewControllerInteractor) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(trySubmitDate)))
        view.backgroundColor = .white
        edgesForExtendedLayout = []
        setupSubviews()
        navigationItem.rightBarButtonItem = doneButton
        navigationItem.title = "Card Date"
    }
    
    @objc
    func trySubmitDate() {
        let result = interactor.isValid()
        switch result {
        case .success(let date):
            UIView.animate(withDuration: 0.75) { [weak self] in
                self?.textField.endEditing(false)
            }
        case .error(let message):
            let alert = UIAlertController(title: "Validation Error", message: message, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Done", style: .cancel, handler: nil))
            present(alert, animated: false, completion: nil)
        }
    }
    
    func setupSubviews() {
        view.addSubview(mainStackView, snapConstraints: true)
        mainStackView.addArrangedSubview(spacerView)
        mainStackView.addArrangedSubview(labelStackView)
        mainStackView.addArrangedSubview(UIView())
        mainStackView.addArrangedSubview(datePicker)
        mainStackView.arrangedSubviews.enumerated().forEach { (indexViewTuple) in
            let index = indexViewTuple.offset
            let view = indexViewTuple.element
            view.setContentHuggingPriority(UILayoutPriority(rawValue: Float(1000-index)), for: .vertical)
        }
        labelStackView.addArrangedSubview(textField)
        labelStackView.addArrangedSubview(expirationLabel)
        spacerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.33).isActive = true
    }
    
    @objc func editingDidBegin(_ sender: UITextField) {
        UIView.animate(withDuration: 0.75) { [weak self] in
            self?.datePicker.isHidden = false
        }
    }
    
    @objc func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        datePicker.isHidden = true
    }
    
    @objc func submitForm() {
        guard case .success(_) = interactor.isValid() else {
            return
        }
        let alert = UIAlertController(title: "Success", message: "Thank you, the data has been saved.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Done", style: .cancel, handler: nil))
        present(alert, animated: false, completion: nil)
    }
    
    func updateView(viewModel: DateViewModel) {
        textField.text = viewModel.labelText
    }
}

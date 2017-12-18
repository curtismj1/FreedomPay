//: A UIKit based Playground for presenting user interface

import UIKit

//@testable import FreedomPayAppFramework

class DateViewController: UIViewController, UITextFieldDelegate {
    
    let doneButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: nil)
    
    let dateDataSource = DatePickerDataSource()
    
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
    
    lazy var datePicker: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.isHidden = true
        pickerView.dataSource = self.dateDataSource
        pickerView.delegate = self.dateDataSource
        return pickerView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(resign)))
        view.backgroundColor = .white
        edgesForExtendedLayout = []
        setupSubviews()
        navigationItem.rightBarButtonItem = doneButton
    }
    
    @objc
    func resign() {
        textField.endEditing(false)
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
}

class DatePickerDataSource: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {
    
    let monthData = ["1 - JAN",
                     "2- FEB",
                     "3 - MAR",
                     "4 - APR",
                     "5- MAY",
                     "6 - JUN",
                     "7 - JUL",
                     "8- AUG",
                     "9 - SEP",
                     "10 - OV",
                     "11- NOV",
                     "12 - DEC"]
    

    let currentYear: Int = {
        let date = Date()
        let calendar = Calendar.current
        return calendar.component(.year, from: date)
    }()
    
    lazy var yearData = Array(currentYear...currentYear + 20)
    
    //MARK - PickerDataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return monthData.count
        case 1:
            return yearData.count
        default:
            return 0
        }
    }
    //MARK - PickerViewDelegate
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
    }
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel()
        switch component {
        case 0:
            label.text = monthData[row]
        case 1:
            label.text = String(yearData[row])
        default:
            break
        }
        return label
    }
}

extension UIView {
    func addSubview(_ view: UIView, snapConstraints: Bool) {
        addSubview(view)
        if snapConstraints {
            view.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
            view.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
            view.topAnchor.constraint(equalTo: topAnchor).isActive = true
            view.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        }
    }
}

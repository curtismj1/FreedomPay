//
//  DatePickerView.swift
//  FreedomPayAppFramework
//
//  Created by Michael on 12/18/17.
//  Copyright © 2017 Michael. All rights reserved.
//

import Foundation

class DatePickerView: UIView {
    let mainStackView: UIStackView = {
        let msv = UIStackView()
        msv.axis = .vertical
        msv.translatesAutoresizingMaskIntoConstraints = false
        return msv
    }()
    
    let toolbar: UIToolbar = {
        let tb = UIToolbar()
        tb.translatesAutoresizingMaskIntoConstraints = false
        return tb
    }()
    
    let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: nil)
    
    lazy var datePicker: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        return pickerView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        addSubview(mainStackView, snapConstraints: true)
        mainStackView.addArrangedSubview(toolbar)
        mainStackView.addArrangedSubview(datePicker)
        toolbar.items = [UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil), doneButton]
        mainStackView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        toolbar.isTranslucent = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

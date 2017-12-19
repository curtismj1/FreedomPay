//
//  DatePresenter.swift
//  FreedomPayAppFramework
//
//  Created by Michael on 12/18/17.
//  Copyright © 2017 Michael. All rights reserved.
//

import Foundation

protocol DateViewPresenter: class {
    func updateView(forDate date: DateStruct?)
    
}

class DateViewPresentationLogic: DateViewPresenter {
    weak var view: DateView?
    
    init(view: DateView? = nil) {
        self.view = view
    }
    
    func updateView(forDate date: DateStruct?) {
        guard let _date = date else {
            view?.updateView(viewModel: DateViewModel(labelText: nil))
            return
        }
        let labelText = "\(_date.month)/\(_date.year)"
        view?.updateView(viewModel: DateViewModel(labelText: labelText))
    }
}

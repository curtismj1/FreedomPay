//
//  PickerDataSource.swift
//  FreedomPayAppFramework
//
//  Created by Michael on 12/18/17.
//  Copyright © 2017 Michael. All rights reserved.
//

import Foundation

class PickerDataSource: NSObject, UIPickerViewDataSource {
    let sections: Sections
    
    init(sections: Sections) {
        self.sections = sections
    }
    
    //MARK - PickerDataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return sections.activeSections.count
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return sections.activeSections[component].count
    }
}

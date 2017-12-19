//
//  Sections.swift
//  FreedomPayAppFramework
//
//  Created by Michael on 12/18/17.
//  Copyright © 2017 Michael. All rights reserved.
//

import Foundation
import UIKit

class Sections {
    private var sections: [[CellInfo]] = [[]]
    private var filteredSections: [[CellInfo]]?
    private var currentFilter: ((CellInfo) -> Bool)?
    
    var activeSections: [[CellInfo]] {
        get {
            return filteredSections ?? sections
        }
        set {
            sections = newValue
            if let filter = currentFilter {
                filteredSections = sections.map {
                    $0.filter(filter)
                }
            }
        }
    }
    
    func getInfo(section: Int, row: Int) -> CellInfo? {
        guard activeSections.count >= 0 && section < activeSections.count,
            row >= 0 && row < activeSections[section].count else {
                return nil
        }
        return sections[section][row]
    }
    
    func setFilter(_ filter: @escaping (CellInfo) -> Bool) {
        filteredSections = sections.map {
            $0.filter(filter)
        }
        currentFilter = filter
    }
    
    func removeFilter() {
        filteredSections = nil
        currentFilter = nil
    }
}

protocol CellInfo {
    func getView() -> UIView
}

class DatePickerCell: CellInfo {
    let displayValue: String
    let rawValue: Int
    func getView() -> UIView {
        let label = UILabel()
        label.text = displayValue
        return label
    }
    init(displayValue: String, rawValue: Int) {
        self.displayValue = displayValue
        self.rawValue = rawValue
    }
}

struct BlankCell: CellInfo {
    func getView() -> UIView { return UIView() }
}

class YearPickerCell: DatePickerCell {}
class MonthPickerCell: DatePickerCell {}

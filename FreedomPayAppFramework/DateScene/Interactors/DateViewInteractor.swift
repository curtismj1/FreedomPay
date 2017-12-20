//
//  DateViewInteractor.swift
//  FreedomPayAppFramework
//
//  Created by Michael on 12/18/17.
//  Copyright © 2017 Michael. All rights reserved.
//

import Foundation

protocol DateViewControllerInteractor: UIPickerViewDelegate {
    var dataSource: PickerDataSource { get set }
    func isValid() -> Result<DateStruct, String>
}

class DateViewControllerLogic: NSObject, DateViewControllerInteractor, UIPickerViewDelegate {
    
    let currentYear = CalendarData.currentYear
    let currentMonth = CalendarData.currentMonth
    var presenter: DateViewPresenter?
    var dataSource: PickerDataSource = PickerDataSource(sections: Sections())
    
    override init() {
        super.init()
        dataSource = setupDataSource()
    }
    
    var currentDate: DateStruct?
    
    private func setupDataSource() -> PickerDataSource {
        let yearData: [CellInfo] = [BlankCell()] + Array(currentYear...currentYear+20).map { year in
            return YearPickerCell(displayValue: String(year), rawValue: year)
        }
        let monthData: [CellInfo] = [BlankCell()] + DateInteractorConfig.monthData
            .enumerated()
            .map { (tuple: (index: Int, displayData: String)) -> MonthPickerCell in
                return MonthPickerCell(displayValue: tuple.displayData, rawValue: tuple.index + 1)
        }
        let sections = Sections()
        sections.activeSections.append(monthData)
        sections.activeSections.append(yearData)
        return PickerDataSource(sections: sections)
    }
    
    func getDate(pickerView: UIPickerView) -> DateStruct? {
        var selectedMonth: Int?
        var selectedYear: Int?
        (0..<pickerView.numberOfComponents).forEach { section in
            let selectedRow = pickerView.selectedRow(inComponent: section)
            guard let cellInfo = dataSource.sections.getInfo(section: section, row: selectedRow) else {
                return
            }
            if let yearInfo = cellInfo as? YearPickerCell {
                selectedYear = yearInfo.rawValue
            } else if let monthInfo = cellInfo as? MonthPickerCell {
                selectedMonth = monthInfo.rawValue
            }
        }
        guard let _selectedMonth = selectedMonth,
            let _selectedYear = selectedYear else {
                return nil
        }
        return DateStruct(month: _selectedMonth, year: _selectedYear)
    }
    
    func isValid() -> Result<DateStruct, String> {
        guard let date = currentDate else {
            return .error(error: DateInteractorConfig.Strings.noDateSelected)
        }
        if date.year > CalendarData.currentYear
            || (date.year == CalendarData.currentYear && date.month >= CalendarData.currentMonth) {
            return .success(result: date)
        } else {
            return .error(error: DateInteractorConfig.Strings.dateCannotBeInPast)
        }
    }
    
    //MARK - PickerViewDelegate
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        currentDate = getDate(pickerView: pickerView)
        presenter?.updateView(forDate: currentDate)
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        return dataSource.sections.getInfo(section: component, row: row)?.getView() ?? UIView()
    }
}

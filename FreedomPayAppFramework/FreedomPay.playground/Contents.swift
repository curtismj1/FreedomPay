//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport
//@testable import FreedomPayAppFramework

class CalendarData {
    
    static var currentYear: Int = {
        let date = Date()
        let calendar = Calendar.current
        return calendar.component(.year, from: date)
    }()
    
    static let currentMonth: Int = {
        let date = Date()
        let calendar = Calendar.current
        return calendar.component(.month, from: date)
    }()
}

struct DateStruct {
    let month: Int
    let year: Int
}

struct DateViewModel {
    let labelText: String?
}

protocol DateViewControllerInteractor: UIPickerViewDelegate {
    var dataSource: PickerDataSource { get set }
    func isValid(pickerView: UIPickerView) -> Bool
}

protocol DateView: class {
    func updateView(viewModel: DateViewModel)
}

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

class DateViewController: UIViewController, DateView, UITextFieldDelegate {
    
    let doneButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: nil)
    
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
        picker.doneButton.action = #selector(resign)
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
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(resign)))
        view.backgroundColor = .white
        edgesForExtendedLayout = []
        setupSubviews()
        navigationItem.rightBarButtonItem = doneButton
        navigationItem.title = "Card Date"
    }
    
    @objc
    func resign() {
        UIView.animate(withDuration: 0.75) { [weak self] in
            self?.textField.endEditing(false)
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
    
    func updateView(viewModel: DateViewModel) {
        textField.text = viewModel.labelText
    }
}

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
class YearPickerCell: DatePickerCell {}
class MonthPickerCell: DatePickerCell {}

struct BlankCell: CellInfo {
    func getView() -> UIView { return UIView() }
}

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

class DateViewControllerLogic: NSObject, DateViewControllerInteractor, UIPickerViewDelegate {
    
    let currentYear = CalendarData.currentYear
    let currentMonth = CalendarData.currentMonth
    weak var presenter: DateViewPresenter?
    var dataSource: PickerDataSource = PickerDataSource(sections: Sections())

    override init() {
        super.init()
        dataSource = setupDataSource()
    }
    
    private func setupDataSource() -> PickerDataSource {
        let yearData: [CellInfo] = [BlankCell()] + Array(currentYear...currentYear+20).map { year in
            return YearPickerCell(displayValue: String(year), rawValue: year)
        }
        let monthData: [CellInfo] = [BlankCell()] + ["1 - JAN", "2- FEB", "3 - MAR", "4 - APR",
                         "5- MAY", "6 - JUN", "7 - JUL", "8- AUG",
                         "9 - SEP", "10 - OV", "11- NOV", "12 - DEC"]
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
    
    func isValid(pickerView: UIPickerView) -> Bool {
        guard let date = getDate(pickerView: pickerView) else {
            return false
        }
        if date.year != CalendarData.currentYear {
            return date.year > CalendarData.currentYear
        } else {
            return date.month >= CalendarData.currentMonth
        }
    }
    
    //MARK - PickerViewDelegate
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard let date = getDate(pickerView: pickerView) else {
            return
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        return dataSource.sections.getInfo(section: component, row: row)?.getView() ?? UIView()
    }
}

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

let interactor = DateViewControllerLogic()
let rvc = DateViewController(interactor: interactor)
let presenter = DateViewPresentationLogic(view: rvc)
interactor.presenter = presenter

let navVC = UINavigationController(rootViewController: rvc)

PlaygroundPage.current.liveView = navVC





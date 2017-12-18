import Foundation

enum Month: Int {
    case January = 1
    case February = 2
    case March = 3
    case April = 4
    case May = 5
    case June = 6
    case July = 7
    case August = 8
    case September = 9
    case October = 10
    case November = 11
    case December = 12
}

class CalendarData {
    
    static var currentYear: Int {
        let date = Date()
        let calendar = Calendar.current
        return calendar.component(.year, from: date)
    }
    
    static var currentMonth: Month {
        let date = Date()
        let calendar = Calendar.current
        return Month(rawValue: calendar.component(.month, from: date))!
    }
}
let cm = CalendarData.currentMonth



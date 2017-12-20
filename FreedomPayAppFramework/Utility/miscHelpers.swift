//
//  miscHelpers.swift
//  FreedomPayAppFramework
//
//  Created by Michael on 12/18/17.
//  Copyright © 2017 Michael. All rights reserved.
//

import Foundation
import UIKit

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

public enum Result<SuccessType, ErrorType> {
    case success(result: SuccessType)
    case error(error: ErrorType)
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

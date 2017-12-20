//
//  DateViewConfig.swift
//  FreedomPayAppFramework
//
//  Created by Michael on 12/20/17.
//  Copyright © 2017 Michael. All rights reserved.
//

import Foundation

struct DateViewConfig {
    struct Strings {
        struct SaveComplete {
            static let title = "Success"
            static let message = "Thank you, the data has been saved."
        }
        struct SubmitFormFailure {
            static let title = "Validation Error"
        }
        static let textFieldPlaceholder = "Required"
        static let expiryLabelDefault = "Expiry Date"
        static let navigationTitle = "Card Date"
    }
    struct Spacing {
        static let stackViewSpacing = 3.0
    }
    struct Animation {
        static let duration = 0.75
    }
}

struct DateInteractorConfig {
    static let monthData = ["1 - JAN", "2- FEB", "3 - MAR", "4 - APR",
                            "5- MAY", "6 - JUN", "7 - JUL", "8- AUG",
                            "9 - SEP", "10 - OCT", "11- NOV", "12 - DEC"]
    struct Strings {
        static let noDateSelected = "Current Date not selected."
        static let dateCannotBeInPast = "The selected date cannot be in the past."
    }
}

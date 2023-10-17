//
//  DateExtention.swift
//  Outline
//
//  Created by hyebin on 10/16/23.
//

import SwiftUI

extension Date {
    func dateToBirthDay() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd."
        return dateFormatter.string(from: self)
    }
}

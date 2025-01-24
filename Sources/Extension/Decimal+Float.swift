//
//  Decimal+Float.swift
//  Pitstop
//
//  Created by Ivan Voloshchuk on 24/01/25.
//

import Foundation

extension Decimal {
    var floatValue: Float {
        return NSDecimalNumber(decimal: self).floatValue
    }
}


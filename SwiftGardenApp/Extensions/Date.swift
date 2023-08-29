//
//  Date.swift
//  SwiftGardenApp
//
//  Created by Yugo Sugiyama on 2023/08/11.
//

import Foundation

extension Date {
    func offsetDays(offset: Int) -> Date? {
        return Calendar.current.date(byAdding: .day, value: offset, to: self)
    }
    
    var yesterday: Date? {
        return offsetDays(offset: -1)
    }
    
    var tomorrow: Date? {
        return offsetDays(offset: 1)
    }
    
    var isToday: Bool {
        return Calendar.current.isDateInToday(self)
    }
    
    var hour: Int {
        return Calendar.current.component(.hour, from: self)
    }
    
    var minute: Int {
        return Calendar.current.component(.minute, from: self)
    }
}

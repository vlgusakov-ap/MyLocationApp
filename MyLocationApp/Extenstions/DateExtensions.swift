//
//  DateExtensions.swift
//  MyLocationApp
//
//  Created by Vladyslav Gusakov on 11/21/17.
//  Copyright © 2017 Vladyslav Gusakov. All rights reserved.
//

import Foundation

extension Date {
    var iso8601String: String {
        // https://github.com/justinmakaila/NSDate-ISO-8601/blob/master/NSDateISO8601.swift
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        
        return dateFormatter.string(from: self).appending("Z")
    }
    
    var elapsedTime: String{
        let now = Date()
        
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full
        formatter.zeroFormattingBehavior = .dropAll
        formatter.maximumUnitCount = 1 //increase it if you want more precision
        formatter.allowedUnits = [.year, .month, .weekOfMonth, .day, .hour, .minute]
        formatter.includesApproximationPhrase = false //to write "About" at the beginning
        
        let formatString = NSLocalizedString("%@ ago", comment: "Used to say how much time has passed. e.g. '2 hours ago'")
        let timeString = formatter.string(from: self, to: now) ?? ""
        return String(format: formatString, timeString)
    }
}

//
//  Logger.swift
//  MyLocationApp
//
//  Created by Vladyslav Gusakov on 11/4/17.
//  Copyright © 2017 Vladyslav Gusakov. All rights reserved.
//

import Foundation

class Logger
{
    @objc enum LogType: Int
    {
        case none
        case warning
        case error
        case networking
        case checkmark
    }
    
    //Add log types you would like to ignore
    private static let ignoredLogTypes: [LogType] = []
    
    private static let logsEnabled = true
    
    static func log(_ value: Any)
    {
        Logger.log(value, type: .none)
    }
    
    static func log(_ values: Any..., type: LogType, separator: String = " ", debugDescription: String = #function)
    {
        guard Logger.logsEnabled else { return }
        
        guard !Logger.ignoredLogTypes.contains(type) else {
            return
        }
        
        let prefixIcon: String
        
        switch type
        {
        case .none:
            prefixIcon = "➤"
        case .warning:
            prefixIcon = "⚠️"
        case .error:
            prefixIcon = "🔴"
        case .networking:
            prefixIcon = "🚀"
        case .checkmark:
            prefixIcon = "✅"
        }
        print(prefixIcon, values, separator: " ")
        
        switch type
        {
        case .warning, .error:
            print("Function:", debugDescription)
        default:
            break
        }
    }
}

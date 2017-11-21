//
//  NSError+Helpers.swift
//  MyLocationApp
//
//  Created by Vladyslav Gusakov on 11/4/17.
//  Copyright © 2017 Vladyslav Gusakov. All rights reserved.
//

import Foundation

extension NSError
{
    // Defined Errors
    static let unknownError = NSError.with(message: Constants.defaultErrorMessage)
    
    struct Constants
    {
        static let defaultDomain = "MyLocationApp.Error"
        static let defaultErrorCode = NSURLErrorUnknown
        static let defaultErrorMessage = "Unknown error occured"
        static let defaultFailureName = "GENERIC_ERROR"
    }
    
    var isDisplayable: Bool
    {
        //List of error descriptions can be found here http://nshipster.com/nserror/
        if self.domain == NSURLErrorDomain
        {
            return true
        }
        
        return self.domain == Constants.defaultDomain
    }
    
    var isAuthError: Bool {
        return self.code == 401
    }
    
    static func with(message: String?) -> NSError
    {
        return NSError.with(message: message, code: Constants.defaultErrorCode, failureName: Constants.defaultFailureName)
    }
    
    static func with(message: String?, code: Int?, failureName: String? = nil) -> NSError
    {
        let errorDomain = Constants.defaultDomain
        let errorCode = code ?? Constants.defaultErrorCode
        let errorMessage = message ?? Constants.defaultErrorMessage
        let failureName = failureName ?? Constants.defaultFailureName
        
        let error = NSError(domain: errorDomain, code: errorCode, userInfo: [NSLocalizedDescriptionKey: errorMessage,
                                                                             NSLocalizedFailureReasonErrorKey: failureName])
        Logger.log("Error: " + errorMessage + " " + failureName, type: .error)
        return error
    }
    
    static func from(dictionary: [String: Any]?) -> NSError?
    {
        guard let dictionary = dictionary,
            let status = dictionary["status"] as? String,
            status == "error"
            else
        {
            return nil
        }
        
        let errorFailureName = dictionary["name"] as? String
        let errorCode = dictionary["code"] as? Int
        let errorMessage = dictionary["message"] as? String
        
        return NSError.with(message: errorMessage, code: errorCode, failureName: errorFailureName)
    }
    
}


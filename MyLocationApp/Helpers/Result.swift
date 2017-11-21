//
//  Result.swift
//  MyLocationApp
//
//  Created by Vladyslav Gusakov on 11/4/17.
//  Copyright © 2017 Vladyslav Gusakov. All rights reserved.
//

import Foundation

/// Either a Value value or an ErrorType
public enum Result<Value> {
    /// Success wraps a Value value
    case success(Value)
    
    /// Failure wraps an ErrorType
    case failure(Error)
    
    /// Construct a result from a `throws` function
    public init(_ capturing: () throws -> Value) {
        do {
            self = .success(try capturing())
        } catch {
            self = .failure(error)
        }
    }
    
    /// Convenience tester/getter for the value
    public var value: Value? {
        switch self {
        case .success(let v): return v
        case .failure: return nil
        }
    }
    
    /// Convenience tester/getter for the error
    public var error: Error? {
        switch self {
        case .success: return nil
        case .failure(let e): return e
        }
    }
    
    /// Test whether the result is an error.
    public var isError: Bool {
        switch self {
        case .success: return false
        case .failure: return true
        }
    }
    
    /// Adapter method used to convert a Result to a value while throwing on error.
    public func unwrap() throws -> Value {
        switch self {
        case .success(let v): return v
        case .failure(let e): throw e
        }
    }
    
    /// Chains another Result to this one. In the event that this Result is a .Success, the provided transformer closure is used to generate another Result (wrapping a potentially new type). In the event that this Result is a .Failure, the next Result will have the same error as this one.
    public func flatMap<U>(_ transform: (Value) -> Result<U>) -> Result<U> {
        switch self {
        case .success(let val): return transform(val)
        case .failure(let e): return .failure(e)
        }
    }
    
    /// Chains another Result to this one. In the event that this Result is a .Success, the provided transformer closure is used to transform the value into another value (of a potentially new type) and a new Result is made from that value. In the event that this Result is a .Failure, the next Result will have the same error as this one.
    public func map<U>(_ transform: (Value) throws -> U) -> Result<U> {
        switch self {
        case .success(let val): return Result<U> { try transform(val) }
        case .failure(let e): return .failure(e)
        }
    }
}

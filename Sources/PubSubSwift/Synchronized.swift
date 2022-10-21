//
//  Synchronized.swift
//  Pub-Sub Test
//
//  Created by Maulik Desai on 21/10/22.
//

import Foundation

@propertyWrapper class Synchronized<T> {
    
    private let semaphore: DispatchSemaphore
    private var value: T
    
    init(wrappedValue: T) {
        self.semaphore = DispatchSemaphore(value: 1)
        self.value = wrappedValue
    }
    
    var wrappedValue: T {
        get {
            semaphore.wait()
            defer { semaphore.signal() }
            return value
        }
        
        set {
            semaphore.wait()
            value = newValue
            semaphore.signal()
        }
    }

    //To create syncronized flow
    public func synchronized(_ block: ((inout T) -> Void)) {
        semaphore.wait()
        block(&value)
        semaphore.signal()
    }
}

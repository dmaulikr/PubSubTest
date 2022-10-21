//
//  Observation.swift
//  Pub-Sub Test
//
//  Created by Maulik Desai on 21/10/22.
//

import Foundation

struct Subscription<T>: EventSubcription {

    weak var observer: AnyObject?
    weak var receipt: Receipt?

    let block: ((T) -> Void)
    var type: T.Type

    // Whether this subscripion was added with an observer. If that's the case, we will become invalid if it deallocates.
    private var isObserverBased: Bool
    
    var isValid: Bool {
        if isObserverBased {
            return observer != nil
        }
        return receipt != nil
    }

    static func create(observer: AnyObject?, block: @escaping ((T) -> Void)) -> (Subscription, Receipt) {
        let receipt = Receipt()
        let subscription = Subscription(observer: observer, receipt: receipt, block: block)
        return (subscription, receipt)
    }

    init(observer: AnyObject?, receipt: Receipt, block: @escaping ((T) -> Void)) {
        self.observer = observer
        self.block = block
        self.receipt = receipt
        self.type = T.self
        self.isObserverBased = observer != nil
    }

    func isEqual(to: EventSubcription) -> Bool {
        guard let to = to as? Subscription<T> else {
            return false
        }
        if to.observer === self.observer, to.type == self.type {
            return true
        }
        return false
    }

    func handle(event: Any) {
        guard let event = event as? T else {
            return
        }
        
        let block = self.block
        block(event)
    }

    func canHandle<U>(event: U.Type) -> Bool where U : EventType {
        return T.self == U.self
    }
}

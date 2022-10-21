//
//  EventSubcription.swift
//  Pub-Sub Test
//
//  Created by Maulik Desai on 21/10/22.
//

import Foundation

protocol EventSubcription {
    var observer: AnyObject? { get }
    var receipt: Receipt? { get } //To send forced notofication
    var isValid: Bool { get } //To validite event/observer

    func isEqual(to: EventSubcription) -> Bool
    func handle(event: Any)

}

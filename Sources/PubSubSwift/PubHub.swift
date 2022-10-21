import Foundation

public protocol EventType: Equatable {}

public class Receipt: Equatable {
    let id: UUID = .init()

    public static func == (lhs: Receipt, rhs: Receipt) -> Bool {
        return lhs.id == rhs.id
    }
}

/// PubSub implementation.
public class PubSubTest {

    public static let shared: PubSubTest = .init()

    @Synchronized private var observations = [EventSubcription]()

    public init() {}

    // Subscribe to events. This subscription will remain active until the observer deallocates or until
    
    public func subscribe<T: EventType>(
        _ observer: AnyObject,
        block: @escaping (T) -> ()) -> Receipt {
        
        let (observation, receipt) = Subscription.create(observer: observer, block: block)
        _observations.synchronized {
            $0 = $0.filter { !$0.isEqual(to: observation) && $0.isValid }
            $0.append(observation)
        }
        return receipt
    }

    // To check Whether we have an active subscription for a given observer.
    public func isSubscribed(_ observer: AnyObject) -> Bool {
        return observations.contains(where: { $0.observer?.isEqual(observer) == true })
    }

    // Remove an observer.
    public func unsubscribe(_ observer: AnyObject) {
        observations = observations.filter { $0.observer !== observer && $0.isValid }
    }

    // Post an event.
    public func publish<T: EventType>(_ event: T) {
        observations.forEach {
            guard $0.isValid else {
                return
            }
            $0.handle(event: event)
        }
    }
    
    // Remove observation with deallocatation
    private func gc() {
        observations = observations.filter { $0.isValid } // Remove nil observers
    }
}

import SwiftUI
import Combine

extension Subject {
    public func asyncSend(_ input: Output) {
        System.async {
            self.send(input)
        }
    }
    
    public func asyncSend(completion: Subscribers.Completion<Failure>) {
        System.async {
            self.send(completion: completion)
        }
    }
    
    public func asyncSend(subscription: Subscription) {
        System.async {
            self.send(subscription: subscription)
        }
    }
}

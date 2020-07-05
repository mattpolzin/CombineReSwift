//
//  Store+CombineSubscriber.swift
//  
//
//  Created by Mathew Polzin on 6/29/20.
//

import Combine
import ReSwift
import Foundation

extension ReSwift.Store: Combine.Subscriber {
    public typealias Input = ReSwift.Action
    public typealias Failure = Error

    public func receive(subscription: Combine.Subscription) {
        subscription.request(.unlimited)
    }

    public func receive(_ input: Action) -> Subscribers.Demand {
        DispatchQueue.main.async {
            self.dispatch(input)
        }
        return .unlimited
    }

    public func receive(completion: Subscribers.Completion<Error>) {}
}

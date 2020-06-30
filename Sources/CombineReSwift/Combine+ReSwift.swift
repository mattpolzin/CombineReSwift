//
//  Combine+ReSwift.swift
//  APITest
//
//  Created by Mathew Polzin on 6/29/20.
//  Copyright © 2020 Mathew Polzin. All rights reserved.
//

import Foundation
import Combine
import ReSwift

extension Publisher {
    public func dispatch(_ actionHandlers: ((Output) -> ReSwift.Action)...) -> Publishers.FlatMap<Publishers.Sequence<[ReSwift.Action], Failure>, Self> {
        self.flatMap { output in
            Publishers.Sequence(sequence: actionHandlers.map { action in action(output) })
        }
    }
}

extension Publisher where Output == ReSwift.Action {
    /// Dispatch actions in place of errors. Any non-nil
    /// result of any action handlers will be dispatched.
    /// If all handlers return nil, the error will be propogated
    /// as unhandled.
    public func dispatchError(_ actionHandlers: ((Failure) -> ReSwift.Action?)...) -> Publishers.Catch<Self, Publishers.Concatenate<Self, Publishers.Sequence<[ReSwift.Action], Failure>>> {
        self.catch { error in
            let actions = actionHandlers.compactMap { $0(error) }
            guard actions.count > 0 else {
                return self.append([])
            }
            return self.append(Publishers.Sequence(sequence: actions))
        }
    }
}

extension Publishers.Sequence where Elements == [ReSwift.Action] {
    /// Dispatch actions in place of errors. Any non-nil
    /// result of any action handlers will be dispatched.
    /// If all handlers return nil, the error will be propogated
    /// as unhandled.
    public func dispatchError(_ actionHandlers: ((Failure) -> ReSwift.Action?)...) -> Publishers.Catch<Self, Publishers.Sequence<[ReSwift.Action], Failure>> {
        self.catch { error in
            let actions = actionHandlers.compactMap { $0(error) }
            guard actions.count > 0 else {
                return self
            }
            return Publishers.Sequence(sequence: actions)
        }
    }
}

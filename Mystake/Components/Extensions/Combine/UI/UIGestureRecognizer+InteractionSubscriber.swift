//
//  UIGestureRecognizer+InteractionSubscriber.swift
//  Mystake
//
//  Created by Vladko on 16.01.2024.
//

import UIKit
import Combine

extension UIGestureRecognizer {
    
    class InteractionSubscription<S: Subscriber>: Subscription where S.Input == Void, S.Failure == Never {
        
        /// Recognizer
        private let sender: UIGestureRecognizer
        
        /// Subscriber
        private let subscriber: S
        
        
        /// Initialization
        init(sender: UIGestureRecognizer, subscriber: S) {
            self.sender = sender
            self.subscriber = subscriber
            sender.addTarget(self, action: #selector(onAction))
        }
        
        /// Action
        @objc
        private func onAction() {
            let _ = subscriber.receive()
        }
        
        /// Request demand
        func request(_ demand: Subscribers.Demand) {}
        
        /// Cancel
        func cancel() {}
        
    }
    
    struct InteractionPublisher: Publisher {
        
        typealias Output = Void
        typealias Failure = Never
        
        /// Recognizer
        private let sender: UIGestureRecognizer
        
        
        /// Initialization
        init(sender: UIGestureRecognizer) {
            self.sender = sender
        }
        
        /// Receive subscriber
        func receive<S>(subscriber: S) where S : Subscriber, Never == S.Failure, Void == S.Input {
            let subscription = InteractionSubscription(sender: sender, subscriber: subscriber)
            subscriber.receive(subscription: subscription)
        }
        
    }
    
}


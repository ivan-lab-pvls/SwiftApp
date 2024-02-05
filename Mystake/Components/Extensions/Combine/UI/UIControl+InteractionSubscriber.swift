//
//  UIControl+InteractionSubscriber.swift
//  Mystake
//
//  Created by Vladko on 16.01.2024.
//

import UIKit
import Combine

extension UIControl {
    
    class InteractionSubscriber<S: Subscriber>: Subscription where S.Input == Void, S.Failure == Never {
        
        /// Control
        private let sender: UIControl
        
        /// Subscriber
        private let subscriber: S
        
        
        /// Initialization
        init(sender: UIControl, event: UIControl.Event, subscriber: S) {
            self.sender = sender
            self.subscriber = subscriber
            sender.addTarget(self, action: #selector(onAction), for: event)
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
        
        /// Control
        private let sender: UIControl
        
        /// Event
        private let event: UIControl.Event
        
        
        /// Initialization
        init(sender: UIControl, event: UIControl.Event) {
            self.sender = sender
            self.event = event
        }
        
        /// Receive subscriber
        func receive<S>(subscriber: S) where S : Subscriber, Never == S.Failure, Void == S.Input {
            let subscription = InteractionSubscriber(sender: sender, event: event, subscriber: subscriber)
            subscriber.receive(subscription: subscription)
        }
        
    }
    
}

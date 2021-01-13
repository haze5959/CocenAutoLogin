//
//  OQ+Publisher.swift
//  AppstoreOQ
//
//  Created by OGyu kwon on 2020/08/20.
//  Copyright © 2020 OQ. All rights reserved.
//

import Combine
import UIKit

extension Publisher {
    var erased: AnyPublisher<Output, Failure> { eraseToAnyPublisher() }
}

struct GesturePublisher: Publisher {
    typealias Output = GestureType
    typealias Failure = Never
    private let view: UIView
    private let gestureType: GestureType
    
    init(view: UIView, gestureType: GestureType) {
        self.view = view
        self.gestureType = gestureType
    }
    
    func receive<S>(subscriber: S) where S : Subscriber, GesturePublisher.Failure == S.Failure, GesturePublisher.Output == S.Input {
        let subscription = GestureSubscription(
            subscriber: subscriber,
            view: view,
            gestureType: gestureType
        )
        subscriber.receive(subscription: subscription)
    }
}

enum GestureType {
    case tap(UITapGestureRecognizer = .init())
    case swipe(UISwipeGestureRecognizer = .init())
    case longPress(UILongPressGestureRecognizer = .init())
    case pan(UIPanGestureRecognizer = .init())
    case pinch(UIPinchGestureRecognizer = .init())
    case leftEdge(UIScreenEdgePanGestureRecognizer = .init())
    
    func get() -> UIGestureRecognizer {
        switch self {
        case let .tap(tapGesture):
            return tapGesture
        case let .swipe(swipeGesture):
            return swipeGesture
        case let .longPress(longPressGesture):
            return longPressGesture
        case let .pan(panGesture):
            return panGesture
        case let .pinch(pinchGesture):
            return pinchGesture
        case let .leftEdge(edgePanGesture):
            edgePanGesture.edges = .left
            return edgePanGesture
       }
    }
}

class GestureSubscription<S: Subscriber>: NSObject, UIGestureRecognizerDelegate, Subscription where S.Input == GestureType, S.Failure == Never {
    private var subscriber: S?
    private var gestureType: GestureType
    private var view: UIView
    
    init(subscriber: S, view: UIView, gestureType: GestureType) {
        self.subscriber = subscriber
        self.view = view
        self.gestureType = gestureType
        super.init()
        self.configureGesture(gestureType)
    }
    
    private func configureGesture(_ gestureType: GestureType) {
        let gesture = gestureType.get()
        gesture.addTarget(self, action: #selector(handler))
        gesture.delegate = self
        view.addGestureRecognizer(gesture)
    }
    
    func request(_ demand: Subscribers.Demand) { }
    
    func cancel() {
        subscriber = nil
    }
    
    @objc
    private func handler() {
        _ = subscriber?.receive(gestureType)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if gestureRecognizer is UITapGestureRecognizer {
            return touch.view == gestureRecognizer.view
        } else {
            return true
        }
    }
}



public extension SignalProtocol where Value: Sequence {
  /**
   Transforms a signal of sequences into a signal of elements by emitting all elements of each sequence.

   - returns: A new signal.
   */
  func uncollect() -> Signal<Value.Iterator.Element, Error> {
    return Signal<Value.Iterator.Element, Error> { (observer, lifetime) in
      let dispose = self.signal.observe { event in
        switch event {
        case let .value(sequence):
          sequence.forEach(observer.send(value:))
        case let .failed(error):
          observer.send(error: error)
        case .completed:
          observer.sendCompleted()
        case .interrupted:
          observer.sendInterrupted()
        }
      }
      lifetime += dispose
    }
  }
}

public extension SignalProducerProtocol where Value: Sequence {
  /**
   Transforms a producer of sequences into a producer of elements by emitting all elements of each sequence.

   - returns: A new producer.
   */
  func uncollect() -> SignalProducer<Value.Iterator.Element, Error> {
    return self.producer.lift { $0.uncollect() }
  }
}

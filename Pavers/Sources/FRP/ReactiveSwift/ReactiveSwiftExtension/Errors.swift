

extension SignalProtocol where Value: EventProtocol, Error == Never {
  /**
   - returns: A signal of errors of `Error` events from a materialized signal.
   */
  public func errors() -> Signal<Value.Error, Never> {
    return self.signal.map { $0.event.error }.skipNil()
  }
}

extension SignalProducerProtocol where Value: EventProtocol, Error == Never {
  /**
   - returns: A producer of errors of `Error` events from a materialized signal.
   */
  public func errors() -> SignalProducer<Value.Error, Never> {
    return self.producer.lift { $0.errors() }
  }
}

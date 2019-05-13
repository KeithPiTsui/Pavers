

extension SignalProtocol where Value: EventProtocol, Error == Never {
  /**
   - returns: A signal of values of `Next` events from a materialized signal.
   */
  public func values() -> Signal<Value.Value, Never> {
    return self.signal.map { $0.event.value }.skipNil()
  }
}

extension SignalProducerProtocol where Value: EventProtocol, Error == Never {
  /**
   - returns: A producer of values of `Next` events from a materialized signal.
   */
  public func values() -> SignalProducer<Value.Value, Never> {
    return self.producer.lift { $0.values() }
  }
}

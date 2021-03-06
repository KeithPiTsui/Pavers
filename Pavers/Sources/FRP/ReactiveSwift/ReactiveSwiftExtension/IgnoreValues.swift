

public extension SignalProtocol {

  /**
   Creates a new signal that emits a void value for every emission of `self`.

   - returns: A new signal.
   */
  func ignoreValues() -> Signal<Void, Self.Error> {
    return signal.map { _ in () }
  }
}

public extension SignalProducerProtocol {

  /**
   Creates a new producer that emits a void value for every emission of `self`.

   - returns: A new producer.
   */
  func ignoreValues() -> SignalProducer<Void, Self.Error> {
    return self.producer.lift { $0.ignoreValues() }
  }
}



public extension SignalProtocol {

  /**
   Maps a signal to a const.

   - parameter value: The constant.

   - returns: A new signal.
   */
  func mapConst <U> (_ value: U) -> Signal<U, Error> {
    return self.signal.map { _ in value }
  }
}

public extension SignalProducerProtocol {

  /**
   Maps a producer to a const.

   - parameter value: The constant.

   - returns: A new producer.
   */
  func mapConst <U> (_ value: U) -> SignalProducer<U, Error> {
    return self.producer.lift { $0.mapConst(value) }
  }
}

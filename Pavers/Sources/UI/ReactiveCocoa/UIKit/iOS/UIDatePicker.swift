import PaversFRP
import UIKit

extension Reactive where Base: UIDatePicker {
	/// Sets the date of the date picker.
	public var date: BindingTarget<Date> {
		return makeBindingTarget { $0.date = $1 }
	}

	/// A signal of dates emitted by the date picker.
	public var dates: Signal<Date, Never> {
		return mapControlEvents(.valueChanged) { $0.date }
	}
}

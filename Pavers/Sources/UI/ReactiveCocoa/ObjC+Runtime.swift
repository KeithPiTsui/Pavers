/// Search in `class` for any method that matches the supplied selector without
/// propagating to the ancestors.
///
/// - parameters:
///   - class: The class to search the method in.
///   - selector: The selector of the method.
///
/// - returns: The matching method, or `nil` if none is found.
internal func class_getImmediateMethod(_ `class`: AnyClass, _ selector: Selector) -> Method? {
	if let buffer = class_copyMethodList(`class`, nil) {
		defer { free(buffer) }

		var iterator = buffer
		while let method = iterator.pointee {
			if method_getName(method) == selector {
				return method
			}
			iterator = iterator.advanced(by: 1)
		}
	}

	return nil
}


//#import <objc/runtime.h>
//#import <objc/message.h>
//
//const IMP _rac_objc_msgForward = _objc_msgForward;
//
//void _rac_objc_setAssociatedObject(const void* object, const void* key, id value, objc_AssociationPolicy policy) {
//  __unsafe_unretained id obj = (__bridge typeof(obj)) object;
//  objc_setAssociatedObject(obj, key, value, policy);
//}

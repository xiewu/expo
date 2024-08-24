// Copyright 2024-present 650 Industries. All rights reserved.

@_expose(Cxx)
public class JavaScriptObject {
  internal weak var _runtime: JavaScriptRuntime?
  internal var pointee: facebook.jsi.Object

  internal var runtime: JavaScriptRuntime {
    return _runtime!
  }

  init(runtime: JavaScriptRuntime, pointee: consuming facebook.jsi.Object) {
    self._runtime = runtime
    self.pointee = pointee
  }

  convenience init(runtime: JavaScriptRuntime) {
    let obj = facebook.jsi.Object(&runtime.pointee) // <-- crashes here because the constructor calls a virtual runtime.createObject()

    self.init(runtime: runtime, pointee: expo.makeObject(&runtime.pointee))
  }

  func get() -> facebook.jsi.Object {
    return facebook.jsi.Value(&runtime.pointee, pointee).getObject(&runtime.pointee)
  }

  func getShared() -> Any {
    fatalError()
  }

  public func hasProperty(_ name: String) -> Bool {
    return pointee.hasProperty(&runtime.pointee, name)
  }

  public func getProperty(_ name: String) -> JavaScriptValue {
    let value = pointee.getProperty(&runtime.pointee, name)
    return JavaScriptValue(runtime: runtime, value: consume value)
  }

  public func getPropertyNames() -> [String] {
    let names: facebook.jsi.Array = pointee.getPropertyNames(&runtime.pointee)
    let count = names.size(&runtime.pointee)

    return (0..<count).map { i in
      return String(names.getValueAtIndex(&runtime.pointee, i).getString(&runtime.pointee).utf8(&runtime.pointee))
    }
  }

  public func setProperty(_ name: String, value: JavaScriptValue) {
    expo.setProperty(&runtime.pointee, pointee, name, value.value)
  }

  public func setProperty(_ name: String, object: JavaScriptObject) {
    expo.setProperty(&runtime.pointee, pointee, name, object.pointee)
  }

  public func setProperty(_ name: String, value: Any) {
    let value = JSIUtils.convertToJSIValue(runtime: &runtime.pointee, value: value)
    expo.setProperty(&runtime.pointee, pointee, name, value)
  }

  public func defineProperty(_ name: String, value: Any, options: [PropertyDescriptorOption]) {
    // TODO: options
    let descriptor = facebook.jsi.Object(&runtime.pointee)

    if options.contains(.configurable) {
      expo.setProperty(&runtime.pointee, descriptor, "configurable", facebook.jsi.Value(true))
    }
    if options.contains(.enumerable) {
      expo.setProperty(&runtime.pointee, descriptor, "enumerable", facebook.jsi.Value(true))
    }
    if options.contains(.writable) {
      expo.setProperty(&runtime.pointee, descriptor, "writable", facebook.jsi.Value(true))
    }

    let jsiValue = JSIUtils.convertToJSIValue(runtime: &runtime.pointee, value: value)
    expo.setProperty(&runtime.pointee, descriptor, "value", jsiValue)

    expo.common.defineProperty(&runtime.pointee, &pointee, name, descriptor)
  }

  public func defineProperty(_ name: String, descriptor: JavaScriptObject) {
    expo.common.defineProperty(&runtime.pointee, &pointee, name, descriptor.get())
  }

  // MARK: - WeakObject

  public func createWeak() -> JavaScriptWeakObject {
    fatalError()
//    return JavaScriptWeakObject(runtime: runtime, pointee: pointee)
  }
}

// Copyright 2024-present 650 Industries. All rights reserved.

@_expose(Cxx)
public class JavaScriptWeakObject {
  internal weak var _runtime: JavaScriptRuntime?

  internal var runtime: JavaScriptRuntime {
    return _runtime!
  }

  #if canImport(reacthermes)
  let pointee: facebook.jsi.WeakObject
  #else
  let pointee: facebook.jsi.Object
  #endif

  init(runtime: JavaScriptRuntime, pointee: consuming facebook.jsi.Object) {
    self._runtime = runtime

    #if canImport(reacthermes)
    self.pointee = facebook.jsi.WeakObject(&runtime.pointee, pointee)
    #else
    if expo.common.isWeakRefSupported(&runtime.pointee) {
      self.pointee = expo.common.createWeakRef(&runtime.pointee, &pointee)
    } else {
      self.pointee = pointee
    }
    #endif
  }

  public func lock() -> JavaScriptObject? {
    #if canImport(reacthermes)
    let value = pointee.lock(&runtime.pointee)
    #else
    let value = expo.common.derefWeakRef(&runtime.pointee, pointee)
    #endif

    if value.isUndefined() {
      return nil
    }
    return JavaScriptObject(runtime: runtime, pointee: value.getObject(&runtime.pointee))
  }
}

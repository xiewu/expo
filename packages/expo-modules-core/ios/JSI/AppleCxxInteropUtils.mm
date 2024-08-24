// Copyright 2024-present 650 Industries. All rights reserved.

#import "AppleCxxInteropUtils.h"
#import "Swift.h"

namespace expo {

void setProperty(jsi::Runtime &runtime, const jsi::Object &object, const char *name, const jsi::Value &value) {
  object.setProperty(runtime, name, value);
}

void setProperty(jsi::Runtime &runtime, const jsi::Object &object, const char *name, const jsi::Object &value) {
  object.setProperty(runtime, name, value);
}

RuntimeSharedPtr makeRuntime() {
#if __has_include(<reacthermes/HermesExecutorFactory.h>)
  // TODO: Polyfill setImmediate, see EXJavaScriptRuntime.mm
  return facebook::hermes::makeHermesRuntime();
#else
  return jsc::makeJSCRuntime();
#endif
}

RuntimeSharedPtr makeShared(void *runtimePtr) {
  jsi::Runtime *runtime = reinterpret_cast<jsi::Runtime *>(runtimePtr);
  return std::shared_ptr<jsi::Runtime>(std::shared_ptr<jsi::Runtime>(), runtime);
}

ObjectSharedPtr makeShared(jsi::Runtime &runtime, jsi::Object &object) {
  auto value = jsi::Value(runtime, object);
  return std::make_shared<jsi::Object>(value.getObject(runtime));
}

CallInvokerSharedPtr makeShared(react::CallInvoker &callInvoker) {
  return std::shared_ptr<react::CallInvoker>(std::shared_ptr<react::CallInvoker>(), &callInvoker);
}

CallInvokerSharedPtr makeSharedTestingSyncJSCallInvoker(RuntimeSharedPtr runtime) {
  auto callInvoker = std::make_shared<TestingSyncJSCallInvoker>(runtime);
  return std::dynamic_pointer_cast<react::CallInvoker>(callInvoker);
}

CallInvokerSharedPtr makeSharedCallInvoker(react::RuntimeExecutor executor) {
  auto callInvoker = std::make_shared<expo::BridgelessJSCallInvoker>(executor);
  return std::dynamic_pointer_cast<react::CallInvoker>(callInvoker);
}

jsi::Object makeObject(jsi::Runtime &runtime) {
  return jsi::Object(runtime);
}

}

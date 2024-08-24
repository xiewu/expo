// Copyright 2024-present 650 Industries. All rights reserved.

#pragma once

#ifdef __cplusplus

#include <jsi/jsi.h>
#include <ReactCommon/CallInvoker.h>

#if __has_include(<reacthermes/HermesExecutorFactory.h>)
#import <reacthermes/HermesExecutorFactory.h>
#else
#import <jsi/JSCRuntime.h>
#endif

#import "TestingSyncJSCallInvoker.h"
#import "BridgelessJSCallInvoker.h"

namespace jsi = facebook::jsi;
namespace react = facebook::react;

namespace expo {

typedef std::shared_ptr<jsi::Runtime> RuntimeSharedPtr;
typedef std::shared_ptr<jsi::Object> ObjectSharedPtr;
typedef std::shared_ptr<react::CallInvoker> CallInvokerSharedPtr;

void setProperty(jsi::Runtime &runtime, const jsi::Object &object, const char *name, const jsi::Value &value);
void setProperty(jsi::Runtime &runtime, const jsi::Object &object, const char *name, const jsi::Object &value);

RuntimeSharedPtr makeRuntime();
RuntimeSharedPtr makeShared(void *runtime);
ObjectSharedPtr makeShared(jsi::Runtime &runtime, jsi::Object &object);
CallInvokerSharedPtr makeShared(react::CallInvoker &callInvoker);
CallInvokerSharedPtr makeSharedTestingSyncJSCallInvoker(RuntimeSharedPtr runtime);
CallInvokerSharedPtr makeSharedCallInvoker(react::RuntimeExecutor executor);

jsi::Object makeObject(jsi::Runtime &runtime);

}; // namespace expo

#endif // __cplusplus

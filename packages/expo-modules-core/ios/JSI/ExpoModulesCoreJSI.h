// Copyright 2024-present 650 Industries. All rights reserved.

#import <Foundation/Foundation.h>

// This stops these C++ code from sneaking into the Swift interface file
#ifdef __cplusplus
#if __has_include(<jsi/jsi.h>)

#import <jsi/jsi.h>
#import <ReactCommon/CallInvoker.h>

#import <ExpoModulesCoreJSI/AppleCxxInteropUtils.h>
#import <ExpoModulesCoreJSI/BridgelessJSCallInvoker.h>
#import "EventEmitter.h"
#import "JSIRuntimeProvider.h"
#import "JSIUtils.h"
#import "LazyObject.h"
#import "NativeModule.h"
#import "ObjectDeallocator.h"
#import "SharedObject.h"
#import "Swift.h"
#import "TestingSyncJSCallInvoker.h"
#import "TypedArray.h"

#endif // __has_include(<jsi/jsi.h>)
#endif // __cplusplus

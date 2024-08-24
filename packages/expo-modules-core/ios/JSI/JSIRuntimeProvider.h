// Copyright 2024-present 650 Industries. All rights reserved.

#pragma once

#import <Foundation/Foundation.h>

#if defined(__cplusplus) && __has_include(<ReactCommon/CallInvoker.h>)
#import <ReactCommon/CallInvoker.h>
#import <jsi/jsi.h>
#import <hermes/hermes.h>
#endif

@protocol JSIRuntimeProviderObjC <NSObject>

- (void *)runtime;

#if defined(__cplusplus) && __has_include(<ReactCommon/CallInvoker.h>)
- (std::shared_ptr<facebook::react::CallInvoker>)jsCallInvoker;
#endif

@end

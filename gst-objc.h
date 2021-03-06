#include <gstpub.h>
#include <pthread.h>
#import <Foundation/Foundation.h>
//#import "LKInterpreterRuntime.h"
#ifndef GNU_RUNTIME
#include <objc/objc-runtime.h>
#endif

@protocol SmalltalkProxy
- (OOP)getStObject;
- (BOOL)isStProxy;
@end

#import "gst-objc-ext.h"

/* Smallltalk proxy */
extern VMProxy* gst_proxy;

/* Mutex to prevent gst_proxy race access */
extern pthread_mutex_t gstProxyMutex;

#define GST_LOCK_PROXY (pthread_mutex_lock (&gstProxyMutex))
#define GST_UNLOCK_PROXY (pthread_mutex_unlock (&gstProxyMutex))

#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "KYGCDTimer.h"
#import "KYProxyTimer.h"

FOUNDATION_EXPORT double KYTimerVersionNumber;
FOUNDATION_EXPORT const unsigned char KYTimerVersionString[];


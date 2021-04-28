//
//  XinstallDefault.h
//  Xinstall
//
//  Created by Xinstall on 2020/5/12.
//  Copyright © 2020 shu bao. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef XinstallDefault_h
#define XinstallDefault_h

extern NSString * _Nonnull const XinstallAppKey;
extern NSString * _Nonnull const XinstallBaseServiceURL;
extern NSString * _Nonnull const XinstallVersion;

#ifdef DEBUG
#define XINNULLSAFE_ENABLED 1
#endif

#ifdef DEBUG
#define XINLog(...) NSLog(__VA_ARGS__)
#define XINDebugMethod() NSLog(@"%s", __func__)
#else
#define XINLog(...)
#define XINDebugMethod()
#endif


#endif /* XinstallDefault_h */

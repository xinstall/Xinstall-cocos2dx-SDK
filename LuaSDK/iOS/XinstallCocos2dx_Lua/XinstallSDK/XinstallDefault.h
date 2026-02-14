//
//  XinstallDefault.h
//  Xinstall
//
//  Created by Xinstall on 2020/5/12.
//  Copyright © 2021 Shu Bao. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef XinstallDefault_h
#define XinstallDefault_h

extern NSString * _Nonnull const XinstallAppKey;
extern NSString * _Nonnull const XinstallBaseServiceURL;
extern NSString * _Nonnull const XinstallVersion;
extern NSString * _Nonnull const XinstallNetworkCheck;

#ifdef DEBUG
#define XINNULLSAFE_ENABLED 1
#endif

#define XINLog(...) [XinstallLog xlog:__VA_ARGS__]

#ifdef DEBUG
#define XINDebugMethod() NSLog(@"%s", __func__)
#else
#define XINDebugMethod()
#endif


#endif /* XinstallDefault_h */

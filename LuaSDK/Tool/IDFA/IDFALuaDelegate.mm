//
//  IDFALuaDelegate.m
//  Shubao
//
//  Created by Shubao on 2021/7/30.
//

#import "IDFALuaDelegate.h"
#import <UIKit/UIKit.h>
#import <AdSupport/AdSupport.h>
#if __has_include(<AppTrackingTransparency/AppTrackingTransparency.h>)
#import <AppTrackingTransparency/AppTrackingTransparency.h>
#endif

@interface IDFALuaDelegate ()

@property (nonatomic, strong) NSTimer *getIDFATimer;

@end

@implementation IDFALuaDelegate

+ (instancetype)defaultManager {
    static IDFALuaDelegate *idfaDelegate;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        idfaDelegate = [[super allocWithZone:NULL] init];
    });
    return idfaDelegate;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [IDFALuaDelegate defaultManager] ;
}

- (instancetype)copyWithZone:(NSZone *)zone {
    return [IDFALuaDelegate defaultManager];
}

- (instancetype)mutableCopyWithZone:(NSZone *)zone {
    return [IDFALuaDelegate defaultManager] ;
}

- (void)getIDFAWithCompletion:(void(^)(NSString *))competion {
#if __has_include(<AppTrackingTransparency/AppTrackingTransparency.h>)
    if (@available(iOS 14, *)) {
        if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive) {
            [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
                NSString *idfa = ASIdentifierManager.sharedManager.advertisingIdentifier.UUIDString;
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (competion) {
                        competion(idfa);
                    }
                });
            }];
        } else {
            self.getIDFATimer = [NSTimer scheduledTimerWithTimeInterval:2 repeats:YES block:^(NSTimer * _Nonnull timer) {
                if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive) {
                    [self.getIDFATimer invalidate];
                    
                    [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
                        NSString *idfa = ASIdentifierManager.sharedManager.advertisingIdentifier.UUIDString;
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if (competion) {
                                competion(idfa);
                            }
                        });
                    }];
                }
            }];
        }
    } else {
        NSString *idfa = ASIdentifierManager.sharedManager.advertisingIdentifier.UUIDString;
        if (competion) {
            competion(idfa);
        }
    }
#else
    NSString *idfa = ASIdentifierManager.sharedManager.advertisingIdentifier.UUIDString;
    if (competion) {
        competion(idfa);
    }
#endif
}

+ (NSString *)jsonStringWithObject:(id)jsonObject{

    id arguments = (jsonObject == nil ? [NSNull null] : jsonObject);

    NSArray* argumentsWrappedInArr = [NSArray arrayWithObject:arguments];

    NSString* argumentsJSON = [self cp_JSONString:argumentsWrappedInArr];

    argumentsJSON = [argumentsJSON substringWithRange:NSMakeRange(1, [argumentsJSON length] - 2)];

    return argumentsJSON;
}

+ (NSString *)cp_JSONString:(NSArray *)array{
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:array
                                                       options:0
                                                         error:&error];

    NSString *jsonString = [[NSString alloc] initWithData:jsonData
                                                 encoding:NSUTF8StringEncoding];

    if ([jsonString length] > 0 && error == nil){
        return jsonString;
    }else{
        return @"";
    }
}

@end

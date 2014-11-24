//
//  APServerOrder.m
//  AllPayMobileSDK iOS Example
//
//  Created by 歐付寶 on 2014/11/2.
//  Copyright (c) 2014年 歐付寶. All rights reserved.
//

#import "APServerOrder.h"
#import "APGlobal.h"



#define AP_STAGE_ServerOrder_URL_STRING @"http://payment-stage.allpay.com.tw/Mobile/CreateServerOrder"
#define AP_PRODUCT_ServerOrder_URL_STRING @"https://payment.allpay.com.tw/Mobile/CreateServerOrder"

#define AP_STAGE_VerifyOtpCode_URL_STRING @"http://payment-stage.allpay.com.tw/Mobile/VerifyOtpCode"
#define AP_PRODUCT_VerifyOtpCode_URL_STRING @"https://payment.allpay.com.tw/Mobile/VerifyOtpCode"


@implementation APServerOrder


+(NSString *)getAPIURLString
{
    NSString *urlString = AP_PRODUCT_ServerOrder_URL_STRING;
    if ([APGlobal environment] == APEnvironment_STAGE) {
        urlString = AP_STAGE_ServerOrder_URL_STRING;
    }
    return urlString;
}

+(NSString *)getOTPURLString
{
    NSString *urlString = AP_PRODUCT_VerifyOtpCode_URL_STRING;
    if ([APGlobal environment] == APEnvironment_STAGE) {
        urlString = AP_STAGE_VerifyOtpCode_URL_STRING;
    }
    return urlString;
}


+(AFHTTPRequestOperationManager *)create:(id)parameters
                                  action:(void (^)(id responseObject, NSError *error))block {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSString *path = [self getAPIURLString];
    manager.responseSerializer.acceptableContentTypes =[[NSSet alloc] initWithObjects: @"text/html",@"text/plain", nil];
    manager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalAndRemoteCacheData;
    [manager POST:path parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"JSON: %@", responseObject);
        
        if ([responseObject objectForKey:@"RtnCode"] !=nil) {
            if (block) {
                block(responseObject, nil);
            }
        }else{
            if (block) {
                NSMutableDictionary* details = [NSMutableDictionary dictionary];
                [details setValue:@"Parse Error" forKey:NSLocalizedDescriptionKey];
                
                NSError *error = [NSError errorWithDomain:@"tw.com.allpay.app.APOrderSDK" code:1000 userInfo:details];
                
                block(nil, error);
            }
        }
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            block(nil, error);
        }
        
    }];
    
    return manager;
}






+(AFHTTPRequestOperationManager *)otp:(id)parameters
                                  action:(void (^)(id responseObject, NSError *error))block {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSString *path = [self getOTPURLString];
    manager.responseSerializer.acceptableContentTypes =[[NSSet alloc] initWithObjects: @"text/html",@"text/plain", nil];
    manager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalAndRemoteCacheData;
    [manager POST:path parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //        NSLog(@"JSON: %@", responseObject);
        
        if ([responseObject objectForKey:@"RtnCode"] !=nil) {
            if (block) {
                block(responseObject, nil);
            }
        }else{
            if (block) {
                NSMutableDictionary* details = [NSMutableDictionary dictionary];
                [details setValue:@"Parse Error" forKey:NSLocalizedDescriptionKey];
                
                NSError *error = [NSError errorWithDomain:@"tw.com.allpay.app.APOrderSDK" code:2000 userInfo:details];
                
                block(nil, error);
            }
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            block(nil, error);
        }
        
    }];
    
    return manager;
}

@end

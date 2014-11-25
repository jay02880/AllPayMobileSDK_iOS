//
//  APLogisticsOrder.m
//  AllPayMobileSDK iOS Example
//
//  Created by 羊小咩 on 2014/11/25.
//  Copyright (c) 2014年 羊小咩. All rights reserved.
//

#import "APLogisticsOrder.h"
#import "APGlobal.h"

#define AP_Stage_URL_ServerOrder @"http://logistics-beta.allpay.com.tw/Mobile/CreateServerOrder"

//#define AP_Stage_URL_ServerOrder @"http://logistics-stage.allpay.com.tw/Mobile/CreateServerOrder"

#define AP_Product_URL_ServerOrder @"http://logistics.allpay.com.tw/Mobile/CreateServerOrder"




#define AP_Stage_URL_CancelOrder @"http://logistics-beta.allpay.com.tw/Mobile/CancelServerOrder"

//#define AP_Stage_URL_CancelOrder @"http://logistics-stage.allpay.com.tw/Mobile/CancelServerOrder"
#define AP_Product_URL_CancelOrder @"https://logistics.allpay.com.tw/Mobile/CancelServerOrder"





@implementation APLogisticsOrder




+(AFHTTPRequestOperationManager *)create:(id)parameters
                                  action:(void (^)(id responseObject, NSError *error))block {
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
    
    
    
    NSString *path = [[self getAPIURLCreateServerOrder] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];;
    
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



+(AFHTTPRequestOperationManager *)cancel:(id)parameters
                                  action:(void (^)(id responseObject, NSError *error))block {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    
    
    NSString *path = [[self getAPIURLCancelServerOrder] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];;
    
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



+(NSString *)getAPIURLCreateServerOrder
{
    NSString *urlString = AP_Product_URL_ServerOrder;
    if ([APGlobal environment] == APEnvironment_STAGE) {
        urlString = AP_Stage_URL_ServerOrder;
    }
    return urlString;
};


+(NSString *)getAPIURLCancelServerOrder
{
    NSString *urlString = AP_Product_URL_CancelOrder;
    if ([APGlobal environment] == APEnvironment_STAGE) {
        urlString = AP_Stage_URL_CancelOrder;
    }
    return urlString;
};

@end

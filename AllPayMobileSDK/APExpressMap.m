//
//  APExpressMap.m
//  AllPayMobileSDK iOS Example
//
//  Created by 羊小咩 on 2014/11/24.
//  Copyright (c) 2014年 羊小咩. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "APExpressMap.h"
#import "APGlobal.h"

#import "APWebViewCtrl.h"


#define AP_STAGE_ExpressMap_URL_STRING @"http://payment-stage.allpay.com.tw/Mobile/CreateClientOrder"
#define AP_PRODUCT_ExpressMap_URL_STRING @"https://payment.allpay.com.tw/Mobile/CreateClientOrder"



@implementation APExpressMap

+(void)getWebViewWithAttributes:(NSDictionary *)attributes
{
    [APWebViewCtrl getWebViewWithURL:[self getAPIURLString] attributes:attributes];
}



+(NSString *)getAPIURLString
{
    NSString *urlString = AP_PRODUCT_ExpressMap_URL_STRING;
    if ([APGlobal environment] == APEnvironment_STAGE) {
        urlString = AP_STAGE_ExpressMap_URL_STRING;
    }
    return urlString;
}

@end

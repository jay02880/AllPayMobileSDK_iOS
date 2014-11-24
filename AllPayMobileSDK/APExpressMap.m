//
//  APExpressMap.m
//  AllPayMobileSDK iOS Example
//
//  Created by 羊小咩 on 2014/11/24.
//  Copyright (c) 2014年 羊小咩. All rights reserved.
//

#import "APExpressMap.h"
#import "APGlobal.h"


#define AP_STAGE_ExpressMap_URL_STRING @"http://payment-stage.allpay.com.tw/Mobile/CreateClientOrder"
#define AP_PRODUCT_ExpressMap_URL_STRING @"https://payment.allpay.com.tw/Mobile/CreateClientOrder"



@implementation APExpressMap





+(NSString *)getAPIURLString
{
    NSString *urlString = AP_PRODUCT_ExpressMap_URL_STRING;
    if ([APGlobal environment] == APEnvironment_STAGE) {
        urlString = AP_STAGE_ExpressMap_URL_STRING;
    }
    return urlString;
}

@end

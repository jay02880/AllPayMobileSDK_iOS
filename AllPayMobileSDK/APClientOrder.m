//
//  ClientOrder.m
//  AllPayMobileSDK iOS Example
//
//  Created by 歐付寶 on 2014/10/30.
//  Copyright (c) 2014年 歐付寶. All rights reserved.
//

#import "APClientOrder.h"
#import "APGlobal.h"
#import "APWebViewCtrl.h"




#define AP_STAGE_ClientOrder_URL_STRING @"http://payment-stage.allpay.com.tw/Mobile/CreateClientOrder"
#define AP_PRODUCT_ClientOrder_URL_STRING @"https://payment.allpay.com.tw/Mobile/CreateClientOrder"


@implementation APClientOrder


+(void)getWebViewWithAttributes:(NSDictionary *)attributes
{
    [APWebViewCtrl getWebViewWithURL:[self getAPIURLString] attributes:attributes];
}


+(NSString *)getAPIURLString
{
    NSString *urlString = AP_PRODUCT_ClientOrder_URL_STRING;
    if ([APGlobal environment] == APEnvironment_STAGE) {
        urlString = AP_STAGE_ClientOrder_URL_STRING;
    }
    return urlString;
}


@end


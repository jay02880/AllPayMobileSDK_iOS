//
//  ClientOrder.m
//  AllPayMobileSDK iOS Example
//
//  Created by 歐付寶 on 2014/10/30.
//  Copyright (c) 2014年 歐付寶. All rights reserved.
//

#import "APClientOrder.h"
#import "APOrderGlobal.h"
#import "APClientOrderViewCtrl.h"




#define AP_STAGE_ClientOrder_URL_STRING @"http://payment-stage.allpay.com.tw/Mobile/CreateClientOrder"
#define AP_PRODUCT_ClientOrder_URL_STRING @"https://payment.allpay.com.tw/Mobile/CreateClientOrder"


@implementation APClientOrder



+(UIViewController *)getRootViewController
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIViewController *rootViewController = window.rootViewController;
    return rootViewController;
}

//
+(void)getOrderViewWithAttributes:(NSDictionary *)attributes
{
    
    APClientOrderViewCtrl *viewCtrl = [[APClientOrderViewCtrl alloc] initDefaultXib:attributes];
    
    UINavigationController *nav = [[UINavigationController alloc]
                                   initWithRootViewController:viewCtrl];
    
    UIViewController *rootViewController =[self getRootViewController];
    [rootViewController presentViewController:nav animated:YES completion:nil];
}


+(NSString *)getAPIURLString
{
    NSString *urlString = AP_PRODUCT_ClientOrder_URL_STRING;
    if ([APOrderGlobal environment] == APEnvironment_STAGE) {
        urlString = AP_STAGE_ClientOrder_URL_STRING;
    }
    return urlString;
}


@end


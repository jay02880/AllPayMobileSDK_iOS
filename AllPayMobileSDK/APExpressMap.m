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


#define AP_STAGE_ExpressMap_URL_STRING @"http://logistics-stage.allpay.com.tw/Express/map"
#define AP_PRODUCT_ExpressMap_URL_STRING @"https://logistics.allpay.com.tw/Express/map"





@implementation APExpressMap



+(void)getWebViewWithDelegate:(id<APWebViewCtrlDelegate>)delegate attributes:(NSDictionary *)attributes
{
    
    NSMutableDictionary *nDict = [attributes mutableCopy];
    
    if([nDict objectForKey:@"ClientReplyURL"] == nil){
        nDict[@"ServerReplyURL"] = @"apmsdk://ExpressMap/";
        nDict[@"IsGet"] =@"Y";
    }
    
    
    [APWebViewCtrl getWebViewWithDelegate:delegate URL:[[self class] getAPIURLString] attributes:nDict];
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

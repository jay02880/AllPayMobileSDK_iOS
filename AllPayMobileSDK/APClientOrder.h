
//
//  ClientOrder.h
//  AllPayMobileSDK iOS Example
//
//  Created by 歐付寶 on 2014/10/30.
//  Copyright (c) 2014年 歐付寶. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>



@interface APClientOrder : NSObject



// ---------------------------
// * 顯示Order 清單
// ---------------------------
+(void)getOrderViewWithAttributes:(NSDictionary *)attributes;

//取得 rootViewController (UI 顯示用）
+(UIViewController *)getRootViewController;

+(NSString *)getAPIURLString;
@end









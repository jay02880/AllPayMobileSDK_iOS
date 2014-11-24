//
//  APOrderGlobal.h
//  AllPayMobileSDK iOS Example
//
//  Created by 歐付寶 on 2014/11/2.
//  Copyright (c) 2014年 歐付寶. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    APEnvironment_STAGE = 0,
    APEnvironment_PRODUCT
    
} APEnvironment;



@interface APGlobal : NSObject

// ---------------------------
// * environment 運行的環境
// APEnvironment_STAGE 測試環境
// APEnvironment_PRODUCT 正式環境
// ---------------------------
+ (APEnvironment) environment;
+ (void) setEnvironment:(APEnvironment )value;


@end

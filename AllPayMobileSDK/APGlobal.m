//
//  APOrderGlobal.m
//  AllPayMobileSDK iOS Example
//
//  Created by 歐付寶 on 2014/11/2.
//  Copyright (c) 2014年 歐付寶. All rights reserved.
//

#import "APGlobal.h"

static APEnvironment _environment = APEnvironment_PRODUCT;

@implementation APGlobal

+ (APEnvironment) environment { return _environment; }
+ (void) setEnvironment:(APEnvironment )value { _environment = value; }

@end

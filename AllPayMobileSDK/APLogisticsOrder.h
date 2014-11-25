//
//  APLogisticsOrder.h
//  AllPayMobileSDK iOS Example
//
//  Created by 羊小咩 on 2014/11/25.
//  Copyright (c) 2014年 羊小咩. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPRequestOperationManager.h"

@interface APLogisticsOrder : NSObject


+(AFHTTPRequestOperationManager *)create:(id)parameters
                                  action:(void (^)(id responseObject, NSError *error))block;

+(AFHTTPRequestOperationManager *)cancel:(id)parameters
                                  action:(void (^)(id responseObject, NSError *error))block;

@end

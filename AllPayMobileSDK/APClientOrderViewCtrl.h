//
//  APClientOrderViewCtrl.h
//  AllPayMobileSDK iOS Example
//
//  Created by 歐付寶 on 2014/11/3.
//  Copyright (c) 2014年 歐付寶. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface APClientOrderViewCtrl : UIViewController

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

-(instancetype) initDefaultXib:(NSDictionary *)attributes;
@end


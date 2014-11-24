//
//  BasicViewController.h
//  AllPayMobileSDK iOS Example
//
//  Created by 歐付寶 on 2014/11/2.
//  Copyright (c) 2014年 歐付寶. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BasePickerViewController.h"

@interface BasicViewController : BasePickerViewController
{
@protected
    __weak IBOutlet UILabel *atmLabel;
    __weak IBOutlet UILabel *cvsLabel;
    __weak IBOutlet UILabel *runVerLabel;
    

    NSArray* kAP_ATMType;
    NSArray* kAP_CVSType;

}

-(void)updateEnvironmentStatus;


@end

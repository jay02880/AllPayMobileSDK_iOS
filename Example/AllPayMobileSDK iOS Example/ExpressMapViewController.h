//
//  ExpressMapViewController.h
//  AllPayMobileSDK iOS Example
//
//  Created by 羊小咩 on 2014/11/24.
//  Copyright (c) 2014年 羊小咩. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BasePickerViewController.h"
@interface ExpressMapViewController : BasePickerViewController
{
    @protected
    __weak IBOutlet UILabel *runVerLabel;
    
    __weak IBOutlet UILabel *typeLabel;
    
    NSArray* kAP_Type;
    
    
}
@property (weak, nonatomic) IBOutlet UIPickerView *picker;


@end

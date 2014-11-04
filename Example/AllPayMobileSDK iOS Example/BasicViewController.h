//
//  BasicViewController.h
//  AllPayMobileSDK iOS Example
//
//  Created by 歐付寶 on 2014/11/2.
//  Copyright (c) 2014年 歐付寶. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BasicViewController : UIViewController<UIPickerViewDataSource ,UIPickerViewDelegate>
{
@protected
    __weak IBOutlet UILabel *atmLabel;
    __weak IBOutlet UILabel *cvsLabel;
    __weak IBOutlet UILabel *runVerLabel;
    
    NSMutableArray *_pickerData;
    NSArray* kAP_ATMType;
    NSArray* kAP_CVSType;
    UILabel *usedLableTarget;
}
@property (weak, nonatomic) IBOutlet UIPickerView *picker;

-(void)updateEnvironmentStatus;

-(NSString *)getRadomTradeNo;
-(NSString *)getDataString;
-(void) handleSingleTap:(UITapGestureRecognizer *) tapper ;
-(void)hidePickerAnim;
-(void)showPickerAnim;
- (void)setRoundedBorder:(float)radius borderWidth:(float)borderWidth color:(UIColor*)color forButton:(UIButton *)button;
@end

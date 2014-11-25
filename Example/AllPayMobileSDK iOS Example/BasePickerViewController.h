//
//  BasePickerViewController.h
//  AllPayMobileSDK iOS Example
//
//  Created by 羊小咩 on 2014/11/24.
//  Copyright (c) 2014年 羊小咩. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BasePickerViewController : UIViewController<UIPickerViewDataSource ,UIPickerViewDelegate>
{
@protected
    
    NSMutableArray *_pickerData;
    UILabel *usedLableTarget;
}

@property (weak, nonatomic) IBOutlet UIPickerView *picker;

-(NSString *)getRadomTradeNo;
-(NSString *)getDataString;
-(void) handleSingleTap:(UITapGestureRecognizer *) tapper ;
-(void)hidePickerAnim;
-(void)showPickerAnim;
-(void) setupTap:(UIView *) view action:(SEL)action;
- (void)setRoundedBorder:(float)radius borderWidth:(float)borderWidth color:(UIColor*)color forButton:(UIButton *)button;

@end

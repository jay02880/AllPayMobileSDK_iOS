//
//  BasePickerViewController.m
//  AllPayMobileSDK iOS Example
//
//  Created by 羊小咩 on 2014/11/24.
//  Copyright (c) 2014年 羊小咩. All rights reserved.
//

#import "BasePickerViewController.h"

@interface BasePickerViewController ()

@end

@implementation BasePickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


#pragma mark -
#pragma mark PickerView Delegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _pickerData.count;
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return _pickerData[row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row
      inComponent:(NSInteger)component
{
    [self hidePickerAnim];
    
    [usedLableTarget setText: [_pickerData objectAtIndex:row]];
    
    
}
#pragma mark -
#pragma mark UI
- (void)setRoundedBorder:(float)radius borderWidth:(float)borderWidth color:(UIColor*)color forButton:(UIButton *)button
{
    CALayer * l = [button layer];
    [l setMasksToBounds:YES];
    [l setCornerRadius:radius];
    // You can even add a border
    [l setBorderWidth:borderWidth];
    [l setBorderColor:[color CGColor]];
}


-(void)showPickerAnim{
    self.picker.alpha = 0;
    [UIView beginAnimations:@"Anim_ShowPick" context:nil];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationDelegate:self];
    //        CGAffineTransform transfrom = CGAffineTransformMakeTranslation(0, -200);
    //        self.picker.transform = transfrom;
    self.picker.alpha = self.picker.alpha * (-1) + 1;
    [UIView setAnimationDidStopSelector:@selector(animationFinished:finished:context:)];
    [UIView commitAnimations];
}

-(void)hidePickerAnim{
    [UIView beginAnimations:@"Anim_HidePick" context:nil];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationDelegate:self];
    self.picker.alpha = 0;
    [UIView setAnimationDidStopSelector:@selector(animationFinished:finished:context:)];
    [UIView commitAnimations];
}

- (void)animationFinished:(NSString *)animationID finished:(BOOL)finished context:(void *)context
{
    
    if ([animationID isEqualToString:@"Anim_ShowPick"])
    {
    }
    if ([animationID isEqualToString:@"Anim_HidePick"])
    {
        self.picker.hidden=YES;
        usedLableTarget = nil;
    }
}





#pragma mark - View lifecycle

-(void) handleSingleTap:(UITapGestureRecognizer *) tapper {
    
    if (tapper.state == UIGestureRecognizerStateEnded) {
        //        NSLog(@"%@",NSStringFromSelector(_cmd));
        [self hidePickerAnim];
        
    }
    
}

-(void) handleDummyTap:(UITapGestureRecognizer *) tapper {
    // silently ignore the tap event for this view.
}

-(void) setupTap:(UIView *) view action:(SEL)action {
    // assign custom tap event handler for given view.
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:action];
    [view addGestureRecognizer:gestureRecognizer];
    
}



@end

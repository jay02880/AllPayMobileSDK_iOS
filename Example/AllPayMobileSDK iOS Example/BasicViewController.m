//
//  BasicViewController.m
//  AllPayMobileSDK iOS Example
//
//  Created by 歐付寶 on 2014/11/2.
//  Copyright (c) 2014年 歐付寶. All rights reserved.
//

#import "BasicViewController.h"
#import "APOrderGlobal.h"


@interface BasicViewController ()


@end


@implementation BasicViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initActionData];
}



-(void)updateEnvironmentStatus
{
    if (APOrderGlobal.environment ==APEnvironment_PRODUCT) {
        runVerLabel.text = @"Run Ver : Stage(正式環境)";
    } else {
        runVerLabel.text = @"Run Ver : Stage(測試環境)";
    }
}

-(void)initActionData{
    
    [self initData];
    //Label Click
    [atmLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chaneATM:)]];
    
    [cvsLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chaneCVS:)]];
    
    atmLabel.userInteractionEnabled = YES;
    cvsLabel.userInteractionEnabled = YES;
    
    
    _pickerData = [kAP_ATMType mutableCopy];
    
    
    atmLabel.text =kAP_ATMType[0];
    cvsLabel.text =kAP_CVSType[0];
    
    // PICKER
    self.picker.dataSource = self;
    self.picker.delegate = self;
    self.picker.hidden=YES;
    
    
    //點擊背景隱藏 picker
    [self setupTap:self.view action:@selector(handleSingleTap:)];

    [self updateEnvironmentStatus];

}
-(void)initData{
    kAP_ATMType =@[@"ALL"];
    kAP_CVSType =@[@"ALL"];
}







#pragma mark -


-(void)chaneATM:(UITapGestureRecognizer *)sender {
    
    if(self.picker.hidden==YES){
        usedLableTarget = (UILabel*)[sender view];
        self.picker.hidden=NO;
        _pickerData = [kAP_ATMType mutableCopy];
        [self.picker reloadAllComponents];
        
        
        NSUInteger index =[kAP_ATMType indexOfObject:usedLableTarget.text];
        [self.picker selectRow:index inComponent:0 animated:NO];
        [self showPickerAnim];
    }
    
}

-(void)chaneCVS:(UITapGestureRecognizer *)sender {
    
    if(self.picker.hidden==YES){
        self.picker.hidden=NO;
        usedLableTarget = (UILabel*)[sender view];
        _pickerData = [kAP_CVSType mutableCopy];
        
        [self.picker reloadAllComponents];
        
        NSUInteger index =[kAP_CVSType indexOfObject:usedLableTarget.text];
        [self.picker selectRow:index inComponent:0 animated:NO];
        
        
        [self showPickerAnim];
    }
    
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





#pragma mark - Utils
//隨機產生交易序號
-(NSString *)getRadomTradeNo
{
    //這是範例隨機自定的，請使用自己定義的交易序號
    return [NSString stringWithFormat:@"APSDK%lld",[@(floor([[NSDate date] timeIntervalSince1970] * 1000)) longLongValue] ];
    
}

-(NSString *)getDataString
{
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    NSString *dateString = [dateFormat stringFromDate:today];
    NSLog(@"date: %@", dateString);
    
    return dateString;
    
}


@end

//
//  BasicViewController.m
//  AllPayMobileSDK iOS Example
//
//  Created by 歐付寶 on 2014/11/2.
//  Copyright (c) 2014年 歐付寶. All rights reserved.
//

#import "BasicViewController.h"
#import "APGlobal.h"


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
    if (APGlobal.environment ==APEnvironment_PRODUCT) {
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






@end

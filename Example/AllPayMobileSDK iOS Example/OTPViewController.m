//
//  OTPViewController.m
//  AllPayMobileSDK iOS Example
//
//  Created by 歐付寶 on 2014/11/3.
//  Copyright (c) 2014年 歐付寶. All rights reserved.
//

#import "OTPViewController.h"
#import "PopUpViewController.h"
#import "AllPayMobileSDK.h"

@interface OTPViewController ()
{
    BOOL getData;
    PopUpViewController *popViewController;
}
@property (weak, nonatomic) IBOutlet UITextField *otpCodeInput;

@property (weak, nonatomic) IBOutlet UINavigationBar *nav;

@property (weak, nonatomic) IBOutlet UILabel *merchantTradNoLabel;
@property (weak, nonatomic) IBOutlet UILabel *otpExpiredTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *tarceNo;

@end

@implementation OTPViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    NSLog(@"%@" , self.responseObject);
    
//    
    if(self.responseObject){
        
        self.merchantTradNoLabel.text       = [NSString stringWithFormat:@"%@" , [self.responseObject objectForKey:@"MerchantTradeNo"]];
        self.tarceNo.text                   = [NSString stringWithFormat:@"%@" , [self.responseObject objectForKey:@"TradeNo"]];
        self.otpExpiredTimeLabel.text       = [NSString stringWithFormat:@"有效時間 %@" , [self.responseObject objectForKey:@"OtpExpiredTime"]];

    }
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"確定" style:UIBarButtonItemStyleBordered target:self action:@selector(snedOTP)];


    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"關閉" style:UIBarButtonItemStyleBordered target:self action:@selector(cancel)];
    
    [self setupTap:self.view action:@selector(handleSingleTap:)];
    
    getData = NO;
}


-(void)snedOTP
{
    if (_otpCodeInput.isFirstResponder) {
        [_otpCodeInput resignFirstResponder];
        
    }
    if(getData) return;
    
    NSString *otpCode = self.otpCodeInput.text;
    
    getData = YES;
    NSMutableDictionary *attributes = [@{
                                         @"MerchantID"          : [self.responseObject objectForKey:@"MerchantID"],    //廠商編號
                                         @"MerchantTradeNo"     : [self.responseObject objectForKey:@"MerchantTradeNo"],  //廠商交易編號
                                         @"TradeNo"   : [self.responseObject objectForKey:@"TradeNo"],
                                         @"OtpCode"   : otpCode
//                                         @"PlatformID"   : @123
                                         
                                         } mutableCopy];

    

    
    [APServerOrder otp:attributes
                   action:^(id responseObject, NSError *error){
                       
                       if(error){
                           NSLog(@"Error: %@", error);
                       }else{
                           NSLog(@"%@" ,responseObject);
                           [self showResult:responseObject];
                           
                           NSInteger RtnCode = (NSInteger)[[responseObject objectForKey:@"RtnCode"] integerValue];
                           
                           if (!(RtnCode == 1 || RtnCode ==2 || RtnCode==3)) {
                               //Error
                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"(%ld) %@" , (long)RtnCode ,responseObject[@"RtnMsg"] ] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                               
                               [alert show];  // 把alert這個物件秀出來
                               getData = NO;
                               return ;
                           }
                           
                           //Do you want to do
                           
                       }
                       getData = NO;
                   }];

    
    
}

-(void)cancel
{

    if (_otpCodeInput.isFirstResponder) {
        [_otpCodeInput resignFirstResponder];
        
    }
    
    [self.navigationController popToRootViewControllerAnimated:YES];
//    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void)showResult:(id)responseObject{
    
    popViewController= [[PopUpViewController alloc] initWithNibName:@"PopUpViewController" bundle:nil];
    

    [popViewController showInView:self.tabBarController.view withText:[responseObject description] animated:YES];
}


-(void) handleSingleTap:(UITapGestureRecognizer *) tapper {
    
    if (_otpCodeInput.isFirstResponder) {
            [_otpCodeInput resignFirstResponder];

    }
}
-(void) setupTap:(UIView *) view action:(SEL)action {
    // assign custom tap event handler for given view.
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:action];
    [view addGestureRecognizer:gestureRecognizer];
    
}

@end

//
//  BehindViewController.m
//  AllPayMobileSDK iOS Example
//
//  Created by 歐付寶 on 2014/11/2.
//  Copyright (c) 2014年 歐付寶. All rights reserved.
//

#import "BehindViewController.h"
#import "AllPayMobileSDK.h"
#import "PopUpViewController.h"
#import "OTPViewController.h"


#define MerchantID @"2000031" //廠商編號
#define AppCode @"test_1234" //App代碼

//for 平台
#define platformAppCode @"test_abcd"
#define platformID @"1000139" //平台商ID 非必要

@interface BehindViewController ()
{
    
    __weak IBOutlet UIButton *btnATM;
    __weak IBOutlet UIButton *btnCVS;
    __weak IBOutlet UIButton *btnCredit;
    
    __weak IBOutlet UISegmentedControl *seqmented;
    __weak IBOutlet UITextField *phone_tf;
    __weak IBOutlet UILabel *validateMsg;
    __weak IBOutlet UIButton *btnPlatform;
    
    id sendResponseObject;
    PopUpViewController *popViewController;
    BOOL canLoadData;
     KBKeyboardHandler *keyboard;
}

@end



@implementation BehindViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    canLoadData = YES;
    //設定 運行環境 （重要）
    //預設為 APEnvironment_PRODUCT
    APOrderGlobal.environment = APEnvironment_STAGE;
//    APOrderGlobal.environment = APEnvironment_PRODUCT;
    //更新 ui label 顯示
    [self updateEnvironmentStatus];
    
    
    [self setRoundedBorder:5 borderWidth:1 color:[UIColor colorWithRed:21.0/255.0 green:128.0/255.0 blue:242.0/255.0 alpha:1.0] forButton:btnATM];
    [self setRoundedBorder:5 borderWidth:1 color:[UIColor colorWithRed:21.0/255.0 green:128.0/255.0 blue:242.0/255.0 alpha:1.0] forButton:btnCVS];
    [self setRoundedBorder:5 borderWidth:1 color:[UIColor colorWithRed:21.0/255.0 green:128.0/255.0 blue:242.0/255.0 alpha:1.0] forButton:btnCredit];
    [self setRoundedBorder:5 borderWidth:1 color:[UIColor colorWithRed:21.0/255.0 green:128.0/255.0 blue:242.0/255.0 alpha:1.0] forButton:btnPlatform];
    
    
    keyboard = [[KBKeyboardHandler alloc] init];
    keyboard.delegate = self;
    
    
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    numberToolbar.barStyle = UIBarStyleDefault;
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelNumberPad)],
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:@"確定" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)],
                           nil];
    [numberToolbar sizeToFit];
    phone_tf.inputAccessoryView = numberToolbar;
    
    
    validateMsg.hidden= YES;
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    [phone_tf becomeFirstResponder];
}

-(void)cancelNumberPad{
    [phone_tf resignFirstResponder];
//    phone_tf.text = @"";
}

-(void)doneWithNumberPad{
    [phone_tf resignFirstResponder];
    
//    [self btnCredit_clickHandle:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    phone_tf.delegate = nil;
    keyboard.delegate = nil;
    keyboard = nil;

}

- (void)keyboardSizeChanged:(CGSize)delta
{

    CGRect frame = self.view.frame;

    frame.origin.y = -delta.height/2 ;
    if(frame.origin.y>0) frame.origin.y =0;
//    NSLog(@"%f",frame.origin.y);
    self.view.frame = frame;
    [super hidePickerAnim];
    
    
}


- (void)showValidateErrorMsg
{
    
    validateMsg.hidden = NO;
    validateMsg.alpha = 0;
    [UIView animateWithDuration:.2 animations:^{
        validateMsg.alpha = 1;
    }];
    
}

- (void)hideValidateErrorMsg
{
    //    if(validateMsg.hidden) return;
    //
    //    validateMsg.hidden = NO;
    //    validateMsg.alpha = 1;
    //    [UIView animateWithDuration:.1 animations:^{
    //        validateMsg.alpha =0;
    //    } completion:^(BOOL finshed){
    //        validateMsg.hidden = YES;
    //    }];
    validateMsg.hidden = YES;
    validateMsg.text = @"";
}
-(void) handleSingleTap:(UITapGestureRecognizer *) tapper {
    [super handleSingleTap:tapper];

    if (phone_tf.isFirstResponder) {
//        [phone_tf resignFirstResponder];
        [self cancelNumberPad];
    }
}


-(void)initData{
    kAP_ATMType = @[

                    @"TAISHIN",     //"台新銀行"
                    @"HUANAN",      //華南銀行
                    @"ESUN",        //玉山銀行
                    @"FUBON",       //台北富邦銀行
                    @"BOT",         //台灣銀行
                    @"CHINATRUST",  //中國信託
                    @"FIRST",        //第一銀行
                    @"ESUN_Counter" //玉山銀行臨櫃繳款
                    ];
    kAP_CVSType = @[

                    @"CVS",     //"全家超商 ＯＫ超商 萊爾富超商“
                    @"IBON"     //統一超商
                    ];
}


-(void)showResult:(id)responseObject{
    popViewController= [[PopUpViewController alloc] initWithNibName:@"PopUpViewController" bundle:nil];
    
    //取得最上層 view
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIViewController *rootViewController = window.rootViewController;
    [popViewController showInView:rootViewController.view withText:[responseObject description] animated:YES];
}




-(void)needOTP{
    
    [self performSegueWithIdentifier:@"segue_otp" sender:nil];
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"segue_otp"])
    {
        OTPViewController *vc = [segue destinationViewController];
        if(sendResponseObject){
            vc.responseObject = [sendResponseObject mutableCopy];
            sendResponseObject = nil;
        }
        
    }
}




#pragma mark -
#pragma mark 付款方式


- (IBAction)btnATM_clickHandle:(id)sender {
    
    if(!canLoadData){
        return;
    }
    canLoadData = NO;
    NSMutableDictionary *attributes = [@{
                                         @"MerchantID"          : MerchantID,    //廠商編號
                                         @"AppCode"             : AppCode,    //App代碼
                                         @"MerchantTradeNo"     : [self getRadomTradeNo],  //廠商交易編號
                                         @"MerchantTradeDate"   : [self getDataString],  //廠商交易時間
                                         @"TotalAmount"         : @100,                   //交易金額
                                         @"TradeDesc"           : @"Allpay商城購物",         //交易描述
                                         @"ItemName"            : @"手機20元X2#隨身碟60元X1"  ,//商品名稱
                                         @"ChoosePayment"       : @"ATM",          //預設付款方式
                                         
                                         } mutableCopy];
    
    
    NSLog(@"ATM 付款 : %@" , atmLabel.text);
    NSString *subPayment = atmLabel.text;
    attributes[@"ChooseSubPayment"] = subPayment; //預設付款子項目
    
    //可設定有效時間(最長60天最短1天)可不填 (不填寫為預設3天）
    attributes[@"ExpireDate"] = @7;
    
    __unused AFHTTPRequestOperationManager *manager = [APServerOrder create:attributes
                                                            action:^(id responseObject, NSError *error){
        
        if(error){
            NSLog(@"Error: %@", error);
        }else{
            NSLog(@"%@" ,responseObject);
            
            [self showResult:responseObject];
            
        }
        canLoadData = YES;
                                            }];
    //
}


- (IBAction)btnCVS_clickHandle:(id)sender {
    
    if(!canLoadData){
        return;
    }
    canLoadData = NO;
    NSMutableDictionary *attributes = [@{
                                         @"MerchantID"          : MerchantID,    //廠商編號
                                         @"AppCode"             : AppCode,    //App代碼
                                         @"MerchantTradeNo"     : [self getRadomTradeNo],  //廠商交易編號
                                         @"MerchantTradeDate"   : [self getDataString],  //廠商交易時間
                                         @"TotalAmount"         : @100,                   //交易金額
                                         @"TradeDesc"           : @"Allpay商城購物",         //交易描述
                                         @"ItemName"            : @"手機20元X2#隨身碟60元X1"  ,//商品名稱
                                         @"ChoosePayment"       : @"CVS",          //預設付款方式
                                         
                                         } mutableCopy];
    
    
    NSLog(@"超商付款 : %@" , cvsLabel.text);
    
    NSString *subPayment = cvsLabel.text;
    attributes[@"ChooseSubPayment"] = subPayment; //預設付款子項目
    
    //交易描述 (在超商繳費平台螢幕顯示) 可不設定
    attributes[@"Desc_1"] =@"Desc_1";
    //    attributes[@"Desc_2"] =@"Desc_2";
    //    attributes[@"Desc_3"] =@"Desc_3";
    //    attributes[@"Desc_4"] =@"Desc_4";
    
    
    [APServerOrder create:attributes
                   action:^(id responseObject, NSError *error){
                       
                       if(error){
                           NSLog(@"Error: %@", error);
                       }else{
                           NSLog(@"%@" ,responseObject);
                           [self showResult:responseObject];
                       }
                       canLoadData = YES;
                   }];
    
    
}


- (IBAction)btnCredit_clickHandle:(id)sender {
    
    
    [self hideValidateErrorMsg];
    NSString* phoneRegex = @"^09[0-9]{8}$";
    NSPredicate* phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    
    BOOL isPhone = [phoneTest evaluateWithObject:phone_tf.text];
    
    if(!isPhone){
        validateMsg.text = @"手機格式錯誤";
        [self showValidateErrorMsg];
        return;
    }
    
    //call 選擇的 api
    switch ([seqmented selectedSegmentIndex]) {
        case 0:
            [self callCreditBasic];
                        break;
            
        case 1:
            [self callCreditInstallment];
            break;
    }

    
//
    
}

-(void)callCreditBasic
{
    NSMutableDictionary *attributes = [@{
                                         @"MerchantID"          : MerchantID,    //廠商編號
                                         @"AppCode"             : AppCode,    //App代碼
                                         @"MerchantTradeNo"     : [self getRadomTradeNo],  //廠商交易編號
                                         @"MerchantTradeDate"   : [self getDataString],  //廠商交易時間
                                         @"TotalAmount"         : @100,                   //交易金額
                                         @"TradeDesc"           : @"Allpay商城購物",         //交易描述
                                         @"ItemName"            : @"手機20元X2#隨身碟60元X1"  ,//商品名稱
                                         @"ChoosePayment"       : @"Credit",          //預設付款方式
                                         
                                         } mutableCopy];
    
    //範例用，請自行設定UI帶入
    attributes[@"PhoneNumber"] = phone_tf.text; //手機號碼
    attributes[@"CreditHolder"] = @"Demo"; //持卡人姓名
    attributes[@"CardNumber"] =@1111222233334444; //信用卡卡號
    attributes[@"CardValidYY"] =@"2020"; //￼有效月份
    attributes[@"CardValidMM"] =@"09"; //￼有效月份
    attributes[@"CardCVV2"] =@"456"; //卡片背面 三碼驗證碼
    
    
    NSLog(@"信用卡付款");
    NSLog(@"%@" , attributes);
    
    
    [APServerOrder create:attributes
                   action:^(id responseObject, NSError *error){
                       
                       if(error){
                           NSLog(@"Error: %@", error);
                       }else{
                           NSLog(@"%@" ,responseObject);
//                           [self showResult:responseObject];
                           
                           //檢查是否成功
                           
                           NSInteger RtnCode = (NSInteger)[[responseObject objectForKey:@"RtnCode"] integerValue];
                           //10100064 //MerchantTradeDate 格式錯誤
                           
                           if (!(RtnCode == 1 || RtnCode ==2 || RtnCode==3)) {
                               //Error
                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"(%ld) %@" , (long)RtnCode ,responseObject[@"RtnMsg"] ] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                               
                               [alert show];  // 把alert這個物件秀出來
                               canLoadData = YES;
                               return ;
                           }
                           
                           //需要OTP驗證
                           if(RtnCode==3)
                           {
                               sendResponseObject =responseObject;
                               [self needOTP];
                           }else{
                               //不需要OTP驗證 授權成功
                               [self showResult:responseObject];
                           }
                           
                           
                       }
                       canLoadData = YES;
                   }];
    
}


-(void)callCreditInstallment
{
    NSMutableDictionary *attributes = [@{
                                         @"MerchantID"          : MerchantID,    //廠商編號
                                         @"AppCode"             : AppCode,    //App代碼
                                         @"MerchantTradeNo"     : [self getRadomTradeNo],  //廠商交易編號
                                         @"MerchantTradeDate"   : [self getDataString],  //廠商交易時間
                                         @"TotalAmount"         : @100,                   //交易金額
                                         @"TradeDesc"           : @"Allpay商城購物",         //交易描述
                                         @"ItemName"            : @"手機20元X2#隨身碟60元X1"  ,//商品名稱
                                         @"ChoosePayment"       : @"Credit",          //預設付款方式
                                         
                                         } mutableCopy];
    
    //範例用，請自行設定UI帶入
    attributes[@"PhoneNumber"] = phone_tf.text; //手機號碼
    attributes[@"CreditHolder"] = @"Demo"; //持卡人姓名
    attributes[@"CardNumber"] =@1111222233334444; //信用卡卡號
    attributes[@"CardValidYY"] =@"2020"; //￼有效月份
    attributes[@"CardValidMM"] =@"09"; //￼有效月份
    attributes[@"CardCVV2"] =@"456"; //卡片背面 三碼驗證碼
    
        attributes[@"CreditInstallment"] =@3; //刷卡分期期數(可為空)
        attributes[@"InstallmentAmount"] =@150; //使用刷卡分期的付款金額 (可為空)
    //    attributes[@"Redeem"] =@"Y"; //信用卡是否使用紅利折抵。(可為空)
    
    NSLog(@"信用卡分期");
    NSLog(@"%@" , attributes);
    
    
    [APServerOrder create:attributes
                   action:^(id responseObject, NSError *error){
                       
                       if(error){
                           NSLog(@"Error: %@", error);
                       }else{
                           NSLog(@"%@" ,responseObject);
                           //                           [self showResult:responseObject];
                           
                           //檢查是否成功
                           
                           NSInteger RtnCode = (NSInteger)[[responseObject objectForKey:@"RtnCode"] integerValue];
                           //10100064 //MerchantTradeDate 格式錯誤
                           
                           if (!(RtnCode == 1 || RtnCode ==2 || RtnCode==3)) {
                               //Error
                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"(%ld) %@" , (long)RtnCode ,responseObject[@"RtnMsg"] ] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                               
                               [alert show];  // 把alert這個物件秀出來
                               canLoadData = YES;
                               return ;
                           }
                           
                           //需要OTP驗證
                           if(RtnCode==3)
                           {
                               sendResponseObject =responseObject;
                               [self needOTP];
                           }else{
                               //不需要OTP驗證 授權成功
                               [self showResult:responseObject];
                           }
                           
                           
                       }
                       canLoadData = YES;
                   }];
    
}



/*
 使用特約合作平台商代號
 可搭配以上任何模式
 以下配合 ATM
 */

- (IBAction)btnPlatform_clickHandle:(id)sender {
    
    if(!canLoadData){
        return;
    }
    canLoadData = NO;
    NSMutableDictionary *attributes = [@{
                                         @"MerchantID"          : MerchantID,    //廠商編號
                                         @"AppCode"             : platformAppCode,    //App代碼
                                         @"MerchantTradeNo"     : [self getRadomTradeNo],  //廠商交易編號
                                         @"MerchantTradeDate"   : [self getDataString],  //廠商交易時間
                                         @"TotalAmount"         : @100,                   //交易金額
                                         @"TradeDesc"           : @"Allpay商城購物",         //交易描述
                                         @"ItemName"            : @"手機20元X2#隨身碟60元X1"  ,//商品名稱
                                         @"ChoosePayment"       : @"ATM",          //預設付款方式
                                         
                                         } mutableCopy];
    
    
    NSLog(@"ATM 付款 : %@" , atmLabel.text);
    NSString *subPayment = atmLabel.text;
    attributes[@"ChooseSubPayment"] = subPayment; //預設付款子項目
    
    
    //特約平台商
    attributes[@"PlatformID"]           = platformID ;    //特約合作平台 商代號(由 AllPay 提供)
    attributes[@"PlatformChargeFee"]    = @50 ;   //特約合作平台商手續費(可為空)
    
    
    
    
    
    __unused AFHTTPRequestOperationManager *manager = [APServerOrder create:attributes
                                                                     action:^(id responseObject, NSError *error){
                                                                         
                                                                         if(error){
                                                                             NSLog(@"Error: %@", error);
                                                                         }else{
                                                                             NSLog(@"%@" ,responseObject);
                                                                             
                                                                             [self showResult:responseObject];
                                                                             
                                                                         }
                                                                         canLoadData = YES;
                                                                     }];
    
    
    
}




@end

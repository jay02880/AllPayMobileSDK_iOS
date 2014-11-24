//
//  FrontViewController.m
//  AllPayMobileSDK iOS Example
//
//  Created by 歐付寶 on 2014/10/30.
//  Copyright (c) 2014年 歐付寶. All rights reserved.
//

#import "FrontViewController.h"
#import "AllPayMobileSDK.h"



//修改成你使用的 ID
#define MerchantID @"2000031" //廠商編號
#define AppCode @"test_1234" //App代碼

//for 平台
#define platformAppCode @"test_abcd"
#define platformID @"1000139" //平台商ID 非必要



@interface FrontViewController ()
{
    __weak IBOutlet UIButton *btnALL;
    
    __weak IBOutlet UIButton *btnATM;
    __weak IBOutlet UIButton *btnCVS;
    
    __weak IBOutlet UIButton *btnCredit;
    __weak IBOutlet UIButton *btnCredit1;
    __weak IBOutlet UIButton *btnCredit2;
    __weak IBOutlet UIButton *btnPlatform;
}

@end

@implementation FrontViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    

    //設定 運行環境 （重要）
    //預設為 APEnvironment_PRODUCT
    APOrderGlobal.environment = APEnvironment_STAGE;
    //更新 ui label 顯示
    [self updateEnvironmentStatus];
    

    [self setRoundedBorder:5 borderWidth:1 color:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forButton:btnATM];
    [self setRoundedBorder:5 borderWidth:1 color:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forButton:btnCVS];
    [self setRoundedBorder:5 borderWidth:1 color:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forButton:btnALL];
    [self setRoundedBorder:5 borderWidth:1 color:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forButton:btnCredit];
    [self setRoundedBorder:5 borderWidth:1 color:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forButton:btnCredit1];
    [self setRoundedBorder:5 borderWidth:1 color:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forButton:btnCredit2];
    [self setRoundedBorder:5 borderWidth:1 color:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forButton:btnPlatform];
    
}


-(void)initData{
    kAP_ATMType = @[
                    @"ALL",
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
                    @"ALL",
                    @"CVS",     //"全家超商 ＯＫ超商 萊爾富超商“
                    @"IBON"     //統一超商
                    ];
}



#pragma mark -
#pragma mark 付款方式
//ALL
- (IBAction)BtnAll_clickHandle:(id)sender {

    
    NSDictionary *attributes = @{
                                 @"MerchantID"          : MerchantID,    //廠商編號
                                 @"AppCode"             : AppCode,    //App代碼
                                 @"MerchantTradeNo"     : [self getRadomTradeNo],       //廠商交易編號(只允許英文字母數字)
                                 @"MerchantTradeDate"   : [self getDataString],  //廠商交易時間
                                 @"TotalAmount"         : @100,                   //交易金額
                                 @"TradeDesc"           : @"Allpay商城購物",         //交易描述
                                 @"ItemName"            : @"手機20元X2#隨身碟60元X1"  ,//商品名稱
                                 @"ChoosePayment"       : @"ALL",          //預設付款方式
                                 
                                 };

    [APClientOrder getOrderViewWithAttributes:attributes];

}

//ATM付款
- (IBAction)BtnATM_clickHandle:(id)sender {
    


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
    
    //如果為ALL則 ChooseSubPayment不用帶值
    if(![atmLabel.text  isEqual: @"ALL"]){
        NSString *subPayment = atmLabel.text;
        attributes[@"ChooseSubPayment"] = subPayment; //預設付款子項目
        
    }
    
    //可設定有效時間(最長60天最短1天)可不填 (不填寫為預設3天）
    attributes[@"ExpireDate"] = @7;

    [APClientOrder getOrderViewWithAttributes:attributes];
}


//超商付款
- (IBAction)BtnCVS_clickHandle:(id)sender {
    


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
    
    //如果為ALL則 ChooseSubPayment不用帶值
    if(![cvsLabel.text  isEqual: @"ALL"]){
        NSString *subPayment = cvsLabel.text;
        attributes[@"ChooseSubPayment"] = subPayment; //預設付款子項目
    }
    
    //交易描述 (在超商繳費平台螢幕顯示) 可不設定
    attributes[@"Desc_1"] =@"Desc_1";
//    attributes[@"Desc_2"] =@"Desc_2";
//    attributes[@"Desc_3"] =@"Desc_3";
//    attributes[@"Desc_4"] =@"Desc_4";
    
    [APClientOrder getOrderViewWithAttributes:attributes];
}



//信用卡付款
- (IBAction)BtnCredit_clickHandle:(id)sender {
    
    
    
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
    
    
    NSLog(@"信用卡付款");
    
    [APClientOrder getOrderViewWithAttributes:attributes];
}

//信用卡分期
- (IBAction)BtnCreditInstallment_clickHandle:(id)sender {
    
    
    
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
    
    
    NSLog(@"信用卡 分期");
    
    attributes[@"CreditInstallment"] =@3; //刷卡分期期數
    attributes[@"InstallmentAmount"] =@150; //使用刷卡分期的付款金額
//    attributes[@"Redeem"] =@"Y"; //信用卡是否使用紅利折抵。
//    attributes[@"UnionPay"] =@"1"; //是否為銀聯卡交易
    
    [APClientOrder getOrderViewWithAttributes:attributes];
}

//信用卡定期定額
- (IBAction)BtnCreditPeriod_clickHandle:(id)sender {
    
    
    
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
    
    
    NSLog(@"信用卡 定期定額");
    
    attributes[@"PeriodAmount"] =@300; //每次授權金額
    attributes[@"PeriodType"] =@"M"; //週期種類 D:天 M:月 Y:年

    
    [APClientOrder getOrderViewWithAttributes:attributes];
}



/*
 使用特約合作平台商代號
 可搭配以上任何模式
*/

- (IBAction)BtnPlatform_clickHandle:(id)sender {
    
    NSMutableDictionary *attributes = [@{
                                 @"MerchantID"          : MerchantID,    //廠商編號
                                 @"AppCode"             : platformAppCode,    //App代碼
                                 @"MerchantTradeNo"     : [self getRadomTradeNo],       //廠商交易編號(只允許英文字母數字)
                                 @"MerchantTradeDate"   : [self getDataString],  //廠商交易時間
                                 @"TotalAmount"         : @100,                   //交易金額
                                 @"TradeDesc"           : @"Allpay商城購物",         //交易描述
                                 @"ItemName"            : @"手機20元X2#隨身碟60元X1"  ,//商品名稱
                                 @"ChoosePayment"       : @"ALL",          //預設付款方式
                                 
                                 
                               
                                 } mutableCopy];
    
    attributes[@"PlatformID"]           = platformID ;    //特約合作平台 商代號(由 AllPay 提供)
    attributes[@"PlatformChargeFee"]    = @30 ;   //特約合作平台商手續費可為空

    
    [APClientOrder getOrderViewWithAttributes:attributes];
}




@end

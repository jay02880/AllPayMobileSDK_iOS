//
//  LogisticsOrderViewController.m
//  AllPayMobileSDK iOS Example
//
//  Created by 羊小咩 on 2014/11/25.
//  Copyright (c) 2014年 羊小咩. All rights reserved.
//

#import "LogisticsOrderViewController.h"

#import "PopUpViewController.h"
#import "APLogisticsOrder.h"


//#define MerchantID @"2000031" //廠商編號
//#define AppCode @"test_1234" //App代碼


#define MerchantID @"1000139" //廠商編號
#define AppCode @"test_1234" //App代碼

@interface LogisticsOrderViewController ()
{
    __weak IBOutlet UILabel *typeLabel;
    
    __weak IBOutlet UILabel *subTypeLabel;
    __weak IBOutlet UISegmentedControl *seqmented;
    
    PopUpViewController *popViewController;

    NSArray* kAP_Type;
    NSArray* kAP_subType_CVS;
    NSArray* kAP_subType_HOME;
    
    NSString *currentUSEType;
    
    BOOL canLoadData;
    __weak IBOutlet UITextField *_logisticsIDLabel;
    NSString *lastLogisticsID;
}
@end

@implementation LogisticsOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initActionData];

    canLoadData =YES;
}


-(void)initActionData{
    
    kAP_Type =@[
                @"CVS",  //超商取貨
                @"Home",     //宅配

                ];
    kAP_subType_CVS =@[
                @"FAMIC2C",     //全家物流(C2C)
                @"UNIMARTC2C",     //統一超商物流(C2C)
                ];
    kAP_subType_HOME =@[
                       @"TCAT",  //黑貓物流
                       ];
    
    
    //Label Click
    [typeLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chaneType:)]];
    [subTypeLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chaneSubType:)]];
    
    
    typeLabel.userInteractionEnabled = YES;
    subTypeLabel.userInteractionEnabled = YES;
    
    
    _pickerData = [kAP_Type mutableCopy];
    typeLabel.text =kAP_Type[0];
    currentUSEType = typeLabel.text;
    
    subTypeLabel.text =kAP_subType_CVS[0];
    
    
    
    // PICKER
    self.picker.dataSource = self;
    self.picker.delegate = self;
    self.picker.hidden=YES;
    
    
    //點擊背景隱藏 picker
    [self setupTap:self.view action:@selector(handleSingleTap:)];
    
}
- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    

    [super pickerView:thePickerView didSelectRow:row inComponent:component];
    if([usedLableTarget isEqual:typeLabel])
    {
        if(![currentUSEType isEqualToString:typeLabel.text]){
            currentUSEType = typeLabel.text;
            
            if ([currentUSEType isEqualToString:@"CVS"]) {
                subTypeLabel.text =kAP_subType_CVS[0];
            }else{
                subTypeLabel.text =kAP_subType_HOME[0];
            }
        }
        
    }
    usedLableTarget = nil;
}
-(void)chaneType:(UITapGestureRecognizer *)sender {
    
    if(self.picker.hidden==YES){
        usedLableTarget = (UILabel*)[sender view];
        self.picker.hidden=NO;
        _pickerData = [kAP_Type mutableCopy];
        [self.picker reloadAllComponents];
        
        NSUInteger index =[kAP_Type indexOfObject:usedLableTarget.text];
        [self.picker selectRow:index inComponent:0 animated:NO];
        [self showPickerAnim];
    }
    
}

-(void)chaneSubType:(UITapGestureRecognizer *)sender {
    
    if(self.picker.hidden==YES){
        usedLableTarget = (UILabel*)[sender view];
        self.picker.hidden=NO;
        
        
        NSMutableArray * useArr;
        
        if([typeLabel.text isEqualToString:@"CVS"]){
            useArr = [kAP_subType_CVS mutableCopy];
        }else{
            useArr = [kAP_subType_HOME mutableCopy];

        }
        _pickerData = useArr ;
        [self.picker reloadAllComponents];
        
        NSUInteger index =[useArr indexOfObject:usedLableTarget.text];
        if(index == NSNotFound){
            [self.picker selectRow:0 inComponent:0 animated:NO];
        }else{
            [self.picker selectRow:index inComponent:0 animated:NO];
        }
        
        [self showPickerAnim];
    }
    
}


//建立訂單
- (IBAction)createOrderBtnClick:(id)sender {
    
    
    if(!canLoadData){
        return;
    }
    canLoadData = NO;
    
       NSString *IsCollection = [seqmented selectedSegmentIndex] == 0 ? @"N" : @"Y";
    
    NSMutableDictionary *attributes = [@{
                                         @"MerchantID"          : MerchantID,    //廠商編號
                                         @"AppCode"             : AppCode,    //App代碼
                                         @"MerchantTradeNo"     : [self getRadomTradeNo],  //廠商交易編號
                                         @"MerchantTradeDate"   : [self getDataString],  //廠商交易時間
                                         @"LogisticsType"       : typeLabel.text,     //物流類型
                                         @"LogisticsSubType"    : subTypeLabel.text,     //物流子類型
                                         @"GoodsAmount"         : @500,     //商品金額
                                         @"IsCollection"        :IsCollection,  //是否代收貨款(可為空) (目前宅配不支援代收貨款，所以LogisticsType為Home時，請勿帶Y)
                                         @"GoodsName"           :@"八寶粥一箱", //(可為空)
                                         @"SenderName"          :@"李小寶", //寄件人姓名
                                         @"SenderPhone"         :@"0988123456", //寄件人電話
                                         @"SenderCellPhone"         :@"", //寄件人手機 (可為空)
                                         @"ReceiverName"          :@"李小妹", //收件人姓名
                                         @"ReceiverPhone"         :@"", //收件人電話 (可為空)
                                         @"ReceiverEmail"         :@"lab@allpay.com.tw", //收件人Mail
                                         @"ReceiverCellPhone"         :@"0988123456", //收件人手機
                                         @"TradeDesc"           :@"", //交易描述
                                         @"Remark"           :@"", //備註
                                         } mutableCopy];
    
    
    if([typeLabel.text isEqualToString:@"HOME"]){
        
        //寄件人郵遞區號
        attributes[@"SenderZipCode"] = @"12300";
         //寄件人地址
        attributes[@"SenderAddress"] = @"台北市南港區";
         //收件人郵遞區號
        attributes[@"ReceiverZipCode"] = @"12300";
        //收件人地址
        attributes[@"ReceiverAddress"] = @"台北市信義區";
        //溫層 0001:常溫 (預設值)  0002:冷藏    0003:冷凍
        attributes[@"Temperature"] = @"0001";
        //距離 00:同縣市 (預設值)  01:外縣市   02:離島
        attributes[@"Distance"] = @"00";
        //規格   0001: 60cm (預設值) 0002: 90cm   0003: 120cm  0004: 150cm
        attributes[@"Specification"] = @"0001";
         //預定取件時段  1: 9~12   2: 12~17    3: 17~20    4: 不限時(固定4不限時)
        attributes[@"ScheduledPickupTime"] = @"2";
        //預定送達時段（可為空） 1: 9~12   2: 12~17   3: 17~20  4:不限時   5:20~21(需限定區域)
        attributes[@"ScheduledDeliveryTime"] = @"4";
        
    }else{
        
        //收件人門市代號
        NSString *storeID = ([subTypeLabel.text isEqual:@"FAMIC2C"]) ? @"F001168" : @"991182";
        
        NSLog(@"%@" , storeID);
        
        attributes[@"ReceiverStoreID"] = storeID;  //(ID 取得方式請參考電子地圖 APExpressMap)
        
        //退貨門市代號（可為空）
//        attributes[@"ReturnStoreID"] = storeID;
    }


    [APLogisticsOrder create:attributes
                   action:^(id responseObject, NSError *error){
                       
                       if(error){
                           NSLog(@"Error: %@", error);
                       }else{
                           
                           
                           if (responseObject[@"RtnCode"] == 0 || [responseObject[@"RtnCode"] isEqualToString:@"0"]) {
                               UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:responseObject[@"RtnMsg"] delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil, nil];
                               [alertView show];
                               canLoadData = YES;
                               return ;
                           }
                           
                           NSLog(@"%@" ,responseObject);
                           [self showResult:responseObject];
                           
                           [self setLogisticsID: responseObject[@"AllPayLogisticsID"]];
                           
                       }
                       canLoadData = YES;
                   }];
    
    //

}

-(void)setLogisticsID:(NSString *)logisticsID
{
    lastLogisticsID = logisticsID;
    _logisticsIDLabel.text = logisticsID;
}


//取消訂單
- (IBAction)cancelBtnClick:(id)sender {
    
    if (_logisticsIDLabel.text == nil || [_logisticsIDLabel.text isEqualToString:@"" ]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"尚未取得編號" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    
    
    
    if(!canLoadData){
        return;
    }
    canLoadData = NO;
    
    
    NSMutableDictionary *attributes = [@{
                                         @"MerchantID"          : MerchantID,    //廠商編號
                                         @"AllPayLogisticsID"   : _logisticsIDLabel.text,    //AllPay的物流交易編號
                                         @"SenderName"          : @"小強", //退貨人姓名
                                         @"SenderPhone"          : @"0912345678", //退貨人電話
                                         @"LogisticsType"       : @"Home", //物流類型
                                         } mutableCopy];
    
    
    
    
    [APLogisticsOrder cancel:attributes
                      action:^(id responseObject, NSError *error){
                          
                          if(error){
                              NSLog(@"Error: %@", error);
                          }else{
                               NSLog(@"%@" ,responseObject);
                              NSLog(@"RtnMsg: %@", responseObject[@"RtnMsg"]);
                              
                              if ([responseObject[@"RtnCode"]  isEqual: @1] || [responseObject[@"RtnCode"] isEqualToString:@"1"]){
                                  [self showResult:responseObject];
                                  
                                  
                              }else{
                                  UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:responseObject[@"RtnMsg"] delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil, nil];
                                  [alertView show];
                                  return ;
                              }
                              
                              
                          }
                          canLoadData = YES;
                      }];
    
    
    
}


-(void)showResult:(id)responseObject{
    popViewController= [[PopUpViewController alloc] initWithNibName:@"PopUpViewController" bundle:nil];
    
    //取得最上層 view
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIViewController *rootViewController = window.rootViewController;
    [popViewController showInView:rootViewController.view withText:[responseObject description] animated:YES];
}



@end

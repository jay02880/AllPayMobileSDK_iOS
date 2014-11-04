AllPayMobileSDK
=========

AllPay Mobile SDK 訂單幕前、幕後產生
請配合使用 AllPay 廠商手機金流介接技術文件

 - web view 產生訂單
 - api 產生訂單
 - otp 簡訊驗證

Version
-----------

1.0

Depends
-----------
相依套件

AFNetworking (https://github.com/AFNetworking/AFNetworking)

How to Use
-----------
如何在你的專案使用 AllPay Mobile SDK 

* 下載 AllPayMobileSDK 
* 下載相依套件
* 將下載的檔案引用到你Xcode 專案內

Usage
--------------

取得預要傳送資料
```objective-c
NSMutableDictionary *attributes = [@{
    @"MerchantID"          : MerchantID,    //廠商編號
    @"AppCode"             : AppCode,    //App代碼
    @"MerchantTradeNo"     : [self getRadomTradeNo],  //廠商交易編號
    @"MerchantTradeDate"   : [self getDataString],  //廠商交易時間
    @"TotalAmount"         : @100,                   //交易金額
    @"TradeDesc"           : @"Allpay商城購物",         //交易描述
    @"ItemName"            : @"手機20元X2#隨身碟60元X1"  ,//商品名稱
    @"ChoosePayment"       : @"ALL",          //預設付款方式
 } mutableCopy];
```

 

ClientOrder 產生訂單
```objective-c
    [APClientOrder getOrderViewWithAttributes:attributes];
```



ServerOrder 產生訂單
```objective-c
[APServerOrder create:attributes
                   action:^(id responseObject, NSError *error){
                       
                       if(error){
                           //失敗
                           NSLog(@"Error: %@", error);
                       }else{
                           //成功
                           NSLog(@"%@" ,responseObject);
                       }
                   }];
```


ServerOrder OTP 驗證
```objective-c
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
                           UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" 
                                                                     message:[NSString stringWithFormat:@"(%ld) %@" , (long)RtnCode ,responseObject[@"RtnMsg"] ] 
                                                                     delegate:self 
                                                                     cancelButtonTitle:@"OK" 
                                                                     otherButtonTitles: nil];
                           
                           [alert show];  // 把alert這個物件秀出來
                           getData = NO;
                           return ;
                       }
                       
                       //Do you want to do
                       
                   }

               }];
```




License
----

MIT

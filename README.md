AllPayMobileSDK
=========

AllPay Mobile SDK 訂單幕前、幕後產生
請配合使用 AllPay 廠商手機金流介接技術文件 或 歐付寶物流進退貨規範手冊

#####金流
 - web view 產生訂單
 - api 產生訂單
 - otp 簡訊驗證

#####物流
- 電子地圖
- 建立物流訂單
- 取消物流訂單


Version
-----------
1.1
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
####金流
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

####物流

電子地圖
```objective-c
    
    NSDictionary *attributes = @{
                                 @"MerchantID"          : MerchantID,    //廠商編號
                                 @"MerchantTradeNo"     : [self getRadomTradeNo],       //廠商交易編號(只允許英文字母數字)
                                 @"LogisticsType"       : @"CVS",   //物流類型
                                 @"LogisticsSubType"   : typeLabel.text, //物流子類型
                                 @"IsCollection" :@"N", //是否代收貨款   Y N
                                 @"ExtraData": @"msg" , //額外資訊 (可為空）
                                 
                                 };

    [APExpressMap getWebViewWithDelegate:self attributes:attributes];
```



建立物流訂單 - 宅配
```objective-c
NSMutableDictionary *attributes = [@{
                                         @"MerchantID"          : MerchantID,    //廠商編號
                                         @"AppCode"             : AppCode,    //App代碼
                                         @"MerchantTradeNo"     : [self getRadomTradeNo],  //廠商交易編號
                                         @"MerchantTradeDate"   : [self getDataString],  //廠商交易時間
                                         @"LogisticsType"       : @"Home",     //物流類型
                                         @"LogisticsSubType"    : @"TCAT",     //物流子類型
                                         @"GoodsAmount"         : @500,     //商品金額
                                         @"IsCollection"        :@"N",  //是否代收貨款(可為空) (目前宅配不支援代收貨款，所以LogisticsType為Home時，請勿帶Y)
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
        
[APLogisticsOrder create:attributes
                   action:^(id responseObject, NSError *error){
                    //do something 
                   }];
```


建立物流訂單 - 超商取貨
```objective-c
NSMutableDictionary *attributes = [@{
                                         @"MerchantID"          : MerchantID,    //廠商編號
                                         @"AppCode"             : AppCode,    //App代碼
                                         @"MerchantTradeNo"     : [self getRadomTradeNo],  //廠商交易編號
                                         @"MerchantTradeDate"   : [self getDataString],  //廠商交易時間
                                         @"LogisticsType"       : @"CVS",     //物流類型
                                         @"LogisticsSubType"    : @"UNIMARTC2C",     //物流子類型
                                         @"GoodsAmount"         : @500,     //商品金額
                                         @"IsCollection"        :@"N",  //是否代收貨款(可為空) (目前宅配不支援代收貨款，所以LogisticsType為Home時，請勿帶Y)
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

        attributes[@"ReceiverStoreID"] = storeID;  //(ID 取得方式請參考電子地圖 APExpressMap
//      attributes[@"ReturnStoreID"] = storeID; //退貨門市代號（可為空）
        
        
[APLogisticsOrder create:attributes
                   action:^(id responseObject, NSError *error){
                    //do something 
                   }];
```


取消物流訂單
```objective-c
NSMutableDictionary *attributes = [@{
                                         @"MerchantID"          : MerchantID,    //廠商編號
                                         @"AllPayLogisticsID"   : @"AllPay的物流交易編號" ,
                                         @"SenderName"          : @"小強", //退貨人姓名
                                         @"SenderPhone"          : @"0912345678", //退貨人電話
                                         @"LogisticsType"       : @"Home", //物流類型
                                         } mutableCopy];

    [APLogisticsOrder cancel:attributes
                      action:^(id responseObject, NSError *error){
                      //do something 
                   }];

```




ChangeLog
-----------
1.1 歐付寶物流
1.0 歐付寶金流

License
----

MIT

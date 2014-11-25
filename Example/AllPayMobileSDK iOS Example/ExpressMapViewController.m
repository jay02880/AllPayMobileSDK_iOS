//
//  ExpressMapViewController.m
//  AllPayMobileSDK iOS Example
//
//  Created by 羊小咩 on 2014/11/24.
//  Copyright (c) 2014年 羊小咩. All rights reserved.
//

#import "ExpressMapViewController.h"

#import "PopUpViewController.h"

//修改成你使用的 ID
#define MerchantID @"2000031" //廠商編號
#define AppCode @"test_1234" //App代碼

@interface ExpressMapViewController ()
{
    PopUpViewController *popViewController;
    __weak IBOutlet UISegmentedControl *seqmented;
}
@end

@implementation ExpressMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initActionData];
}

-(void)initActionData{
    
    kAP_Type =@[
                @"UNIMARTC2C",  //統一超 商寄貨便
                @"FAMIC2C",     //"全家店到店"
                @"UNIMART",      //統一超商
                @"FAMI",        //全家
                ];
    
    
    
    //Label Click
    [typeLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chaneType:)]];

    
    typeLabel.userInteractionEnabled = YES;

    
    
    _pickerData = [kAP_Type mutableCopy];
    
    
    typeLabel.text =kAP_Type[0];

    
    // PICKER
    self.picker.dataSource = self;
    self.picker.delegate = self;
    self.picker.hidden=YES;
    
    
    //點擊背景隱藏 picker
    [self setupTap:self.view action:@selector(handleSingleTap:)];
    [self updateEnvironmentStatus];
    
}

-(void)updateEnvironmentStatus
{
    if (APGlobal.environment ==APEnvironment_PRODUCT) {
        runVerLabel.text = @"Run Ver : Stage(正式環境)";
    } else {
        runVerLabel.text = @"Run Ver : Stage(測試環境)";
    }
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


- (IBAction)callBtnClickHandle:(id)sender {
    
    
    NSString *IsCollection = [seqmented selectedSegmentIndex] == 0 ? @"N" : @"Y";
    
    NSDictionary *attributes = @{
                                 @"MerchantID"          : MerchantID,    //廠商編號
                                 @"MerchantTradeNo"     : [self getRadomTradeNo],       //廠商交易編號(只允許英文字母數字)
                                 @"LogisticsType"       : @"CVS",   //物流類型
                                 @"LogisticsSubType"   : typeLabel.text, //物流子類型
                                 @"IsCollection" :IsCollection, //是否代收貨款
                                 @"ExtraData": @"msg" , //額外資訊 (可為空）
                                 
                                 };
    

    [APExpressMap getWebViewWithDelegate:self attributes:attributes];
    
}


-(void)getExpressMap:(NSDictionary *)aDict
{
     NSLog(@"%@" , aDict);
    
    [self showResult:aDict];
}



-(void)showResult:(id)responseObject{
    popViewController= [[PopUpViewController alloc] initWithNibName:@"PopUpViewController" bundle:nil];
    
    //取得最上層 view
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIViewController *rootViewController = window.rootViewController;
    [popViewController showInView:rootViewController.view withText:[responseObject description] animated:YES];
}


@end

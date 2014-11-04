//
//  APClientOrderViewCtrl.m
//  AllPayMobileSDK iOS Example
//
//  Created by 歐付寶 on 2014/11/3.
//  Copyright (c) 2014年 歐付寶. All rights reserved.
//

#import "APClientOrderViewCtrl.h"
#import "NSDictionary+APURLEncoding.h"
#import "APClientOrder.h"

@interface APClientOrderViewCtrl()
{
    NSArray *nib;
    NSString *queryString;
}
@end
@implementation APClientOrderViewCtrl



-(instancetype) initDefaultXib:(NSDictionary *)attributes
{
    if(self = [super init]){
                nib =[[NSBundle mainBundle] loadNibNamed:@"APClientOrderViewCtrl" owner:self options:nil];
//        [[NSBundle mainBundle] loadNibNamed:@"APWebView" owner:self options:nil] ;
        
        queryString = [attributes urlEncodedString];
        NSLog(@"%@" , queryString);
    }
    return self;
    
}

- (void)loadView {
//    [super loadView];
    //    UIView *coustomView= [nib objectAtIndex:0];
    //    nib = nil;
    //    self.view  = coustomView;
    //    self.view = [[nib objectAtIndex:0] view];
}
-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    
    //    NSLog(@"%@",@"loadView");
    //    NSLog(@"%@",self.navBar);
    //    NSLog(@"%@",self.webView);
    self.activityIndicator.hidden=YES;
    
    self.navigationItem.title= @"AllPay";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"關閉" style:UIBarButtonItemStyleBordered target:self action:@selector(cancel)];
    
    [self postData];
    
    
}


//取消交易
-(void)cancel{
    
    UIViewController *rootViewController =[APClientOrder getRootViewController];
    [rootViewController dismissViewControllerAnimated:YES completion:nil];
}

-(void)postData
{
    
    NSURL *url = [NSURL URLWithString:[APClientOrder getAPIURLString]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: url];
    [request setHTTPMethod: @"POST"];
    [request setHTTPBody: [queryString dataUsingEncoding: NSUTF8StringEncoding]];
    [self.webView loadRequest: request];
}



//#pragma mark - UIWebView
//- (void)webViewDidStartLoad:(UIWebView *)webView
//{
//    self.activityIndicator.hidden=NO;
//    [self.activityIndicator startAnimating];
//}
//- (void)webViewDidFinishLoad:(UIWebView *)webView
//{
//    self.activityIndicator.hidden=YES;
//    [self.activityIndicator stopAnimating];
//
//    
//}


@end
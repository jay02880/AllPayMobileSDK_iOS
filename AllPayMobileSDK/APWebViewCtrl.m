//
//  APClientOrderViewCtrl.m
//  AllPayMobileSDK iOS Example
//
//  Created by 歐付寶 on 2014/11/3.
//  Copyright (c) 2014年 歐付寶. All rights reserved.
//

#import "APWebViewCtrl.h"
#import "NSDictionary+APURLEncoding.h"
#import "APClientOrder.h"

@interface APWebViewCtrl()
{
    NSArray *nib;
    NSString *queryString;

}
@end
@implementation APWebViewCtrl



-(instancetype) initDefaultXib:(NSDictionary *)attributes
{
    if(self = [super init]){
                nib =[[NSBundle mainBundle] loadNibNamed:@"APWebViewCtrl" owner:self options:nil];
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
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(cancel)];
    
    [self postData];
    
    
}

//取消交易
-(void)cancel{
    
    UIViewController *rootViewController =[[self class] getRootViewController];
    [rootViewController dismissViewControllerAnimated:YES completion:nil];
}

-(void)postData
{
    NSURL *url = [NSURL URLWithString:self.url];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: url];
    [request setHTTPMethod: @"POST"];
    [request setHTTPBody: [queryString dataUsingEncoding: NSUTF8StringEncoding]];
    [self.webView loadRequest: request];
}





+(UIViewController *)getRootViewController
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIViewController *rootViewController = window.rootViewController;
    return rootViewController;
}

//
+(void)getWebViewWithURL:(NSString * )url attributes:(NSDictionary *)attributes
{
    
    APWebViewCtrl *viewCtrl = [[APWebViewCtrl alloc] initDefaultXib:attributes];
    
    viewCtrl.url = url;
    
    UINavigationController *nav = [[UINavigationController alloc]
                                   initWithRootViewController:viewCtrl];
    
    UIViewController *rootViewController =[self getRootViewController];
    [rootViewController presentViewController:nav animated:YES completion:nil];
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
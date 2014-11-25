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



//-(instancetype) initDefaultXib:(NSDictionary *)attributes
//{
//    if(self = [super init]){
//                nib =[[NSBundle mainBundle] loadNibNamed:@"APWebViewCtrl" owner:self options:nil];
//        
////        [[NSBundle mainBundle] loadNibNamed:@"APWebView" owner:self options:nil] ;
//        
//        queryString = [attributes urlEncodedString];
//        NSLog(@"%@" , queryString);
//        
//
//    }
//    return self;
//}


- (instancetype)initWithAttributes:(NSDictionary *)attributes {
    if (self = [super initWithNibName:nil bundle:nil]) {
        // set up ivars and other stuff here.
        queryString = [attributes urlEncodedString];
    }
    return self;
}




- (void)viewDidLoad {
    [super viewDidLoad];
    
    
//     NSLog(@"%@",@"viewDidLoad");
    
    nib =[[NSBundle mainBundle] loadNibNamed:@"APWebViewCtrl" owner:self options:nil];
    

    
    //    NSLog(@"%@",self.navBar);
    //    NSLog(@"%@",self.webView);
    self.activityIndicator.hidden=YES;
    self.webView.delegate = self;
    self.navigationItem.title= @"AllPay";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(cancel)];
    
    NSLog(@"%@",queryString);

    
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
    
    NSLog(@"%@" ,url);
    
    [self.webView loadRequest: request];
}





+(UIViewController *)getRootViewController
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIViewController *rootViewController = window.rootViewController;
    return rootViewController;
}

//
+(instancetype)getWebViewWithURL:(NSString * )url attributes:(NSDictionary *)attributes
{
    
    APWebViewCtrl *viewCtrl = [[APWebViewCtrl alloc] initWithAttributes:attributes];
    
    viewCtrl.url = url;
    
    UINavigationController *nav = [[UINavigationController alloc]
                                   initWithRootViewController:viewCtrl];
    
    UIViewController *rootViewController =[self getRootViewController];
    [rootViewController presentViewController:nav animated:YES completion:nil];
    return viewCtrl;
}

+(instancetype)getWebViewWithDelegate:(id)delegate URL:(NSString * )url attributes:(NSDictionary *)attributes;
{
    APWebViewCtrl *viewCtrl = [[self class] getWebViewWithURL:url attributes:attributes];
    viewCtrl.delegate = delegate;
    
    return viewCtrl;
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

- (BOOL)webView:(UIWebView *)webView
shouldStartLoadWithRequest:(NSURLRequest *)request
 navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *target = [[request URL] absoluteString];
    
    NSRange checkApp = [target rangeOfString: @"apmsdk://"];
    NSLog(@"Catch:%@",target);

    if( checkApp.location != NSNotFound )
    {
        NSMutableString *mString = [NSMutableString stringWithString:target];
        
        [mString replaceCharactersInRange:[target rangeOfString: @"/?"] withString:@"/"];
        [mString replaceCharactersInRange:checkApp withString:@""];
        
        NSMutableArray *action = [NSMutableArray arrayWithArray:[mString componentsSeparatedByString:@"/"]];
        NSLog(@"action: \n  %@  " ,action);
        
        if([action[0] isEqualToString:@"ExpressMap"]){
            NSDictionary *dict = [[self class] dictionaryWithQueryString:action[1]];

            NSLog(@"%@" , dict);
            if ([self.delegate respondsToSelector:@selector(getExpressMap:)]) {
                  [self.delegate performSelector:@selector(getExpressMap:) withObject:dict];
                
                
            };
            [self cancel];
        }
        

        return NO;
    }
    
    //讓其他的通訊協定可以正常運作 ex mailto
    //注意itms 只有實機可跑
    NSURL *url = request.URL;
    if (![url.scheme isEqual:@"http"] && ![url.scheme isEqual:@"https"]) {
        if ([[UIApplication sharedApplication]canOpenURL:url]) {
            [[UIApplication sharedApplication]openURL:url];
            return NO;
        }
    }
    
    return YES;

}

+ (NSDictionary *)dictionaryWithQueryString:(NSString *)queryString
{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    NSArray *pairs = [queryString componentsSeparatedByString:@"&"];
    
    for (NSString *pair in pairs)
    {
        NSArray *elements = [pair componentsSeparatedByString:@"="];
        if (elements.count == 2)
        {
            NSString *key = elements[0];
            NSString *value = elements[1];
            NSString *decodedKey = [self URLDecodedString:key];
            NSString *decodedValue = [self URLDecodedString:value ];
            
            if (![key isEqualToString:decodedKey])
                key = decodedKey;
            
            if (![value isEqualToString:decodedValue])
                value = decodedValue;
            
            [dictionary setObject:value forKey:key];
        }
    }
    
    return [NSDictionary dictionaryWithDictionary:dictionary];
}


+ (NSString *)URLEncodedString:(NSString *)string
{
    //CFSTR("*'();:@&=+$,/?%#[]~"),
    __autoreleasing NSString *encodedString;
    encodedString = (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(
                                                                                          NULL,
                                                                                          (__bridge CFStringRef)string,
                                                                                          NULL,
                                                                                          (CFStringRef)@":!*();@/&?#[]+$,='%’\"",
                                                                                          kCFStringEncodingUTF8
                                                                                          );
    return encodedString;
}

+ (NSString *)URLDecodedString:(NSString *)string
{
    __autoreleasing NSString *decodedString;
    decodedString = (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(
                                                                                                          NULL,
                                                                                                          (__bridge CFStringRef)string,
                                                                                                          CFSTR(""),
                                                                                                          kCFStringEncodingUTF8
                                                                                                          );
    return decodedString;
}


@end
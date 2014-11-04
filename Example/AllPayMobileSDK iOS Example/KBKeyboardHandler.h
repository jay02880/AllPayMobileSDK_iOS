//
//  KBKeyboardHandler.h
//  AllPayMobileSDK iOS Example
//
//  Created by 歐付寶 on 2014/11/2.
//  Copyright (c) 2014年 歐付寶. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@protocol KBKeyboardHandlerDelegate;

@interface KBKeyboardHandler : NSObject

- (id)init;


@property(nonatomic, weak) id<KBKeyboardHandlerDelegate> delegate;
@property(nonatomic) CGRect frame;

@end

@protocol KBKeyboardHandlerDelegate

- (void)keyboardSizeChanged:(CGSize)delta;

@end

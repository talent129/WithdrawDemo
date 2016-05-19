//
//  NSString+Alert.m
//  WithdrawDemo
//
//  Created by iMac on 16/5/19.
//  Copyright © 2016年 Cai. All rights reserved.
//

#import "NSString+Alert.h"
#import <UIKit/UIKit.h>

@interface NSString ()<UIAlertViewDelegate>

@end

@implementation NSString (Alert)

- (BOOL)alert
{
    if (self.length) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:self message:nil delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
        [alert show];
        return YES;
    }
    return NO;
}


@end

//
//  PXCustomization.m
//  PXAlertViewDemo
//
//  Created by liubiao on 14-4-8.
//  Copyright (c) 2014年 panaxiom. All rights reserved.
//

#import "PXAlertViewStyleOption.h"

@implementation PXAlertViewStyleOption
@synthesize windowTintColor;
@synthesize backgroundColor;
@synthesize titleColor;
@synthesize titleFont;
@synthesize messageColor;
@synthesize messageFont;
@synthesize cancelButtonBackgroundColor;
@synthesize otherButtonBackgroundColor;

+(PXAlertViewStyleOption*)alertViewStyleOptionWithStyle:(PXAlertViewStyle)alertViewStyle{
    PXAlertViewStyleOption *styleOption=[[PXAlertViewStyleOption alloc] init];
    [styleOption setWindowTintColor:[UIColor colorWithRed:94/255.0 green:196/255.0 blue:221/255.0 alpha:0.25]];
    [styleOption setBackgroundColor:[UIColor colorWithRed:255/255.0 green:206/255.0 blue:13/255.0 alpha:1.0]];
    
    [styleOption setTitleFont:[UIFont fontWithName:@"Zapfino" size:15.0f]];
    [styleOption setTitleColor:[UIColor darkGrayColor]];
    
    [styleOption setMessageColor:[UIColor cyanColor]];
    [styleOption setMessageFont:[UIFont systemFontOfSize:14.0]];
    
    [styleOption setCancelButtonBackgroundColor:[UIColor redColor]];
    [styleOption setOtherButtonBackgroundColor:[UIColor blueColor]];
    
    return styleOption;
}
@end

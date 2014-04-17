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
@synthesize alertViewBgColor;
@synthesize alertViewBgimage;
@synthesize titleColor;
@synthesize titleFont;
@synthesize messageColor;
@synthesize messageFont;
@synthesize cancelButtonBackgroundColor;
@synthesize otherButtonBackgroundColor;
@synthesize lineColor=_lineColor;

+(PXAlertViewStyleOption*)alertViewStyleOptionWithStyle:(PXAlertViewStyle)alertViewStyle{
    //默认样式
    PXAlertViewStyleOption *styleOption=[[PXAlertViewStyleOption alloc] init];
    styleOption.windowTintColor=[UIColor colorWithWhite:0 alpha:0.25];
    styleOption.alertViewBgColor=[UIColor whiteColor];
    
    styleOption.titleFont=[UIFont boldSystemFontOfSize:17];
    styleOption.titleColor=[UIColor blackColor];
    
    styleOption.messageColor=[UIColor blackColor];
    styleOption.messageFont=[UIFont systemFontOfSize:15.0];
    
    styleOption.cancelButtonTitleColor=[UIColor colorWithRed:0.0 green:0.48 blue:1 alpha:1];
    styleOption.cancelButtonTitleHilightedColor=[UIColor colorWithRed:0.0 green:0.48 blue:1 alpha:1];
    styleOption.cancelButtonBackgroundColor=[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.1];

    styleOption.otherButtonTitleColor=[UIColor colorWithRed:0.0 green:0.48 blue:1 alpha:1];
    styleOption.otherButtonTitleHilightedColor=[UIColor colorWithRed:0.0 green:0.48 blue:1 alpha:1];
    styleOption.otherButtonBackgroundColor=[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.1];
    
    styleOption.lineColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.3];
   
    //黑色风格
    if (alertViewStyle==PXAlertViewStyleBlack){
        styleOption.windowTintColor=[UIColor colorWithWhite:0 alpha:0.25];
        styleOption.alertViewBgColor=[UIColor colorWithWhite:0.25 alpha:1];
        
        styleOption.titleFont=[UIFont boldSystemFontOfSize:17];
        styleOption.titleColor=[UIColor whiteColor];
        
        styleOption.messageColor=[UIColor whiteColor];
        styleOption.messageFont=[UIFont systemFontOfSize:15];
        
        styleOption.cancelButtonTitleColor=[UIColor whiteColor];
        styleOption.cancelButtonTitleHilightedColor=[UIColor blackColor];
        styleOption.cancelButtonBackgroundColor=[UIColor colorWithRed:94/255.0 green:196/255.0 blue:221/255.0 alpha:1.0];

        styleOption.otherButtonTitleColor=[UIColor whiteColor];
        styleOption.otherButtonTitleHilightedColor=[UIColor blackColor];
        styleOption.otherButtonBackgroundColor=[UIColor colorWithRed:94/255.0 green:196/255.0 blue:221/255.0 alpha:1.0];
        
        styleOption.lineColor = [UIColor colorWithWhite:0.90 alpha:0.3];
    }
    //紫色风格
    else if (alertViewStyle==PXAlertViewStyleViolet){
        styleOption.windowTintColor=[UIColor colorWithWhite:0 alpha:0.25];
        styleOption.alertViewBgColor=[UIColor whiteColor];
        
        styleOption.titleFont=[UIFont boldSystemFontOfSize:17];
        styleOption.titleColor=[UIColor blackColor];
        
        styleOption.messageColor=[UIColor blackColor];
        styleOption.messageFont=[UIFont systemFontOfSize:15.0];
        
        styleOption.cancelButtonTitleColor=[UIColor colorWithRed:0.0 green:0.48 blue:1 alpha:1];
        styleOption.cancelButtonTitleHilightedColor=[UIColor colorWithRed:0.0 green:0.48 blue:1 alpha:1];
        styleOption.cancelButtonBackgroundColor=[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.1];
        
        styleOption.otherButtonTitleColor=[UIColor colorWithRed:0.0 green:0.48 blue:1 alpha:1];
        styleOption.otherButtonTitleHilightedColor=[UIColor colorWithRed:0.0 green:0.48 blue:1 alpha:1];
        styleOption.otherButtonBackgroundColor=[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.1];
        
        styleOption.lineColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.3];
    }
    
    return styleOption;
}
@end

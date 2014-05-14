//
//  PXCustomization.m
//  PXAlertViewDemo
//
//  Created by liubiao on 14-4-8.
//  Copyright (c) 2014年 panaxiom. All rights reserved.
//

#import "PXAlertViewStyleOption.h"

@interface PXAlertViewStyleOption ()

@property (nonatomic, assign,readwrite) BOOL btnStyle;//按钮样式
@property (nonatomic, assign,readwrite) PXAVStyle alertViewStyle;//弹框样式

@end

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
@synthesize btnStyle=_btnStyle;
@synthesize otherButtonBackgroundHilightedColor=_otherButtonBackgroundHilightedColor;
@synthesize cancelButtonBackgroundHilightedColor=_cancelButtonBackgroundHilightedColor;
@synthesize otherButtonBackgroundImage=_otherButtonBackgroundImage;
@synthesize otherButtonBackgroundHilightedImage=_otherButtonBackgroundHilightedImage;

+(PXAlertViewStyleOption*)alertViewStyleOptionWithStyle:(PXAVStyle)alertViewStyle btnStyle:(BOOL)btnStyle{
    PXAlertViewStyleOption *styleOption=[[PXAlertViewStyleOption alloc] initWithAlertViewStyle:alertViewStyle btnStyle:btnStyle];
    return styleOption;
}

- (instancetype)initWithAlertViewStyle:(PXAVStyle)alertViewStyle btnStyle:(BOOL)btnStyle{
    self = [super init];
    if (self) {
        _alertViewStyle=alertViewStyle;
        _btnStyle=btnStyle;
        
        if (alertViewStyle==PXAVStyleDefault) {
            //默认样式
            [self alertViewStyleOptionDefault];
        }else if (alertViewStyle==PXAVStyleBlack){
            //黑色风格
            [self alertViewStyleOptionBlack];
        }else if (alertViewStyle==PXAVStyleCustomization){
            //自定义风格: 使用默认风格，然后通过block修改属性
            [self alertViewStyleOptionDefault];
        }else{
            //默认样式
            [self alertViewStyleOptionDefault];
        }
    }
    return self;
}

#pragma mark- PXAViewStyle-->PXAlertViewStyleOption
//默认样式
-(void)alertViewStyleOptionDefault{
    self.windowTintColor=[UIColor colorWithWhite:0 alpha:0.25];
    self.alertViewBgColor=[UIColor whiteColor];
    
    self.titleFont=[UIFont boldSystemFontOfSize:17];
    self.titleColor=[UIColor blackColor];
    
    self.messageColor=[UIColor blackColor];
    self.messageFont=[UIFont systemFontOfSize:15.0];
    
    if (self.btnStyle) {
        self.lineColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.3];
        
        self.cancelButtonTitleColor=[UIColor colorWithRed:0.0 green:0.48 blue:1 alpha:1];
        self.cancelButtonTitleHilightedColor=[UIColor whiteColor];
        self.cancelButtonBackgroundColor=[UIColor clearColor];
        self.cancelButtonBackgroundHilightedColor=[UIColor blueColor];
        
        self.otherButtonTitleColor=[UIColor colorWithRed:0.0 green:0.48 blue:1 alpha:1];
        self.otherButtonTitleHilightedColor=[UIColor whiteColor];
        self.otherButtonBackgroundColor=[UIColor clearColor];
        self.otherButtonBackgroundHilightedColor=[UIColor blueColor];
    }else{
        self.lineColor = [UIColor clearColor];
        
        self.cancelButtonTitleColor=[UIColor colorWithRed:0.0 green:0.48 blue:1 alpha:1];
        self.cancelButtonTitleHilightedColor=[UIColor whiteColor];
        self.cancelButtonBackgroundColor=[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.1];
        self.cancelButtonBackgroundHilightedColor=[UIColor blueColor];
        
        self.otherButtonTitleColor=[UIColor colorWithRed:0.0 green:0.48 blue:1 alpha:1];
        self.otherButtonTitleHilightedColor=[UIColor whiteColor];
        self.otherButtonBackgroundColor=[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.1];
        self.otherButtonBackgroundHilightedColor=[UIColor blueColor];
    }
}

//黑色风格
-(void)alertViewStyleOptionBlack{
    //初始默认设置
    [self alertViewStyleOptionDefault];
    
    self.windowTintColor=[UIColor colorWithWhite:0 alpha:0.25];
    self.alertViewBgColor=[UIColor colorWithWhite:0.25 alpha:1];
    
    self.titleFont=[UIFont boldSystemFontOfSize:17];
    self.titleColor=[UIColor whiteColor];
    
    self.messageColor=[UIColor whiteColor];
    self.messageFont=[UIFont systemFontOfSize:15];
    
    if (self.btnStyle) {
        self.lineColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.3];
        
        self.cancelButtonTitleColor=[UIColor colorWithRed:0.0 green:0.48 blue:1 alpha:1];
        self.cancelButtonTitleHilightedColor=[UIColor whiteColor];
        self.cancelButtonBackgroundColor=[UIColor clearColor];
        self.cancelButtonBackgroundHilightedColor=[UIColor blueColor];
        
        self.otherButtonTitleColor=[UIColor colorWithRed:0.0 green:0.48 blue:1 alpha:1];
        self.otherButtonTitleHilightedColor=[UIColor whiteColor];
        self.otherButtonBackgroundColor=[UIColor clearColor];
        self.otherButtonBackgroundHilightedColor=[UIColor blueColor];
    }else{
        self.lineColor = [UIColor colorWithWhite:0.90 alpha:0.3];
        
        self.cancelButtonTitleColor=[UIColor whiteColor];
        self.cancelButtonTitleHilightedColor=[UIColor blackColor];
        self.cancelButtonBackgroundColor=[UIColor colorWithRed:94/255.0 green:196/255.0 blue:221/255.0 alpha:1.0];
        self.cancelButtonBackgroundHilightedColor=[UIColor blueColor];
        
        self.otherButtonTitleColor=[UIColor whiteColor];
        self.otherButtonTitleHilightedColor=[UIColor blackColor];
        self.otherButtonBackgroundColor=[UIColor colorWithRed:94/255.0 green:196/255.0 blue:221/255.0 alpha:1.0];
        self.otherButtonBackgroundHilightedColor=[UIColor blueColor];
    }
}



@end

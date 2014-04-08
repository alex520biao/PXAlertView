//
//  PXCustomization.h
//  PXAlertViewDemo
//
//  Created by liubiao on 14-4-8.
//  Copyright (c) 2014年 panaxiom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PXAlertView+Customization.h"
typedef NS_ENUM(NSInteger, PXAlertViewStyle)
{
    PXAlertViewStyleDefault = 0,
    
    PXAlertViewStyleWhite,              //白色风格(iOS7)
    PXAlertViewStyleBlack,              //黑色风格
    PXAlertViewStyleViolet,             //紫色风格
    PXAlertViewStyleCustomization       //自定义风格(默认自定义风格为PXAlertViewStyleWhite)
};

/**
 * PXAlertViewStyleOption是PXAlertViewStyle对应的具体样式类
 */
@interface PXAlertViewStyleOption : NSObject
@property (nonatomic, strong) UIColor *windowTintColor;
@property (nonatomic, strong) UIColor *backgroundColor;

@property (nonatomic, strong) UIColor *titleColor;
@property (nonatomic, strong) UIFont *titleFont;

@property (nonatomic, strong) UIColor *messageColor;
@property (nonatomic, strong) UIFont *messageFont;

@property (nonatomic, strong) UIColor *cancelButtonBackgroundColor;
@property (nonatomic, strong) UIColor *otherButtonBackgroundColor;

+(PXAlertViewStyleOption*)alertViewStyleOptionWithStyle:(PXAlertViewStyle)alertViewStyle;
@end

//
//  PXCustomization.h
//  PXAlertViewDemo
//
//  Created by liubiao on 14-4-8.
//  Copyright (c) 2014年 panaxiom. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum {
    //可选样式类型 PXAlertViewStyle
    PXAlertViewStyleDefault = 0,        //默认类型(系统风格)
    PXAlertViewStyleBlack,              //黑色风格
    PXAlertViewStyleViolet,             //紫色风格
    
    //完整样式类型 PXDetailStyle
    PXAVStyleDefault=PXAlertViewStyleDefault,   //默认类型
    PXAVStyleBlack,                             //黑色风格
    PXAVStyleViolet,                            //紫色风格
    PXAVStyleCustomization                      //自定义类型
}PXAlertViewStyle, PXAVStyle;

/*
 * PXAlertViewStyleOption是PXAlertViewStyle对应的具体样式类
 */
@interface PXAlertViewStyleOption : NSObject
@property (nonatomic, strong) UIColor *windowTintColor;

//alertView矩形框背景色及背景图
@property (nonatomic, strong) UIColor *alertViewBgColor;
@property (nonatomic, strong) UIImage *alertViewBgimage;

@property (nonatomic, strong) UIColor *titleColor;
@property (nonatomic, strong) UIFont *titleFont;

@property (nonatomic, strong) UIColor *messageColor;
@property (nonatomic, strong) UIFont *messageFont;

@property (nonatomic, strong) UIColor *cancelButtonTitleColor;
@property (nonatomic, strong) UIColor *cancelButtonTitleHilightedColor;
@property (nonatomic, strong) UIColor *otherButtonTitleColor;
@property (nonatomic, strong) UIColor *otherButtonTitleHilightedColor;

@property (nonatomic, strong) UIColor *cancelButtonBackgroundColor;
@property (nonatomic, strong) UIColor *otherButtonBackgroundColor;

@property (nonatomic, strong) UIColor *lineColor;

+(PXAlertViewStyleOption*)alertViewStyleOptionWithStyle:(PXAlertViewStyle)alertViewStyle;
@end

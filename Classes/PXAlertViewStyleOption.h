//
//  PXCustomization.h
//  PXAlertViewDemo
//
//  Created by liubiao on 14-4-8.
//  Copyright (c) 2014年 panaxiom. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum {
    //PXAVStyleDefault(全部主题)
    PXAVStyleDefault=0,                         //默认主题
    PXAVStyleBlack,                             //黑色主题
    PXAVStyleCustomization,                     //自定义主题

    //PXAlertViewStyle(预定义主题)
    PXAlertViewStyleDefault = PXAVStyleDefault, //默认主题
    PXAlertViewStyleBlack,                      //黑色主题
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

//按钮样式
@property (nonatomic, strong) UIColor *cancelButtonTitleColor;
@property (nonatomic, strong) UIColor *cancelButtonTitleHilightedColor;
@property (nonatomic, strong) UIColor *cancelButtonBackgroundColor;
@property (nonatomic, strong) UIColor *cancelButtonBackgroundHilightedColor;

@property (nonatomic, strong) UIColor *otherButtonTitleColor;
@property (nonatomic, strong) UIColor *otherButtonTitleHilightedColor;
@property (nonatomic, strong) UIColor *otherButtonBackgroundColor;
@property (nonatomic, strong) UIColor *otherButtonBackgroundHilightedColor;

//分割线
@property (nonatomic, assign,readonly) PXAVStyle alertViewStyle;//(只读)
@property (nonatomic, assign,readonly) BOOL btnStyle;//按钮样式(只读)
@property (nonatomic, strong) UIColor *lineColor;//btnStyle==YES时有效

+(PXAlertViewStyleOption*)alertViewStyleOptionWithStyle:(PXAVStyle)alertViewStyle btnStyle:(BOOL)btnStyle;
@end

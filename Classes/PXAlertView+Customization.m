//
//  PXAlertView+Customization.m
//  PXAlertViewDemo
//
//  Created by Michal Zygar on 21.10.2013.
//  Copyright (c) 2013 panaxiom. All rights reserved.
//

#import "PXAlertView+Customization.h"
#import <objc/runtime.h>

void * const kCancelBGKey = (void * const) &kCancelBGKey;
void * const kOtherBGKey = (void * const) &kOtherBGKey;
void * const kStyleOptionKey = (void * const) &kStyleOptionKey;

@interface PXAlertView ()

@property (nonatomic) UIView *backgroundView;
@property (nonatomic) UIView *alertView;
@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UILabel *messageLabel;
@property (nonatomic) UIButton *cancelButton;
@property (nonatomic) UIButton *otherButton;

@end

@implementation PXAlertView (Customization)

- (void)setWindowTintColor:(UIColor *)color
{
    self.backgroundView.backgroundColor = color;
}

- (void)setBackgroundColor:(UIColor *)color
{
    self.alertView.backgroundColor = color;
}

- (void)setTitleColor:(UIColor *)color
{
    self.titleLabel.textColor = color;
}

- (void)setTitleFont:(UIFont *)font
{
    self.titleLabel.font = font;
}

- (void)setMessageColor:(UIColor *)color
{
    self.messageLabel.textColor = color;
}

- (void)setMessageFont:(UIFont *)font
{
    self.messageLabel.font = font;
}

#pragma mark -
#pragma mark Buttons Customization
- (void)setCustomBackgroundColorForButton:(id)sender
{
    if (sender == self.cancelButton && self.cancelButtonBackgroundColor) {
        self.cancelButton.backgroundColor = self.cancelButtonBackgroundColor;
    } else if (sender == self.otherButton && self.otherButtonBackgroundColor) {
        self.otherButton.backgroundColor = self.otherButtonBackgroundColor;
    } else {
        [sender setBackgroundColor:[UIColor colorWithRed:94/255.0 green:196/255.0 blue:221/255.0 alpha:1]];
    }
}

- (void)setCancelButtonBackgroundColor:(UIColor *)color
{
    objc_setAssociatedObject(self, kCancelBGKey, color, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self.cancelButton addTarget:self action:@selector(setCustomBackgroundColorForButton:) forControlEvents:UIControlEventTouchDown];
    [self.cancelButton addTarget:self action:@selector(setCustomBackgroundColorForButton:) forControlEvents:UIControlEventTouchDragEnter];
}

- (UIColor *)cancelButtonBackgroundColor
{
    return objc_getAssociatedObject(self, kCancelBGKey);
}

- (void)setOtherButtonBackgroundColor:(UIColor *)color
{
    objc_setAssociatedObject(self, kOtherBGKey, color, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self.otherButton addTarget:self action:@selector(setCustomBackgroundColorForButton:) forControlEvents:UIControlEventTouchDown];
    [self.otherButton addTarget:self action:@selector(setCustomBackgroundColorForButton:) forControlEvents:UIControlEventTouchDragEnter];
}

- (UIColor *)otherButtonBackgroundColor
{
    return objc_getAssociatedObject(self, kOtherBGKey);
}

/**
 * 设置PXAlertViewStyle样式
 */
-(void)setAlertViewStyle:(PXAlertViewStyle)alertViewStyle customization:(CustomizationBlock)customizationBlock{
    //默认样式
    __block PXAlertViewStyleOption *styleOption=[PXAlertViewStyleOption alertViewStyleOptionWithStyle:alertViewStyle];
    //用户自定义样式
    if(alertViewStyle==PXAlertViewStyleCustomization){
        styleOption=customizationBlock(self,styleOption);
    }
    //更新样式
    [self setStyleOption:styleOption];
}

-(void)setStyleOption:(PXAlertViewStyleOption*)styleOption{
    //保存PXAlertView样式
    objc_setAssociatedObject(self, kStyleOptionKey, styleOption, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

    //更新PXAlertView界面
    [self setWindowTintColor:styleOption.windowTintColor];
    [self setBackgroundColor:styleOption.backgroundColor];
    
    [self setTitleColor:styleOption.titleColor];
    [self setTitleFont:styleOption.titleFont];
    
    [self setMessageColor:styleOption.messageColor];
    [self setMessageFont:styleOption.messageFont];

    [self setCancelButtonBackgroundColor:styleOption.cancelButtonBackgroundColor];
    [self setOtherButtonBackgroundColor:styleOption.otherButtonBackgroundColor];
}

/**
 *  自定义样式的alertView
 *
 */
+ (id)showAlertWithTitle:(NSString *)title
                 message:(NSString *)message
           customization:(CustomizationBlock)customization
              completion:(PXAlertViewCompletionBlock)completion
             cancelTitle:(NSString *)cancelTitle
             otherTitles:(NSString *)otherTitles, ... NS_REQUIRES_NIL_TERMINATION{
    //otherTitles参数列表
    NSMutableArray *argsArray = [[NSMutableArray alloc] init];
    va_list params; //定义一个指向个数可变的参数列表指针；
    va_start(params,otherTitles);//va_start  得到第一个可变参数地址,
    id arg;
    if (otherTitles) {
        //将第一个参数添加到array
        id prev = otherTitles;
        [argsArray addObject:prev];
        
        //va_arg 指向下一个参数地址
        //这里是问题的所在 网上的例子，没有保存第一个参数地址，后边循环，指针将不会在指向第一个参数
        while( (arg = va_arg(params,id)) ){
            if ( arg ){
                [argsArray addObject:arg];
            }
        }
        //置空
        va_end(params);
    }
    
    
    PXAlertView *alertView=[PXAlertView showAlertWithTitle:title
                                                   message:message
                                               cancelTitle:cancelTitle
                                               otherTitles:argsArray
                                               contentView:nil
                                                completion:completion];
    //指定样式
    __block PXAlertViewStyleOption *styleOption=[PXAlertViewStyleOption alertViewStyleOptionWithStyle:PXAlertViewStyleDefault];
    //自定义样式
    if(customization){
        styleOption=customization(alertView,styleOption);
    }
    //更新样式
    [alertView setStyleOption:styleOption];
    return alertView;
}

@end

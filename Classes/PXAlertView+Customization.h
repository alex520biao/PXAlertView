//
//  PXAlertView+Customization.h
//  PXAlertViewDemo
//
//  Created by Michal Zygar on 21.10.2013.
//  Copyright (c) 2013 panaxiom. All rights reserved.
//

#import "PXAlertView.h"
#import "PXAlertViewStyleOption.h"

@class PXAlertViewStyleOption;
typedef PXAlertViewStyleOption *(^CustomizationBlock)(PXAlertView *alertView,PXAlertViewStyleOption *styleOption);

@interface PXAlertView (Customization)

- (void)setWindowTintColor:(UIColor *)color;
- (void)setBackgroundColor:(UIColor *)color;

- (void)setTitleColor:(UIColor *)color;
- (void)setTitleFont:(UIFont *)font;

- (void)setMessageColor:(UIColor *)color;
- (void)setMessageFont:(UIFont *)font;

- (void)setCancelButtonBackgroundColor:(UIColor *)color;
- (void)setOtherButtonBackgroundColor:(UIColor *)color;

/**
 * 设置PXAlertViewStyle样式
 */
//-(void)setAlertViewStyle:(PXAlertViewStyle)alertViewStyle customization:(CustomizationBlock)customizationBlock;

/**
 *  自定义样式的alertView
 *
 */
+ (id)showAlertWithTitle:(NSString *)title
                 message:(NSString *)message
           customization:(CustomizationBlock)customization
              completion:(PXAlertViewCompletionBlock)completion
             cancelTitle:(NSString *)cancelTitle
             otherTitles:(NSString *)otherTitles, ... NS_REQUIRES_NIL_TERMINATION;


@end
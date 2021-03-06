//
//  PXAlertView.h
//  PXAlertViewDemo
//
//  Created by Alex Jarvis on 25/09/2013.
//  Copyright (c) 2013 Panaxiom Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PXAlertViewStyleOption.h"
@class PXAlertView;
@class PXAlertViewStyleOption;
typedef PXAlertViewStyleOption *(^CustomizationBlock)(PXAlertView *alertView,PXAlertViewStyleOption *styleOption);
typedef void(^PXAlertViewCompletionBlock)(BOOL cancelled, NSInteger buttonIndex);
typedef BOOL(^SpecialButtonBlock)(NSInteger buttonIndex);

@interface PXAlertView : UIViewController

@property (nonatomic, getter = isVisible) BOOL visible;

/*
 * 设置PXAlertViewStyle可选样式样式
 */
-(void)setAlertViewStyle:(PXAlertViewStyle)alertViewStyle btnStyle:(BOOL)btnStyle;

/*
 * Dismisses the receiver, optionally with animation.
 */
- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated;

/*
 *  隐藏PXAlertView，默认PXAlertViewCompletionBlock中cancelled=YES
 */
- (void)dismissWithAnimated:(BOOL)animated;


/*
 * By default the alert allows you to tap anywhere around the alert to dismiss it.
 * This method enables or disables this feature.
 */
- (void)setTapToDismissEnabled:(BOOL)enabled;


#pragma mark- 快捷方法
/*
 *  自定义样式的alertView
 *
 */
+ (instancetype)showAlertWithTitle:(NSString *)title
                           message:(NSString *)message
                        completion:(PXAlertViewCompletionBlock)completion
                       cancelTitle:(NSString *)cancelTitle
                       otherTitles:(NSString *)otherTitles, ... NS_REQUIRES_NIL_TERMINATION;

/*
 * @param otherTitles Must be a NSArray containing type NSString, or set to nil for no otherTitles.
 */
+ (instancetype)showAlertWithTitle:(NSString *)title
                       contentView:(UIView *)view
                       secondTitle:(NSString *)secondTitle
                           message:(NSString *)message
                       cancelTitle:(NSString *)cancelTitle
                       otherTitles:(NSArray *)otherTitles
                          btnStyle:(BOOL)btnStyle
                        completion:(PXAlertViewCompletionBlock)completion;

/*
 *  自定义样式的alertView
 *
 */
+ (instancetype)showAlertWithTitle:(NSString *)title
                       contentView:(UIView*)contentView
                       secondTitle:(NSString *)secondTitle
                           message:(NSString *)message
                          btnStyle:(BOOL)btnStyle
                     customization:(CustomizationBlock)customization
                        completion:(PXAlertViewCompletionBlock)completion
                       cancelTitle:(NSString *)cancelTitle
                       otherTitles:(NSString *)otherTitles, ... NS_REQUIRES_NIL_TERMINATION;

/*
 *  自定义样式的alertView
 *
 */
+ (instancetype)showAlertWithTitle:(NSString *)title
                       contentView:(UIView*)contentView
                       secondTitle:(NSString *)secondTitle
                           message:(NSString *)message
                          btnStyle:(BOOL)btnStyle
                       cancelTitle:(NSString *)cancelTitle
                       otherTitles:(NSArray *)otherTitles
                     specialButton:(SpecialButtonBlock)specialButton
                     customization:(CustomizationBlock)customization
                        completion:(PXAlertViewCompletionBlock)completion;

//完全自定义alertView
+ (PXAlertView *)showAlertWithCustomAlertView:(UIView*)customAlertView;


@end

//
//  TRAlertViewManager.h
//  DiTravel
//
//  Created by liubiao on 14-5-14.
//  Copyright (c) 2014年 didi inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PXAlertView.h"
@interface TRAlertViewManager : NSObject

typedef enum {
    TRAlertViewIconNone=0,                   //无icon
    TRAlertViewIconExclamMark,               //感叹号提示
    TRAlertViewIconRedStar,                  //红心
    TRAlertViewIconAddr,                     //地址
    TRAlertViewIconFace,                     //笑脸
    TRAlertViewIconMaike                     //麦克
}TRAlertViewIcon;

/*
 *  自定义样式的alertView
 *  title 标题
 *  alertViewIcon 图标样式
 *  message 消息正文
 *  completion按钮点击处理
 *  cancelTitle 取消按钮标题
 *  specialButton 控制按钮是否特殊样式
 *  otherTitles 除去取消按钮其他按钮标题
 */
+ (void)showAlertWithTitle:(NSString *)title
             alertViewIcon:(TRAlertViewIcon)alertViewIcon
                   message:(NSString *)message
                completion:(PXAlertViewCompletionBlock)completion
               cancelTitle:(NSString *)cancelTitle
             specialButton:(SpecialButtonBlock)specialButton
               otherTitles:(NSString *)otherTitles, ... NS_REQUIRES_NIL_TERMINATION;


@end

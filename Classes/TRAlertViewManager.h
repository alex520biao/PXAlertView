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
 *  无icon的alertView
 *
 */
+ (void)showAlertWithTitle:(NSString *)title
                   message:(NSString *)message
                completion:(PXAlertViewCompletionBlock)completion
               cancelTitle:(NSString *)cancelTitle
               otherTitles:(NSString *)otherTitles, ... NS_REQUIRES_NIL_TERMINATION;

/*
 *  自定义样式的alertView
 *
 */
+ (void)showAlertWithTitle:(NSString *)title
             alertViewIcon:(TRAlertViewIcon)alertViewIcon
                   message:(NSString *)message
                completion:(PXAlertViewCompletionBlock)completion
               cancelTitle:(NSString *)cancelTitle
               otherTitles:(NSString *)otherTitles, ... NS_REQUIRES_NIL_TERMINATION;

@end

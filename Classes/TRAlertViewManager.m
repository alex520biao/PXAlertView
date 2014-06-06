//
//  TRAlertViewManager.m
//  DiTravel
//
//  Created by liubiao on 14-5-14.
//  Copyright (c) 2014年 didi inc. All rights reserved.
//

#import "TRAlertViewManager.h"
#import "UIImage+resizableImage.h"
@implementation TRAlertViewManager

#pragma mark- public
/*
 *  自定义样式的alertView
 *
 */
+ (void)showAlertWithTitle:(NSString *)title
             alertViewIcon:(TRAlertViewIcon)alertViewIcon
                   message:(NSString *)message
                completion:(PXAlertViewCompletionBlock)completion
               cancelTitle:(NSString *)cancelTitle
             specialButton:(SpecialButtonBlock)specialButton
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

    
    [TRAlertViewManager showAlertWithTitle:title
                             alertViewIcon:alertViewIcon
                                   message:message
                                completion:completion
                               cancelTitle:cancelTitle
                             specialButton:specialButton
                            otherTitleList:argsArray];
}


#pragma mark- private
/*
 *  自定义样式的alertView
 *
 */
+ (void)showAlertWithTitle:(NSString *)title
             alertViewIcon:(TRAlertViewIcon)alertViewIcon
                   message:(NSString *)message
                completion:(PXAlertViewCompletionBlock)completion
               cancelTitle:(NSString *)cancelTitle
             specialButton:(SpecialButtonBlock)specialButton
            otherTitleList:(NSArray *)otherTitleList{
    
    UIImageView *contentView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 55, 55)];
    switch (alertViewIcon) {
        case TRAlertViewIconNone:{
            contentView=nil;
        }break;
        case TRAlertViewIconExclamMark:{
            contentView.image=[UIImage imageNamed:@"dialog_icon_exclamation_mark"];
        }break;
        case TRAlertViewIconRedStar:{
            contentView.image=[UIImage imageNamed:@"dialog_icon_heart"];
        }break;
        case TRAlertViewIconAddr:{
            contentView.image=[UIImage imageNamed:@"dialog_icon_address"];
        }break;
        case TRAlertViewIconFace:{
            contentView.image=[UIImage imageNamed:@"ExampleImage.png"];
        }break;
        case TRAlertViewIconMaike:{
            contentView.image=[UIImage imageNamed:@"dialog_icon_micro_error"];
        }break;
        default:{
            contentView.image=nil;
        }break;
    }
    
    //图片命名不规范会有问题(单倍图:img.png/双倍图:img@2x.png)
    UIImage *foucesImg=[UIImage resizableImageNamed:@"dialog_b1"];
    UIImage *foucesImg1=[UIImage resizableImageNamed:@"dialog_b1_down"];
    UIImage *spcImg=[UIImage resizableImageNamed:@"dialog_b"];
    UIImage *spcImg1=[UIImage resizableImageNamed:@"dialog_b_down"];

    PXAlertView *alertView=[PXAlertView showAlertWithTitle:nil
                                               contentView:contentView
                                               secondTitle:title
                                                   message:message
                                                  btnStyle:NO
                                               cancelTitle:cancelTitle
                                               otherTitles:otherTitleList
                                             specialButton:specialButton
                                             customization:^PXAlertViewStyleOption *(PXAlertView *alertView, PXAlertViewStyleOption *styleOption) {
                                                 //title
                                                 styleOption.titleColor=[UIColor colorWithHexString:@"333333"];
                                                 styleOption.titleFont=[UIFont boldSystemFontOfSize:19];
                                                 
                                                 //message
                                                 styleOption.messageColor=[UIColor colorWithHexString:@"999999"];
                                                 styleOption.messageFont=[UIFont systemFontOfSize:14];

                                                 //cancelBtn
                                                 styleOption.cancelButtonTitleColor=[UIColor colorWithHexString:@"999999"];
                                                 styleOption.cancelButtonTitleHilightedColor=[UIColor whiteColor];
                                                 styleOption.cancelButtonBackgroundImage=foucesImg;
                                                 styleOption.cancelButtonBackgroundHilightedImage=foucesImg1;

                                                 //otherBtn
                                                 styleOption.otherButtonTitleColor=[UIColor colorWithHexString:@"999999"];
                                                 styleOption.otherButtonTitleHilightedColor=[UIColor whiteColor];
                                                 styleOption.otherButtonBackgroundImage=foucesImg;
                                                 styleOption.otherButtonBackgroundHilightedImage=foucesImg1;
                                                 
                                                 //specialBtn
                                                 styleOption.specialButtonBackgroundImage=spcImg;
                                                 styleOption.specialButtonBackgroundHilightedImage=spcImg1;
                                                 styleOption.specialButtonTitleColor=[UIColor whiteColor];
                                                 styleOption.specialButtonTitleHilightedColor=[UIColor whiteColor];                                                 
                                                 
                                                 return styleOption;
                                             }completion:completion];
    [alertView description];
}



@end

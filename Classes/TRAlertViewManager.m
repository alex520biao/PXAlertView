//
//  TRAlertViewManager.m
//  DiTravel
//
//  Created by liubiao on 14-5-14.
//  Copyright (c) 2014年 didi inc. All rights reserved.
//

#import "TRAlertViewManager.h"

@implementation TRAlertViewManager

/*
 *  自定义样式的alertView
 *
 */
+ (void)showAlertWithTitle:(NSString *)title
             alertViewIcon:(TRAlertViewIcon)alertViewIcon
                   message:(NSString *)message
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
//    
//    TRAlertViewIconNone=0,                   //无icon
//    TRAlertViewIconExclamMark,               //感叹号提示
//    TRAlertViewIconRedStar,                  //红心
//    TRAlertViewIconAddr,                     //定位图标
//    TRAlertViewIconFace,                     //笑脸
//    TRAlertViewIconHongbao                   //红包

    UIImageView *contentView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 55, 55)];
    switch (alertViewIcon) {
        case TRAlertViewIconNone:{
            contentView=nil;
        }break;
        case TRAlertViewIconExclamMark:{
            contentView.image=[UIImage imageNamed:@"ExampleImage.png"];
        }break;
        case TRAlertViewIconRedStar:{
            contentView.image=[UIImage imageNamed:@"ExampleImage.png"];
        }break;
        case TRAlertViewIconAddr:{
            contentView.image=[UIImage imageNamed:@"ExampleImage.png"];
        }break;
        case TRAlertViewIconFace:{
            contentView.image=[UIImage imageNamed:@"ExampleImage.png"];
        }break;
        case TRAlertViewIconHongbao:{
            contentView.image=[UIImage imageNamed:@"ExampleImage.png"];
        }break;
        default:{
            contentView.image=nil;
        }break;
    }
    
    
    PXAlertView *alertView=[PXAlertView showAlertWithTitle:nil
                                               contentView:contentView
                                               secondTitle:title
                                                   message:message
                                                  btnStyle:NO
                                               cancelTitle:cancelTitle
                                               otherTitles:argsArray
                                             customization:^PXAlertViewStyleOption *(PXAlertView *alertView, PXAlertViewStyleOption *styleOption) {

                                                 UIImage *foucesImg=[UIImage imageNamed:@"b1"];//图片命名不规范会有问题(单倍图:img.png/双倍图:img@2x.png)
                                                 foucesImg = [foucesImg resizableImageWithCapInsets:UIEdgeInsetsMake(floor(foucesImg.size.height/2),
                                                                                                                     floor(foucesImg.size.width/2),
                                                                                                                     floor(foucesImg.size.height/2),
                                                                                                                     floor(foucesImg.size.width/2))];
                                                 styleOption.otherButtonBackgroundImage=foucesImg;
                                                 
                                                 UIImage *foucesImg1=[UIImage imageNamed:@"b1_down"];
                                                 foucesImg1 = [foucesImg1 resizableImageWithCapInsets:UIEdgeInsetsMake(floor(foucesImg1.size.height/2),
                                                                                                                     floor(foucesImg1.size.width/2),
                                                                                                                     floor(foucesImg1.size.height/2),
                                                                                                                     floor(foucesImg1.size.width/2))];
                                                 styleOption.otherButtonBackgroundHilightedImage=foucesImg1;
                                                 
                                                 styleOption.otherButtonTitleColor=[UIColor colorWithHexString:@"999999"];
                                                 styleOption.otherButtonTitleHilightedColor=[UIColor whiteColor];
                                                 
                                                 
                                                 UIImage *spcImg=[UIImage imageNamed:@"b"];//图片命名不规范会有问题(单倍图:img.png/双倍图:img@2x.png)
                                                 spcImg = [spcImg resizableImageWithCapInsets:UIEdgeInsetsMake(floor(spcImg.size.height/2),
                                                                                                                     floor(spcImg.size.width/2),
                                                                                                                     floor(spcImg.size.height/2),
                                                                                                                     floor(spcImg.size.width/2))];
                                                 styleOption.specialButtonBackgroundImage=spcImg;
                                                 
                                                 UIImage *spcImg1=[UIImage imageNamed:@"b_down"];
                                                 spcImg1 = [spcImg1 resizableImageWithCapInsets:UIEdgeInsetsMake(floor(spcImg1.size.height/2),
                                                                                                                       floor(spcImg1.size.width/2),
                                                                                                                       floor(spcImg1.size.height/2),
                                                                                                                       floor(spcImg1.size.width/2))];
                                                 styleOption.specialButtonBackgroundHilightedImage=spcImg1;
                                                 
                                                 styleOption.specialButtonTitleColor=[UIColor whiteColor];
                                                 styleOption.specialButtonTitleHilightedColor=[UIColor whiteColor];
                                                 
                                                 styleOption.titleColor=[UIColor colorWithHexString:@"333333"];
                                                 styleOption.titleFont=[UIFont boldSystemFontOfSize:19];

                                                 styleOption.messageColor=[UIColor colorWithHexString:@"999999"];
                                                 styleOption.messageFont=[UIFont systemFontOfSize:14];


                                                 return styleOption;
                                             }completion:completion];
//    NSLog(@"",alertView);
}



@end

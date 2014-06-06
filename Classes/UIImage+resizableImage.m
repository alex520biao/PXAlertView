//
//  UIImage+resizableImage.m
//  PXAlertViewDemo
//
//  Created by liubiao on 14-6-6.
//  Copyright (c) 2014年 panaxiom. All rights reserved.
//

#import "UIImage+resizableImage.h"

@implementation UIImage (resizableImage)

// load from main bundle。 图片必须是对半可拉伸的。图片命名必须规范，否则会有问题(单倍图:img.png/双倍图:img@2x.png)
+(UIImage*)resizableImageNamed:(NSString*)name{
    UIImage *resizableImage=[UIImage imageNamed:name];
    resizableImage = [resizableImage resizableImageWithCapInsets:UIEdgeInsetsMake(
                                                                                  floor(resizableImage.size.height/2),
                                                                                  floor(resizableImage.size.width/2),
                                                                                  floor(resizableImage.size.height/2),
                                                                                  floor(resizableImage.size.width/2))];
    return resizableImage;
}

@end

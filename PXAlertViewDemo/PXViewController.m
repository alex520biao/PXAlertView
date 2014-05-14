//
//  PXViewController.m
//  PXAlertViewDemo
//
//  Created by Alex Jarvis on 25/09/2013.
//  Copyright (c) 2013 Panaxiom Ltd. All rights reserved.
//

#import "PXViewController.h"

@interface PXViewController ()<UIAlertViewDelegate>
@property(nonatomic,weak)PXAlertView *alertView;
@end

@implementation PXViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}


#pragma mark- PXAlertViewDemo
- (IBAction)showSimpleAlertView:(id)sender{
    [PXAlertView showAlertWithTitle:@"PorridgeNew"
                        contentView:nil
                        secondTitle:nil
                            message:@"How would you like it?"
                           btnStyle:NO
                      customization:nil
                         completion:^(BOOL cancelled, NSInteger buttonIndex) {
                             if (cancelled) {
                                 NSLog(@"Cancel button pressed");
                             } else {
                                 NSLog(@"Button with index %li pressed", (long)buttonIndex);
                             }
                         }
                        cancelTitle:@"Cancel"
                        otherTitles:nil];

    [PXAlertView showAlertWithTitle:@"PorridgeNew"
                        contentView:nil
                        secondTitle:nil
                            message:@"How would you like it?"
                           btnStyle:NO
                      customization:nil
                         completion:^(BOOL cancelled, NSInteger buttonIndex) {
                             if (cancelled) {
                                 NSLog(@"Cancel button pressed");
                             } else {
                                 NSLog(@"Button with index %li pressed", (long)buttonIndex);
                             }
                         } cancelTitle:@"Cancel"
                        otherTitles:@"Too Hot",nil];
    
    [PXAlertView showAlertWithTitle:@"PorridgeNew"
                        contentView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ExampleImage.png"]]
                        secondTitle:nil
                            message:@"How would you like it?"
                           btnStyle:NO
                      customization:^PXAlertViewStyleOption *(PXAlertView *alertView, PXAlertViewStyleOption *styleOption) {
                          return styleOption;
                      } completion:^(BOOL cancelled, NSInteger buttonIndex) {
                          if (cancelled) {
                              NSLog(@"Cancel button pressed");
                          } else {
                              NSLog(@"Button with index %li pressed", (long)buttonIndex);
                          }
                      } cancelTitle:@"Cancel"
                        otherTitles:@"Too Hot", @"Luke Warm", @"Quite nippy",@"Other1",@"Other2",nil];
}

- (IBAction)showSimpleCustomizedAlertView:(id)sender{
    //customization自定义alertView样式
    PXAlertView *alertView=[PXAlertView showAlertWithTitle:@"I'm title"
                            contentView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ExampleImage.png"]]
                            secondTitle:nil
                            message:@"I'm message。alertView背景、各个按钮、contentView、title、message等均可自定义。"
                           btnStyle:YES
                      customization:^PXAlertViewStyleOption *(PXAlertView *alertView,PXAlertViewStyleOption *styleOption) {
                          //返回的styleOption为默认样式
                          styleOption.windowTintColor=[UIColor colorWithRed:94/255.0 green:196/255.0 blue:221/255.0 alpha:0.25];
                          styleOption.alertViewBgColor=[UIColor colorWithRed:255/255.0 green:206/255.0 blue:13/255.0 alpha:1.0];
                          
                          //UIImageView.contentMode使用默认设置即可
                          UIImage *foucesImg=[UIImage imageNamed:@"s_5.png"];//必须同时有单倍/双倍图片
                          foucesImg = [foucesImg resizableImageWithCapInsets:UIEdgeInsetsMake((foucesImg.size.height)/2.0f,(foucesImg.size.width)/2.0f, (foucesImg.size.height)/2.0f, (foucesImg.size.width)/2.0f)];
                          styleOption.alertViewBgimage=foucesImg;
                          
                          styleOption.titleFont=[UIFont fontWithName:@"Zapfino" size:15.0f];
                          styleOption.titleColor=[UIColor darkGrayColor];
                          
                          styleOption.messageColor=[UIColor cyanColor];
                          styleOption.messageFont=[UIFont systemFontOfSize:14.0];
                          
                          styleOption.cancelButtonBackgroundColor=[UIColor clearColor];
                          styleOption.cancelButtonTitleHilightedColor=[UIColor blueColor];
                          styleOption.cancelButtonTitleColor=[UIColor blueColor];
                          
                          styleOption.otherButtonBackgroundColor=[UIColor clearColor];
                          styleOption.otherButtonBackgroundHilightedColor=[UIColor blueColor];
                          styleOption.otherButtonTitleColor=[UIColor whiteColor];
                          styleOption.lineColor=[UIColor blueColor];
                          
                          return styleOption;
                      } completion:^(BOOL cancelled, NSInteger buttonIndex) {
                          
                      } cancelTitle:@"Cancel"
                        otherTitles:@"Other1",@"Other2",@"Other3",nil];
    
    //dispatch计时器
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        //黑色风格
        [alertView setAlertViewStyle:PXAlertViewStyleBlack btnStyle:YES];
    });
}


- (IBAction)showLargeAlertView:(id)sender
{
//    UIImageView *contentView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ExampleImage.png"]];
////    contentView.frame=CGRectMake(0, 0, 300, 300);
//    PXAlertView *alertView=[PXAlertView showAlertWithTitle:@"Why this is a larger title! Even larger than the largest large thing that ever was large in a very large way."
//                                                   message:@"Oh my this looks like a nice message. Yes it does, and it can span multiple lines... all the way down."
//                                               contentView:contentView
//                                                  btnStyle:NO
//                                             customization:^PXAlertViewStyleOption *(PXAlertView *alertView, PXAlertViewStyleOption *styleOption) {
//                                                 return styleOption;
//                                             } completion:^(BOOL cancelled, NSInteger buttonIndex) {
//                                                 
//                                             } cancelTitle:@"Ok thanks, that's grand"
//                                               otherTitles:@"1234",nil];
//    //黑色风格
//    [alertView setAlertViewStyle:PXAlertViewStyleBlack btnStyle:YES];
//
//    //点击背景关闭
//    [alertView setTapToDismissEnabled:YES];
    
    //嘀嘀打车样式
    UIImageView *contentView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ExampleImage.png"]];
    PXAlertView *alertView=[PXAlertView showAlertWithTitle:@"提示信息"
                                               contentView:contentView
                                               secondTitle:@"嘀嘀打车送你回家"
                                                   message:@"当前不是WIFI网络,下载离线地图需呀18.2M流量,继续下载吗？"
                                                  btnStyle:NO
                                             customization:^PXAlertViewStyleOption *(PXAlertView *alertView, PXAlertViewStyleOption *styleOption) {
                                                 styleOption.otherButtonBackgroundColor=[UIColor yellowColor];
                                                 
                                                 //只平铺图片中心点的内容
                                                 UIImage *foucesImg=[UIImage imageNamed:@"ExampleImage"];//必须同时有单倍/双倍图片
                                                 foucesImg = [foucesImg resizableImageWithCapInsets:UIEdgeInsetsMake((foucesImg.size.height)/2.0f,(foucesImg.size.width)/2.0f, (foucesImg.size.height)/2.0f, (foucesImg.size.width)/2.0f)];
                                                 styleOption.otherButtonBackgroundImage=foucesImg;
                                                 styleOption.otherButtonTitleColor=[UIColor whiteColor];
                                                 
                                                 styleOption.titleColor=[UIColor colorWithHexString:@"#333333"];
                                                 styleOption.titleFont=[UIFont boldSystemFontOfSize:19];

                                                 styleOption.messageColor=[UIColor colorWithHexString:@"#666666"];
                                                 styleOption.messageFont=[UIFont systemFontOfSize:14];
                                                 return styleOption;
                                             } completion:^(BOOL cancelled, NSInteger buttonIndex) {
                                                 
                                             } cancelTitle:@"取消"
                                               otherTitles:@"确定",nil];
}


- (IBAction)dismissWithNoAnimationAfter1Second:(id)sender{
    
    PXAlertView *alertView = [PXAlertView showAlertWithTitle:@"No Animation"
                                                     message:@"When dismissed"
                                                  completion:nil
                                                 cancelTitle:@"OK"
                                                 otherTitles:nil];
    
    //dispatch计时器
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [alertView dismissWithClickedButtonIndex:0 animated:NO];
    });
}


//完全自定义弹框
- (IBAction)showAlertViewWithCustomView:(id)sender{
    //alertView的contentView最大宽度为270
    UIView *customView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 270, 200)];
    
    UILabel *lab=[[UILabel alloc] initWithFrame:CGRectMake(0, 50, 200, 50)];
    lab.text=@"我是customView";
    lab.textColor=[UIColor whiteColor];
    lab.textAlignment=NSTextAlignmentCenter;
    lab.lineBreakMode=NSLineBreakByTruncatingTail;
    lab.numberOfLines=1;
    lab.center=CGPointMake(CGRectGetMidX(customView.frame), lab.center.y);
    lab.backgroundColor=[UIColor clearColor];
    [customView addSubview:lab];
    
    UIButton *checkButton = [UIButton buttonWithType:UIButtonTypeCustom];
    checkButton.frame = CGRectMake(0, 150, 200, 50);
    [checkButton setTitle:@"自定义关闭" forState:UIControlStateNormal];
    [checkButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [checkButton addTarget:self action:@selector(checkAction:) forControlEvents:UIControlEventTouchUpInside];
    checkButton.backgroundColor = [UIColor clearColor];
    checkButton.center=CGPointMake(CGRectGetMidX(customView.frame), checkButton.center.y);
    [customView addSubview:checkButton];
    
    PXAlertView *alertView=[PXAlertView showAlertWithCustomAlertView:customView];
    self.alertView=alertView;//保持当前自定义PXAlertView引用,可以使用代码代码关闭alertView
    
    customView.backgroundColor=[UIColor blueColor];
}


#pragma mark-UIAlertView
- (IBAction)showLargeUIAlertView:(id)sender
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Some really long title that should wrap to two lines at least. But does it cut off after a certain number of lines? Does it? Does it really? And then what? Does it truncate? Nooo it still hasn't cut off yet. Wow this AlertView can take a lot of characters."
                               message:@"How long does the standard UIAlertView stretch to? This should give a good estimation"
                              delegate:self
                     cancelButtonTitle:@"Cancel"
                     otherButtonTitles:@"Too Hot", @"Luke Warm", @"Quite nippy", nil];
    [alertView show];
    
    
    UIAlertView *alertView1 = [[UIAlertView alloc] initWithTitle:@"title1"
                                                        message:@"message1"
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"Too Hot", @"Luke Warm", @"Quite nippy", nil];
    [alertView1 show];
}

//关闭当前alertView
-(IBAction)checkAction:(id)sender{
    //点击其他按钮关闭alertView
    [self.alertView  dismissWithAnimated:YES];
}

#pragma mark-UIAlertViewDelegate
// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"clickButtonAtIndex:%d",buttonIndex);
}

// Called when we cancel a view (eg. the user clicks the Home button). This is not called when the user clicks the cancel button.
// If not defined in the delegate, we simulate a click in the cancel button
- (void)alertViewCancel:(UIAlertView *)alertView{
    NSLog(@"alertViewCancel");
}


@end

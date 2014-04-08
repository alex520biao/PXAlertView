//
//  PXViewController.m
//  PXAlertViewDemo
//
//  Created by Alex Jarvis on 25/09/2013.
//  Copyright (c) 2013 Panaxiom Ltd. All rights reserved.
//

#import "PXViewController.h"
#import "PXAlertView+Customization.h"

@interface PXViewController ()
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

- (IBAction)showSimpleAlertView:(id)sender
{
    [PXAlertView showAlertWithTitle:@"Hello World"
                            message:@"Oh my this looks like a nice message."
                        cancelTitle:@"Ok"
                         completion:^(BOOL cancelled, NSInteger buttonIndex) {
                             if (cancelled) {
                                 NSLog(@"Simple Alert View cancelled");
                             } else {
                                 NSLog(@"Simple Alert View dismissed, but not cancelled");
                             }
                         }];
}

- (IBAction)showSimpleCustomizedAlertView:(id)sender
{
    PXAlertView *alert = [PXAlertView showAlertWithTitle:@"Hello World"
                                                 message:@"Oh my this looks like a nice message."
                                             cancelTitle:@"Ok"
                                              completion:^(BOOL cancelled, NSInteger buttonIndex) {
                                                  if (cancelled) {
                                                      NSLog(@"Simple Customised Alert View cancelled");
                                                  } else {
                                                      NSLog(@"Simple Customised Alert View dismissed, but not cancelled");
                                                  }
                                              }];
    [alert setWindowTintColor:[UIColor colorWithRed:94/255.0 green:196/255.0 blue:221/255.0 alpha:0.25]];
    [alert setBackgroundColor:[UIColor colorWithRed:255/255.0 green:206/255.0 blue:13/255.0 alpha:1.0]];
    [alert setCancelButtonBackgroundColor:[UIColor redColor]];
    [alert setTitleFont:[UIFont fontWithName:@"Zapfino" size:15.0f]];
    [alert setTitleColor:[UIColor darkGrayColor]];
    [alert setCancelButtonBackgroundColor:[UIColor redColor]];
}


- (IBAction)showLargeAlertView:(id)sender
{
    [PXAlertView showAlertWithTitle:@"Why this is a larger title! Even larger than the largest large thing that ever was large in a very large way."
                            message:@"Oh my this looks like a nice message. Yes it does, and it can span multiple lines... all the way down."
                        cancelTitle:@"Ok thanks, that's grand"
                         completion:^(BOOL cancelled, NSInteger buttonIndex) {
                             if (cancelled) {
                                 NSLog(@"Larger Alert View cancelled");
                             } else {
                                 NSLog(@"Larger Alert View dismissed, but not cancelled");
                             }
                         }];
}

- (IBAction)showTwoButtonAlertView:(id)sender
{
    PXAlertView *alert = [PXAlertView showAlertWithTitle:@"The Matrix"
                            message:@"Pick the Red pill, or the blue pill"
                        cancelTitle:@"Blue"
                         otherTitle:@"Red"
                         completion:^(BOOL cancelled, NSInteger buttonIndex) {
                             if (cancelled) {
                                 NSLog(@"Cancel (Blue) button pressed");
                             } else {
                                 NSLog(@"Other (Red) button pressed");
                             }
                         }];
    
    [alert setCancelButtonBackgroundColor:[UIColor blueColor]];
    [alert setOtherButtonBackgroundColor:[UIColor redColor]];
}

- (IBAction)showMultiButtonAlertView:(id)sender
{
    [PXAlertView showAlertWithTitle:@"Porridge"
                            message:@"How would you like it?"
                        cancelTitle:@"No thanks"
                        otherTitles:@[ @"Too Hot", @"Luke Warm", @"Quite nippy" ]
                         completion:^(BOOL cancelled, NSInteger buttonIndex) {
                             if (cancelled) {
                                 NSLog(@"Cancel button pressed");
                             } else {
                                 NSLog(@"Button with index %li pressed", (long)buttonIndex);
                             }
                         }];
}

- (IBAction)showAlertViewWithContentView:(id)sender
{
    [PXAlertView showAlertWithTitle:@"A picture should appear below"
                            message:@"Yay, it works!"
                        cancelTitle:@"Ok"
                         otherTitle:nil
                        contentView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ExampleImage.png"]]
                         completion:^(BOOL cancelled, NSInteger buttonIndex) {
                         }];
}

//完全自定义弹框
- (IBAction)showAlertViewWithCustomView:(id)sender{
    //alertView的contentView最大宽度为270
    UIView *customView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 270, 200)];
    
    UILabel *lab=[[UILabel alloc] initWithFrame:CGRectMake(0, 50, 200, 50)];
    lab.text=@"我是customView";
    lab.textColor=[UIColor whiteColor];
    lab.textAlignment=NSTextAlignmentCenter;
    lab.lineBreakMode=UILineBreakModeTailTruncation;
    lab.numberOfLines=1;
    lab.center=CGPointMake(CGRectGetMidX(customView.frame), lab.center.y);
    [customView addSubview:lab];
    
    UIButton *checkButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
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

- (IBAction)show5StackedAlertViews:(id)sender
{
    for (int i = 1; i <= 5; i++) {
        [PXAlertView showAlertWithTitle:[NSString stringWithFormat:@"Hello %@", @(i)]
                                message:@"Oh my this looks like a nice message."
                            cancelTitle:@"Ok"
                             completion:^(BOOL cancelled, NSInteger buttonIndex) {}];
    }
}

- (IBAction)showNoTapToDismiss:(id)sender
{
    PXAlertView *alertView = [PXAlertView showAlertWithTitle:@"Tap"
                                                     message:@"Try tapping around the alert view to dismiss it. This should NOT work on this alert."];
    [alertView setTapToDismissEnabled:NO];
}

- (IBAction)dismissWithNoAnimationAfter1Second:(id)sender
{
    PXAlertView *alertView = [PXAlertView showAlertWithTitle:@"No Animation" message:@"When dismissed"];
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [alertView dismissWithClickedButtonIndex:0 animated:NO];
    });
}

- (IBAction)showAlertInsideAlertCompletion:(id)sender
{
    [PXAlertView showAlertWithTitle:@"Alert Inception"
                            message:@"After pressing ok, another alert should appear"
                         completion:^(BOOL cancelled, NSInteger buttonIndex) {
                             [PXAlertView showAlertWithTitle:@"Woohoo"];
                         }];
}

- (IBAction)showLargeUIAlertView:(id)sender
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Some really long title that should wrap to two lines at least. But does it cut off after a certain number of lines? Does it? Does it really? And then what? Does it truncate? Nooo it still hasn't cut off yet. Wow this AlertView can take a lot of characters."
                               message:@"How long does the standard UIAlertView stretch to? This should give a good estimation"
                              delegate:self
                     cancelButtonTitle:@"Cancel"
                     otherButtonTitles:@"Ok", nil];
    [alertView show];
}

//关闭当前alertView
-(IBAction)checkAction:(id)sender{
    //点击其他按钮关闭alertView
    [self.alertView  dismissWithAnimated:YES];
}

@end

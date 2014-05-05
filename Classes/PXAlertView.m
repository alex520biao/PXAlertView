//
//  PXAlertView.m
//  PXAlertViewDemo
//
//  Created by Alex Jarvis on 25/09/2013.
//  Copyright (c) 2013 Panaxiom Ltd. All rights reserved.
//

#import "PXAlertView.h"

@interface PXAlertViewStack : NSObject

@property (nonatomic) NSMutableArray *alertViews;

+ (PXAlertViewStack *)sharedInstance;

- (void)push:(PXAlertView *)alertView;
- (void)pop:(PXAlertView *)alertView;

@end

static const CGFloat AlertViewWidth = 270.0;
static const CGFloat AlertViewContentMargin = 9;
static const CGFloat AlertViewVerticalElementSpace = 10;
static const CGFloat AlertViewButtonHeight = 44;
static const CGFloat AlertViewLineLayerWidth = 0.5;

@interface PXAlertView ()

@property (nonatomic) UIWindow *mainWindow;
@property (nonatomic,strong) UIWindow *alertWindow;
@property (nonatomic) UIView *backgroundView;
@property (nonatomic) UIView *alertView;
@property (nonatomic) UIImageView *alertBgImageView;
@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UIView *contentView;
@property (nonatomic) UILabel *messageLabel;
@property (nonatomic) UIButton *cancelButton;
@property (nonatomic) UIButton *otherButton;
@property (nonatomic) NSArray *buttons;
@property (nonatomic) CGFloat buttonsY;
@property (nonatomic) CALayer *verticalLine;
@property (nonatomic) UITapGestureRecognizer *tap;
@property (nonatomic, copy) void (^completion)(BOOL cancelled, NSInteger buttonIndex);

//存放所有分割线(横向、纵向)
@property (nonatomic,strong)NSMutableArray *lineLayerArray;


@property (nonatomic,strong)PXAlertViewStyleOption *styleOption;

@end

@implementation PXAlertView
@synthesize styleOption=_styleOption;

- (UIWindow *)windowWithLevel:(UIWindowLevel)windowLevel
{
    NSArray *windows = [[UIApplication sharedApplication] windows];
    for (UIWindow *window in windows) {
        if (window.windowLevel == windowLevel) {
            return window;
        }
    }
    return nil;
}

- (id)initWithTitle:(NSString *)title
            message:(NSString *)message
        cancelTitle:(NSString *)cancelTitle
         otherTitle:(NSString *)otherTitle
        contentView:(UIView *)contentView
         completion:(PXAlertViewCompletionBlock)completion
{
    return [self initWithTitle:title
                       message:message
                   cancelTitle:cancelTitle
                   otherTitles:(otherTitle) ? @[ otherTitle ] : nil
                   contentView:contentView
                    completion:completion
                   tapGestures:NO];
}

- (id)initWithTitle:(NSString *)title
            message:(NSString *)message
        cancelTitle:(NSString *)cancelTitle
        otherTitles:(NSArray *)otherTitles
        contentView:(UIView *)contentView
         completion:(PXAlertViewCompletionBlock)completion
        tapGestures:(BOOL)isTapEnable
{
    self = [super init];
    if (self) {
        _lineLayerArray=[NSMutableArray array];
        
        _mainWindow = [self windowWithLevel:UIWindowLevelNormal];
        _alertWindow = [self windowWithLevel:UIWindowLevelAlert];
        
        if (!_alertWindow) {
            _alertWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
            _alertWindow.windowLevel = UIWindowLevelAlert;
            _alertWindow.backgroundColor = [UIColor clearColor];
        }
        _alertWindow.userInteractionEnabled = YES;
        _alertWindow.rootViewController = self;
        
        CGRect frame = [self frameForOrientation:self.interfaceOrientation];
        self.view.frame = frame;
        
        _backgroundView = [[UIView alloc] initWithFrame:frame];
        _backgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.25];
        _backgroundView.alpha = 0;
        [self.view addSubview:_backgroundView];
        
        _alertView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, AlertViewWidth, 150)];
//        _alertView.backgroundColor = [UIColor colorWithWhite:0.25 alpha:1];
        _alertView.backgroundColor = [UIColor whiteColor];
        _alertView.layer.cornerRadius = 8.0;
        _alertView.layer.opacity = .95;
        _alertView.clipsToBounds = YES;
        
        UIImageView  *alertBgImageView=[[UIImageView alloc] initWithFrame:_alertView.bounds];
        alertBgImageView.backgroundColor=[UIColor clearColor];
        _alertBgImageView=alertBgImageView;
        [_alertView addSubview:alertBgImageView];
        [self.view addSubview:_alertView];
        
        // Title
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(AlertViewContentMargin,
                                                                AlertViewVerticalElementSpace,
                                                                AlertViewWidth - AlertViewContentMargin*2,
                                                                44)];
        _titleLabel.text = title;
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont boldSystemFontOfSize:17];
        _titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _titleLabel.numberOfLines = 0;
        _titleLabel.frame = [self adjustLabelFrameHeight:self.titleLabel];
        [_alertView addSubview:_titleLabel];
        
        CGFloat messageLabelY = _titleLabel.frame.origin.y + _titleLabel.frame.size.height + AlertViewVerticalElementSpace;
        
        // Optional Content View
        if (contentView) {
            _contentView = contentView;
            _contentView.frame = CGRectMake(0,
                                            messageLabelY,
                                            _contentView.frame.size.width,
                                            _contentView.frame.size.height);
            _contentView.center = CGPointMake(AlertViewWidth/2, _contentView.center.y);
            [_alertView addSubview:_contentView];
            messageLabelY += contentView.frame.size.height + AlertViewVerticalElementSpace;
        }
        
        // Message
        _messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(AlertViewContentMargin,
                                                                  messageLabelY,
                                                                  AlertViewWidth - AlertViewContentMargin*2,
                                                                  44)];
        _messageLabel.text = message;
        _messageLabel.backgroundColor = [UIColor clearColor];
        _messageLabel.textColor = [UIColor blackColor];
        _messageLabel.textAlignment = NSTextAlignmentCenter;
        _messageLabel.font = [UIFont systemFontOfSize:15];
        _messageLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _messageLabel.numberOfLines = 0;
        _messageLabel.frame = [self adjustLabelFrameHeight:self.messageLabel];
        [_alertView addSubview:_messageLabel];
        
        //初始化分割线及按钮
        [self initLineAndBtns:cancelTitle otherTitles:otherTitles];
                
        //alertView子视图布局
        [self layoutSubviews_alertView];
        
        //self.view子视图布局
        [self layoutSubviews_selfView];
        
        if (completion) {
            _completion = completion;
        }

        //更新背景手势点击处理
        [self setupGestures:isTapEnable];
        
        //设定alertView的默认样式
        [self setAlertViewStyle:PXAlertViewStyleDefault];
    }
    return self;
}

//customAlertView
- (id)initWithCustomView:(UIView*)customView{
    self = [super init];
    if (self) {
        _mainWindow = [self windowWithLevel:UIWindowLevelNormal];
        _alertWindow = [self windowWithLevel:UIWindowLevelAlert];
        
        if (!_alertWindow) {
            _alertWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
            _alertWindow.windowLevel = UIWindowLevelAlert;
            _alertWindow.backgroundColor = [UIColor clearColor];
        }
        _alertWindow.userInteractionEnabled = YES;
        _alertWindow.rootViewController = self;
        
        CGRect frame = [self frameForOrientation:self.interfaceOrientation];
        self.view.frame = frame;
        
        _backgroundView = [[UIView alloc] initWithFrame:frame];
        _backgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.25];
        _backgroundView.alpha = 0;
        [self.view addSubview:_backgroundView];
        
        _alertView = customView;
        _alertView.backgroundColor = [UIColor colorWithWhite:0.25 alpha:1];
        _alertView.layer.cornerRadius = 8.0;
        _alertView.layer.opacity = .95;
        _alertView.clipsToBounds = YES;
        [self.view addSubview:_alertView];
        
        _alertView.bounds = CGRectMake(0, 0, AlertViewWidth, _alertView.frame.size.height);
        _alertView.center = [self centerWithFrame:frame];
        [self setupGestures:NO];
    }
    return self;
}

/*
 *初始化分割线及按钮
 */
-(void)initLineAndBtns:(NSString*)cancelTitle otherTitles:(NSArray*)otherTitles{
    NSMutableArray *titleArray=[NSMutableArray array];
    if (cancelTitle) {
        [titleArray addObject:cancelTitle];
    }
    if (titleArray) {
        [titleArray addObjectsFromArray:otherTitles];
    }
    
    //如果2个按钮
    if (titleArray.count==2) {
        //横向分割线
        CALayer *lineLayer = [self lineLayer];
        [self.alertView.layer addSublayer:lineLayer];
        [_lineLayerArray addObject:lineLayer];
        
        //first button
        NSString *title0=[titleArray objectAtIndex:0];
        UIButton *button0 = [self genericButton];
        [button0 setTitle:title0 forState:UIControlStateNormal];
        [self.alertView addSubview:button0];
        if (cancelTitle) {
            self.cancelButton=button0;
            self.cancelButton.titleLabel.font = [UIFont boldSystemFontOfSize:17];
        }
        self.buttons = (self.buttons) ? [self.buttons arrayByAddingObject:button0] : @[ button0 ];
        
        //垂直分割线
        self.verticalLine = [self lineLayer];
        [self.alertView.layer addSublayer:self.verticalLine];
        [_lineLayerArray addObject:self.verticalLine];
        
        //second button
        NSString *title1=[titleArray objectAtIndex:1];
        UIButton *button1 = [self genericButton];
        [button1 setTitle:title1 forState:UIControlStateNormal];
        [self.alertView addSubview:button1];
        self.otherButton = button1;
        self.buttons = (self.buttons) ? [self.buttons arrayByAddingObject:button1] : @[ button1 ];
    }else{
        for (int i=0; i<titleArray.count; i++) {
            CALayer *lineLayer = [self lineLayer];
            lineLayer.frame = CGRectMake(0, 0, AlertViewWidth, AlertViewLineLayerWidth);
            [self.alertView.layer addSublayer:lineLayer];
            [_lineLayerArray addObject:lineLayer];
            
            NSString *title=[titleArray objectAtIndex:i];
            UIButton *button = [self genericButton];
            [button setTitle:title forState:UIControlStateNormal];
            [self.alertView addSubview:button];
            if (cancelTitle&&i==0) {
                self.cancelButton=button;
                self.cancelButton.titleLabel.font = [UIFont boldSystemFontOfSize:17];
            }
            self.buttons = (self.buttons) ? [self.buttons arrayByAddingObject:button] : @[ button ];
        }
    }
}

- (CGRect)frameForOrientation:(UIInterfaceOrientation)orientation
{
    CGRect frame;
    if (orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight) {
        CGRect bounds = [UIScreen mainScreen].bounds;
        frame = CGRectMake(bounds.origin.x, bounds.origin.y, bounds.size.height, bounds.size.width);
    } else {
        frame = [UIScreen mainScreen].bounds;
    }
    return frame;
}

- (CGRect)adjustLabelFrameHeight:(UILabel *)label
{
    CGFloat height;
    
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        CGSize size = [label.text sizeWithFont:label.font
                             constrainedToSize:CGSizeMake(label.frame.size.width, FLT_MAX)
                                 lineBreakMode:NSLineBreakByWordWrapping];
        
        height = size.height;
#pragma clang diagnostic pop
    } else {
        NSStringDrawingContext *context = [[NSStringDrawingContext alloc] init];
        context.minimumScaleFactor = 1.0;
        CGRect bounds = [label.text boundingRectWithSize:CGSizeMake(label.frame.size.width, FLT_MAX)
                                                 options:NSStringDrawingUsesLineFragmentOrigin
                                              attributes:@{NSFontAttributeName:label.font}
                                                 context:context];
        height = bounds.size.height;
    }
    
    return CGRectMake(label.frame.origin.x, label.frame.origin.y, label.frame.size.width, height);
}

- (UIButton *)genericButton
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor clearColor];
    button.titleLabel.font = [UIFont systemFontOfSize:17];
//    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [button setTitleColor:[UIColor colorWithWhite:0.25 alpha:1] forState:UIControlStateHighlighted];
    [button setTitleColor:[UIColor colorWithRed:0.0 green:0.48 blue:1 alpha:1] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithRed:0.0 green:0.48 blue:1 alpha:1] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(dismiss:) forControlEvents:UIControlEventTouchUpInside];
    [button addTarget:self action:@selector(setBackgroundColorForButton:) forControlEvents:UIControlEventTouchDown];
    [button addTarget:self action:@selector(clearBackgroundColorForButton:) forControlEvents:UIControlEventTouchDragExit];
    button.titleLabel.lineBreakMode=NSLineBreakByTruncatingTail;
    button.contentEdgeInsets=UIEdgeInsetsMake(0, 10, 0, 10);
    return button;
}

- (CGPoint)centerWithFrame:(CGRect)frame
{
    return CGPointMake(CGRectGetMidX(frame), CGRectGetMidY(frame) - [self statusBarOffset]);
}

- (CGFloat)statusBarOffset
{
    CGFloat statusBarOffset = 0;
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        statusBarOffset = 20;
    }
    return statusBarOffset;
}

- (void)setupGestures:(BOOL)isTapEnable{
    if (isTapEnable) {
        self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss:)];
        [self.tap setNumberOfTapsRequired:1];
        [self.backgroundView setUserInteractionEnabled:YES];
        [self.backgroundView setMultipleTouchEnabled:NO];
        [self.backgroundView addGestureRecognizer:self.tap];
    }else{
        if (self.tap) {
            [self.backgroundView removeGestureRecognizer:self.tap];
            self.tap = nil;
        }
        [self.backgroundView setUserInteractionEnabled:NO];
        [self.backgroundView setMultipleTouchEnabled:NO];
    }
}

//按钮进入点击态的事件处理方法
- (void)setBackgroundColorForButton:(id)sender{
//    [sender setBackgroundColor:[UIColor colorWithRed:94/255.0 green:196/255.0 blue:221/255.0 alpha:1.0]];
    if (self.cancelButton) {
        [sender setBackgroundColor:self.styleOption.cancelButtonBackgroundColor];
        [sender setTitleColor:self.styleOption.cancelButtonTitleHilightedColor forState:UIControlStateHighlighted];
    }else{
        [sender setBackgroundColor:self.styleOption.otherButtonBackgroundColor];
        [sender setTitleColor:self.styleOption.otherButtonTitleHilightedColor forState:UIControlStateHighlighted];
    }
}

//按钮从点击态切回正常态的事件处理方法
- (void)clearBackgroundColorForButton:(id)sender{
    if (self.cancelButton) {
        [sender setBackgroundColor:[UIColor clearColor]];
        [sender setTitleColor:self.styleOption.cancelButtonTitleColor forState:UIControlStateNormal];
    }else{
        [sender setBackgroundColor:[UIColor clearColor]];
        [sender setTitleColor:self.styleOption.otherButtonTitleColor forState:UIControlStateNormal];
    }
}

- (void)show
{
    [[PXAlertViewStack sharedInstance] push:self];
}

- (void)showInternal
{
    [self.alertWindow addSubview:self.view];
    [self.alertWindow makeKeyAndVisible];
    self.alertWindow.userInteractionEnabled = YES;
    self.visible = YES;
    [self showBackgroundView];
    [self showAlertAnimation];
}

- (void)showBackgroundView
{
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
        self.mainWindow.tintAdjustmentMode = UIViewTintAdjustmentModeDimmed;
        [self.mainWindow tintColorDidChange];
    }
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundView.alpha = 1;
    }];
}

- (void)hide
{
    [self.view removeFromSuperview];
}

- (void)clearWindow
{
    self.alertWindow.userInteractionEnabled = NO;
    [self.alertWindow removeFromSuperview];
    self.alertWindow = nil;
    [self.mainWindow makeKeyAndVisible];
}

- (void)dismiss:(id)sender
{
    [self dismiss:sender animated:YES];
}

- (void)dismiss:(id)sender animated:(BOOL)animated
{
    self.visible = NO;
    if (animated) {
        [self dismissAlertAnimation];
    }
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
        self.mainWindow.tintAdjustmentMode = UIViewTintAdjustmentModeAutomatic;
        [self.mainWindow tintColorDidChange];
    }
    [UIView animateWithDuration:(animated ? 0.2 : 0) animations:^{
        self.backgroundView.alpha = 0;
        self.alertView.alpha = 0;
    } completion:^(BOOL finished) {
        [[PXAlertViewStack sharedInstance] pop:self];
        if ([PXAlertViewStack sharedInstance].alertViews.count<=0) {
            [self clearWindow];
        }
        [self.view removeFromSuperview];
        
        if (self.completion) {
            BOOL cancelled = NO;
            if (sender == self.cancelButton || sender == self.tap) {
                cancelled = YES;
            }
            NSInteger buttonIndex = -1;
            if (self.buttons) {
                NSUInteger index = [self.buttons indexOfObject:sender];
                if (buttonIndex != NSNotFound) {
                    buttonIndex = index;
                }
            }
            self.completion(cancelled, buttonIndex);
        }
        
        
        
    }];
    
    
    
    
}

- (void)showAlertAnimation
{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    
    animation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1)],
                         [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.05, 1.05, 1)],
                         [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1)]];
    animation.keyTimes = @[ @0, @0.5, @1 ];
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    animation.duration = .3;
    
    [self.alertView.layer addAnimation:animation forKey:@"showAlert"];
}

- (void)dismissAlertAnimation
{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    
    animation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1)],
                         [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.95, 0.95, 1)],
                         [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.8, 0.8, 1)]];
    animation.keyTimes = @[ @0, @0.5, @1 ];
    animation.fillMode = kCAFillModeRemoved;
    animation.duration = .2;
    
    [self.alertView.layer addAnimation:animation forKey:@"dismissAlert"];
}

- (CALayer *)lineLayer
{
    CALayer *lineLayer = [CALayer layer];
    //    lineLayer.backgroundColor = [[UIColor colorWithWhite:0.90 alpha:0.3] CGColor];
    //浅灰色
    lineLayer.backgroundColor = [[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.3] CGColor];
    return lineLayer;
}

#pragma mark -
#pragma mark UIViewController

- (BOOL)prefersStatusBarHidden
{
	return [UIApplication sharedApplication].statusBarHidden;
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration
{
    CGRect frame = [self frameForOrientation:interfaceOrientation];
    self.backgroundView.frame = frame;
    self.alertView.center = [self centerWithFrame:frame];
}

#pragma mark -
#pragma mark Public

+ (instancetype)showAlertWithTitle:(NSString *)title
{
    return [[self class] showAlertWithTitle:title message:nil cancelTitle:NSLocalizedString(@"Ok", nil) completion:nil];
}

+ (instancetype)showAlertWithTitle:(NSString *)title
                           message:(NSString *)message
{
    return [[self class] showAlertWithTitle:title message:message cancelTitle:NSLocalizedString(@"Ok", nil) completion:nil];
}

+ (instancetype)showAlertWithTitle:(NSString *)title
                           message:(NSString *)message
                        completion:(PXAlertViewCompletionBlock)completion
{
    return [[self class] showAlertWithTitle:title message:message cancelTitle:NSLocalizedString(@"Ok", nil) completion:completion];
}

+ (instancetype)showAlertWithTitle:(NSString *)title
                           message:(NSString *)message
                       cancelTitle:(NSString *)cancelTitle
                        completion:(PXAlertViewCompletionBlock)completion
{
    PXAlertView *alertView = [[self alloc] initWithTitle:title
                                                 message:message
                                             cancelTitle:cancelTitle
                                              otherTitle:nil
                                             contentView:nil
                                              completion:completion];
    [alertView show];
    return alertView;
}

+ (instancetype)showAlertWithTitle:(NSString *)title
                           message:(NSString *)message
                       cancelTitle:(NSString *)cancelTitle
                        otherTitle:(NSString *)otherTitle
                        completion:(PXAlertViewCompletionBlock)completion
{
    PXAlertView *alertView = [[self alloc] initWithTitle:title
                                                 message:message
                                             cancelTitle:cancelTitle
                                              otherTitle:otherTitle
                                             contentView:nil
                                              completion:completion];
    [alertView show];
    return alertView;
}

+ (instancetype)showAlertWithTitle:(NSString *)title
                           message:(NSString *)message
                       cancelTitle:(NSString *)cancelTitle
                       otherTitles:(NSArray *)otherTitles
                        completion:(PXAlertViewCompletionBlock)completion
{
    PXAlertView *alertView = [[self alloc] initWithTitle:title
                                                 message:message
                                             cancelTitle:cancelTitle
                                             otherTitles:otherTitles
                                             contentView:nil
                                              completion:completion
                                             tapGestures:NO];
    [alertView show];
    return alertView;
}

+ (instancetype)showAlertWithTitle:(NSString *)title
                           message:(NSString *)message
                       cancelTitle:(NSString *)cancelTitle
                        otherTitle:(NSString *)otherTitle
                       contentView:(UIView *)view
                        completion:(PXAlertViewCompletionBlock)completion
{
    PXAlertView *alertView = [[self alloc] initWithTitle:title
                                                 message:message
                                             cancelTitle:cancelTitle
                                              otherTitle:otherTitle
                                             contentView:view
                                              completion:completion];
    [alertView show];
    return alertView;
}

+ (instancetype)showAlertWithTitle:(NSString *)title
                           message:(NSString *)message
                       cancelTitle:(NSString *)cancelTitle
                       otherTitles:(NSArray *)otherTitles
                       contentView:(UIView *)view
                        completion:(PXAlertViewCompletionBlock)completion
{
    PXAlertView *alertView = [[self alloc] initWithTitle:title
                                                 message:message
                                             cancelTitle:cancelTitle
                                             otherTitles:otherTitles
                                             contentView:view
                                              completion:completion
                                             tapGestures:NO];
    [alertView show];
    return alertView;
}

/*
 *  自定义样式的alertView
 *
 */
+ (instancetype)showAlertWithTitle:(NSString *)title
                 message:(NSString *)message
             contentView:(UIView*)contentView
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
                                               contentView:contentView
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

//完全自定义alertView
+ (PXAlertView *)showAlertWithCustomAlertView:(UIView*)customAlertView{
    PXAlertView *alertView = [[PXAlertView alloc] initWithCustomView:customAlertView];
    [alertView show];
    return alertView;
}

/*
 * 设置PXAlertViewStyle可选样式样式
 */
-(void)setAlertViewStyle:(PXAlertViewStyle)alertViewStyle{
    //指定样式
    PXAlertViewStyleOption *styleOption=[PXAlertViewStyleOption alertViewStyleOptionWithStyle:alertViewStyle];
    //更新样式
    [self setStyleOption:styleOption];
}

-(void)setStyleOption:(PXAlertViewStyleOption*)styleOption{
    //保存PXAlertView样式
    if (_styleOption!=styleOption) {
        _styleOption=styleOption;
    }
    
    /*更新PXAlertView界面*/
    //
    self.backgroundView.backgroundColor = styleOption.windowTintColor;
    
    //alertBgImageView优先设置
    self.alertView.backgroundColor = styleOption.alertViewBgColor;
    if (styleOption.alertViewBgimage) {
        _alertBgImageView.image=styleOption.alertViewBgimage;
        _alertView.backgroundColor = [UIColor clearColor];
    }
    
    self.titleLabel.textColor = styleOption.titleColor;
    self.titleLabel.font = styleOption.titleFont;
    self.messageLabel.textColor = styleOption.messageColor;
    self.messageLabel.font = styleOption.messageFont;
    
    //更新UIButton的样式
    for (UIButton *btn in self.buttons) {
        [self clearBackgroundColorForButton:btn];
    }
    
    //更新lineLayer
    [self.lineLayerArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        CALayer *lineLayer=(CALayer*)obj;
        lineLayer.backgroundColor=[self.styleOption.lineColor CGColor];
    }];
    
    //alertView子视图布局: alertView上add以及reomew子视图，以及子视图的frame变化，均会引起resizeViews方法调用
    [self layoutSubviews_alertView];
    
    //self.view子视图布局: self.view上add及remove子视图，以及子视图的frame变化，均会引起layoutSubviews_selfView方法调用
    [self layoutSubviews_selfView];
}



/*
 *  隐藏PXAlertView，默认PXAlertViewCompletionBlock中cancelled=YES
 */
- (void)dismissWithAnimated:(BOOL)animated{
    //默认设置为点击背景关闭alertView
    [self dismiss:self.tap animated:animated];
}

- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated
{
    if (buttonIndex >= 0 && buttonIndex < [self.buttons count]) {
        [self dismiss:self.buttons[buttonIndex] animated:animated];
    }
}

- (void)setTapToDismissEnabled:(BOOL)enabled
{
    [self setupGestures:enabled];
}

#pragma mark- layoutView
//self.view子视图布局: self.view上add及remove子视图，以及子视图的frame变化，均会引起layoutSubviews_selfView方法调用
-(void)layoutSubviews_selfView{
    _alertView.center = [self centerWithFrame:self.view.frame];
    self.alertBgImageView.frame = _alertView.bounds;

}

//alertView子视图布局: alertView上add以及reomew子视图，以及子视图的frame变化，均会引起resizeViews方法调用
- (void)layoutSubviews_alertView{
    CGFloat totalHeight = 0;
    //titleLab、contentView、messagelab布局不包括UIButton
    for (UIView *view in [self.alertView subviews]) {
        if ([view class] != [UIButton class]&& view!=self.alertBgImageView) {
            totalHeight += view.frame.size.height + AlertViewVerticalElementSpace;
        }
    }
    totalHeight += AlertViewVerticalElementSpace;
    
    //分割线及按钮布局
    if (self.buttons) {
        //两个按钮时横向排列
        if (self.buttons.count==2) {
            //分割线
            CALayer *lineLayer=[_lineLayerArray objectAtIndex:0];
            lineLayer.frame = CGRectMake(0, totalHeight, AlertViewWidth, AlertViewLineLayerWidth);
            totalHeight += lineLayer.frame.size.height;
            
            //first button
            UIButton *btn0=[self.buttons objectAtIndex:0];
            btn0.frame=CGRectMake(0, totalHeight, AlertViewWidth/2, AlertViewButtonHeight);
            
            //垂直分割线
            self.verticalLine.frame = CGRectMake(AlertViewWidth/2, CGRectGetMaxY(lineLayer.frame), AlertViewLineLayerWidth, AlertViewButtonHeight);
            
            //second button
            UIButton *btn1=[self.buttons objectAtIndex:1];
            btn1.frame=CGRectMake(CGRectGetMaxX(btn0.frame), totalHeight, AlertViewWidth/2, AlertViewButtonHeight);
            totalHeight += btn0.frame.size.height;
        }
        //1个按钮或者3个及以上数目按钮
        else{
            for (int i=0; i<self.buttons.count; i++) {
                CALayer *lineLayer=[_lineLayerArray objectAtIndex:i];
                lineLayer.frame = CGRectMake(0, totalHeight, AlertViewWidth, AlertViewLineLayerWidth);
                totalHeight += lineLayer.frame.size.height;
                
                UIButton *btn=[self.buttons objectAtIndex:i];
                btn.frame=CGRectMake(0, totalHeight, AlertViewWidth, AlertViewButtonHeight);
                totalHeight += btn.frame.size.height;
            }
        }
    }
    
    self.alertView.frame = CGRectMake(self.alertView.frame.origin.x,
                                      self.alertView.frame.origin.y,
                                      self.alertView.frame.size.width,
                                      totalHeight);
    
    self.alertBgImageView.frame=self.alertView.bounds;
    
    //self.view子视图布局: self.view上add及remove子视图，以及子视图的frame变化，均会引起layoutSubviews_selfView方法调用
    [self layoutSubviews_selfView];
}


@end


#pragma mark- PXAlertViewStack
@implementation PXAlertViewStack

+ (instancetype)sharedInstance
{
    static PXAlertViewStack *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[PXAlertViewStack alloc] init];
        _sharedInstance.alertViews = [NSMutableArray array];
    });
    
    return _sharedInstance;
}

- (void)push:(PXAlertView *)alertView
{
    [self.alertViews addObject:alertView];
    [alertView showInternal];
    for (PXAlertView *av in self.alertViews) {
        if (av != alertView) {
            [av hide];
        }
    }
}

- (void)pop:(PXAlertView *)alertView
{
    [self.alertViews removeObject:alertView];
    PXAlertView *last = [self.alertViews lastObject];
    if (last) {
        [last showInternal];
    }
}

@end
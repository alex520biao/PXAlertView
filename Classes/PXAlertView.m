//
//  PXAlertView.m
//  PXAlertViewDemo
//
//  Created by Alex Jarvis on 25/09/2013.
//  Copyright (c) 2013 Panaxiom Ltd. All rights reserved.
//

#import "PXAlertView.h"
#define kBtnFontSize 16
@interface PXAlertViewStack : NSObject

@property (nonatomic,strong) NSMutableArray *alertViews;

+ (PXAlertViewStack *)sharedInstance;

- (void)push:(PXAlertView *)alertView;
- (void)pop:(PXAlertView *)alertView;

@end

static const CGFloat AlertViewWidth = 270.0;
static const CGFloat AlertViewContentMargin = 9;
static const CGFloat AlertViewVerticalElementSpace = 10;
static const CGFloat AlertViewButtonHeight = 44;
static const CGFloat AlertViewLineLayerWidth = 1;//非高清屏幕不支持0.5px

@interface PXAlertView ()
@property (nonatomic,weak) UIWindow *mainWindow; //程序主window
@property (nonatomic,strong) UIWindow *alertWindow;//PXAlertView所在的window

@property (nonatomic,strong) UIView *backgroundView;
@property (nonatomic,strong) UIView *alertView;
@property (nonatomic,strong) UIImageView *alertBgImageView;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIView *contentView;
@property (nonatomic,strong) UILabel *secondTitleLabel;
@property (nonatomic,strong) UILabel *messageLabel;
@property (nonatomic,strong) UIButton *cancelButton;
@property (nonatomic,strong) UIButton *otherButton;
@property (nonatomic,strong) NSArray *buttons;
@property (nonatomic,assign) CGFloat buttonsY;
@property (nonatomic,strong) UIImageView *verticalLine;
@property (nonatomic,strong) UITapGestureRecognizer *tap;
@property (nonatomic, copy) void (^completion)(BOOL cancelled, NSInteger buttonIndex);

//存放所有分割线(横向、纵向)
@property (nonatomic,strong)NSMutableArray *lineLayerArray;


@property (nonatomic,strong)PXAlertViewStyleOption *styleOption;

@end

@implementation PXAlertView
@synthesize styleOption=_styleOption;
@synthesize lineLayerArray=_lineLayerArray;

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
        contentView:(UIView *)contentView
        secondTitle:(NSString *)secondTitle
            message:(NSString *)message
        cancelTitle:(NSString *)cancelTitle
        otherTitles:(NSArray *)otherTitles
           btnStyle:(BOOL)btnStyle
     alertViewStyle:(PXAlertViewStyle)alertViewStyle
         completion:(PXAlertViewCompletionBlock)completion
        tapGestures:(BOOL)isTapEnable
{
    self = [super init];
    if (self) {
        _lineLayerArray=[NSMutableArray array];
        
        _mainWindow = [self windowWithLevel:UIWindowLevelNormal];
        _alertWindow = [self windowWithLevel:UIWindowLevelAlert];
        
        if (!_alertWindow) {
            //UIWindow是直接显示在UIScreen上的，UIScreen坐标系左顶点为手机左顶点
            _alertWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
            _alertWindow.windowLevel = UIWindowLevelAlert;
            _alertWindow.backgroundColor = [UIColor clearColor];
        }
        _alertWindow.userInteractionEnabled = YES;
//        _alertWindow.rootViewController = self;
        
        self.view.frame = _alertWindow.bounds;
        
        //UIViewController上得view得子视图的frame
        CGRect frame = [self frameForOrientation:self.interfaceOrientation];
        _backgroundView = [[UIView alloc] initWithFrame:frame];
        _backgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.25];
        _backgroundView.alpha = 1;//背景色无需动画
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
            [_alertView addSubview:_contentView];
            _contentView.center = CGPointMake(floorf(AlertViewWidth/2), _contentView.center.y);
            messageLabelY += contentView.frame.size.height + AlertViewVerticalElementSpace;
        }
        
        _secondTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(AlertViewContentMargin,
                                                                      messageLabelY,
                                                                      AlertViewWidth - AlertViewContentMargin*2,
                                                                      44)];
        _secondTitleLabel.text = secondTitle;
        _secondTitleLabel.backgroundColor = [UIColor clearColor];
        _secondTitleLabel.textColor = [UIColor blackColor];
        _secondTitleLabel.textAlignment = NSTextAlignmentCenter;
        _secondTitleLabel.font = [UIFont boldSystemFontOfSize:17];
        _secondTitleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _secondTitleLabel.numberOfLines = 0;
        _secondTitleLabel.frame = [self adjustLabelFrameHeight:_secondTitleLabel];
        [_alertView addSubview:_secondTitleLabel];
        messageLabelY += _secondTitleLabel.frame.size.height + AlertViewVerticalElementSpace;
        
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
        [self setAlertViewStyle:alertViewStyle btnStyle:btnStyle];
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
        UIImageView *lineLayer = [self lineLayer];
        [self.alertView addSubview:lineLayer];
        [_lineLayerArray addObject:lineLayer];
        
        //first button
        NSString *title0=[titleArray objectAtIndex:0];
        UIButton *button0 = [self genericButton];
        [button0 setTitle:title0 forState:UIControlStateNormal];
        [self.alertView addSubview:button0];
        if (cancelTitle) {
            self.cancelButton=button0;
            self.cancelButton.titleLabel.font = [UIFont systemFontOfSize:kBtnFontSize];
        }
        self.buttons = (self.buttons) ? [self.buttons arrayByAddingObject:button0] : @[ button0 ];
        
        //垂直分割线
        self.verticalLine = [self lineLayer];
        [self.alertView addSubview:self.verticalLine];
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
            UIImageView *lineLayer = [self lineLayer];
            lineLayer.frame = CGRectMake(0, 2*i, AlertViewWidth, AlertViewLineLayerWidth);
            [self.alertView addSubview:lineLayer];
            [_lineLayerArray addObject:lineLayer];
            
            NSString *title=[titleArray objectAtIndex:i];
            UIButton *button = [self genericButton];
            [button setTitle:title forState:UIControlStateNormal];
            [self.alertView addSubview:button];
            if (cancelTitle&&i==0) {
                self.cancelButton=button;
                self.cancelButton.titleLabel.font = [UIFont systemFontOfSize:kBtnFontSize];
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
    button.adjustsImageWhenHighlighted=NO;
    button.backgroundColor = [UIColor clearColor];
    button.titleLabel.font = [UIFont systemFontOfSize:kBtnFontSize];
//    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [button setTitleColor:[UIColor colorWithWhite:0.25 alpha:1] forState:UIControlStateHighlighted];
//    [button setTitleColor:[UIColor colorWithRed:0.0 green:0.48 blue:1 alpha:1] forState:UIControlStateNormal];
//    [button setTitleColor:[UIColor colorWithRed:0.0 green:0.48 blue:1 alpha:1] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(dismiss:) forControlEvents:UIControlEventTouchUpInside];
    [button addTarget:self action:@selector(setBackgroundColorForButton:) forControlEvents:UIControlEventTouchDown];
    [button addTarget:self action:@selector(clearBackgroundColorForButton:) forControlEvents:UIControlEventTouchDragExit];
    button.titleLabel.lineBreakMode=NSLineBreakByTruncatingTail;
    button.contentEdgeInsets=UIEdgeInsetsMake(0, 10, 0, 10);
    return button;
}

- (CGPoint)centerWithFrame:(CGRect)frame
{
    return CGPointMake(CGRectGetMidX(frame), CGRectGetMidY(frame));
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
- (void)setBackgroundColorForButton:(UIButton*)sender{
    if (self.cancelButton==sender) {
        [sender setTitleColor:self.styleOption.specialButtonTitleHilightedColor forState:UIControlStateNormal];

        if (self.styleOption.specialButtonBackgroundHilightedImage) {
            [sender setBackgroundColor:[UIColor clearColor]];
            [sender setBackgroundImage:self.styleOption.specialButtonBackgroundHilightedImage forState:UIControlStateNormal];
        }else{
            [sender setBackgroundColor:self.styleOption.specialButtonBackgroundHilightedColor];
        }
    }else{
        [sender setTitleColor:self.styleOption.otherButtonTitleHilightedColor forState:UIControlStateNormal];
        if (self.styleOption.otherButtonBackgroundHilightedImage) {
            [sender setBackgroundColor:[UIColor clearColor]];
            [sender setBackgroundImage:self.styleOption.otherButtonBackgroundHilightedImage forState:UIControlStateNormal];
        }else{
            [sender setBackgroundColor:self.styleOption.otherButtonBackgroundHilightedColor];
        }
    }
}

//按钮从点击态切回正常态的事件处理方法
- (void)clearBackgroundColorForButton:(UIButton*)sender{
    if (self.cancelButton==sender) {
        [sender setTitleColor:self.styleOption.specialButtonTitleColor forState:UIControlStateNormal];
        
        //使用分割线
        if (self.styleOption.btnStyle) {
            sender.layer.cornerRadius=0;//清除圆角
            [sender setBackgroundColor:self.styleOption.specialButtonBackgroundColor];
            [sender setBackgroundImage:nil forState:UIControlStateNormal];
        }else{
            //优先使用背景图片
            if (self.styleOption.specialButtonBackgroundImage) {
                [sender setBackgroundColor:[UIColor clearColor]];
                [sender setBackgroundImage:self.styleOption.specialButtonBackgroundImage forState:UIControlStateNormal];
                sender.layer.cornerRadius=0;//清除圆角
            }else{
                [sender setBackgroundColor:self.styleOption.specialButtonBackgroundColor];
                [sender setBackgroundImage:nil forState:UIControlStateNormal];
                sender.layer.cornerRadius=5;//设置圆角
            }
        }
    }else{
        [sender setTitleColor:self.styleOption.otherButtonTitleColor forState:UIControlStateNormal];
        
        //使用分割线
        if (self.styleOption.btnStyle) {
            sender.layer.cornerRadius=0;//清除圆角
            [sender setBackgroundColor:self.styleOption.otherButtonBackgroundColor];
            [sender setBackgroundImage:nil forState:UIControlStateNormal];
        }else{
            //优先使用背景图片
            if (self.styleOption.otherButtonBackgroundImage) {
                [sender setBackgroundColor:[UIColor clearColor]];
                [sender setBackgroundImage:self.styleOption.otherButtonBackgroundImage forState:UIControlStateNormal];
                sender.layer.cornerRadius=0;//清除圆角
            }else{
                [sender setBackgroundColor:self.styleOption.otherButtonBackgroundColor];
                [sender setBackgroundImage:nil forState:UIControlStateNormal];
                sender.layer.cornerRadius=5;//设置圆角
            }
        }
    }
}

- (void)show
{
    [[PXAlertViewStack sharedInstance] push:self];
}

- (void)showInternal
{
//    [self.alertWindow addSubview:self.view];
    self.alertWindow.rootViewController=self;
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
//    [self.view removeFromSuperview];
}

- (void)clearWindow
{
    self.alertWindow.userInteractionEnabled = NO;
//    [self.alertWindow removeFromSuperview];
    
    [self.mainWindow makeKeyAndVisible];
    self.alertWindow.rootViewController = nil;
    self.alertWindow = nil;
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
//        self.backgroundView.alpha = 0;
        self.alertView.alpha = 0;
    } completion:^(BOOL finished) {
        [[PXAlertViewStack sharedInstance] pop:self];
        if ([PXAlertViewStack sharedInstance].alertViews.count<=0) {
            [self clearWindow];
        }
//        [self.view removeFromSuperview];
        
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

- (UIImageView *)lineLayer
{
    UIImageView *lineLayer = [[UIImageView alloc] init];
    //    lineLayer.backgroundColor = [[UIColor colorWithWhite:0.90 alpha:0.3] CGColor];
    //浅灰色
    lineLayer.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.3];
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
     _alertWindow.frame=[[UIScreen mainScreen] bounds];
     self.view.frame=_alertWindow.bounds;
     self.backgroundView.frame = self.view.bounds;
     
     CGRect frame = [self frameForOrientation:interfaceOrientation];
     CGPoint center=[self centerWithFrame:frame];
     self.alertView.center = center;
}

//- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
////    CGRect appFrame=[[UIScreen mainScreen] applicationFrame];//程序的frame
//    _alertWindow.frame=[[UIScreen mainScreen] bounds];
//    self.view.frame=_alertWindow.bounds;
//    self.backgroundView.frame = self.view.bounds;
//    
//    CGRect frame = [self frameForOrientation:self.interfaceOrientation];
//    CGPoint center=[self centerWithFrame:frame];
//    self.alertView.center = center;
//}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
     //    CGRect appFrame=[[UIScreen mainScreen] applicationFrame];//程序的frame
     _alertWindow.frame=[[UIScreen mainScreen] bounds];
    
     CGRect frame = [self frameForOrientation:self.interfaceOrientation];
    self.view.frame=frame;
    self.backgroundView.frame = frame;
     CGPoint center=[self centerWithFrame:frame];
     self.alertView.center = center;
}

#pragma mark -
#pragma mark Public
/*
 *  自定义样式的alertView
 *
 */
+ (instancetype)showAlertWithTitle:(NSString *)title
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

    PXAlertView *alertView = [[PXAlertView alloc] initWithTitle:title
                                                    contentView:nil
                                                    secondTitle:nil
                                                        message:message
                                                    cancelTitle:cancelTitle
                                                    otherTitles:argsArray
                                                       btnStyle:NO
                                                 alertViewStyle:PXAlertViewStyleDefault
                                                     completion:completion
                                                    tapGestures:NO];
    [alertView show];
    return alertView;
}

+ (instancetype)showAlertWithTitle:(NSString *)title
                       contentView:(UIView *)view
                       secondTitle:(NSString *)secondTitle
                           message:(NSString *)message
                       cancelTitle:(NSString *)cancelTitle
                       otherTitles:(NSArray *)otherTitles
                          btnStyle:(BOOL)btnStyle
                        completion:(PXAlertViewCompletionBlock)completion{
    
    PXAlertView *alertView = [[PXAlertView alloc] initWithTitle:title
                                                    contentView:view
                                                    secondTitle:secondTitle
                                                        message:message
                                                    cancelTitle:cancelTitle
                                                    otherTitles:otherTitles
                                                       btnStyle:btnStyle
                                                 alertViewStyle:PXAlertViewStyleDefault
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
                       contentView:(UIView*)contentView
                       secondTitle:(NSString *)secondTitle
                           message:(NSString *)message
                          btnStyle:(BOOL)btnStyle
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
    
    return [PXAlertView showAlertWithTitle:title
                        contentView:contentView
                        secondTitle:secondTitle
                            message:message
                           btnStyle:btnStyle
                        cancelTitle:cancelTitle
                        otherTitles:argsArray
                      customization:customization
                         completion:completion];
}

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
                     customization:(CustomizationBlock)customization
                        completion:(PXAlertViewCompletionBlock)completion{

    //创建默认样式alertView并显示
    PXAlertView *alertView = [[PXAlertView alloc] initWithTitle:title
                                                    contentView:contentView
                                                    secondTitle:secondTitle
                                                        message:message
                                                    cancelTitle:cancelTitle
                                                    otherTitles:otherTitles
                                                       btnStyle:btnStyle
                                                 alertViewStyle:PXAlertViewStyleDefault
                                                     completion:completion
                                                    tapGestures:NO];
    
    [alertView show];

    //自定义样式刷新界面
    if(customization){
        __block PXAlertViewStyleOption *styleOption=[PXAlertViewStyleOption alertViewStyleOptionWithStyle:PXAVStyleCustomization btnStyle:btnStyle];
        styleOption=customization(alertView,styleOption);
        //更新样式
        [alertView setStyleOption:styleOption];
    }
    
    
    return alertView;
}

//完全自定义alertView
+ (PXAlertView *)showAlertWithCustomAlertView:(UIView*)customAlertView{
    PXAlertView *alertView = [[PXAlertView alloc] initWithCustomView:customAlertView];
    [alertView show];
    return alertView;
}

-(void)setStyleOption:(PXAlertViewStyleOption*)styleOption{
    //保存PXAlertView样式
    if (_styleOption!=styleOption) {
        _styleOption=styleOption;

        //更新
        [self updateView_styleOption];
    }
}

#pragma mark-other
/*
 * 设置PXAlertViewStyle可选样式样式
 */
-(void)setAlertViewStyle:(PXAlertViewStyle)alertViewStyle btnStyle:(BOOL)btnStyle{
    //指定样式
    PXAlertViewStyleOption *styleOption=[PXAlertViewStyleOption alertViewStyleOptionWithStyle:alertViewStyle btnStyle:btnStyle];
    //更新样式
    [self setStyleOption:styleOption];
}


#pragma mark- updateView
-(void)updateView_styleOption{
    /*更新PXAlertView界面*/
    //
    self.backgroundView.backgroundColor = self.styleOption.windowTintColor;
    
    //alertBgImageView优先设置
    self.alertView.backgroundColor = self.styleOption.alertViewBgColor;
    if (self.styleOption.alertViewBgimage) {
        _alertBgImageView.image=self.styleOption.alertViewBgimage;
        _alertView.backgroundColor = [UIColor clearColor];
    }
    
    self.titleLabel.textColor = self.styleOption.titleColor;
    self.titleLabel.font = self.styleOption.titleFont;
    self.secondTitleLabel.textColor=self.styleOption.titleColor;
    self.secondTitleLabel.font=self.styleOption.titleFont;
    self.messageLabel.textColor = self.styleOption.messageColor;
    self.messageLabel.font = self.styleOption.messageFont;
    
    //更新UIButton的样式
    for (UIButton *btn in self.buttons) {
        [self clearBackgroundColorForButton:btn];
    }
    
    //更新lineLayer
    [self.lineLayerArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIImageView *lineLayer=(UIImageView*)obj;
        lineLayer.backgroundColor=self.styleOption.lineColor;
        if (self.styleOption.btnStyle) {
            lineLayer.hidden=NO;
        }else{
            lineLayer.hidden=YES;
        }
    }];
    
    //alertView子视图布局: alertView上add以及reomew子视图，以及子视图的frame变化，均会引起resizeViews方法调用
    [self layoutSubviews_alertView];
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

    CGRect frame = [self frameForOrientation:self.interfaceOrientation];
    CGPoint center=[self centerWithFrame:frame];
    _alertView.center = center;
    self.alertBgImageView.frame = _alertView.bounds;
}

//alertView子视图布局: alertView上add以及reomew子视图，以及子视图的frame变化，均会引起resizeViews方法调用
- (void)layoutSubviews_alertView{
    int totalHeight = 0;
    //titleLab、contentView、messagelab布局不包括UIButton
    for (UIView *view in [self.alertView subviews]) {
        if (view==self.titleLabel||view==self.contentView||view==self.messageLabel||view==_secondTitleLabel) {
            totalHeight += view.frame.size.height + AlertViewVerticalElementSpace;            
        }
    }
    totalHeight += AlertViewVerticalElementSpace;
    
    //分割线及按钮布局
    if (self.buttons) {
        //两个按钮时横向排列
        if (self.buttons.count==2) {
            //使用分割线
            if (self.styleOption.btnStyle) {
                //分割线
                UIImageView *lineLayer=[_lineLayerArray objectAtIndex:0];
                lineLayer.frame = CGRectMake(0, totalHeight, AlertViewWidth, AlertViewLineLayerWidth);
                totalHeight += lineLayer.frame.size.height;
                
                //first button
                UIButton *btn0=[self.buttons objectAtIndex:0];
                btn0.frame=CGRectMake(0, totalHeight, floorf(AlertViewWidth/2), AlertViewButtonHeight);
                
                //垂直分割线
                self.verticalLine.frame = CGRectMake(floorf(AlertViewWidth/2), CGRectGetMaxY(lineLayer.frame), AlertViewLineLayerWidth, AlertViewButtonHeight);
                
                //second button
                UIButton *btn1=[self.buttons objectAtIndex:1];
                btn1.frame=CGRectMake(CGRectGetMaxX(btn0.frame), totalHeight, floorf(AlertViewWidth/2), AlertViewButtonHeight);
                totalHeight += btn0.frame.size.height;
            }else{
                //first button
                UIButton *btn0=[self.buttons objectAtIndex:0];
                btn0.frame=CGRectMake(AlertViewVerticalElementSpace, totalHeight, floorf((AlertViewWidth-3*AlertViewVerticalElementSpace)/2), AlertViewButtonHeight);
                
                //second button
                UIButton *btn1=[self.buttons objectAtIndex:1];
                btn1.frame=CGRectMake(AlertViewVerticalElementSpace+CGRectGetMaxX(btn0.frame), totalHeight, floorf((AlertViewWidth-3*AlertViewVerticalElementSpace)/2), AlertViewButtonHeight);
                totalHeight += btn0.frame.size.height;
            }
        }
        //1个按钮或者3个及以上数目按钮
        else{
            for (int i=0; i<self.buttons.count; i++) {
                //使用分割线
                if (self.styleOption.btnStyle) {
                    UIImageView *lineLayer=[_lineLayerArray objectAtIndex:i];
                    lineLayer.frame = CGRectMake(0, ceil(totalHeight), AlertViewWidth, AlertViewLineLayerWidth);
                    totalHeight += lineLayer.frame.size.height;
                    
                    UIButton *btn=[self.buttons objectAtIndex:i];
                    btn.frame=CGRectMake(0, totalHeight, AlertViewWidth, AlertViewButtonHeight);
                    totalHeight += btn.frame.size.height;
                }
                //使用AlertViewVerticalElementSpace的空白
                else{
                    totalHeight += AlertViewVerticalElementSpace;
                    
                    UIButton *btn=[self.buttons objectAtIndex:i];
                    btn.frame=CGRectMake(AlertViewVerticalElementSpace, totalHeight, floorf(AlertViewWidth-2*AlertViewVerticalElementSpace), AlertViewButtonHeight);
                    totalHeight += btn.frame.size.height;
                }
            }
        }
    }
    
    //不使用分割线
    if (!self.styleOption.btnStyle) {
        totalHeight += AlertViewVerticalElementSpace;
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
@synthesize alertViews=_alertViews;

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
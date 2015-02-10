//
//  AlertComponent.m
//  Dynamic_Custom_UIAlertView
//
//  Created by youjian on 15-2-10.
//  Copyright (c) 2015年 www.code.tutsplus. All rights reserved.
//

#import "AlertComponent.h"

//class extension 常用来申明一些私有属性和私有方法
@interface AlertComponent ()

@property (nonatomic,strong) UIView * alertView;
@property (nonatomic,strong) UIView * backgroundView;
@property (nonatomic,strong) UIView * targetView;//外面的父类视图
@property (nonatomic,strong) UILabel * titleLabel;
@property (nonatomic,strong) UILabel * messageLabel;

@property (nonatomic,strong) UIDynamicAnimator * animator;//最大的容器
@property (nonatomic,strong) NSString * title;
@property (nonatomic,strong) NSString * message;
@property (nonatomic,strong) NSArray * buttonTitles;
@property (nonatomic)CGRect initialAlertViewFrame;
@property (nonatomic,strong) void(^selectionHandler)(NSInteger,NSString *);

- (void)setupBackgroundView;
- (void)setupAlertView;
- (void)handleButtonTap:(UIButton *)sender;

@end

@implementation AlertComponent

- (id)initAlertWithTitle:(NSString *)title andMessage:(NSString *)message andButtonTitles:(NSArray *)buttonTitles andTargetView:(UIView *)targetView
{
    if (self = [super init]) {
        self.title = title;
        self.message = message;
        self.targetView = targetView;
        self.buttonTitles = buttonTitles;
        
        [self setupBackgroundView];
        [self setupAlertView];
        
        self.animator = [[UIDynamicAnimator alloc]initWithReferenceView:self.targetView];
        
        
    }
    return self;
}

- (void)setupAlertView
{
    CGSize alertViewSize = CGSizeMake(250.0, 130.0 + 50 * self.buttonTitles.count);
    //alertView初始位置是在屏幕上面，不是在可视区的范围内。
    CGPoint initialOriginPoint = CGPointMake(self.targetView.frame.origin.x, self.targetView.frame.origin.y - alertViewSize.height);
    
    self.alertView = [[UIView alloc]initWithFrame:CGRectMake(initialOriginPoint.x, initialOriginPoint.y, alertViewSize.width, alertViewSize.height)];
    [self.alertView setBackgroundColor:[UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:1.0]];
    
    [self.alertView.layer setCornerRadius:10.0];
    [self.alertView.layer setBorderWidth:1.0];
    [self.alertView.layer setBorderColor:[UIColor blackColor].CGColor];
    self.initialAlertViewFrame = self.alertView.frame;
    
    //setup title label
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0.0, 10.0, self.alertView.frame.size.width, 40)];
    [self.titleLabel setText:self.title];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = [UIFont fontWithName:@"Avenir-Heavy" size:14.0];
    [self.alertView addSubview:self.titleLabel];
    
    //setup message label
    self.messageLabel = [[UILabel alloc]initWithFrame:CGRectMake(0.0, self.titleLabel.frame.origin.y + self.titleLabel.frame.size.height, self.alertView.frame.size.width, 80)];
    self.messageLabel.textAlignment = NSTextAlignmentCenter;
    self.messageLabel.font = [UIFont fontWithName:@"Avenir" size:14.0];
    self.messageLabel.text = self.message;
    [self.messageLabel setNumberOfLines:3];
    [self.messageLabel setLineBreakMode:NSLineBreakByWordWrapping];//在换行的时候以单词为界限来换行
    [self.alertView addSubview:self.messageLabel];
    
    //setup button
    CGFloat lastSubViewBottomY = CGRectGetMaxY(self.messageLabel.frame);
    
    for (int i = 0; i < self.buttonTitles.count; i++) {
        UIButton * button = [[UIButton alloc]initWithFrame:CGRectMake(10.0, lastSubViewBottomY+5, CGRectGetWidth(self.alertView.frame)-20.0, 40.0)];
        [button setTitle:[self.buttonTitles objectAtIndex:i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];   [button setTitleColor:[UIColor yellowColor] forState:UIControlStateHighlighted];
        [button setBackgroundColor:[UIColor colorWithRed:0.0 green:0.47 blue:0.39 alpha:1.0]];
        [button addTarget:self action:@selector(handleButtonTap:) forControlEvents:UIControlEventTouchUpInside];
        [button setTag:i + 1];
        
        [self.alertView addSubview:button];
        lastSubViewBottomY = button.frame.origin.y + button.frame.size.height;
    }
    
    [self.targetView addSubview:self.alertView];
}

- (void)setupBackgroundView{
    self.backgroundView = [[UIView alloc]initWithFrame:self.targetView.frame];
    self.backgroundView.backgroundColor = [UIColor grayColor];
    self.backgroundView.alpha = 0.0;
    [self.targetView addSubview:self.backgroundView];
}

- (void)showAlertViewWithSelectionHandler:(void(^)(NSInteger buttonIndex,NSString * buttonTitle))handler{
    self.selectionHandler = handler;
    [self.animator removeAllBehaviors];
    UISnapBehavior * snapBehavior = [[UISnapBehavior alloc]initWithItem:self.alertView snapToPoint:self.targetView.center];
    //0 --- 1之间
    // 0 会围绕着中心点，最大的晃动
    // 1 比较稳定的
    snapBehavior.damping = 1.0;
    [self.animator addBehavior:snapBehavior];
    
    [UIView animateWithDuration:0.75 animations:^{
        [self.backgroundView setAlpha:0.5];
    }];
    
}


//- (void)showAlertView
//{
//    [self.animator removeAllBehaviors];
//    UISnapBehavior * snapBehavior = [[UISnapBehavior alloc]initWithItem:self.alertView snapToPoint:self.targetView.center];
//    //0 --- 1之间
//    // 0 会围绕着中心点，最大的晃动
//    // 1 比较稳定的
//    snapBehavior.damping = 1.0;
//    [self.animator addBehavior:snapBehavior];
//    
//    [UIView animateWithDuration:0.75 animations:^{
//        [self.backgroundView setAlpha:0.5];
//    }];
//}

- (void)handleButtonTap:(UIButton *)sender
{
    
    self.selectionHandler(sender.tag,sender.titleLabel.text);
    
    [self.animator removeAllBehaviors];
    
    UIPushBehavior * pushBehavior = [[UIPushBehavior alloc]initWithItems:@[self.alertView] mode:UIPushBehaviorModeInstantaneous];
    
    /*
     M_PI 会向左上角差不多45方向移动 
     M_PI_2正上方 
     M_PI_4 右上角45度方法移动
     
     magnitude 10,50,100 数字越大，推力越快
     正数==方向向下
     负数==方向向上
     
     */
    [pushBehavior setAngle:M_PI_2 magnitude:-50.0];//angle property 代表the direction of the push,这个推力指向the bottom of the screen
    
    [self.animator addBehavior:pushBehavior];
    
    UIGravityBehavior * gravityBehavior = [[UIGravityBehavior alloc]initWithItems:@[self.alertView]];
    [gravityBehavior setGravityDirection:CGVectorMake(0.0, -1.0)];//重力向上，拉alverView回到屏幕上面
    [self.animator addBehavior:gravityBehavior];
    
    UICollisionBehavior * collisionBehavior = [[UICollisionBehavior alloc]initWithItems:@[self.alertView]];
    [collisionBehavior addBoundaryWithIdentifier:@"alertCollisionBoundary" fromPoint:CGPointMake(self.initialAlertViewFrame.origin.x, self.initialAlertViewFrame.origin.y - 10.0) toPoint:CGPointMake(self.initialAlertViewFrame.origin.x + self.initialAlertViewFrame.size.width, self.initialAlertViewFrame.origin.y - 10.0)];
    [self.animator addBehavior:collisionBehavior];
    
    //弹力
    UIDynamicItemBehavior * itemBehavior =[[UIDynamicItemBehavior alloc]initWithItems:@[self.alertView]];
    itemBehavior.elasticity = 0.4;
    [self.animator addBehavior:itemBehavior];
    
    [UIView animateWithDuration:2.0 animations:^{
        [self.backgroundView setAlpha:0.0];
    }];
}

@end

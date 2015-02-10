//
//  AlertComponent.h
//  Dynamic_Custom_UIAlertView
//
//  Created by youjian on 15-2-10.
//  Copyright (c) 2015年 www.code.tutsplus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface AlertComponent : NSObject

- (id)initAlertWithTitle:(NSString *)title andMessage:(NSString *)message andButtonTitles:(NSArray *)buttonTitles andTargetView:(UIView *)targetView;

//- (void)showAlertView;

/*
第一步：
    处理这个view里面button事件，在ViewController里面的响应，
    - (void)method:(void(^)(参数 例如：NSString * btnTitle)handlerBlock名字)
 
    （void(^)(参数)）block名称
 
第二步：
    声明block的成员变量@property (nonatomic,strong) void(^selectionHandler)(NSInteger,NSString *);
    void(^block名称)(类型)；
 
第三步：初始化
    在外部调用时候，就把外部形参block,赋值给成员变量的block
    self.selectionHandler = handler;//block就开始在这里等着

第四步：
    内部事件触发了，block要开始生效了
    self.selectionHandler(sender.tag,sender.titleLabel.text);//成员变量block开始调用，传递参数回到外部使用

第五步：
    外部调用，直接用里面的参数
 [self.alertComponent showAlertViewWithSelectionHandler:^(NSInteger buttonIndex, NSString *buttonTitle) {
 
 }];


*/
- (void)showAlertViewWithSelectionHandler:(void(^)(NSInteger buttonIndex,NSString * buttonTitle))handler;

@end

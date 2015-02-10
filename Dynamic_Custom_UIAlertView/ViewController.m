//
//  ViewController.m
//  Dynamic_Custom_UIAlertView
//
//  Created by youjian on 15-2-10.
//  Copyright (c) 2015年 www.code.tutsplus. All rights reserved.
//

#import "ViewController.h"
#import "AlertComponent.h"
@interface ViewController ()

@property (nonatomic,strong) AlertComponent * alertComponent;

@end

@implementation ViewController
- (IBAction)showAlert:(id)sender {
    
//    [self.alertComponent showAlertView];
    [self.alertComponent showAlertViewWithSelectionHandler:^(NSInteger buttonIndex, NSString *buttonTitle) {
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.alertComponent = [[AlertComponent alloc]initAlertWithTitle:@"Custome Alert" andMessage:@"You have a new e-mail message,but I don't know from whom" andButtonTitles:@[@"show me",@"I don't care",@"For me ,really?"] andTargetView:self.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

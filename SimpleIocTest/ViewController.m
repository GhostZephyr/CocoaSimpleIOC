//
//  ViewController.m
//  SimpleIocTest
//
//  Created by qvod on 14-9-25.
//  Copyright (c) 2014年 YF. All rights reserved.
//

#import "ViewController.h"
#import "SimpleIoc.h"
#import "MainViewModel.h"
#import "TestServiceC.h"
#import "TestServiceB.h"
#import "TestViewController.h"

@interface ViewController ()

@end

@implementation ViewController
- (IBAction)btnClick:(id)sender {
    //这是一个固化的ViewController 需要检测工厂中是否存在 如果不存在则注册一个
    if(![[SimpleIoc defaultInstance] isRegistered:[TestViewController class]]) {
        [[SimpleIoc defaultInstance] registerInstance:[TestViewController class]];
    }
    TestViewController *viewController = [[SimpleIoc defaultInstance] getInstance:[TestViewController class]];
    
    [self.navigationController pushViewController:viewController animated:true];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    MainViewModel *viewModel = [[SimpleIoc defaultInstance] getInstance:[MainViewModel class]];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

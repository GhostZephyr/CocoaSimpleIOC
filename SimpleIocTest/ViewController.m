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
#import "IVideoPlayer.h"
@interface ViewController ()

@end

@implementation ViewController
- (IBAction)btnClick:(id)sender {
    //这是一个固化的ViewController 需要检测工厂中是否存在 如果不存在则注册一个
//    if(![[SimpleIoc defaultInstance] isRegistered:NSStringFromClass([TestViewController class])]) {
//        [[SimpleIoc defaultInstance] registerInstance:[TestViewController class]];
//    }
    simpleIoc_register(@"TestViewController");
    
    TestViewController *viewController = [[SimpleIoc defaultInstance] getInstance:[TestViewController class]];
//    id<IVideoPlayer> player = [[SimpleIoc defaultInstance] getInstanceByProtocol:@protocol(IVideoPlayer)];
//    [player changeSkin:@"cell"];
    [self.navigationController pushViewController:viewController animated:true];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *arguments = [[NSArray alloc] initWithObjects:@"my custom arguments", nil];
     NSArray *arguments2 = [[NSArray alloc] initWithObjects:@"my custom arguments2", nil];
    MainViewModel *viewModel = [[SimpleIoc defaultInstance] getInstanceWithArguments:[MainViewModel class] arguments:arguments];
    [viewModel isOK];
    MainViewModel *viewModel2 = [[SimpleIoc defaultInstance] getInstanceWithArguments:[MainViewModel class] arguments:arguments2];
    [viewModel isOK];
    [viewModel2 isOK];
    MainViewModel *viewModel3 = [[MainViewModel alloc] init];
    [viewModel3 isOK];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

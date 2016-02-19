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
    simpleIoc_register(@"TestViewController");
    
    TestViewController *viewController = [[SimpleIoc defaultInstance] getInstance:[TestViewController class]];
    [self.navigationController pushViewController:viewController animated:true];
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    NSArray *arguments = [[NSArray alloc] initWithObjects:@"my custom arguments", nil];
//     NSArray *arguments2 = [[NSArray alloc] initWithObjects:@"my custom arguments2", nil];
//    MainViewModel *viewModel = [[SimpleIoc defaultInstance] getInstanceWithArguments:[MainViewModel class] arguments:arguments];
//    [viewModel isOK];
//    MainViewModel *viewModel2 = [[SimpleIoc defaultInstance] getInstanceWithArguments:[MainViewModel class] arguments:arguments2];
//    [viewModel isOK];
//    [viewModel2 isOK];
//    MainViewModel *viewModel3 = [[MainViewModel alloc] init];
//    [viewModel3 isOK];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

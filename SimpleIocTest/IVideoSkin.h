//
//  IVideoSkin.h
//  SimpleIoc
//
//  Created by qvod on 14/10/25.
//  Copyright (c) 2014年 YF. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VideoEngine.h"

@protocol IVideoSkin <NSObject>
@property (weak,nonatomic) VideoEngine *myEngine;
-(void)doSomeThing;
@end

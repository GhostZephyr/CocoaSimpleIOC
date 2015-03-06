//
//  FullScreenPlayer.h
//  SimpleIoc
//
//  Created by qvod on 14/10/25.
//  Copyright (c) 2014年 YF. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IVideoSkin.h"
#import "CellPlayer.h"
#import "IConstructorProvider.h"
#import "SimpleIoc.h"
#import "VideoEngine.h"


@interface FullScreenPlayer : NSObject<IVideoSkin>
@property (weak,nonatomic) id<IVideoSkin> cellPlayer;
@end

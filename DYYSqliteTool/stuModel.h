//
//  stuModel.h
//  DYYSqliteTool
//
//  Created by yang on 2017/7/17.
//  Copyright © 2017年 dingyangyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "DYYModelProtocol.h"
@interface stuModel : NSObject<DYYModelProtocol>
@property(nonatomic, copy) NSString *name;
@property(nonatomic, assign) NSInteger age;
@property(nonatomic, assign) CGFloat score;
@property(nonatomic, assign) CGFloat score2;
@property(nonatomic, assign) CGFloat score4;


@end

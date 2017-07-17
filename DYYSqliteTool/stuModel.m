//
//  stuModel.m
//  DYYSqliteTool
//
//  Created by yang on 2017/7/17.
//  Copyright © 2017年 dingyangyang. All rights reserved.
//

#import "stuModel.h"

@implementation stuModel
+ (NSString *)primaryKey{

    return @"name";
}
+ (NSArray *)ingnoreColumnNames{

    return @[@"score2"];
}
@end

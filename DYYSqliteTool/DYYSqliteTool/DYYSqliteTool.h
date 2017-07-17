//
//  DYYSqliteTool.h
//  DYYSqliteTool
//
//  Created by yang on 2017/7/13.
//  Copyright © 2017年 dingyangyang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DYYSqliteTool : NSObject

/**
 执行sql语句
 */
+ (BOOL)deal:(NSString *)sql withUid:(NSString *)uid;

/**
 查询sql语句
 */
+ (NSMutableArray <NSMutableDictionary *> *)query:(NSString *)sql withUid:(NSString *)uid;

@end

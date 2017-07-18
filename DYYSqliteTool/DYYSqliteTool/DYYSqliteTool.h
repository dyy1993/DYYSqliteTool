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
+ (BOOL)deal:(NSString *)sql uid:(NSString *)uid;

/**
 查询sql语句
 */
+ (NSMutableArray <NSMutableDictionary *> *)query:(NSString *)sql uid:(NSString *)uid;

/**
 执行sql语句组

 @param sqls sql语句组
 @param uid 用户标识
 @return 是否成功执行
 */
+ (BOOL)dealSqls:(NSArray <NSString *>*)sqls uid:(NSString *)uid;

@end

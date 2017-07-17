//
//  DYYModelTool.h
//  DYYSqliteTool
//
//  Created by yang on 2017/7/14.
//  Copyright © 2017年 dingyangyang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DYYModelTool : NSObject

/**
 获取表明
 */
+ (NSString *)tableName:(Class)cls;
/**
 根据类名获取成员变量名和对应的类型
 */
+ (NSDictionary *)classIvarNameTypeDic:(Class)cls;
/**
 根据类名获取成员变量名和对应sqlite类型
 */
+ (NSDictionary *)classIvarNameSqliteTypeDic:(Class)cls;
/**
 将成员变量名和对应sqlite类型拼接成string
 */
+ (NSString *)columnNamesAndTypesStr:(Class)cls;
@end

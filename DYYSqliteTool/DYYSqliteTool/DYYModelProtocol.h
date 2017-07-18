//
//  DYYModelProtocol.h
//  DYYSqliteTool
//
//  Created by yang on 2017/7/17.
//  Copyright © 2017年 dingyangyang. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DYYModelProtocol <NSObject>
@required
/**
 主键
 */
+ (NSString *)primaryKey;
@optional

/**
 忽略模型中字段
 */
+ (NSArray *)ingnoreColumnNames;

/**
 新字段名称-> 旧的字段名称的映射表格
 
 @return 映射表格
 */
+ (NSDictionary *)newNameToOldNameDic;
@end

//
//  DYYSqliteModelTool.h
//  DYYSqliteTool
//
//  Created by yang on 2017/7/14.
//  Copyright © 2017年 dingyangyang. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSUInteger, ColumnNameToValueRelationType) {
    ColumnNameToValueRelationTypeMore,          // >
    ColumnNameToValueRelationTypeLess,          // <
    ColumnNameToValueRelationTypeEqual,         // =
    ColumnNameToValueRelationTypeMoreEqual,     // >=
    ColumnNameToValueRelationTypeLessEqual,     // <=
};

@interface DYYSqliteModelTool : NSObject


/**
 创建表格

 @param cls 类
 @param uid 用户标识
 @return 是否创建成功
 */
+ (BOOL)createTable:(Class)cls uid:(NSString *)uid;

/**
 table是否需要更新

 @param cls 类
 @param uid 用户标识
 @return 是否需要更新
 */
+ (BOOL)isTableRequiredUpdate:(Class)cls uid:(NSString *)uid;

/**
 更新表格

 @param cls 类
 @param uid 用户标识
 @return 是否更新成功
 */
+ (BOOL)updateTable:(Class)cls uid:(NSString *)uid;

/**
 保存/更新模型

 @param model 模型
 @param uid 用户标识
 @return 是否执行成功
 */
+ (BOOL)saveOrUpdateModel:(id)model uid:(NSString *)uid;


/**
 根据模型删除

 @param model 要删除的模型
 @param uid 用户标识
 @return 是否删除成功
 */
+ (BOOL)deleteModel:(id)model uid:(NSString *)uid;

/**
 根据条件来删除

 @param cls 类
 @param whereStr 条件语句
 @param uid 用户标识
 @return 是否删除成功
 */
+ (BOOL)deleteModel:(Class)cls whereStr:(NSString *)whereStr uid:(NSString *)uid;


/**
 根据条件删除

 @param cls 类
 @param name 要删除的字段名
 @param relation 条件
 @param value 值
 @param uid 用户标识
 @return 是否删除成功
 */
+ (BOOL)deleteModel:(Class)cls columnName:(NSString *)name relation:(ColumnNameToValueRelationType)relation value:(id)value uid:(NSString *)uid;

/**
 查询全部模型

 @param cls 类
 @param uid 用户标识
 @return 模型数组
 */
+ (NSArray *)queryAllModels:(Class)cls uid:(NSString *)uid;

/**
 根据条件查询模型

 @param cls 类
 @param name 字段名
 @param relation 条件
 @param value 条件值
 @param uid 用户标识
 @return 符合条件的模型数组
 */
+ (NSArray *)queryModels:(Class)cls columnName:(NSString *)name relation:(ColumnNameToValueRelationType)relation value:(id)value uid:(NSString *)uid;

/**
 根据sql语句查询

 @param cls 类
 @param sql sql语句
 @param uid 用户标识
 @return 模型数组
 */
+ (NSArray *)queryModels:(Class)cls WithSql:(NSString *)sql uid:(NSString *)uid;




@end

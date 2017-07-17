//
//  DYYSqliteModelTool.m
//  DYYSqliteTool
//
//  Created by yang on 2017/7/14.
//  Copyright © 2017年 dingyangyang. All rights reserved.
//

#import "DYYSqliteModelTool.h"
#import "DYYModelTool.h"
#import "DYYModelProtocol.h"
#import "DYYSqliteTool.h"
#import "DYYTableTool.h"
@implementation DYYSqliteModelTool
+ (BOOL)createTable:(Class)cls withUid:(NSString *)uid{

    //表名 键名 类型 
    NSString *tableName = [DYYModelTool tableName:cls];
    NSString *keyAndType = [DYYModelTool columnNamesAndTypesStr:cls];
    
    if (![cls respondsToSelector:@selector(primaryKey)]) {
        NSLog(@"必须实现primaryKey，返回主键名");
        return NO;
    }
    NSString *primaryKey = [cls primaryKey];
    NSString *sql = [NSString stringWithFormat:@"create table if not exists %@(%@,primary key (%@))",tableName,keyAndType,primaryKey];
    
    return [DYYSqliteTool deal:sql uid:uid];
    
}
+ (BOOL)isTableRequiredUpdate:(Class)cls uid:(NSString *)uid{

    NSArray *modelNames = [DYYModelTool classSortedIvarNames:cls];
    NSArray *tableNames = [DYYTableTool tableSortedColumnNames:cls uid:uid];
    return ![modelNames isEqualToArray:tableNames];

}
+ (BOOL)updateTable:(Class)cls uid:(NSString *)uid {
    
    
    // 1. 创建一个拥有正确结构的临时表
    // 1.1 获取表格名称
    NSString *tmpTableName = [DYYModelTool tmpTableName:cls];
    NSString *tableName = [DYYModelTool tableName:cls];
    
    if (![cls respondsToSelector:@selector(primaryKey)]) {
        NSLog(@"如果想要操作这个模型, 必须要实现+ (NSString *)primaryKey;这个方法, 来告诉我主键信息");
        return NO;
    }
    NSMutableArray *execSqls = [NSMutableArray array];
    NSString *primaryKey = [cls primaryKey];
    NSString *createTableSql = [NSString stringWithFormat:@"create table if not exists %@(%@, primary key(%@));", tmpTableName, [DYYModelTool columnNamesAndTypesStr:cls], primaryKey];
    [execSqls addObject:createTableSql];
    // 2. 根据主键, 插入数据
    // insert into xmgstu_tmp(stuNum) select stuNum from xmgstu;
    NSString *insertPrimaryKeyData = [NSString stringWithFormat:@"insert into %@(%@) select %@ from %@;", tmpTableName, primaryKey, primaryKey, tableName];
    [execSqls addObject:insertPrimaryKeyData];
    // 3. 根据主键, 把所有的数据更新到新表里面
    NSArray *oldNames = [DYYTableTool tableSortedColumnNames:cls uid:uid];
    NSArray *newNames = [DYYModelTool classSortedIvarNames:cls];
    
    for (NSString *columnName in newNames) {
        if (![oldNames containsObject:columnName]) {
            continue;
        }
        NSString *updateSql = [NSString stringWithFormat:@"update %@ set %@ = (select %@ from %@ where %@.%@ = %@.%@)", tmpTableName, columnName, columnName, tableName, tmpTableName, primaryKey, tableName, primaryKey];
        [execSqls addObject:updateSql];
    }
    
    NSString *deleteOldTable = [NSString stringWithFormat:@"drop table if exists %@", tableName];
    [execSqls addObject:deleteOldTable];
    
    NSString *renameTableName = [NSString stringWithFormat:@"alter table %@ rename to %@", tmpTableName, tableName];
    [execSqls addObject:renameTableName];
    
    
    return [DYYSqliteTool dealSqls:execSqls uid:uid];
    
}

@end

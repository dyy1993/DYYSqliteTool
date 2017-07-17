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
@implementation DYYSqliteModelTool
+ (BOOL)saveModel:(Class)cls withUid:(NSString *)uid{

    //表名 键名 类型 
    NSString *tableName = [DYYModelTool tableName:cls];
    NSString *keyAndType = [DYYModelTool columnNamesAndTypesStr:cls];
    
    if (![cls respondsToSelector:@selector(primaryKey)]) {
        NSLog(@"必须实现primaryKey，返回主键名");
        return NO;
    }
    NSString *primaryKey = [cls primaryKey];
    NSString *sql = [NSString stringWithFormat:@"create table if not exists %@(%@,primary key (%@))",tableName,keyAndType,primaryKey];
    
    return [DYYSqliteTool deal:sql withUid:uid];
    
}
@end

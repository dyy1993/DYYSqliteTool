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
+ (BOOL)createTable:(Class)cls uid:(NSString *)uid{

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
    
    
    NSString *tmpTableName = [DYYModelTool tmpTableName:cls];
    NSString *tableName = [DYYModelTool tableName:cls];
    
    if (![cls respondsToSelector:@selector(primaryKey)]) {
        NSLog(@"必须实现primaryKey，返回主键名");
        return NO;
    }
    NSMutableArray *execSqls = [NSMutableArray array];
    NSString *primaryKey = [cls primaryKey];
    NSString *createTableSql = [NSString stringWithFormat:@"create table if not exists %@(%@, primary key(%@));", tmpTableName, [DYYModelTool columnNamesAndTypesStr:cls], primaryKey];
    [execSqls addObject:createTableSql];
    // 根据主键, 插入数据
    NSString *insertPrimaryKeyData = [NSString stringWithFormat:@"insert into %@(%@) select %@ from %@;", tmpTableName, primaryKey, primaryKey, tableName];
    [execSqls addObject:insertPrimaryKeyData];
    //根据主键, 把所有的数据更新到新表里面
    NSArray *oldNames = [DYYTableTool tableSortedColumnNames:cls uid:uid];
    NSArray *newNames = [DYYModelTool classSortedIvarNames:cls];
    
    //获取更名字典
    NSDictionary *newNameToOldNameDic = @{};
    if ([cls respondsToSelector:@selector(newNameToOldNameDic)]) {
        newNameToOldNameDic = [cls newNameToOldNameDic];
    }
    
    for (NSString *columnName in newNames) {
        NSString *oldName = columnName;
        // 找映射的旧的字段名称
        if ([newNameToOldNameDic[columnName] length] != 0) {
            oldName = newNameToOldNameDic[columnName];
        }
        // 如果老表包含了新的列明, 应该从老表更新到临时表格里面
        if ((![oldNames containsObject:columnName] && ![oldNames containsObject:oldName]) || [columnName isEqualToString:primaryKey]) {
            continue;
        }
        // update 临时表 set 新字段名称 = (select 旧字段名 from 旧表 where 临时表.主键 = 旧表.主键)
        NSString *updateSql = [NSString stringWithFormat:@"update %@ set %@ = (select %@ from %@ where %@.%@ = %@.%@)", tmpTableName, columnName, oldName, tableName, tmpTableName, primaryKey, tableName, primaryKey];
        [execSqls addObject:updateSql];
    }
    
    NSString *deleteOldTable = [NSString stringWithFormat:@"drop table if exists %@", tableName];
    [execSqls addObject:deleteOldTable];
    
    NSString *renameTableName = [NSString stringWithFormat:@"alter table %@ rename to %@", tmpTableName, tableName];
    [execSqls addObject:renameTableName];
    
    
    return [DYYSqliteTool dealSqls:execSqls uid:uid];
    
}

+ (BOOL)saveOrUpdateModel:(id)model uid:(NSString *)uid {
    
    // 保存一个模型
    Class cls = [model class];
    //判断表格是否存在, 不存在, 则创建
    if (![DYYTableTool isTableExists:cls uid:uid]) {
        [self createTable:cls uid:uid];
    }
    //检测表格是否需要更新, 需要, 更新
    if ([self isTableRequiredUpdate:cls uid:uid]) {
        if ([self updateTable:cls uid:uid]) {
            NSLog(@"更新成功");
        }else{
         NSLog(@"更新失败");
            return NO;
        }
    }
    
    //判断记录是否存在, 主键
    NSString *tableName = [DYYModelTool tableName:cls];
    
    if (![cls respondsToSelector:@selector(primaryKey)]) {
        NSLog(@"必须实现primaryKey，返回主键名");
        return NO;
    }
    NSString *primaryKey = [cls primaryKey];
    id primaryValue = [model valueForKeyPath:primaryKey];
    
    NSString *checkSql = [NSString stringWithFormat:@"select * from %@ where %@ = '%@'", tableName, primaryKey, primaryValue];
    NSArray *result = [DYYSqliteTool query:checkSql uid:uid];
    
    
    // 获取字段数组
    NSArray *columnNames = [DYYModelTool classIvarNameTypeDic:cls].allKeys;
    
    // 获取值数组
    NSMutableArray *values = [NSMutableArray array];
    for (NSString *columnName in columnNames) {
        id value = [model valueForKeyPath:columnName];
        
        if ([value isKindOfClass:[NSArray class]] || [value isKindOfClass:[NSDictionary class]]) {
            
            NSData *data = [NSJSONSerialization dataWithJSONObject:value options:NSJSONWritingPrettyPrinted error:nil];
            
            value = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        }
        [values addObject:value];
    }
    
    NSInteger count = columnNames.count;
    NSMutableArray *setValueArray = [NSMutableArray array];
    for (int i = 0; i < count; i++) {
        NSString *name = columnNames[i];
        id value = values[i];
        NSString *setStr = [NSString stringWithFormat:@"%@='%@'", name, value];
        [setValueArray addObject:setStr];
    }
    
    // update 表名 set 字段1=字段1值,字段2=字段2的值... where 主键 = '主键值'
    NSString *execSql = @"";
    if (result.count > 0) {
        execSql = [NSString stringWithFormat:@"update %@ set %@  where %@ = '%@'", tableName, [setValueArray componentsJoinedByString:@","], primaryKey, primaryValue];
        
        
    }else {
        // insert into 表名(字段1, 字段2, 字段3) values ('值1', '值2', '值3')
        execSql = [NSString stringWithFormat:@"insert into %@(%@) values('%@')", tableName, [columnNames componentsJoinedByString:@","], [values componentsJoinedByString:@"','"]];
    }
    
    
    return [DYYSqliteTool deal:execSql uid:uid];
}

+ (BOOL)deleteModel:(id)model uid:(NSString *)uid {
    
    Class cls = [model class];
    NSString *tableName = [DYYModelTool tableName:cls];
    if (![cls respondsToSelector:@selector(primaryKey)]) {
        NSLog(@"必须实现primaryKey，返回主键名");
        return NO;
    }
    NSString *primaryKey = [cls primaryKey];
    id primaryValue = [model valueForKeyPath:primaryKey];
    NSString *deleteSql = [NSString stringWithFormat:@"delete from %@ where %@ = '%@'", tableName, primaryKey, primaryValue];
    
    return [DYYSqliteTool deal:deleteSql uid:uid];
    
}


+ (BOOL)deleteModel:(Class)cls whereStr:(NSString *)whereStr uid:(NSString *)uid {
    
    NSString *tableName = [DYYModelTool tableName:cls];
    
    NSString *deleteSql = [NSString stringWithFormat:@"delete from %@", tableName];
    if (whereStr.length > 0) {
        deleteSql = [deleteSql stringByAppendingFormat:@" where %@", whereStr];
    }
    
    return [DYYSqliteTool deal:deleteSql uid:uid];
    
}



+ (BOOL)deleteModel:(Class)cls columnName:(NSString *)name relation:(ColumnNameToValueRelationType)relation value:(id)value uid:(NSString *)uid {
    
    NSString *tableName = [DYYModelTool tableName:cls];
    
    
    
    NSString *deleteSql = [NSString stringWithFormat:@"delete from %@ where %@ %@ '%@'", tableName, name, self.ColumnNameToValueRelationTypeDic[@(relation)], value];
    
    
    return [DYYSqliteTool deal:deleteSql uid:uid];
}

+ (NSArray *)queryAllModels:(Class)cls uid:(NSString *)uid {
    
    NSString *tableName = [DYYModelTool tableName:cls];
 
    NSString *sql = [NSString stringWithFormat:@"select * from %@", tableName];
    
    NSArray <NSDictionary *>*results = [DYYSqliteTool query:sql uid:uid];
    
    return [self parseResults:results withClass:cls];;
    
}

+ (NSArray *)queryModels:(Class)cls columnName:(NSString *)name relation:(ColumnNameToValueRelationType)relation value:(id)value uid:(NSString *)uid {
    
    NSString *tableName = [DYYModelTool tableName:cls];
    
    NSString *sql = [NSString stringWithFormat:@"select * from %@ where %@ %@ '%@' ", tableName, name, self.ColumnNameToValueRelationTypeDic[@(relation)], value];
    
    NSArray <NSDictionary *>*results = [DYYSqliteTool query:sql uid:uid];
    
    return [self parseResults:results withClass:cls];
}

+ (NSArray *)queryModels:(Class)cls WithSql:(NSString *)sql uid:(NSString *)uid {
    
    NSArray <NSDictionary *>*results = [DYYSqliteTool query:sql uid:uid];
    
    return [self parseResults:results withClass:cls];
    
}


+ (NSArray *)parseResults:(NSArray <NSDictionary *>*)results withClass:(Class)cls {
    
    NSMutableArray *models = [NSMutableArray array];
    
    NSDictionary *nameTypeDic = [DYYModelTool classIvarNameTypeDic:cls];
    
    for (NSDictionary *modelDic in results) {
        id model = [[cls alloc] init];
        [models addObject:model];
        
        [modelDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            
            NSString *type = nameTypeDic[key];
            id resultValue = obj;
            if ([type isEqualToString:@"NSArray"] || [type isEqualToString:@"NSDictionary"]) {
                
                NSData *data = [obj dataUsingEncoding:NSUTF8StringEncoding];
                resultValue = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                
            }else if ([type isEqualToString:@"NSMutableArray"] || [type isEqualToString:@"NSMutableDictionary"]) {
                NSData *data = [obj dataUsingEncoding:NSUTF8StringEncoding];
                resultValue = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            }
            
            [model setValue:resultValue forKeyPath:key];
            
        }];
    }
    
    return models;
}
+ (NSDictionary *)ColumnNameToValueRelationTypeDic {
    return @{
             @(ColumnNameToValueRelationTypeMore):@">",
             @(ColumnNameToValueRelationTypeLess):@"<",
             @(ColumnNameToValueRelationTypeEqual):@"=",
             @(ColumnNameToValueRelationTypeMoreEqual):@">=",
             @(ColumnNameToValueRelationTypeLessEqual):@"<="
             };
}


@end

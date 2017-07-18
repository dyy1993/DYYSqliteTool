//
//  DYYTableTool.m
//  DYYSqliteTool
//
//  Created by yang on 2017/7/17.
//  Copyright © 2017年 dingyangyang. All rights reserved.
//

#import "DYYTableTool.h"
#import "DYYModelTool.h"
#import "DYYSqliteTool.h"
@implementation DYYTableTool
+ (NSArray *)tableSortedColumnNames:(Class)cls uid:(NSString *)uid{

    NSString *tableName = [DYYModelTool tableName:cls];
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM sqlite_master WHERE type = \"table\" AND name = \"%@\"",tableName];
    
   NSDictionary *tableDic = [[DYYSqliteTool query:sql uid:uid] firstObject];
    // CREATE TABLE stuModel(age integer,score real,name text,score3 real,primary key (name))
    NSString *createSql = [tableDic[@"sql"] lowercaseString];
    if (createSql.length == 0) {
        return nil;
    }
    createSql = [createSql stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\""]];
    createSql = [createSql stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    createSql = [createSql stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    createSql = [createSql stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    //age integer,score real,name text,score3 real,primary key
   createSql = [createSql componentsSeparatedByString:@"("][1];
    
    NSMutableArray *nameArray = [NSMutableArray array];
    
    NSArray *names = [createSql componentsSeparatedByString:@","];
    
    for (NSString *columnName in names) {
        if ([columnName containsString:@"primary"]) {
            continue;
        }
        
        NSString *columnName2 = [columnName stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]];
        
        NSString *str = [columnName2 componentsSeparatedByString:@" "].firstObject;
        [nameArray addObject:str];
    }
    [nameArray sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2];
    }];
    
    return nameArray;
}
+ (BOOL)isTableExists:(Class)cls uid:(NSString *)uid {
    
    NSString *tableName = [DYYModelTool tableName:cls];
    NSString *queryCreateSqlStr = [NSString stringWithFormat:@"select sql from sqlite_master where type = 'table' and name = '%@'", tableName];
    
    NSMutableArray *result = [DYYSqliteTool query:queryCreateSqlStr uid:uid];
    
    return result.count > 0;
}
@end

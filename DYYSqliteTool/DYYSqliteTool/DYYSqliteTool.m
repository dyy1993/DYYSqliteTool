//
//  DYYSqliteTool.m
//  DYYSqliteTool
//
//  Created by yang on 2017/7/13.
//  Copyright © 2017年 dingyangyang. All rights reserved.
//

#import "DYYSqliteTool.h"
#import "sqlite3.h"
//#define kCachePath NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject
#define kCachePath @"/Users/yang/Desktop/carrier"
@implementation DYYSqliteTool
sqlite3 *ppDb = nil;

+ (BOOL)deal:(NSString *)sql uid:(NSString *)uid{

 
    if (![self open:uid]) {
        NSLog(@"打开数据库失败");
        return NO;
    }
    
    BOOL result = sqlite3_exec(ppDb, sql.UTF8String, nil, nil, nil) == SQLITE_OK;
    
    sqlite3_close(ppDb);
    
    return result;
}

+ (NSMutableArray <NSMutableDictionary *> *)query:(NSString *)sql uid:(NSString *)uid{

    if (![self open:uid]) {
        NSLog(@"打开数据库失败");
        return nil;
    }
    sqlite3_stmt *ppStmt = nil;
    sqlite3_prepare_v2(ppDb, sql.UTF8String, -1, &ppStmt, nil);
    NSMutableArray *dictArray = [NSMutableArray array];

    while ( sqlite3_step(ppStmt) == SQLITE_ROW) {
//        取每条数据的值
        int column = sqlite3_column_count(ppStmt);
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];

        for (int i = 0; i < column; i++) {
            //取列名
            const char *columnNameC = sqlite3_column_name(ppStmt, i);
            NSString *columnName = [NSString stringWithUTF8String:columnNameC];
            //取列值
            int type = sqlite3_column_type(ppStmt, i);
            id value = nil;
            switch (type) {
                case SQLITE_INTEGER:
                    value = @(sqlite3_column_int(ppStmt, i));
                    break;
                case SQLITE_FLOAT:
                    value = @(sqlite3_column_double(ppStmt, i));

                    break;
                case SQLITE_BLOB:
                    value = CFBridgingRelease(sqlite3_column_blob(ppStmt, i));

                    break;
                case SQLITE_NULL:
                    value = @"";
                    
                    break;
                case SQLITE3_TEXT:
                    value = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(ppStmt, i)] ;
                    break;
                default:
                    break;
            }
            [dict setValue:value forKey:columnName];
            
        }
        [dictArray addObject:dict];

    }
    
    sqlite3_finalize(ppStmt);
    
    [self close];
    return dictArray;
}

+ (BOOL)dealSqls:(NSArray <NSString *>*)sqls uid:(NSString *)uid {
    
    [self beginTransaction:uid];
    
    for (NSString *sql in sqls) {
        BOOL result = [self deal:sql uid:uid];
        if (result == NO) {
            [self rollBackTransaction:uid];
            return NO;
        }
    }
    
    [self commitTransaction:uid];
    return YES;
}

+ (void)beginTransaction:(NSString *)uid {
    [self deal:@"begin transaction" uid:uid];
}

+ (void)commitTransaction:(NSString *)uid {
    [self deal:@"commit transaction" uid:uid];
}
+ (void)rollBackTransaction:(NSString *)uid {
    [self deal:@"rollback transaction" uid:uid];
}


+ (BOOL)open:(NSString *)uid{

    NSString *dbName = @"common.sqlite";
    if (uid.length != 0) {
        dbName = [NSString stringWithFormat:@"%@.sqlite",uid];
    }
    NSString *dbPath = [kCachePath stringByAppendingPathComponent:dbName];

    return sqlite3_open(dbPath.UTF8String, &ppDb) == SQLITE_OK;
}
+ (void)close{
    sqlite3_close(ppDb);
}
@end

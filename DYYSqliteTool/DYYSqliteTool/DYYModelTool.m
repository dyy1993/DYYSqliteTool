//
//  DYYModelTool.m
//  DYYSqliteTool
//
//  Created by yang on 2017/7/14.
//  Copyright © 2017年 dingyangyang. All rights reserved.
//

#import "DYYModelTool.h"
#import <objc/runtime.h>
#import "DYYModelProtocol.h"
@implementation DYYModelTool
+ (NSString *)tableName:(Class)cls{
    return NSStringFromClass(cls);
}

+ (NSDictionary *)classIvarNameTypeDic:(Class)cls{
    
    unsigned int outCount = 0;
    Ivar *ivarList = class_copyIvarList(cls, &outCount);
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSArray *ingnoreNames = nil;
    if ([cls respondsToSelector:@selector(ingnoreColumnNames)]) {
        ingnoreNames = [cls ingnoreColumnNames];
    }
    for (int i = 0; i < outCount; i++) {
        Ivar ivar = ivarList[i];
        
        NSString *ivarName = [NSString stringWithUTF8String:ivar_getName(ivar)];
        ivarName = [ivarName stringByReplacingOccurrencesOfString:@"_" withString:@""];
        //忽略name
        if ([ingnoreNames containsObject:ivarName]) {
            continue;
        }
        NSString *ivarType = [NSString stringWithUTF8String:ivar_getTypeEncoding(ivar)];
        ivarType = [ivarType stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"@\""]];
        
        [dict setObject:ivarType forKey:ivarName];
        
    }
    return dict;
}
+ (NSDictionary *)classIvarNameSqliteTypeDic:(Class)cls{

    NSMutableDictionary *dict = [[self classIvarNameTypeDic:cls] mutableCopy];
    NSDictionary *typeDict = [self ocTypeToSqliteTypeDic];
    [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        dict[key] = typeDict[obj];
    }];
    
    return dict;
}
+ (NSString *)columnNamesAndTypesStr:(Class)cls{

    NSDictionary * dict = [self classIvarNameSqliteTypeDic:cls];
    NSMutableArray *strArray = [NSMutableArray array];
    [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        NSString *str = [NSString stringWithFormat:@"%@ %@",key,obj];
        [strArray addObject:str];
    }];
    return [strArray componentsJoinedByString:@","];
    
}

#pragma mark - 私有的方法
+ (NSDictionary *)ocTypeToSqliteTypeDic {
    return @{
             @"d": @"real", // double
             @"f": @"real", // float
             
             @"i": @"integer",  // int
             @"q": @"integer", // long
             @"Q": @"integer", // long long
             @"B": @"integer", // bool
             
             @"NSData": @"blob",
             @"NSDictionary": @"text",
             @"NSMutableDictionary": @"text",
             @"NSArray": @"text",
             @"NSMutableArray": @"text",
             
             @"NSString": @"text"
             };
    
}

@end

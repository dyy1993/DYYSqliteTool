//
//  DYYTableTool.h
//  DYYSqliteTool
//
//  Created by yang on 2017/7/17.
//  Copyright © 2017年 dingyangyang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DYYTableTool : NSObject

/**
 查询class表中排序好的列名
 */
+ (NSArray *)tableSortedColumnNames:(Class)cls uid:(NSString *)uid;
@end

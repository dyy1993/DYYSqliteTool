//
//  DYYSqliteModelTool.h
//  DYYSqliteTool
//
//  Created by yang on 2017/7/14.
//  Copyright © 2017年 dingyangyang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DYYSqliteModelTool : NSObject

/**
 保存模型到数据库
 */
+ (BOOL)saveModel:(Class)cls withUid:(NSString *)uid;

+ (BOOL)isTableRequiredUpdate:(Class)cls uid:(NSString *)uid;

@end

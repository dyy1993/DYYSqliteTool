//
//  DYYSqliteModelTool.h
//  DYYSqliteTool
//
//  Created by yang on 2017/7/14.
//  Copyright © 2017年 dingyangyang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DYYSqliteModelTool : NSObject
+ (BOOL)saveModel:(Class)cls withUid:(NSString *)uid;
@end

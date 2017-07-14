//
//  DYYSqliteToolTest.m
//  DYYSqliteTool
//
//  Created by yang on 2017/7/14.
//  Copyright © 2017年 dingyangyang. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "DYYSqliteTool.h"
@interface DYYSqliteToolTest : XCTestCase

@end

@implementation DYYSqliteToolTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    NSString *sql = @"create table if not exists t_stu(id integer primary key autoincrement, name text not null, age integer, score real)";
    BOOL result = [DYYSqliteTool deal:sql withUid:nil];
    XCTAssertEqual(result, YES);
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}
- (void)testQuery {
    NSString *sql = @"select * from t_stu";
    NSMutableArray *resut = [DYYSqliteTool query:sql withUid:nil];

    NSLog(@"%@",resut);
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}


- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end

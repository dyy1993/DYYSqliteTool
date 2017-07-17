//
//  ViewController.m
//  DYYSqliteTool
//
//  Created by yang on 2017/7/13.
//  Copyright © 2017年 dingyangyang. All rights reserved.
//

#import "ViewController.h"
#import "DYYSqliteTool.h"
#import "DYYModelTool.h"
#import "stuModel.h"
#import "DYYSqliteModelTool.h"
#import "DYYTableTool.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)createTab:(id)sender {
    NSString *sql = @"create table if not exists t_stu(id integer primary key autoincrement, name text not null, age integer, score real)";
    BOOL result = [DYYSqliteTool deal:sql withUid:nil];
    if (result) {
        NSLog(@"操作成功");
    }else
        NSLog(@"操作失败");
}
- (IBAction)query:(id)sender {
//    NSString *sql = @"select * from t_stu";
//    NSMutableArray *resut = [DYYSqliteTool query:sql withUid:nil];
//    
//    NSLog(@"%@",resut);
//    [DYYSqliteModelTool saveModel:[stuModel class] withUid:nil];
    [DYYSqliteModelTool isTableRequiredUpdate:[stuModel class] uid:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

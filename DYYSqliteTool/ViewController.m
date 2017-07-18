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
- (IBAction)delete:(id)sender {
    [DYYSqliteModelTool deleteModel:[stuModel class] columnName:@"score4" relation:ColumnNameToValueRelationTypeEqual value:@(12) uid:nil];
}
- (IBAction)createTab:(id)sender {
    stuModel *model = [[stuModel alloc] init];
    int x = arc4random() % 100;
    model.name = [NSString stringWithFormat:@"李四%i",x];
    model.score = 11;
    model.score4 = 12;
    model.age = 22;
    model.scores = @[@11,@23,@22,@[@88,@99]];
    model.dict = @{
                   @"ss" : @[@11,@23,@22,@[@88,@99]],
                   @"bb" : @"33"
                   };
       [DYYSqliteModelTool saveOrUpdateModel:model uid:nil];
}
- (IBAction)query:(id)sender {
    NSArray *array = [DYYSqliteModelTool queryAllModels:[stuModel class] uid:nil];
    NSLog(@"%@",array);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

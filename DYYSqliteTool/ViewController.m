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
    [DYYSqliteModelTool createTable:[stuModel class] withUid:nil];
}
- (IBAction)query:(id)sender {
    [DYYSqliteModelTool updateTable:[stuModel class] uid:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

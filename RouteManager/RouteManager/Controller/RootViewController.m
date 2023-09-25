//
//  RootViewController.m
//  RouteManager
//
//  Created by lixinglu on 2017/12/20.
//  Copyright © 2017年 lxl. All rights reserved.
//

#import "RootViewController.h"

#import "XLRoutesManager.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)mainCliecked:(id)sender {
    [[XLRoutesManager instance] handleOpenURL:[NSURL URLWithString:@"lxl://main"]];
}

- (IBAction)setCliecked:(id)sender {
//    [[XLRoutesManager instance] handleOpenURL:[NSURL URLWithString:@"lxl://set" param:@{@"title":@"设置来了"}]];
    [[XLRoutesManager instance] handleOpenURL:[NSURL URLWithString:@"lxl://myset" param:@{@"title":@"设置来了"}]];
}
- (IBAction)colorCliecked:(id)sender {
    [[XLRoutesManager instance] handleOpenURL:[NSURL URLWithString:@"lxl://color"]];
}
- (IBAction)redColorCliecked:(id)sender {
    [[XLRoutesManager instance] handleOpenURL:[NSURL URLWithString:@"lxl://color"] param:@{@"color":[UIColor redColor]}];
}
- (IBAction)greenColorCliecked:(id)sender {
    [[XLRoutesManager instance] handleOpenURL:[NSURL URLWithString:@"lxl://greenColor"]];
}
- (IBAction)webCliecked:(id)sender {
    [[XLRoutesManager instance] handleOpenURL:[NSURL URLWithString:@"https://www.baidu.com"]];
}

- (IBAction)yellowCliecked:(id)sender {
    [[XLRoutesManager instance] handleOpenURL:[NSURL URLWithString:@"lxl://lxlYellowColor"]];
}

- (IBAction)innerWebCliecked:(id)sender {
    [[XLRoutesManager instance] handleOpenURL:[NSURL URLWithString:@"lxl://web"] param:@{@"path":@"https://www.baidu.com"}];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

//
//  RootViewController.m
//  RouteManager
//
//  Created by lixinglu on 2017/12/20.
//  Copyright © 2017年 lxl. All rights reserved.
//

#import "RootViewController.h"

#import "RoutesManager.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)mainCliecked:(id)sender {
    [[RoutesManager instance] handleOpenURL:[NSURL URLWithString:@"route://main"]];
}

- (IBAction)setCliecked:(id)sender {
    [[RoutesManager instance] handleOpenURL:[NSURL URLWithString:@"route://set" param:@{@"title":@"设置来了"}]];
}
- (IBAction)colorCliecked:(id)sender {
    [[RoutesManager instance] handleOpenURL:[NSURL URLWithString:@"route://color"]];
}
- (IBAction)redColorCliecked:(id)sender {
    [[RoutesManager instance] handleOpenURL:[NSURL URLWithString:@"route://color"] context:@{@"color":[UIColor redColor]}];
}
- (IBAction)greenColorCliecked:(id)sender {
    [[RoutesManager instance] handleOpenURL:[NSURL URLWithString:@"route://color?title=COLOR"]];
}
- (IBAction)webCliecked:(id)sender {
    [[RoutesManager instance] handleOpenURL:[NSURL URLWithString:@"http://www.baidu.com"]];
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

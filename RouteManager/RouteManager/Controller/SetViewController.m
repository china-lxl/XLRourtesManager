//
//  SetViewController.m
//  RouteManager
//
//  Created by lixinglu on 2017/12/20.
//  Copyright © 2017年 lxl. All rights reserved.
//

#import "SetViewController.h"

@interface SetViewController ()

@property (copy, nonatomic)  NSString *param1;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation SetViewController

- (instancetype)initWithParam:(NSDictionary *)param{
    self = [super init];
    if (self) {
        self.title = [param valueForKey:@"title"];
        self.param1 = [param valueForKey:@"param1"];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.nameLabel.text = self.param1;
    // Do any additional setup after loading the view from its nib.
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

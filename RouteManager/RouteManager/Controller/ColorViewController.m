//
//  ColorViewController.m
//  RouteManager
//
//  Created by lixinglu on 2017/12/20.
//  Copyright © 2017年 lxl. All rights reserved.
//

#import "ColorViewController.h"

@interface ColorViewController ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (copy, nonatomic)  NSString *color;


@end

@implementation ColorViewController

- (instancetype)initWithParam:(NSDictionary *)param{
    self = [super init];
    if (self) {
        if ([param valueForKey:@"color"]) {
            if ([[param valueForKey:@"color"] isKindOfClass:[NSString class]]) {
                self.color = [param valueForKey:@"color"];
            }else{
                self.view.backgroundColor = [param valueForKey:@"color"];
            }
        }
        if ([param valueForKey:@"title"]) {
            self.title = [param valueForKey:@"title"];
        }
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.nameLabel.text = self.color ? :@"-";
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

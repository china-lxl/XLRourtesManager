//
//  WebViewController.m
//  RouteManager
//
//  Created by lixinglu on 2017/12/20.
//  Copyright © 2017年 lxl. All rights reserved.
//

#import "WebViewController.h"

#import <WebKit/WebKit.h>

@interface WebViewController ()<WKNavigationDelegate>

@property(nonatomic, copy) NSString *path;


@property (weak, nonatomic) IBOutlet WKWebView *webView;


@end

@implementation WebViewController

- (instancetype)initWithParam:(NSDictionary *)param{
    self = [super init];
    if (self) {
        self.path = [param valueForKey:@"path"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"加载中...";
    
    self.webView.navigationDelegate = self;
    
    NSURL *url = [NSURL URLWithString:self.path];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    // Do any additional setup after loading the view from its nib.
}


- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    self.title = webView.title;
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

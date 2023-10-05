//
//  AppDelegate.m
//  RouteManager
//
//  Created by lixinglu on 2017/12/20.
//  Copyright © 2017年 lxl. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self initRoutes];

    // Override point for customization after application launch.
    return YES;
}

- (void)initRoutes{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"RouteInfo" ofType:@"plist"];
    [XLRoutesManager defaultRoutesNamesFilePath:path scheme:@"lxl"];
    
    BOOL isLogin = NO;
    [[XLRoutesManager instance] registerVaildation:^NSURL *(NSURL *url) {
        if (!isLogin) {
            NSLog(@"需要登录权限,这里处理登录逻辑");
            //处理 去登录的逻辑
            return [NSURL URLWithString:@"lxl://Login"];
        }
        return url;
    } forKey:@"login"];
    
    
    // 可单独 再次 注册 路由
    [[XLRoutesManager instance] registerRoute:@"color" className:@"ColorViewController"];
    [[XLRoutesManager instance] registerRoute:@"greenColor" className:@"ColorViewController" defaultParam:@{@"color":[UIColor greenColor]}];
    
    //
    [[XLRoutesManager instance] registerRoute:@"myset" className:@"ColorViewController" defaultParam:@{@"color":[UIColor orangeColor]} vaildationKeys:@[@"login",@"vip"]];
    
    [[XLRoutesManager instance] registerRoute:@"lxlYellowColor" className:@"ColorViewController" defaultParam:nil vaildationKeys:nil intercept:^NSURL *(NSURL *url) {
        return [NSURL URLWithString:@"lxl://color" param:@{@"color":@"FFFF00"}];
    }];}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end

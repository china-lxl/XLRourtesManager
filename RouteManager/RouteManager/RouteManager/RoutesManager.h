//
//  RoutesManager.h
//  RouteManager
//
//  Created by lixinglu on 2017/12/20.
//  Copyright © 2017年 lxl. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NSURL+param.h"

@class UIViewController;
@interface RoutesManager : NSObject

+ (instancetype)instance;

//注册路由
- (void)registerRoute:(NSString *)routesName className:(NSString *)className;
- (void)registerRoute:(NSString *)routesName className:(NSString *)className defaultParam:(NSDictionary *)defaultParam;
- (void)registerRoute:(NSString *)routesName className:(NSString *)className defaultParam:(NSDictionary *)defaultParam vaildationParam:(NSDictionary *)validationParam;
- (void)registerRoute:(NSString *)routesName className:(NSString *)className defaultParam:(NSDictionary *)defaultParam vaildationParam:(NSDictionary *)validationParam intercept:(NSURL *(^)(NSURL *url))intercept;

//- (BOOL)canOpenURL:(NSURL *)url;
- (void)handleOpenURL:(NSURL *)url;
- (void)handleOpenURL:(NSURL *)url context:(id)context;
- (void)handleOpenURL:(NSURL *)url context:(id)context fromController:(UIViewController *)viewContro;

@end


@interface NSObject (ParamInit)

- (instancetype)initWithParam:(NSDictionary *)param;

@end

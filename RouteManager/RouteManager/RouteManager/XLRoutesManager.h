//
//  XLRoutesManager.h
//  XLRoutesManager
//
//  Created by lixinglu on 2017/12/20.
//  Copyright © 2017年 lxl. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NSURL+XLParam.h"
#import "NSString+XLEncode.h"

typedef NSURL *(^vaildationBlock)(NSURL *url);

@class UIViewController;

@interface XLRoutesManager : NSObject

/// 初始化 时候，默认注册的路由 映射关系  以及对应的 scheme
+ (BOOL)defaultRoutesNamesFilePath:(NSString *)path scheme:(NSString *)scheme;

/// 单例
+ (instancetype)instance;

- (void)registerVaildation:(vaildationBlock)vaildation forKey:(NSString *)key;


/// 注册 路由
- (void)registerRoute:(NSString *)routesName className:(NSString *)className;

/// 路由 带默认参数
- (void)registerRoute:(NSString *)routesName className:(NSString *)className defaultParam:(NSDictionary *)defaultParam;

/// 路由 带 校验参数
- (void)registerRoute:(NSString *)routesName className:(NSString *)className defaultParam:(NSDictionary *)defaultParam vaildationKeys:(NSArray *)vaildationKeys;

/// 路由带 校验参数 以及 映射关系
- (void)registerRoute:(NSString *)routesName className:(NSString *)className defaultParam:(NSDictionary *)defaultParam vaildationKeys:(NSArray *)vaildationKeys intercept:(NSURL *(^)(NSURL *url))intercept;


///  是否能处理该url 主要针对 本地自定义的路由事件
- (BOOL)canOpenURL:(NSURL *)url;


/// 页面跳转
- (void)handleOpenURL:(NSURL *)url;
- (void)handleOpenURL:(NSURL *)url model:(id)model;
- (void)handleOpenURL:(NSURL *)url param:(NSDictionary *)param;
- (void)handleOpenURL:(NSURL *)url param:(NSDictionary *)param fromController:(UIViewController *)viewContro;
- (void)handleOpenURL:(NSURL *)url model:(id)model fromController:(UIViewController *)viewContro;
- (void)handleOpenURL:(NSURL *)url param:(NSDictionary *)param model:(id)model fromController:(UIViewController *)viewContro;

@end


///  三种接收 传值方法，  1 和 2  不要同时出现，不然默认 走 1
@interface NSObject (ParamInit)

- (instancetype)initWithParam:(NSDictionary *)param;
- (instancetype)initWithModel:(id)model;
- (instancetype)initWithParam:(NSDictionary *)param model:(id)object;

@end

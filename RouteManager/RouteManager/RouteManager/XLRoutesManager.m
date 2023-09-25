//
//  XLRoutesManager.m
//  XLRoutesManager
//
//  Created by lixinglu on 2017/12/20.
//  Copyright © 2017年 lxl. All rights reserved.
//

#import "XLRoutesManager.h"

#import <UIKit/UIKit.h>

static XLRoutesManager *_routesManager;

@interface RoutesInfo : NSObject

@property (nonatomic, strong) NSString *className;
@property (nonatomic, strong) NSDictionary *defaultParam;
@property (nonatomic, strong) NSArray *validations;
@property (nonatomic, copy) NSURL *(^intercept)(NSURL *url);

@end

@implementation RoutesInfo

+ (RoutesInfo *)routesInfoWithClassName:(NSString *)className defaultParam:(NSDictionary *)defaultParam validations:(NSArray *)validations intercept:(NSURL *(^)(NSURL *url))intercept {
    RoutesInfo *info = [[RoutesInfo alloc] init];
    info.className = className;
    info.defaultParam = defaultParam;
    info.validations = validations;
    info.intercept = intercept;
    return info;
}

@end

@interface XLRoutesManager ()

@property (nonatomic, strong) NSMutableDictionary *routes;

@property (strong, nonatomic)  NSMutableDictionary *vaildations;

@end

@implementation XLRoutesManager

+ (instancetype)instance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _routesManager = [[XLRoutesManager alloc] init];
    });
    return _routesManager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.vaildations = [NSMutableDictionary dictionary];
    }
    return self;
}

#pragma mark - 校验 处理
- (void)registerVaildation:(NSURL *(^)(NSURL *))vaildation forKey:(NSString *)key{
    [self.vaildations setValue:vaildation forKey:key];
}

#pragma mark - 处理跳转的Url
- (BOOL)canOpenURL:(NSURL *)url{
    BOOL canOpen = NO;
    if ([url.scheme isEqualToString:@"lxl"]) {
        RoutesInfo *info = [self.routes objectForKey:url.host];
        if (info) {
            canOpen = YES;
        }
    }
    return canOpen;
}
- (void)handleOpenURL:(NSURL *)url{
    [self handleOpenURL:url param:nil];
}
- (void)handleOpenURL:(NSURL *)url model:(id)model{
    [self handleOpenURL:url model:model fromController:nil];
}
- (void)handleOpenURL:(NSURL *)url param:(NSDictionary *)param{
    [self handleOpenURL:url param:param fromController:nil];
}
- (void)handleOpenURL:(NSURL *)url model:(id)model fromController:(UIViewController *)viewContro{
    [self handleOpenURL:url param:nil model:model fromController:viewContro];
}
- (void)handleOpenURL:(NSURL *)url param:(NSDictionary *)param fromController:(UIViewController *)viewContro{
    [self handleOpenURL:url param:param model:nil fromController:viewContro];
}
- (void)handleOpenURL:(NSURL *)url param:(NSDictionary *)context model:(id)model fromController:(UIViewController *)viewContro{
#ifdef DEBUG
    NSLog(@"url:%@", url.absoluteString);
#endif
    if ([url.scheme isEqualToString:@"lxl"]) {
        RoutesInfo *info = [self.routes objectForKey:url.host];
        if (!info) {
            return;
        }
        if (info.intercept) {
            url = info.intercept(url);
        }
        if (!url) {
            return;
        }
        NSDictionary *param = [url queryParam];
        if (info.validations && ![self validationCheckUrl:url param:param withValidation:info.validations]) {
            return;
        }
        if (info.defaultParam) {
            NSMutableDictionary *temp = [[NSMutableDictionary alloc] initWithCapacity:param.count + info.defaultParam.count];
            if ([context isKindOfClass:[NSDictionary class]]) {
                NSDictionary *t = (NSDictionary *)context;
                for (NSString *key in t.allKeys) {
                    [temp setObject:[t objectForKey:key] forKey:key];
                }
            }
            for (NSString *key in info.defaultParam.allKeys) {
                [temp setObject:[info.defaultParam objectForKey:key] forKey:key];
            }
            for (NSString *key in param.allKeys) {
                [temp setObject:[param objectForKey:key] forKey:key];
            }
            
            param = temp;
        }else if ([context isKindOfClass:[NSDictionary class]]){
            NSMutableDictionary *temp = [[NSMutableDictionary alloc] initWithCapacity: info.defaultParam.count];

            NSDictionary *t = (NSDictionary *)context;
            for (NSString *key in t.allKeys) {
                [temp setObject:[t objectForKey:key] forKey:key];
            }
            param = temp;
        }
        Class controllerClass = NSClassFromString(info.className);
        UIViewController *controller = nil;
        if ([controllerClass instancesRespondToSelector:@selector(initWithParam:model:)]) {
            controller = (UIViewController *)[[controllerClass alloc] initWithParam:param model:model];
        }
        else if([controllerClass instancesRespondToSelector:@selector(initWithModel:)]) {
            controller = (UIViewController *)[[controllerClass alloc] initWithModel:model];
        }
        else if([controllerClass instancesRespondToSelector:@selector(initWithParam:)]) {
            controller = (UIViewController *)[[controllerClass alloc] initWithParam:param];
        }
        else {
            controller = (UIViewController *)[[controllerClass alloc] init];
        }
        if ([controller isKindOfClass:[UIViewController class]]) {
            UINavigationController *nav;
            if (viewContro) {
                nav = viewContro.navigationController;
            }else{
                nav = [self getRootNavigationVC];
            }
            [nav pushViewController:controller animated:YES];
        }
    }
    else if ([url.scheme hasPrefix:@"http"]){
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
        }
    }
}


/// 获取根视图的 navigationVC
- (UINavigationController *)getRootNavigationVC{
    UINavigationController *nav;
    UIWindow *rootWindow;
    if (@available(iOS 13.0, *)) {
        for (UIWindowScene *windowScene in [UIApplication sharedApplication].connectedScenes) {
            if (windowScene.activationState == UISceneActivationStateForegroundActive) {
                for (UIWindow *window in windowScene.windows){
                    if (window.isKeyWindow){
                        rootWindow = window;
                        break;
                    }
                }
            }
        }
    } else {
        rootWindow = [UIApplication sharedApplication].keyWindow;
    }
    
    UIViewController *root = rootWindow.rootViewController;
    
    if ([root isKindOfClass:[UINavigationController class]]) {
        nav = (UINavigationController *)root;
    }else if ([root isKindOfClass:[UITabBarController class]]){
        UITabBarController *tabBar = (UITabBarController *)root;
        nav = (UINavigationController *)tabBar.selectedViewController;
    }else if ([root isKindOfClass:[UIViewController class]]){
        nav = root.navigationController;
    }
    return nav;
}

- (BOOL)validationCheckUrl:(NSURL *)url param:(NSDictionary *)param withValidation:(NSArray *)validations{
    __block BOOL limit = YES;
    [validations enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        vaildationBlock vaildation = [self.vaildations objectForKey:obj];
        if (vaildation) {
            NSURL *url_new = vaildation(url);
            if (!url_new) {
                limit = NO;
                *stop = YES;
            }
        }else{
#ifdef DEBUG
            NSLog(@"字段 %@ 未处理，默认此选项通过",obj);
#endif
        }
    }];
    return limit;
}

#pragma mark - 注册路由处理
- (void)registerRoute:(NSString *)routesName className:(NSString *)className {
    [self registerRoute:routesName className:className defaultParam:nil];
}

- (void)registerRoute:(NSString *)routesName className:(NSString *)className defaultParam:(NSDictionary *)defaultParam {
    [self registerRoute:routesName className:className defaultParam:defaultParam vaildationKeys:nil];
}

- (void)registerRoute:(NSString *)routesName className:(NSString *)className defaultParam:(NSDictionary *)defaultParam vaildationKeys:(NSArray *)vaildationKeys{
    [self registerRoute:routesName className:className defaultParam:defaultParam vaildationKeys:vaildationKeys intercept:nil];
}

- (void)registerRoute:(NSString *)routesName className:(NSString *)className defaultParam:(NSDictionary *)defaultParam vaildationKeys:(NSArray *)vaildationKeys intercept:(NSURL *(^)(NSURL *))intercept{
    if (routesName.length == 0) {
        return;
    }
    if (!self.routes) {
        self.routes = [[NSMutableDictionary alloc] initWithCapacity:20];
    }
    RoutesInfo *info = [RoutesInfo routesInfoWithClassName:className defaultParam:defaultParam validations:vaildationKeys intercept:intercept];
    [self.routes setObject:info forKey:routesName];
}

#pragma mark - 初始化 路由映射关系
+ (BOOL)defaultRoutesNamesFilePath:(NSString *)path{
    if ([[XLRoutesManager instance] routes].allKeys.count > 0) {
#ifdef DEBUG
        NSLog(@"默认 路由 映射 关系 已存在，无须再次 初始化");
#endif
        return NO;
    }
    BOOL result = NO;
    
    NSError *error;
    NSDictionary *info = [[NSDictionary alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:&error];
    if (error) {
#ifdef DEBUG
        NSLog(@"路由映射关系文件，读取失败！");
#endif
        return NO;
    }
    
    NSMutableDictionary *routes = [NSMutableDictionary dictionary];
    [info enumerateKeysAndObjectsUsingBlock:^(NSString *key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        NSString *className;
        NSMutableDictionary *defaultParamer = [NSMutableDictionary dictionary];
        if ([obj isKindOfClass:[NSDictionary class]]) {
            className = [obj valueForKey:@"className"];
            [defaultParamer addEntriesFromDictionary:obj];
            [defaultParamer removeObjectForKey:@"className"];
        }else{
            className = obj;
        }
        RoutesInfo *info = [RoutesInfo routesInfoWithClassName:className defaultParam:defaultParamer validations:nil intercept:nil];
        [routes setObject:info forKey:key];
    }];
    [XLRoutesManager instance].routes = routes;

    return result;
}

@end

@implementation NSObject (ParamInit)
@end

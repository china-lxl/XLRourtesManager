//
//  RoutesManager.m
//  RouteManager
//
//  Created by lixinglu on 2017/12/20.
//  Copyright © 2017年 lxl. All rights reserved.
//

#import "RoutesManager.h"


#import "WebViewController.h"



static RoutesManager *_routesManager;

@interface RoutesInfo : NSObject

@property (nonatomic, strong) NSString *className;
@property (nonatomic, strong) NSDictionary *defaultParam;
@property (nonatomic, strong) NSDictionary *validationParam;
@property (nonatomic, copy) NSURL *(^intercept)(NSURL *url);

@end

@implementation RoutesInfo

+ (RoutesInfo *)routesInfoWithClassName:(NSString *)className defaultParam:(NSDictionary *)defaultParam validationParam:(NSDictionary *)validationParam intercept:(NSURL *(^)(NSURL *url))intercept {
    RoutesInfo *info = [[RoutesInfo alloc] init];
    info.className = className;
    info.defaultParam = defaultParam;
    info.validationParam = validationParam;
    info.intercept = intercept;
    return info;
}

@end

@interface RoutesManager ()

@property (nonatomic, strong) NSMutableDictionary *routes;

@end

@implementation RoutesManager

+ (instancetype)instance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _routesManager = [[RoutesManager alloc] init];
    });
    return _routesManager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self defalutRegister];
    }
    return self;
}


/**
 初始化 时候 注册的一些路由，  也可以在外部注册
 */
- (void)defalutRegister{
    [self registerRoute:@"main" className:@"MainViewController"];
    [self registerRoute:@"color" className:@"ColorViewController"];
    [self registerRoute:@"set" className:@"SetViewController"];
    //
}


- (void)handleOpenURL:(NSURL *)url context:(id)context {
    [self handleOpenURL:url context:context fromController:nil];
}

- (void)handleOpenURL:(NSURL *)url context:(id)context fromController:(UIViewController *)viewContro{
    NSLog(@"url:%@", url.absoluteString);
    if ([url.scheme isEqualToString:@"route"]) {
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
        if (info.validationParam && ![self validateParam:param withValidation:info.validationParam]) {
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
        if ([controllerClass instancesRespondToSelector:@selector(initWithParam:)]) {
            controller = (UIViewController *)[[controllerClass alloc] initWithParam:param];
        }
        else {
            controller = (UIViewController *)[[controllerClass alloc] init];
        }
        if ([controller isKindOfClass:[UIViewController class]]) {
            if (viewContro) {
                [viewContro.navigationController pushViewController:controller animated:YES];
            }else{
                UIViewController *root = [UIApplication sharedApplication].keyWindow.rootViewController;
                if ([root isKindOfClass:[UINavigationController class]]) {
                    UINavigationController *nav = (UINavigationController *)root;
                    [nav pushViewController:controller animated:YES];
                }else if ([root isKindOfClass:[UIViewController class]]){
                    [root.navigationController pushViewController:controller animated:YES];
                }
            }
        }
    }
    else if ([url.scheme hasPrefix:@"http"]){

            WebViewController *controller = [[WebViewController alloc] init];
            controller.targetURL = url.absoluteString;
            
            if (viewContro) {
                [viewContro.navigationController pushViewController:controller animated:YES];
            }else{
                UIViewController *root = [UIApplication sharedApplication].keyWindow.rootViewController;
                if ([root isKindOfClass:[UINavigationController class]]) {
                    UINavigationController *nav = (UINavigationController *)root;
                    [nav pushViewController:controller animated:YES];
                }else if ([root isKindOfClass:[UIViewController class]]){
                    [root.navigationController pushViewController:controller animated:YES];
                }
            }
    }
}

- (void)handleOpenURL:(NSURL *)url {
    [self handleOpenURL:url context:nil];
}

- (BOOL)validateParam:(NSDictionary *)param withValidation:(NSDictionary *)validationParam {
    //fix me
    return YES;
}

- (void)registerRoute:(NSString *)routesName className:(NSString *)className {
    [self registerRoute:routesName className:className defaultParam:nil];
}

- (void)registerRoute:(NSString *)routesName className:(NSString *)className defaultParam:(NSDictionary *)defaultParam {
    [self registerRoute:routesName className:className defaultParam:defaultParam vaildationParam:nil];
}

- (void)registerRoute:(NSString *)routesName className:(NSString *)className defaultParam:(NSDictionary *)defaultParam vaildationParam:(NSDictionary *)validationParam {
    [self registerRoute:routesName className:className defaultParam:defaultParam vaildationParam:validationParam intercept:nil];
}

- (void)registerRoute:(NSString *)routesName className:(NSString *)className defaultParam:(NSDictionary *)defaultParam vaildationParam:(NSDictionary *)validationParam intercept:(NSURL *(^)(NSURL *url))intercept {
    if (routesName.length == 0) {
        return;
    }
    if (!self.routes) {
        self.routes = [[NSMutableDictionary alloc] initWithCapacity:20];
    }
    RoutesInfo *info = [RoutesInfo routesInfoWithClassName:className defaultParam:defaultParam validationParam:validationParam intercept:intercept];
    [self.routes setObject:info forKey:routesName];
}



@end

@implementation NSObject (ParamInit)

- (instancetype)initWithParam:(NSDictionary *)param {
    self = [self init];
    //other Class should implement this method
    return self;
}

@end

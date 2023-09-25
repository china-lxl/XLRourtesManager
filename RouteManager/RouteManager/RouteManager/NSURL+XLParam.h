//
//  NSURL+XLParam.h
//  RouteManager
//
//  Created by lixinglu on 2017/12/20.
//  Copyright © 2017年 lxl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (XLParam);

- (NSDictionary *)queryParam;
+ (NSURL *)URLWithString:(NSString *)url param:(NSDictionary *)param;

@end

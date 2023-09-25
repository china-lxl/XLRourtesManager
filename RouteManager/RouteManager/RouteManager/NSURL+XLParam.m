//
//  NSURL+XLParam.m
//  RouteManager
//
//  Created by lixinglu on 2017/12/20.
//  Copyright © 2017年 lxl. All rights reserved.
//

#import "NSURL+XLParam.h"

#import "NSString+XLEncode.h"


@implementation NSURL (XLParam)

- (NSDictionary *)queryParam {
    if (!self.query) {
        return nil;
    }
    NSMutableDictionary *param = [[NSMutableDictionary alloc] initWithCapacity:10];
    NSArray *array = [self.query componentsSeparatedByString:@"&"];
    for (NSString *string in array) {
        NSArray *p = [string componentsSeparatedByString:@"="];
        if (p.count == 2) {
            [param setObject:[p[1] decodedString] forKey:[p[0] decodedString]];
        }
    }
    return param;
}

+ (NSURL *)URLWithString:(NSString *)url param:(NSDictionary *)param; {
    NSMutableString *string = [[NSMutableString alloc] initWithString:url];
    if ([string rangeOfString:@"?"].location == NSNotFound) {
        [string appendString:@"?"];
    }
    else {
        [string appendString:@"&"];
    }
    for (NSString *k in param.allKeys) {
        NSString *key = [k description];
        NSString *value = [[param objectForKey:k] description];
        [string appendFormat:@"%@=%@&", [key encodedString], [value encodedString]];
    }
    if ([string hasSuffix:@"&"]) {
        [string deleteCharactersInRange:NSMakeRange(string.length - 1, 1)];
    }
    return [[NSURL alloc] initWithString:string];
}

@end

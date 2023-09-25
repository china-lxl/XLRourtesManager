//
//  NSString+XLEncode.m
//  RouteManager
//
//  Created by lxl on 2023/9/25.
//  Copyright © 2023 lxl. All rights reserved.
//

#import "NSString+XLEncode.h"

@implementation NSString (XLEncode)

- (NSString *)encodedString{
    return [self stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}

- (NSString *)decodedString{
    return self.stringByRemovingPercentEncoding;
}

@end

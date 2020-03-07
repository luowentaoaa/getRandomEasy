//
//  LLInfo.m
//  缓存图片
//
//  Created by luowentao on 2020/3/7.
//  Copyright © 2020 luowentao. All rights reserved.
//

#import "LLInfo.h"

@implementation LLInfo

+ (instancetype)InfoWithDic:(NSDictionary *)dic{
    LLInfo *info = [[self alloc] init];
    
    [info setValuesForKeysWithDictionary:dic];
    info.icon = @"https://bing.ioliu.cn/v1/rand?w=320&h=240";
    return info;
}

+ (NSArray *)Info{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"some.plist" ofType:nil];
    NSArray *array = [NSArray arrayWithContentsOfFile:path];
    
    NSMutableArray *mArray = [NSMutableArray arrayWithCapacity:10];
    
    for (NSDictionary *dict in array) {
        LLInfo *info = [LLInfo InfoWithDic:dict];
        [mArray addObject:info];
    }
    return mArray.copy;
}


@end

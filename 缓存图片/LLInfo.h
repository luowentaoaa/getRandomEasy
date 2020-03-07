//
//  LLInfo.h
//  缓存图片
//
//  Created by luowentao on 2020/3/7.
//  Copyright © 2020 luowentao. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface LLInfo : NSObject

@property (nonatomic, copy)NSString *name;
@property (nonatomic, copy)NSString *icon;
@property (nonatomic, copy)NSString *phone;

@property (nonatomic, strong)UIImage *image;

+ (instancetype) InfoWithDic:(NSDictionary *)dic;

+ (NSArray *) Info;

@end

NS_ASSUME_NONNULL_END

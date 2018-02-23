//
//  word.m
//  鑫鑫背单词
//
//  Created by tongwei on 2018/2/6.
//  Copyright © 2018年 yoese. All rights reserved.
//

#import "YSword.h"

@implementation YSword

- (instancetype)initWithDict:(NSDictionary *)dict{
    if (self = [super init]) {
        self.word = dict[@"word"];
        self.zh = dict[@"zh"];
        self.deacon = dict[@"deacon"];
        self.status = dict[@"status"];
    }
    return self;
}

+ (instancetype)wordWithDict:(NSDictionary *)dict{
    return [[self alloc] initWithDict:dict];
}

@end

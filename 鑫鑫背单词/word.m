//
//  word.m
//  鑫鑫背单词
//
//  Created by tongwei on 2018/2/6.
//  Copyright © 2018年 yoese. All rights reserved.
//

#import "word.h"

@implementation word

- (instancetype)initWithDict:(NSDictionary *)dict{
    if (self = [super init]) {
        self.name = dict[@"name"];
        self.meaning = dict[@"meaning"];
        self.url = dict[@"url"];
        
    }
    return self;
}

+ (instancetype)wordWithDict:(NSDictionary *)dict{
    return [[self alloc] initWithDict:dict];
}
@end

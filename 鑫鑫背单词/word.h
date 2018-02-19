//
//  word.h
//  鑫鑫背单词
//
//  Created by tongwei on 2018/2/6.
//  Copyright © 2018年 yoese. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface word : NSObject
/** 单词名 */
@property (nonatomic, copy) NSString *name;
/** 单词中文意思 */
@property (nonatomic, copy) NSString *meaning;
/** 单词朗读 */
@property (nonatomic, copy) NSURL *url;

// 提供构造方法
- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)wordWithDict:(NSDictionary *)dict;
@end

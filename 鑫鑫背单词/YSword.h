//
//  word.h
//  鑫鑫背单词
//
//  Created by tongwei on 2018/2/6.
//  Copyright © 2018年 yoese. All rights reserved.
//  类功能： 存储单词数据

#import <Foundation/Foundation.h>

@interface YSword : NSObject
/** 单词名 */
@property (nonatomic, copy) NSString *word;
/** 单词中文意思 */
@property (nonatomic, copy) NSString *zh;
/** 单词朗读 */
@property (nonatomic, copy) NSString *deacon;
/** 单词背诵状态： 99 没背过  1 不熟练 2 熟练 */
@property (nonatomic, assign) int status;

// 提供构造方法
- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)wordWithDict:(NSDictionary *)dict;


@end

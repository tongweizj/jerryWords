//
//  queryDB.h
//  鑫鑫背单词
//
//  Created by 童远山 on 2018/2/22.
//  Copyright © 2018年 yoese. All rights reserved.
//
//  类功能: 连接sqlite数据库

#import <Foundation/Foundation.h>

@interface YSqueryDB : NSObject

// 提供数据库使用方法
-(void)connectDatabase;

// 根据传入的文件路径 和 文件类型，获取词库
-(void)queryWords;

// 获取单词
-(NSArray *)getwords;
@end


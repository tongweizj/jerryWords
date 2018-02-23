//
//  queryDB.h
//  鑫鑫背单词
//
//  Created by 童远山 on 2018/2/22.
//  Copyright © 2018年 yoese. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface queryDB : NSObject

// 提供数据库使用方法
-(void)connectDatabase;
// 2. 根据传入的文件路径 和 文件类型，获取词库
//- (NSArray *)readDbFromPath:(NSString *)path andType:(NSString *)type;
-(void)queryWords;
@end


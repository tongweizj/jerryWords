//
//  queryDB.m
//  鑫鑫背单词
//
//  Created by 童远山 on 2018/2/22.
//  Copyright © 2018年 yoese. All rights reserved.
//

#import "queryDB.h"
#import "word.h"
#import "FMDatabase.h"

@interface queryDB ()
@property (nonatomic, strong) NSArray *weekList; //本周要背词库清单
@property (nonatomic, strong) NSArray *words; //本周要背单词清单
@end

FMDatabase *dataBase;
/*
 1. 从数据库里，读出要背诵的单词
 1） 打开数据库
 2. 查询要被的单词
 1> 读取单词表清单，查出要背的list
 2> 根据要list字段，从单词表中查询出单词
 2. 把取出来的单词写到单词model里面
 */
@implementation queryDB

-(void)connectDatabase{
    //1.创建数据库
    //1>获得数据库文件的路径
    NSString *path = [[NSBundle mainBundle] pathForResource:@"jerryDB" ofType:@"SQLite"];
    //2> 创建执行SQLite数据库的类
    dataBase = [FMDatabase databaseWithPath:path];
    //3> 打开数据库
    [dataBase open];
    
    //3.使用如下语句，如果打开失败，可能是权限不足或者资源不足。通常打开完操作操作后，需要调用 close 方法来关闭数据库。在和数据库交互 之前，数据库必须是打开的。如果资源或权限不足无法打开或创建数据库，都会导致打开失败。
    if ([dataBase open]){
        NSLog(@"打开成功");
    }else{
        NSLog(@"打开失败");
    }
    // 2. 查询要背的单词
    // 1> 读取单词表清单，查出要背的list
    // status:0=没有背过  1=需要背诵  2=需要复习   3=完成
    [self queryWordsListname:nil andStatus:1];
    // 2> 根据要list字段，从单词表中查询出单词
    [self queryWords];
    
    //关闭数据库
    //[_dataBase close];
}

-(void)queryWordsListname:(NSString *)name andStatus:(int)status{
    //根据list字段查询
    NSString *selectSQL=@"select * from wordsList where status = 1;";
    FMResultSet *set = [dataBase executeQuery:selectSQL];
    NSLog(@"%@",set);
    
    //取数据
    NSMutableArray *tmpArr = [[NSMutableArray alloc] init];
    while ([set next]) {
        int listId = [set intForColumn:@"id"];
        NSNumber * number = [NSNumber numberWithInt:listId];
        [tmpArr addObject:number];
        NSLog(@"listId = %@", number);
    }
    _weekList = tmpArr;
}

-(void)queryWords{
    
    NSEnumerator * enumerateor =  [_weekList objectEnumerator];
    NSString * value;
    while (value = [enumerateor nextObject]) {
        NSLog(@"enum str %@",value);
        //根据list字段,构造SQL语句
        NSString *selectSQL = [[NSString alloc] initWithFormat:@"select * from words where list = %@;", value];
        //根据sql语句查询
        FMResultSet *set = [dataBase executeQuery:selectSQL];
        NSLog(@"%@",set);
        
        //取数据
        NSMutableArray *tmpArr = [[NSMutableArray alloc] init];

        while ([set next]) {
            NSString * word = [set stringForColumn:@"word"];
            NSString * zh = [set stringForColumn:@"zh"];
            NSString * deacon = [set stringForColumn:@"deacon"];
            int status = [set intForColumn:@"status"];
            
            //创建临时字典
            NSDictionary *tmpDict = [NSDictionary dictionaryWithObjectsAndKeys:word,@"word",zh,@"zh",deacon,@"deacon",[NSNumber numberWithInt:status],@"status", nil];
            
//            NSLog(@"tmpDict = %@", tmpDict);
//            NSLog(@"tmpDict = %@", tmpDict[@"word"]);
//            NSLog(@"tmpDict = %@", tmpDict[@"zh"]);
//            NSLog(@"tmpDict = %@", tmpDict[@"deacon"]);
//
//            NSLog(@"tmpDict = %@", tmpDict[@"status"]);
            //将字典装入要返回的数组
            word *aWord = [word shopWithDict:dict];
            // 把模型装入数组
            [tempArray addObject:shop];
            [tmpArr addObject:tmpDict];
        }
    }
}
@end


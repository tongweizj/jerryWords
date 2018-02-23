//
//  queryDB.m
//  鑫鑫背单词
//
//  Created by 童远山 on 2018/2/22.
//  Copyright © 2018年 yoese. All rights reserved.
//

#import "YSqueryDB.h"
#import "YSword.h"
#import "FMDatabase.h"

@interface YSqueryDB ()
@property (nonatomic, strong) NSArray *weekList; //本周要背词库清单
@property (nonatomic, strong) NSArray *words; //本周要背单词清单
@end

FMDatabase *dataBase;

@implementation YSqueryDB

-(void)connectDatabase{
    //1.创建数据库
    //1>获得数据库文件的路径
    NSString *path = [[NSBundle mainBundle] pathForResource:@"jerryDB" ofType:@"SQLite"];
    //2> 创建执行SQLite数据库的类
    dataBase = [FMDatabase databaseWithPath:path];
    //3> 打开数据库
    [dataBase open];
    
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
        [tmpArr addObject:[NSNumber numberWithInt:listId]];
    }
    //存到类属性
    _weekList = tmpArr;
}

-(void)queryWords{
    NSMutableArray *tmpArr = [[NSMutableArray alloc] init];
    // 将weeklist 数组枚举
    NSEnumerator * enumerateor =  [_weekList objectEnumerator];
    NSString * value;
    // 遍历数据
    while (value = [enumerateor nextObject]) {
        //根据list字段,构造SQL语句
        NSString *selectSQL = [[NSString alloc] initWithFormat:@"select * from words where list = %@;", value];
        //根据sql语句查询
        FMResultSet *set = [dataBase executeQuery:selectSQL];
        //读取数据
        while ([set next]) {
            NSString * word = [set stringForColumn:@"word"];
            NSString * zh = [set stringForColumn:@"zh"];
            NSString * deacon = [set stringForColumn:@"deacon"];
            if([set stringForColumn:@"deacon"]){
                
            }else{
                deacon = @" "; //如果 deacon=空的时候，给他一个空格，否则字典会没有这个字段
            }
            int status = [set intForColumn:@"status"];
            if(status == 0){
                status = 99; //如果 status=0，给他一个空格，否则字典会没有这个字段
            }
            // 创建临时字典，一个单词一个字典
            NSDictionary *tmpDict = [NSDictionary dictionaryWithObjectsAndKeys:word,@"word",zh,@"zh",deacon,@"deacon",[NSNumber numberWithInt:status],@"status", nil];
            // 将单词的字典转化成单词对象
            YSword *aWord = [YSword wordWithDict:tmpDict];
            // 将单词对象装入数组
            [tmpArr addObject:aWord];
        }
    }
    _words = tmpArr;
}

// 单词表的get方法
-(NSArray *)getwords{
    return _words;
}
@end


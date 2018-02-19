//
//  ViewController.m
//  鑫鑫背单词
//
//  Created by 童玮 on 2018-01-23.
//  Copyright © 2018 yoese. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface ViewController ()

// 词库数据
@property (nonatomic, assign) NSArray *wordsList; //词库全清单
@property (nonatomic, assign) NSArray *weekList; //本周要背词库清单
@property (nonatomic, assign) NSInteger  index; //当前单词索引号
@property (nonatomic, assign) NSString *wordsName; //当前词库名称
@property (nonatomic, strong) NSArray *wordsArr; // 当前词库数据


// 文本Label
@property (weak, nonatomic) IBOutlet UILabel *wordLabel; //单词区
@property (weak, nonatomic) IBOutlet UILabel *translationLabel;//中文翻译区
@property (weak, nonatomic) IBOutlet UIImageView *logo;  //首页的logo

//按钮
@property (weak, nonatomic) IBOutlet UIButton *startBTN; //开始背单词
@property (weak, nonatomic) IBOutlet UIButton *nextBTN;  //下一个单词
@property (weak, nonatomic) IBOutlet UIButton *lastBTN;  //上一个单词
@property (weak, nonatomic) IBOutlet UIButton *seeTranslationBTN; //查看翻译
@property (weak, nonatomic) IBOutlet UIButton *playWordBTN; //朗读
@property (weak, nonatomic) IBOutlet UIButton *wordList; //选词库
@property (weak, nonatomic) IBOutlet UIButton *closeBTN; //关闭单词页，回首页

/** 播放器 */
@property (nonatomic, strong) AVPlayer *player;
@end


@implementation ViewController

//启动
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 1. 设置为首页
    [self isHome:YES];

    // 2.和文本转语音相关
    self.speechSynthesizer = [[AVSpeechSynthesizer alloc] init];
    [self.speechSynthesizer setDelegate:self];
    
    //3. 读取本周要背的单词
    [self pullWordsListArr];
    [self pullWeekWordsList];
    
    // 5.创建播放器
    self.player = [[AVPlayer alloc] init];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 词库数据懒加载
// 1. 获取词库清单
- (void)pullWordsListArr{
    self.wordsList = [self readDataFromPath:@"wordsList" andType:@"plist"];
}
// 2. 组装本周要背的单词
- (void)pullWeekWordsList{
    NSMutableArray *combineArray = [[NSMutableArray alloc] init];
    NSArray *tmpArray = [[NSArray alloc] init];
    NSDictionary *tmplist = nil;
    for(NSDictionary *list in self.wordsList){
        //NSLog(@"List: %@",list);
        // 如果list.status = 0 没有背过; 1 要背; 2 背完复习
        NSInteger status = [list[@"status"] integerValue];
        if( status == 1){
            tmpArray = [self readDataFromPath:list[@"path"] andType:@"plist"];
            for(tmplist in tmpArray){
                [combineArray addObject:tmplist];
                //NSLog(@"tmplist%@",tmplist);
            }
        }
    }
    self.wordsArr = combineArray;
    //NSLog(@"wordsArr%@",self.wordsArr);
}
// 2. 根据传入的文件路径 和 文件类型，获取词库
- (NSArray *)readDataFromPath:(NSString *)path andType:(NSString *)type{
    NSString *dataPath = [[NSBundle mainBundle] pathForResource:path ofType:type]; //根据输入的文件名来拼装路径
    NSArray *tmpArr = [NSArray arrayWithContentsOfFile:dataPath]; //根据dataPath 路径来读取数组
    return tmpArr;
}
// 3. 读取词库数组
- (NSArray *)pullWordsArr{
    if (_wordsArr == nil && _wordsName != nil) {
        // 加载数据
        [self readDataFromPath:_wordsName andType:@"plist"];
    }
    return _wordsArr;
}



/** 前端页面显示功能 **/
// 切换首页和单词页
- (void)isHome:(BOOL)yesOrNo{
    if (yesOrNo) {
        // 1. 首页元素设置
        self.startBTN.hidden = NO;
        self.wordList.hidden = NO;
        self.logo.hidden = NO;
        self.wordLabel.hidden = YES;
        self.lastBTN.hidden = YES;
        self.nextBTN.hidden = YES;
        self.translationLabel.hidden = YES;
        self.seeTranslationBTN.hidden = YES;
        self.playWordBTN.hidden = YES;
        self.closeBTN.hidden = YES;
    } else {
        // 3. 单词页元素设置
        self.logo.hidden = YES;
        self.startBTN.hidden = YES;
        self.wordList.hidden = YES;
        self.wordLabel.hidden = NO;
        self.nextBTN.hidden = NO;
        self.lastBTN.hidden = NO;
        self.translationLabel.hidden = YES;
        self.seeTranslationBTN.hidden = NO;
        self.playWordBTN.hidden = NO;
        self.closeBTN.hidden = NO;
    }
}

// 单词翻译的现实开关
- (void)translationSwitch:(BOOL)yesOrNo{
    if (yesOrNo) {
        self.translationLabel.hidden = YES;
        self.seeTranslationBTN.enabled = YES;
    } else {
        self.translationLabel.hidden = NO;
        self.seeTranslationBTN.enabled = NO;
    }
}
/** 前端页面显示功能 end **/


/** 按钮功能设定**/
// BTN：开始
- (IBAction)start:(UIButton *)button {
    
    // 1. 预读要背诵的单词  <==这里要修改
    //[self pullWordsArr];
    
    // 2. 设置为单词页
    [self isHome:NO];
    // 3. 取词
    self.index = 0;
    [self takeWordAndShow:0];
}

// BTN：回到首页
- (IBAction)close:(UIButton *)button {
    // 2. 设置为单词页
    [self isHome:YES];
}
- (IBAction)last:(UIButton *)button {
    // 1.检查是否第一个单词
    
    if(self.index == 0){
        self.index = 0;
    }else{
        self.index --;
    }
    // 2.取词
    [self takeWordAndShow:0];
    // 3.修改翻译按钮显示状态
    [self translationSwitch:YES];
}

//BTN：下一个单词
- (IBAction)next:(UIButton *)button {
    // 1.检查是否最后一个单词
    NSInteger indexLast = [self.wordsArr count] - 1;
    if(self.index == indexLast){
        self.index = 0;
    }else{
        self.index ++;
    }
    // 2.取词
    [self takeWordAndShow:0];
    // 3.修改翻译按钮显示状态
    [self translationSwitch:YES];
    
}

//BTN：查看翻译
- (IBAction)seeTranslation:(UIButton *)button {
    // 1.显示翻译
    [self takeWordAndShow:1];
    // 2.修改翻译按钮显示状态
    [self translationSwitch:NO];
}

//BTN：播放单词发音
- (IBAction)playWordBTN:(id)sender {
    // 1.播放读音
    [self takeWordAndShow:2];
}





/** 按钮功能设定 end **/

/** 功能 **/
//单词读取和显示
-(void) takeWordAndShow: (int)partNumber {
    // 1.取词
    NSDictionary *word = self.wordsArr[self.index];
    NSString *wordText = word[@"word"];
    NSString *wordTranslation = word[@"translation"];
    NSString *url = word[@"url"];
    // 2.填入内容
    switch (partNumber) {
        case 0:
            // 3.wordLabel填入单词
            self.wordLabel.text = wordText;
            break;
        case 1:
            // 2.translationLabel填入中文翻译
            self.translationLabel.text = wordTranslation;
            break;
        case 2:
            //把文本传给api
            [self speakWordUrl:url withword:wordText];
            break;
        default:
            break;
    }
}
//https://www.ldoceonline.com/media/english/ameProns/too.mp3

- (void)speakWordUrl:(NSString *)urlStr withword:(NSString *)wordText{

    if (urlStr.length != 0) {
        [self speakUrl:urlStr];
    } else {
        [self speakText:wordText];
    }

}
//根据URL 来朗读单词
-(void)speakUrl:(NSString *)urlStr{
    /*
     // 资源的URL地址
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"too.mp3" withExtension:nil];
    //NSURL *url  = [NSURL URLWithString:urlStr];
    // 创建播放器曲目
    AVPlayerItem *playerItem = [[AVPlayerItem alloc] initWithURL:url];
    // 创建播放器
     
    AVPlayer *player = [[AVPlayer alloc] initWithPlayerItem:playerItem];
    [player play];
    */
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:urlStr withExtension:nil];
    //NSURL *url  = [NSURL URLWithString:urlStr];
    AVPlayerItem *playerItem = [[AVPlayerItem alloc] initWithURL:url];
    [self.player replaceCurrentItemWithPlayerItem:playerItem];
    [self.player play];
}
/*
 Take the current contents of the TextView and output it through the speakers of the user's device
 获取TextView的当前内容并通过用户设备的扬声器输出
 */
- (void)speakText:(NSString *)toBeSpoken{
    
    AVSpeechUtterance *utt = [AVSpeechUtterance speechUtteranceWithString:toBeSpoken];
    /*
     rate = 0.4  慢速
     0.5  正常速度
     */
    utt.rate = 0.5 ;//设置播放速度
    [self.speechSynthesizer speakUtterance:utt];
}
/** 功能 end **/
@end

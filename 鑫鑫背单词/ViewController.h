//
//  ViewController.h
//  鑫鑫背单词
//
//  Created by 童玮 on 2018-01-23.
//  Copyright © 2018 yoese. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <AVFoundation/AVFoundation.h>
@interface ViewController : UIViewController <AVSpeechSynthesizerDelegate, UITextViewDelegate>
/**
 * 这是一个文本转语音的类
 */
/** 文本转语音相关 */
@property (nonatomic, retain) AVSpeechSynthesizer *speechSynthesizer;

//
/** 和文本转语音相关 */
- (IBAction)playWordBTN:(id)sender;

/** 要转语音的文本 */
- (void)speakText:(NSString *)toBeSpoken;

/** 切换首页和单词页 */
- (void)isHome:(BOOL)yesOrNo;

@end

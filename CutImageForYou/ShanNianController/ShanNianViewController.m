//
//  ShanNianViewController.m
//  CutImageForYou
//
//  Created by chenxi on 2018/5/23.
//  Copyright © 2018年 chenxi. All rights reserved.
//

#import "ShanNianViewController.h"
#import "IATConfig.h"
#import "ISRDataHelper.h"
#import "PopupView.h"
#import "WaveView.h"
#import "PcmPlayer.h"
#import "PcmPlayerDelegate.h"
#import <Foundation/Foundation.h>
#import<AVFoundation/AVFoundation.h>
#import "ShanNianMuLuViewController.h"
#import <WebKit/WebKit.h>
#import "UIImage+Gradient.h"

#define SPEAKVIEW_HEIZGHT   kAUTOHEIGHT(170)
#define SPEAKVIEW_WIDTH     ScreenWidth - kAUTOWIDTH(40)

#define DAMPING  12
#define STIFFNESS 100
#define MASS   1
#define  INITIALVE   1
#define Dur_Time  2

#define NAME        @"userwords"
#define USERWORDS   @"{\"userword\":[{\"name\":\"我的常用词\",\"words\":[\"佳晨实业\",\"蜀南庭苑\",\"高兰路\",\"复联二\"]},{\"name\":\"我的好友\",\"words\":[\"李馨琪\",\"鹿晓雷\",\"张集栋\",\"周家莉\",\"叶震珂\",\"熊泽萌\"]}]}"

@interface ShanNianViewController ()<IFlySpeechRecognizerDelegate,IFlyRecognizerViewDelegate,UIActionSheetDelegate,IFlyPcmRecorderDelegate,PcmPlayerDelegate,AVAudioPlayerDelegate,WKNavigationDelegate,WKUIDelegate>
@property(nonatomic,strong)UIButton *beginSpeakButton;
@property(nonatomic,strong)UILabel *speakLabel;
@property(nonatomic,strong)UIButton *beginPlayButton;
@property(nonatomic,strong)UIButton *pushButton;


//不带界面的识别对象
@property (nonatomic, strong) IFlySpeechRecognizer *iFlySpeechRecognizer;
@property (nonatomic,strong) IFlyPcmRecorder *pcmRecorder;//PCM Recorder to be used to demonstrate Audio Stream Recognition.
@property (nonatomic, strong) IFlyRecognizerView *iflyRecognizerView;//Recognition control with view

@property (nonatomic, strong) NSString * result;
@property (nonatomic, strong) PopupView *popUpView;
@property (nonatomic,strong) WaveView *waveView;
@property (nonatomic, strong) PcmPlayer *audioPlayer;
@property (nonatomic, strong) WKWebView *webView;
@property(nonatomic,strong)CALayer *speakSubLayer;
@property (nonatomic,assign) BOOL isStreamRec;//Whether or not it is Audio Stream function
@property (nonatomic, strong) IFlyDataUploader *uploader;//upload control

@property(nonatomic,strong)CALayer *webViewSubLayer;


@end

@implementation ShanNianViewController

#pragma mark ========生命周期==========

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.hidden = YES;
    [self createBaseUI];
    self.volumArray = [[NSMutableArray alloc]init];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self initRecognizer];
    [_beginPlayButton setEnabled:YES];
    [_beginSpeakButton setEnabled:YES];
}
- (void)viewWillDisappear:(BOOL)animated{
    NSLog(@"%s",__func__);
    if ([IATConfig sharedInstance].haveView == NO) {
        [_iFlySpeechRecognizer cancel];
        [_iFlySpeechRecognizer setDelegate:nil];
        [_iFlySpeechRecognizer setParameter:@"" forKey:[IFlySpeechConstant PARAMS]];
        [_pcmRecorder stop];
        _pcmRecorder.delegate = nil;
    }else{
        [_iflyRecognizerView cancel];
        [_iflyRecognizerView setDelegate:nil];
        [_iflyRecognizerView setParameter:@"" forKey:[IFlySpeechConstant PARAMS]];
    }
    [super viewWillDisappear:animated];
}


#pragma mark - Button Handling

/**
 start speech recognition
 **/

- (void)setTextLabelIsNil{
    
    _speakLabel.text = @"";
    [_speakLabel resignFirstResponder];
    
    _speakTextView.text = @"";
    [_speakTextView resignFirstResponder];
}

- (void)startBtnHandler:(id)sender {
    
    NSLog(@"%s[IN]",__func__);
    
    if ([IATConfig sharedInstance].haveView == NO) {
        
        [self setTextLabelIsNil];
        self.isCanceled = NO;
        self.isStreamRec = NO;
        
        if(_iFlySpeechRecognizer == nil)
        {
            [self initRecognizer];
        }
        
        [_iFlySpeechRecognizer cancel];
        
        //Set microphone as audio source
        [_iFlySpeechRecognizer setParameter:IFLY_AUDIO_SOURCE_MIC forKey:@"audio_source"];
        
        //Set result type
        [_iFlySpeechRecognizer setParameter:@"json" forKey:[IFlySpeechConstant RESULT_TYPE]];
        
        //Set the audio name of saved recording file while is generated in the local storage path of SDK,by default in library/cache.
        [_iFlySpeechRecognizer setParameter:@"asr.pcm" forKey:[IFlySpeechConstant ASR_AUDIO_PATH]];
        
        [_iFlySpeechRecognizer setDelegate:self];
        
        BOOL ret = [_iFlySpeechRecognizer startListening];
        
        if (ret) {
            [_beginSpeakButton setEnabled:NO];
            [_beginPlayButton setEnabled:NO];
//            [_upContactBtn setEnabled:NO];
            
        }else{
            [_popUpView showText: NSLocalizedString(@"M_ISR_Fail", nil)];//Last session may be not over, recognition not supports concurrent multiplexing.
        }
    }else {
        
        if(_iflyRecognizerView == nil)
        {
            [self initRecognizer ];
        }
        
     
        
        //Set microphone as audio source
        [_iflyRecognizerView setParameter:IFLY_AUDIO_SOURCE_MIC forKey:@"audio_source"];
        
        //Set result type
        [_iflyRecognizerView setParameter:@"plain" forKey:[IFlySpeechConstant RESULT_TYPE]];
        
        //Set the audio name of saved recording file while is generated in the local storage path of SDK,by default in library/cache.
        [_iflyRecognizerView setParameter:@"asr.pcm" forKey:[IFlySpeechConstant ASR_AUDIO_PATH]];
        
        BOOL ret = [_iflyRecognizerView start];
        if (ret) {
            [_beginSpeakButton setEnabled:NO];
            [_beginPlayButton setEnabled:NO];
    
        }
    }
    
}

/**
 stop recording
 **/
- (void)stopBtnHandler:(id)sender {
    
    NSLog(@"%s",__func__);
    
    if(self.isStreamRec && !self.isBeginOfSpeech){
        NSLog(@"%s,stop recording",__func__);
        [_pcmRecorder stop];
    }
    
    [_iFlySpeechRecognizer stopListening];
    [_speakLabel resignFirstResponder];
    [_speakTextView resignFirstResponder];
}

/**
 cancel speech recognition
 **/
- (void)cancelBtnHandler:(id)sender {
    NSLog(@"%s",__func__);
    
    if(self.isStreamRec && !self.isBeginOfSpeech){
        NSLog(@"%s,stop recording",__func__);
        [_pcmRecorder stop];
    }
    
    self.isCanceled = YES;
    
    [_iFlySpeechRecognizer cancel];
    
    [_popUpView removeFromSuperview];
    [_speakLabel resignFirstResponder];
    [_speakTextView resignFirstResponder];
    
}




/**
 upload contacts
 **/
- (void)upContactBtnHandler:(id)sender {
    //Ensure that the recognition session is over
    [_iFlySpeechRecognizer stopListening];
    
    [_beginPlayButton setEnabled:NO];
    [_beginSpeakButton setEnabled:NO];

    [self showPopup];
    
    //acquire contact list
    IFlyContact *iFlyContact = [[IFlyContact alloc] init];
    NSString *contact = [iFlyContact contact];
    
    _speakTextView.text = contact;
    _speakLabel.text = contact;
    
    [_uploader setParameter:@"uup" forKey:[IFlySpeechConstant SUBJECT]];
    [_uploader setParameter:@"contact" forKey:[IFlySpeechConstant DATA_TYPE]];
    [_uploader uploadDataWithCompletionHandler:
     ^(NSString * grammerID, IFlySpeechError *error)
     {
         [self onUploadFinished:error];
     } name:@"contact" data: _speakTextView.text];
}


/**
 upload customized words
 **/
- (void)upWordBtnHandler:(id)sender {
    
    [_iFlySpeechRecognizer stopListening];
    
    [_beginSpeakButton setEnabled:NO];
    [_beginPlayButton setEnabled:NO];

    
    [_uploader setParameter:@"uup" forKey:[IFlySpeechConstant SUBJECT]];
    [_uploader setParameter:@"userword" forKey:[IFlySpeechConstant DATA_TYPE]];
    
    [self showPopup];
    
    IFlyUserWords *iFlyUserWords = [[IFlyUserWords alloc] initWithJson:USERWORDS ];
    
    [_uploader uploadDataWithCompletionHandler:
     ^(NSString * grammerID, IFlySpeechError *error)
     {
         if (error.errorCode == 0) {
             _speakTextView.text = @"佳晨实业\n蜀南庭苑\n高兰路\n复联二\n李馨琪\n鹿晓雷\n张集栋\n周家莉\n叶震珂\n熊泽萌\n";
         }
         [self onUploadFinished:error];
     } name:NAME data:[iFlyUserWords toString]];
    
}

/**
 start audio stream recognition
 **/
- (void)audioStreamBtnHandler:(id)sender {
    
    NSLog(@"%s[IN]",__func__);
    [self chuLiSuoYouView];
//    [self createDismissSpeakViewAnimation];
    [self createSpeakView];
    [self createSpeakViewAnimation];
    
    [self setTextLabelIsNil];
    
    self.isStreamRec = YES;
    self.isBeginOfSpeech = NO;
    
    if ([IATConfig sharedInstance].haveView == YES) {
        [_popUpView showText: NSLocalizedString(@"M_ISR_Stream_Fail", nil)];
        return;
    }
    
    if(_iFlySpeechRecognizer == nil)
    {
        [self initRecognizer];
    }
    
    [_beginPlayButton setEnabled:NO];
    [_beginSpeakButton setEnabled:NO];

    
    [_iFlySpeechRecognizer setDelegate:self];
    [_iFlySpeechRecognizer setParameter:@"json" forKey:[IFlySpeechConstant RESULT_TYPE]];
    [_iFlySpeechRecognizer setParameter:IFLY_AUDIO_SOURCE_STREAM forKey:@"audio_source"];    //Set audio stream as audio source,which requires the developer import audio data into the recognition control by self through "writeAudio:".
    BOOL ret  = [_iFlySpeechRecognizer startListening];
    
    
    if (ret) {
        self.isCanceled = NO;
        //set the category of AVAudioSession
        [IFlyAudioSession initRecordingAudioSession];
        
        _pcmRecorder.delegate = self;
        
        //start recording
        BOOL ret = [_pcmRecorder start];
        
        [_popUpView showText: NSLocalizedString(@"T_RecNow", nil)];
        
        NSLog(@"%s[OUT],Success,Recorder ret=%d",__func__,ret);
    }
    else
    {
        [_beginPlayButton setEnabled:YES];
        [_beginSpeakButton setEnabled:YES];

        [_popUpView showText: NSLocalizedString(@"M_ISR_Fail", nil)];
        NSLog(@"%s[OUT],Failed",__func__);
    }
}

- (void)onSetting:(id)sender {
    
//    if ([[self.navigationController topViewController] isKindOfClass:[IATViewController class]]){
//        [self performSegueWithIdentifier:@"ISRSegue" sender:self];
//    }
    
}



#pragma mark - IFlySpeechRecognizerDelegate

/**
 volume callback,range from 0 to 30.
 **/
- (void) onVolumeChanged: (int)volume
{
    if (self.isCanceled) {
        [_popUpView removeFromSuperview];
        return;
    }
    
    NSString * vol = [NSString stringWithFormat:@"%@：%d", NSLocalizedString(@"T_RecVol", nil),volume];
    [_popUpView showText: vol];
}



/**
 Beginning Of Speech
 **/
- (void) onBeginOfSpeech
{
    NSLog(@"onBeginOfSpeech");
    
    if (self.isStreamRec == NO)
    {
        self.isBeginOfSpeech = YES;
        [_popUpView showText: NSLocalizedString(@"T_RecNow", nil)];
    }
}

/**
 End Of Speech
 **/
- (void) onEndOfSpeech
{
    NSLog(@"onEndOfSpeech");
    
    [_pcmRecorder stop];
    [_popUpView showText: NSLocalizedString(@"T_RecStop", nil)];
}


/**
 recognition session completion, which will be invoked no matter whether it exits error.
 error.errorCode =
 0     success
 other fail
 **/
- (void) onCompleted:(IFlySpeechError *) error
{
    NSLog(@"%s",__func__);
    NSLog(@"onBeginOfSpeech");

    if ([IATConfig sharedInstance].haveView == NO ) {
        
        NSString *text ;
        
        if (self.isCanceled) {
            text = NSLocalizedString(@"T_ISR_Cancel", nil);
            
        } else if (error.errorCode == 0 ) {
            if (_result.length == 0) {
                text = NSLocalizedString(@"T_ISR_NoRlt", nil);
            }else {
                text = NSLocalizedString(@"T_ISR_Succ", nil);
                //empty results
                _result = nil;
            }
        }else {
            text = [NSString stringWithFormat:@"Error：%d %@", error.errorCode,error.errorDesc];
            NSLog(@"%@",text);
        }
        
        [_popUpView showText: text];
        
    }else {
        [_popUpView showText: NSLocalizedString(@"T_ISR_Succ", nil)];
        NSLog(@"errorCode:%d",[error errorCode]);
    }
    
    [_beginPlayButton setEnabled:YES];
    [_beginSpeakButton setEnabled:YES];
 
    
}

/**
 result callback of recognition without view
 results：recognition results
 isLast：whether or not this is the last result
 **/
- (void) onResults:(NSArray *) results isLast:(BOOL)isLast
{
    NSMutableString *resultString = [[NSMutableString alloc] init];
    NSDictionary *dic = results[0];
    
    for (NSString *key in dic) {
        [resultString appendFormat:@"%@",key];
    }
    
    _result =[NSString stringWithFormat:@"%@%@", _speakTextView.text,resultString];
//    _result =[NSString stringWithFormat:@"%@%@", _speakTextView.text,resultString];

    NSString * resultFromJson =  nil;
    
    if([IATConfig sharedInstance].isTranslate){
        
        NSDictionary *resultDic  = [NSJSONSerialization JSONObjectWithData:    //The result type must be utf8, otherwise an unknown error will happen.
                                    [resultString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
        if(resultDic != nil){
            NSDictionary *trans_result = [resultDic objectForKey:@"trans_result"];
            
            if([[IATConfig sharedInstance].language isEqualToString:@"en_us"]){
                NSString *dst = [trans_result objectForKey:@"dst"];
                NSLog(@"dst=%@",dst);
                resultFromJson = [NSString stringWithFormat:@"%@\ndst:%@",resultString,dst];
            }
            else{
                NSString *src = [trans_result objectForKey:@"src"];
                NSLog(@"src=%@",src);
                resultFromJson = [NSString stringWithFormat:@"%@\nsrc:%@",resultString,src];
            }
        }
    }
    else{
        resultFromJson = [ISRDataHelper stringFromJson:resultString];
    }
    
    _speakLabel.text = [NSString stringWithFormat:@"%@%@", _speakLabel.text,resultFromJson];
    _speakTextView.text = [NSString stringWithFormat:@"%@%@", _speakTextView.text,resultFromJson];

    if (isLast){
        NSLog(@"ISR Results(json)：%@",  self.result);
    }
    NSLog(@"_result=%@",_result);
    NSLog(@"resultFromJson=%@",resultFromJson);
    NSLog(@"isLast=%d,_textView.text=%@",isLast,_speakTextView.text);
    NSLog(@"isLast=%d,_textView.text=%@",isLast,_speakLabel.text);

}



/**
 result callback of recognition with view
 resultArray：recognition results
 isLast：whether or not this is the last result
 **/
- (void)onResult:(NSArray *)resultArray isLast:(BOOL)isLast
{
    NSMutableString *resultString = [[NSMutableString alloc] init];
    NSDictionary *dic = [resultArray objectAtIndex:0];
    
    for (NSString *key in dic) {
        [resultString appendFormat:@"%@",key];
    }
    
    NSString * resultFromJson =  nil;
    
    if([IATConfig sharedInstance].isTranslate){
        
        NSDictionary *resultDic  = [NSJSONSerialization JSONObjectWithData:    //The result type must be utf8, otherwise an unknown error will happen.
                                    [resultString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
        if(resultDic != nil){
            NSDictionary *trans_result = [resultDic objectForKey:@"trans_result"];
            
            if([[IATConfig sharedInstance].language isEqualToString:@"en_us"]){
                NSString *dst = [trans_result objectForKey:@"dst"];
                NSLog(@"dst=%@",dst);
                resultFromJson = [NSString stringWithFormat:@"%@\ndst:%@",resultString,dst];
            }
            else{
                NSString *src = [trans_result objectForKey:@"src"];
                NSLog(@"src=%@",src);
                resultFromJson = [NSString stringWithFormat:@"%@\nsrc:%@",resultString,src];
            }
        }
    }
    else{
        resultFromJson = [NSString stringWithFormat:@"%@",resultString];//;[ISRDataHelper stringFromJson:resultString];
    }
    
    _speakTextView.text = [NSString stringWithFormat:@"%@%@", _speakTextView.text,resultFromJson];
    _speakLabel.text = [NSString stringWithFormat:@"%@%@", _speakLabel.text,resultFromJson];

}



/**
 callback of canceling recognition
 **/
- (void) onCancel
{
    NSLog(@"Recognition is cancelled");
}

-(void) showPopup
{
    [_popUpView showText: NSLocalizedString(@"T_ISR_Uping", nil)];
}

#pragma mark - IFlyDataUploaderDelegate

/**
 result callback of uploading contacts or customized words
 **/
- (void) onUploadFinished:(IFlySpeechError *)error
{
    NSLog(@"%d",[error errorCode]);
    
    if ([error errorCode] == 0) {
        [_popUpView showText: NSLocalizedString(@"T_ISR_UpSucc", nil)];
    }
    else {
        [_popUpView showText: [NSString stringWithFormat:@"%@:%d", NSLocalizedString(@"T_ISR_UpFail", nil), error.errorCode]];
        
    }
    
    [_beginPlayButton setEnabled:YES];
    [_beginSpeakButton setEnabled:YES];

}


#pragma mark - Initialization

/**
 initialize recognition conctol and set recognition params
 **/
-(void)initRecognizer
{
    NSLog(@"%s",__func__);
    
    if ([IATConfig sharedInstance].haveView == NO) {
        
        //recognition singleton without view
        if (_iFlySpeechRecognizer == nil) {
            _iFlySpeechRecognizer = [IFlySpeechRecognizer sharedInstance];
        }
        
        [_iFlySpeechRecognizer setParameter:@"" forKey:[IFlySpeechConstant PARAMS]];
        
        //set recognition domain
        [_iFlySpeechRecognizer setParameter:@"iat" forKey:[IFlySpeechConstant IFLY_DOMAIN]];
        
        _iFlySpeechRecognizer.delegate = self;
        
        if (_iFlySpeechRecognizer != nil) {
            IATConfig *instance = [IATConfig sharedInstance];
            
            //set timeout of recording
            [_iFlySpeechRecognizer setParameter:instance.speechTimeout forKey:[IFlySpeechConstant SPEECH_TIMEOUT]];
            //set VAD timeout of end of speech(EOS)
            [_iFlySpeechRecognizer setParameter:instance.vadEos forKey:[IFlySpeechConstant VAD_EOS]];
            //set VAD timeout of beginning of speech(BOS)
            [_iFlySpeechRecognizer setParameter:instance.vadBos forKey:[IFlySpeechConstant VAD_BOS]];
            //set network timeout
            [_iFlySpeechRecognizer setParameter:@"20000" forKey:[IFlySpeechConstant NET_TIMEOUT]];
            
            //set sample rate, 16K as a recommended option
            [_iFlySpeechRecognizer setParameter:instance.sampleRate forKey:[IFlySpeechConstant SAMPLE_RATE]];
            
            //set language
            [_iFlySpeechRecognizer setParameter:instance.language forKey:[IFlySpeechConstant LANGUAGE]];
            //set accent
            [_iFlySpeechRecognizer setParameter:instance.accent forKey:[IFlySpeechConstant ACCENT]];
            
            //set whether or not to show punctuation in recognition results
            [_iFlySpeechRecognizer setParameter:instance.dot forKey:[IFlySpeechConstant ASR_PTT]];
            
        }
        
        //Initialize recorder
        if (_pcmRecorder == nil)
        {
            _pcmRecorder = [IFlyPcmRecorder sharedInstance];
        }
        
        _pcmRecorder.delegate = self;
        
        [_pcmRecorder setSample:[IATConfig sharedInstance].sampleRate];
        
        [_pcmRecorder setSaveAudioPath:nil];    //not save the audio file
        
    }else  {
        
        //recognition singleton with view
        if (_iflyRecognizerView == nil) {
            
            _iflyRecognizerView= [[IFlyRecognizerView alloc] initWithCenter:self.view.center];
        }
        
        [_iflyRecognizerView setParameter:@"" forKey:[IFlySpeechConstant PARAMS]];
        
        //set recognition domain
        [_iflyRecognizerView setParameter:@"iat" forKey:[IFlySpeechConstant IFLY_DOMAIN]];
        
        
        _iflyRecognizerView.delegate = self;
        
        if (_iflyRecognizerView != nil) {
            IATConfig *instance = [IATConfig sharedInstance];
            //set timeout of recording
            [_iflyRecognizerView setParameter:instance.speechTimeout forKey:[IFlySpeechConstant SPEECH_TIMEOUT]];
            //set VAD timeout of end of speech(EOS)
            [_iflyRecognizerView setParameter:instance.vadEos forKey:[IFlySpeechConstant VAD_EOS]];
            //set VAD timeout of beginning of speech(BOS)
            [_iflyRecognizerView setParameter:instance.vadBos forKey:[IFlySpeechConstant VAD_BOS]];
            //set network timeout
            [_iflyRecognizerView setParameter:@"20000" forKey:[IFlySpeechConstant NET_TIMEOUT]];
            
            //set sample rate, 16K as a recommended option
            [_iflyRecognizerView setParameter:instance.sampleRate forKey:[IFlySpeechConstant SAMPLE_RATE]];
            
            //set language
            [_iflyRecognizerView setParameter:instance.language forKey:[IFlySpeechConstant LANGUAGE]];
            //set accent
            [_iflyRecognizerView setParameter:instance.accent forKey:[IFlySpeechConstant ACCENT]];
            //set whether or not to show punctuation in recognition results
            [_iflyRecognizerView setParameter:instance.dot forKey:[IFlySpeechConstant ASR_PTT]];
            
        }
    }
    
    if([[IATConfig sharedInstance].language isEqualToString:@"en_us"]){
        if([IATConfig sharedInstance].isTranslate){
            [self translation:NO];
        }
    }
    else{
        if([IATConfig sharedInstance].isTranslate){
            [self translation:YES];
        }
    }
    
}

-(void)translation:(BOOL) langIsZh
{
    
    if ([IATConfig sharedInstance].haveView == NO) {
        [_iFlySpeechRecognizer setParameter:@"1" forKey:[IFlySpeechConstant ASR_SCH]];
        
        if(langIsZh){
            [_iFlySpeechRecognizer setParameter:@"cn" forKey:@"orilang"];
            [_iFlySpeechRecognizer setParameter:@"en" forKey:@"translang"];
        }
        else{
            [_iFlySpeechRecognizer setParameter:@"en" forKey:@"orilang"];
            [_iFlySpeechRecognizer setParameter:@"cn" forKey:@"translang"];
        }
        
        [_iFlySpeechRecognizer setParameter:@"translate" forKey:@"addcap"];
        
        [_iFlySpeechRecognizer setParameter:@"its" forKey:@"trssrc"];
    }
    else{
        [_iflyRecognizerView setParameter:@"1" forKey:[IFlySpeechConstant ASR_SCH]];
        
        if(langIsZh){
            [_iflyRecognizerView setParameter:@"cn" forKey:@"orilang"];
            [_iflyRecognizerView setParameter:@"en" forKey:@"translang"];
        }
        else{
            [_iflyRecognizerView setParameter:@"en" forKey:@"orilang"];
            [_iflyRecognizerView setParameter:@"cn" forKey:@"translang"];
        }
        
        [_iflyRecognizerView setParameter:@"translate" forKey:@"addcap"];
        
        [_iflyRecognizerView setParameter:@"its" forKey:@"trssrc"];
    }
    
    
}


-(void)setExclusiveTouchForButtons:(UIView *)myView
{
    for (UIView * button in [myView subviews]) {
        if([button isKindOfClass:[UIButton class]])
        {
            [((UIButton *)button) setExclusiveTouch:YES];
        }
        else if ([button isKindOfClass:[UIView class]])
        {
            [self setExclusiveTouchForButtons:button];
        }
    }
}


#pragma mark - IFlyPcmRecorderDelegate

- (void) onIFlyRecorderBuffer: (const void *)buffer bufferSize:(int)size
{
    NSData *audioBuffer = [NSData dataWithBytes:buffer length:size];
    
    int ret = [self.iFlySpeechRecognizer writeAudio:audioBuffer];
    if (!ret)
    {
        [self.iFlySpeechRecognizer stopListening];
        
        [_beginPlayButton setEnabled:YES];
        [_beginSpeakButton setEnabled:YES];
  
        
    }
}

- (void) onIFlyRecorderError:(IFlyPcmRecorder*)recoder theError:(int) error
{
    
}

//range from 0 to 30
- (void) onIFlyRecorderVolumeChanged:(int) power
{
    //    NSLog(@"%s,power=%d",__func__,power);
    
    if (self.isCanceled) {
        [_popUpView removeFromSuperview];
        return;
    }
    
    NSString * vol = [NSString stringWithFormat:@"%@：===我是声音=========== %d", NSLocalizedString(@"T_RecVol", nil),power];
    NSLog(@"声音大小 === %d",power);
    [_popUpView showText: vol];
}





























#pragma mark ===========WebViewDelegate============
- (void)createWebViewAnimation{
    
    self.webFatherView.frame = self.beginSpeakButton.frame;

    [UIView animateWithDuration: 3 delay:0 usingSpringWithDamping:100 initialSpringVelocity:0.3 options:0 animations:^{
       
        self.webFatherView.transform = CGAffineTransformMakeScale(1, 1);
        self.webFatherView.frame = CGRectMake(kAUTOWIDTH(20), CGRectGetMaxY(self.speakView.frame) + kAUTOHEIGHT(20), ScreenWidth - kAUTOWIDTH(40), ScreenHeight -SPEAKVIEW_HEIZGHT - kAUTOHEIGHT(44) - 50);
        self.webFatherView.alpha = 1;
        
    }completion:^(BOOL finished) {
        
            _webViewSubLayer=[CALayer layer];
            CGRect fixframe=self.webFatherView.layer.frame;
            _webViewSubLayer.frame = fixframe;
            _webViewSubLayer.cornerRadius = kAUTOHEIGHT(10);
            _webViewSubLayer.backgroundColor=[[UIColor grayColor] colorWithAlphaComponent:0.5].CGColor;
            _webViewSubLayer.masksToBounds=NO;
            _webViewSubLayer.shadowColor=[UIColor grayColor].CGColor;
            _webViewSubLayer.shadowOffset=CGSizeMake(0,0);
            _webViewSubLayer.shadowOpacity=0.7f;
            _webViewSubLayer.shadowRadius= 7;
            [self.view.layer insertSublayer:_webViewSubLayer below:self.webFatherView.layer];

    }];
}

- (void)createWebView{
    
    self.webFatherView = [[UIView alloc]initWithFrame:CGRectMake(kAUTOWIDTH(20),ScreenHeight, ScreenWidth - kAUTOWIDTH(40), ScreenHeight -SPEAKVIEW_HEIZGHT - kAUTOHEIGHT(44) - 50)];
    
    self.webFatherView.alpha = 0;
    self.webFatherView.transform = CGAffineTransformMakeScale(0.7, 0.7);
    
    
    self.webFatherView.layer.masksToBounds = YES;
    self.webFatherView.layer.cornerRadius = 10;
//
//    CALayer *subLayer=[CALayer layer];
//    CGRect fixframe=self.webFatherView.layer.frame;
//    subLayer.frame = fixframe;
//    subLayer.cornerRadius = kAUTOHEIGHT(10);
//    subLayer.backgroundColor=[[UIColor grayColor] colorWithAlphaComponent:0.5].CGColor;
//    subLayer.masksToBounds=NO;
//    subLayer.shadowColor=[UIColor grayColor].CGColor;
//    subLayer.shadowOffset=CGSizeMake(0,0);
//    subLayer.shadowOpacity=0.7f;
//    subLayer.shadowRadius= 7;
//    [self.view.layer insertSublayer:subLayer below:self.webFatherView.layer];
    
    
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth - kAUTOWIDTH(40), kAUTOHEIGHT(44))];
    titleView.backgroundColor = [UIColor whiteColor];
    [self.webFatherView addSubview:titleView];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:titleView.bounds];
    titleLabel.backgroundColor = [UIColor whiteColor];
    [titleView addSubview:titleLabel];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"百度搜索";
    
    titleView.layer.shadowColor=[UIColor grayColor].CGColor;
    titleView.layer.shadowOffset=CGSizeMake(0,0.5);
    titleView.layer.shadowOpacity=0.2f;
    titleView.layer.shadowRadius= 2;
    
    
    self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0,  kAUTOHEIGHT(44), SPEAKVIEW_WIDTH, ScreenHeight - SPEAKVIEW_HEIZGHT - kAUTOHEIGHT(44) - 50 - kAUTOHEIGHT(44))];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.baidu.com"]]];
    self.webView.navigationDelegate = self;
    self.webView.UIDelegate = self;
    self.webView.backgroundColor = [UIColor yellowColor];
    //开了支持滑动返回
    self.webView.allowsBackForwardNavigationGestures = YES;
    [self.webFatherView addSubview:self.webView];
    [self.view addSubview:self.webFatherView];
    
    [self.webFatherView sendSubviewToBack:self.webView];
}





- (WaveView *)waveView{
    if (!_waveView) {
        _waveView = [[WaveView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_speakLabel.frame) + 50, self.view.bounds.size.width, 100)];
        _waveView.backgroundColor = [UIColor whiteColor];
        _waveView.targetWaveHeight = 0;
    }
    return _waveView;
}

#pragma mark ========== 上面显示的SpeakView的动画
- (void)createDismissSpeakViewAnimation{
    [_speakSubLayer removeFromSuperlayer];
    
    [UIView animateWithDuration:3 animations:^{
        self.speakView.frame = CGRectMake(ScreenWidth/2 - ScreenWidth/6, kAUTOHEIGHT(44) + SPEAKVIEW_HEIZGHT/2 - kAUTOHEIGHT(22),ScreenWidth/3, kAUTOHEIGHT(44));

        self.speakTextView.frame = CGRectMake(kAUTOWIDTH(30), kAUTOHEIGHT(35), SPEAKVIEW_WIDTH - kAUTOWIDTH(60), SPEAKVIEW_HEIZGHT - kAUTOHEIGHT(80));
        
        for (int i = 0; i < 5; i ++) {
            UIButton *upButton = [self.speakView viewWithTag:1000 + i];
            upButton.transform = CGAffineTransformMakeScale(1.2, 1.2);
            
            UIButton *downButton = [self.speakView viewWithTag:100 + i];
            downButton.transform = CGAffineTransformMakeScale(1.2, 1.2);
            
            [UIView animateWithDuration: 0.7 delay:0 usingSpringWithDamping:0.3 initialSpringVelocity:0.3 options:0 animations:^{
                upButton.transform = CGAffineTransformMakeScale(0.1, 0.1);
                downButton.transform = CGAffineTransformMakeScale(0.1, 0.1);
                
                upButton.alpha = 0;
                downButton.alpha = 0;
            } completion:^(BOOL finished) {
                upButton.hidden = YES;
                downButton.hidden = YES;
            }];
            
        }
        
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:3 animations:^{
            self.speakView.frame = CGRectMake(ScreenWidth, kAUTOHEIGHT(44) + SPEAKVIEW_HEIZGHT/2 - kAUTOHEIGHT(22),ScreenWidth/3, kAUTOHEIGHT(44));
            self.speakView.alpha = 0;
            
            [self.webViewSubLayer removeFromSuperlayer];
              self.webFatherView.frame = CGRectMake(kAUTOWIDTH(20), SPEAKVIEW_HEIZGHT - kAUTOHEIGHT(20), ScreenWidth - kAUTOWIDTH(40), ScreenHeight -SPEAKVIEW_HEIZGHT - kAUTOHEIGHT(44) - 50);
            [UIView animateWithDuration:0.5 animations:^{
                self.webFatherView.frame = CGRectMake(kAUTOWIDTH(20), ScreenHeight, ScreenWidth - kAUTOWIDTH(40), ScreenHeight -SPEAKVIEW_HEIZGHT - kAUTOHEIGHT(44) - 50);
            } completion:^(BOOL finished) {
                [self.webFatherView removeFromSuperview];
            }];
            
        } completion:^(BOOL finished) {
            [self.speakView removeFromSuperview];
        }];
    }];
}


- (void)createSpeakViewAnimation{
    
    self.speakView.frame = self.beginSpeakButton.frame;
    self.speakView.layer.anchorPoint = CGPointMake(0.5, 0.5);
    [UIView animateWithDuration:  3 delay:0 usingSpringWithDamping:100 initialSpringVelocity:0.3 options:0 animations:^{
        self.speakView.transform = CGAffineTransformMakeScale(1, 1);
        self.speakView.frame = CGRectMake(kAUTOWIDTH(20), kAUTOHEIGHT(44),SPEAKVIEW_WIDTH, SPEAKVIEW_HEIZGHT);
        self.speakView.alpha = 1;
    }completion:^(BOOL finished) {
        
        for (int i = 0; i < 5; i ++) {
            UIButton *upButton = [self.speakView viewWithTag:1000 + i];
            upButton.hidden = NO;
            upButton.transform = CGAffineTransformMakeScale(0.8, 0.8);
            
            UIButton *downButton = [self.speakView viewWithTag:100 + i];
            downButton.hidden = NO;
            downButton.transform = CGAffineTransformMakeScale(0.8, 0.8);
            
            [UIView animateWithDuration: 0.7 delay:0 usingSpringWithDamping:0.3 initialSpringVelocity:0.3 options:0 animations:^{
                upButton.transform = CGAffineTransformMakeScale(1, 1);
                downButton.transform = CGAffineTransformMakeScale(1, 1);

            } completion:nil];
            
        }
        
       _speakSubLayer=[CALayer layer];
        CGRect fixframe=self.speakView.layer.frame;
        _speakSubLayer.frame = fixframe;
        _speakSubLayer.cornerRadius = kAUTOHEIGHT(10);
        _speakSubLayer.backgroundColor=[[UIColor grayColor] colorWithAlphaComponent:0.5].CGColor;
        _speakSubLayer.masksToBounds=NO;
        _speakSubLayer.shadowColor=[UIColor grayColor].CGColor;
        _speakSubLayer.shadowOffset=CGSizeMake(0,0);
        _speakSubLayer.shadowOpacity=0.7f;
        _speakSubLayer.shadowRadius= 10;
        [self.view.layer insertSublayer:_speakSubLayer below:self.speakView.layer];
        
    }];
//    self.speakView.alpha = 1;
//
    
//    CASpringAnimation *springAnimationRight = [CASpringAnimation animationWithKeyPath:@"position.y"];
//    springAnimationRight.fromValue = [NSNumber numberWithFloat:ScreenHeight] ;
//    springAnimationRight.toValue =  [NSNumber numberWithFloat:kAUTOHEIGHT(128)] ;
//
//    //    springAnimation.initialVelocity = 1;
//    springAnimationRight.initialVelocity = INITIALVE;
//    springAnimationRight.damping = DAMPING;
//    springAnimationRight.stiffness = STIFFNESS;
//    springAnimationRight.mass = MASS;
//    springAnimationRight.duration = Dur_Time;
//    //            springAnimation.additive = NO;
//    springAnimationRight.removedOnCompletion = NO;
//    springAnimationRight.fillMode = kCAFillModeForwards;
//    [_speakView.layer addAnimation:springAnimationRight forKey:@"positionAnimation"];
//
    
    
}

#pragma mark =========== 创建SpeakView ==========
- (void)createSpeakView{
    
    self.speakView = [[UIView alloc]initWithFrame:CGRectMake(kAUTOWIDTH(20),ScreenHeight,SPEAKVIEW_WIDTH, SPEAKVIEW_HEIZGHT)];
    self.speakView.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.speakView];
    self.speakView.alpha = 0;
    self.speakView.transform = CGAffineTransformMakeScale(0.7, 0.7);
    
//            CALayer *subLayer=[CALayer layer];
//            CGRect fixframe=self.speakView.layer.frame;
//            subLayer.frame = fixframe;
//            subLayer.cornerRadius = kAUTOHEIGHT(10);
//            subLayer.backgroundColor=[[UIColor grayColor] colorWithAlphaComponent:0.5].CGColor;
//            subLayer.masksToBounds=NO;
//            subLayer.shadowColor=[UIColor grayColor].CGColor;
//            subLayer.shadowOffset=CGSizeMake(0,0);
//            subLayer.shadowOpacity=0.7f;
//            subLayer.shadowRadius= 10;
//            [self.view.layer insertSublayer:subLayer below:self.speakView.layer];
    
    
    self.speakTextView = [[UITextView alloc]initWithFrame:CGRectMake(kAUTOWIDTH(30), kAUTOHEIGHT(35), SPEAKVIEW_WIDTH - kAUTOWIDTH(60), SPEAKVIEW_HEIZGHT - kAUTOHEIGHT(80))];
    self.speakTextView.text = @"";
    self.speakTextView.tintColor = [UIColor whiteColor];
    self.speakTextView.backgroundColor = [UIColor clearColor];
    self.speakTextView.font = [UIFont fontWithName:@"HeiTi SC" size:14];
    self.speakTextView.textColor = [UIColor whiteColor];
    [self.speakView addSubview:self.speakTextView];
    
    for (int i = 0 ; i < 5; i ++) {
       
        
        UIImageView *buttonBackImage = [[UIImageView alloc]initWithFrame: CGRectMake( kAUTOWIDTH(100)/2  + i *(((ScreenWidth - kAUTOWIDTH(40) - kAUTOWIDTH(100))- kAUTOWIDTH(30)*5)/4 + kAUTOWIDTH(30)), -kAUTOHEIGHT(15), kAUTOWIDTH(30), kAUTOHEIGHT(30))];
        buttonBackImage.layer.cornerRadius = kAUTOHEIGHT(15);
        buttonBackImage.layer.masksToBounds = YES;
//        [self.speakView addSubview:buttonBackImage];
        
        
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake( kAUTOWIDTH(100)/2  + i *(((ScreenWidth - kAUTOWIDTH(40) - kAUTOWIDTH(100))- kAUTOWIDTH(30)*5)/4 + kAUTOWIDTH(30)), -kAUTOHEIGHT(15), kAUTOWIDTH(30), kAUTOHEIGHT(30));
        button.backgroundColor = [UIColor blueColor];
        [self.speakView addSubview:button];
        
        button.layer.borderWidth = 2;
        button.layer.borderColor = [UIColor whiteColor].CGColor;
        button.layer.shadowOffset = CGSizeMake(0, 2);
        button.layer.shadowColor = [UIColor grayColor].CGColor;
        button.layer.shadowOpacity = 0.3;
        button.layer.shadowRadius = 3;
        button.layer.cornerRadius = kAUTOHEIGHT(15);
        
        
//        UIImage *backImage = [UIImage alloc] createImageWithSize:CGSizeMake(80, 80) gradientColors:@[(id)PNCColor(55, 188, 253),(id)PNCColor(0, 0, 0)] percentageArray:@[@(0.5),@(1)]  percentage:@[@(0.3),@(1)] gradientType:GradientFromTopToBottom];

        UIImage *newImage = [[UIImage alloc]createImageWithSize:CGSizeMake(80, 80) gradientColors:@[(id)PNCColor(164, 185, 277),(id)PNCColor(101, 152, 255)] percentage:@[@(0.3),@(1)] gradientType:GradientFromTopToBottom];
        buttonBackImage.image = newImage;

    
        
        if (i == 0) {
            
            UIImage *newImage = [[UIImage alloc]createImageWithSize:CGSizeMake(80, 80) gradientColors:@[(id)PNCColor(164, 185, 277),(id)PNCColor(101, 152, 255)] percentage:@[@(0.4),@(1)] gradientType:GradientFromTopToBottom];
            buttonBackImage.image = newImage;

            
            button.backgroundColor =  PNCColor(134, 176, 255);
            [button setImage:[UIImage imageNamed:@"目标"] forState:UIControlStateNormal];
            [button setImageEdgeInsets:UIEdgeInsetsMake(kAUTOWIDTH(6), kAUTOHEIGHT(6),kAUTOWIDTH(6), kAUTOHEIGHT(6))];

        }else if (i == 1){
            
            UIImage *newImage = [[UIImage alloc]createImageWithSize:CGSizeMake(80, 80) gradientColors:@[(id)PNCColor(252, 167, 165),(id)PNCColor(245, 93, 94)] percentage:@[@(0.4),@(1)] gradientType:GradientFromTopToBottom];
            buttonBackImage.image = newImage;

            
            button.backgroundColor = PNCColor(255, 120, 159);
            [button setImage:[UIImage imageNamed:@"沟通"] forState:UIControlStateNormal];
            [button setImageEdgeInsets:UIEdgeInsetsMake(kAUTOWIDTH(6), kAUTOHEIGHT(6),kAUTOWIDTH(6), kAUTOHEIGHT(6))];

        }else if (i == 2){
            
            UIImage *newImage = [[UIImage alloc]createImageWithSize:CGSizeMake(80, 80) gradientColors:@[(id)PNCColor(254, 216, 168),(id)PNCColor(233, 143, 93)] percentage:@[@(0.4),@(1)] gradientType:GradientFromTopToBottom];
            buttonBackImage.image = newImage;

            
            button.backgroundColor = PNCColor(255, 172, 94);
            [button setImage:[UIImage imageNamed:@"标签"] forState:UIControlStateNormal];
            [button setImageEdgeInsets:UIEdgeInsetsMake(kAUTOWIDTH(6), kAUTOHEIGHT(6),kAUTOWIDTH(6), kAUTOHEIGHT(6))];

        }else if (i == 3){
            
            UIImage *newImage = [[UIImage alloc]createImageWithSize:CGSizeMake(80, 80) gradientColors:@[(id)PNCColor(162, 210, 151),(id)PNCColor(99, 178, 86)] percentage:@[@(0.4),@(1)] gradientType:GradientFromTopToBottom];
            buttonBackImage.image = newImage;

            
            button.backgroundColor = PNCColor(109, 212, 92);
            [button setImage:[UIImage imageNamed:@"女士"] forState:UIControlStateNormal];
            [button setImageEdgeInsets:UIEdgeInsetsMake(kAUTOWIDTH(6), kAUTOHEIGHT(6),kAUTOWIDTH(6), kAUTOHEIGHT(6))];
        }else if (i == 4){
            
            UIImage *newImage = [[UIImage alloc]createImageWithSize:CGSizeMake(80, 80) gradientColors:@[(id)PNCColor(205, 175, 220),(id)PNCColor(152, 103, 186)] percentage:@[@(0.4),@(1)] gradientType:GradientFromTopToBottom];
            buttonBackImage.image = newImage;

            
            button.backgroundColor = PNCColor(182, 118, 219);
            [button setImage:[UIImage imageNamed:@"灵感"] forState:UIControlStateNormal];
            [button setImageEdgeInsets:UIEdgeInsetsMake(kAUTOWIDTH(6), kAUTOHEIGHT(6),kAUTOWIDTH(6), kAUTOHEIGHT(6))];
        }
        
//        button.backgroundColor = [UIColor clearColor];
        
        //处理按钮点击事件
        [button addTarget:self action:@selector(TouchDown:)forControlEvents: UIControlEventTouchDown];
        //处理按钮松开状态
        [button addTarget:self action:@selector(TouchUp:)forControlEvents: UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
        
        button.tag = 1000 + i;
        button.hidden = YES;
    }
    
   
    for (int i = 0; i < 5; i ++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake( kAUTOWIDTH(30)/2  + i *(((ScreenWidth - kAUTOWIDTH(40) - kAUTOWIDTH(30))- kAUTOWIDTH(30)*5)/4 + kAUTOWIDTH(30)),SPEAKVIEW_HEIZGHT - kAUTOHEIGHT(35), kAUTOWIDTH(30), kAUTOHEIGHT(30));
        button.backgroundColor = [UIColor blueColor];
        [self.speakView addSubview:button];
        [button setImage:[UIImage imageNamed:@"灵感"] forState:UIControlStateNormal];
        button.tag = 100 + i;
        button.hidden = YES;
        
        button.layer.borderWidth = 2;
        button.layer.borderColor = [UIColor whiteColor].CGColor;
        button.layer.shadowOffset = CGSizeMake(0, 2);
        button.layer.shadowColor = [UIColor grayColor].CGColor;
        button.layer.shadowOpacity = 0.3;
        button.layer.shadowRadius = 3;
        button.layer.cornerRadius = kAUTOHEIGHT(15);
        [button addTarget:self action:@selector(XiaYiPaiButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [button setImageEdgeInsets:UIEdgeInsetsMake(kAUTOWIDTH(4), kAUTOHEIGHT(4),kAUTOWIDTH(4), kAUTOHEIGHT(4))];

        if (i == 0) {
            
            UIImage *newImage = [[UIImage alloc]createImageWithSize:CGSizeMake(80, 80) gradientColors:@[(id)PNCColor(164, 185, 277),(id)PNCColor(101, 152, 255)] percentage:@[@(0.4),@(1)] gradientType:GradientFromTopToBottom];
            
            
            button.backgroundColor =  PNCColor(134, 176, 255);
            [button setImage:[UIImage imageNamed:@"删除min"] forState:UIControlStateNormal];
            
        }else if (i == 1){
            
            UIImage *newImage = [[UIImage alloc]createImageWithSize:CGSizeMake(80, 80) gradientColors:@[(id)PNCColor(252, 167, 165),(id)PNCColor(245, 93, 94)] percentage:@[@(0.4),@(1)] gradientType:GradientFromTopToBottom];
            
            
            button.backgroundColor = PNCColor(255, 120, 159);
            [button setImage:[UIImage imageNamed:@"日历"] forState:UIControlStateNormal];
            
        }else if (i == 2){
            
            UIImage *newImage = [[UIImage alloc]createImageWithSize:CGSizeMake(80, 80) gradientColors:@[(id)PNCColor(254, 216, 168),(id)PNCColor(233, 143, 93)] percentage:@[@(0.4),@(1)] gradientType:GradientFromTopToBottom];
            
            
            button.backgroundColor = PNCColor(255, 172, 94);
            [button setImage:[UIImage imageNamed:@"收藏"] forState:UIControlStateNormal];
            
        }else if (i == 3){
            
            UIImage *newImage = [[UIImage alloc]createImageWithSize:CGSizeMake(80, 80) gradientColors:@[(id)PNCColor(162, 210, 151),(id)PNCColor(99, 178, 86)] percentage:@[@(0.4),@(1)] gradientType:GradientFromTopToBottom];
            
            
            button.backgroundColor = PNCColor(109, 212, 92);
            [button setImage:[UIImage imageNamed:@"编辑"] forState:UIControlStateNormal];
        }else if (i == 4){
            
            UIImage *newImage = [[UIImage alloc]createImageWithSize:CGSizeMake(80, 80) gradientColors:@[(id)PNCColor(205, 175, 220),(id)PNCColor(152, 103, 186)] percentage:@[@(0.4),@(1)] gradientType:GradientFromTopToBottom];
            
            
            button.backgroundColor = PNCColor(182, 118, 219);
            [button setImage:[UIImage imageNamed:@"下载"] forState:UIControlStateNormal];
        }
        
    }
    
    for (int i = 0; i < 4; i ++) {
        
        UIView *lineView =  [[UIView alloc]initWithFrame:CGRectMake( kAUTOWIDTH(30)/2  + i *(((ScreenWidth - kAUTOWIDTH(40) - kAUTOWIDTH(30))- kAUTOWIDTH(30)*5)/4 + kAUTOWIDTH(30)) +  ((ScreenWidth - kAUTOWIDTH(40) - kAUTOWIDTH(30))- kAUTOWIDTH(30)*5)/48 + kAUTOWIDTH(30),SPEAKVIEW_HEIZGHT - kAUTOHEIGHT(38), 0.5, kAUTOHEIGHT(38))];
        lineView.backgroundColor = PNCColor(235, 235, 235);

//        lineView.alpha = 0.7;
//        [self.speakView addSubview:lineView];
        
        
    }
    
    UIView *lineView =  [[UIView alloc]initWithFrame:CGRectMake(0, SPEAKVIEW_HEIZGHT - kAUTOHEIGHT(38), SPEAKVIEW_WIDTH,0.5)];
    lineView.backgroundColor = PNCColor(235, 235, 235);
//    lineView.alpha = 0.7;
    [self.speakView addSubview:lineView];
    
    self.speakView.layer.cornerRadius = kAUTOWIDTH(10);
    self.speakView.layer.borderWidth = 2;
    self.speakView.layer.borderColor = [UIColor whiteColor].CGColor;
}

- (void)TouchDown:(UIButton *)sender{

    // 弹簧动画，参数分别为：时长，延时，弹性（越小弹性越大），初始速度
//    [UIView animateWithDuration: 0.3 delay:0 usingSpringWithDamping:0.3 initialSpringVelocity:0.3 options:0 animations:^{
//        // 放大
//        sender.transform = CGAffineTransformMakeScale(1.5, 1.5);
//    } completion:nil];
    
    [UIView animateWithDuration:0.3 animations:^{
        sender.transform = CGAffineTransformMakeScale(1.5, 1.5);
    }];
}

-(void)TouchUp:(UIButton *)sender{
    [UIView animateWithDuration:0.3 animations:^{
        sender.transform = CGAffineTransformMakeScale(1, 1);
    }];
}

#pragma mark ========创建识别按钮========
- (void)createBaseUI{
    
    self.beginSpeakButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.beginSpeakButton.frame = CGRectMake(ScreenWidth/2 - 25, ScreenHeight - 100, 50, 50);
    self.beginSpeakButton.backgroundColor = [UIColor redColor];
    self.beginSpeakButton.layer.masksToBounds = YES;
    self.beginSpeakButton.layer.cornerRadius = 25;
    [self.view addSubview:self.beginSpeakButton];
    [self.beginSpeakButton addTarget:self action:@selector(audioStreamBtnHandler:) forControlEvents:UIControlEventTouchUpInside];
    
    self.beginPlayButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.beginPlayButton.frame = CGRectMake(ScreenWidth/2 - 25, ScreenHeight - 170, 50, 50);
    self.beginPlayButton.backgroundColor = [UIColor redColor];
    self.beginPlayButton.layer.masksToBounds = YES;
    self.beginPlayButton.layer.cornerRadius = 25;
    [self.view addSubview:self.beginPlayButton];
    [self.beginPlayButton addTarget:self action:@selector(playRecord) forControlEvents:UIControlEventTouchUpInside];
    
    self.pushButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.pushButton.frame = CGRectMake(ScreenWidth/2 - 25 + 70, ScreenHeight - 170, 50, 50);
    self.pushButton.backgroundColor = [UIColor redColor];
    self.pushButton.layer.masksToBounds = YES;
    self.pushButton.layer.cornerRadius = 25;
    [self.pushButton setTitle:@"next" forState:UIControlStateNormal];
    [self.view addSubview:self.pushButton];
    [self.pushButton addTarget:self action:@selector(pushMuLu) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.speakLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 350, ScreenWidth-20, 200)];
    self.speakLabel.textColor = [UIColor redColor];
    self.speakLabel.numberOfLines = 0;
    [self.view addSubview:self.speakLabel];
    
//    //创建语音识别对象
//    _iFlySpeechRecognizer = [IFlySpeechRecognizer sharedInstance];
//    //设置识别参数
//    //设置为听写模式
//    [_iFlySpeechRecognizer setParameter: @"iat" forKey: [IFlySpeechConstant IFLY_DOMAIN]];
//    //asr_audio_path 是录音文件名，设置value为nil或者为空取消保存，默认保存目录在Library/cache下。
//    [_iFlySpeechRecognizer setParameter:@"iat.pcm" forKey:[IFlySpeechConstant ASR_AUDIO_PATH]];
    //启动识别服务
//    [_iFlySpeechRecognizer start];
    
}

- (void)pushMuLu{
    ShanNianMuLuViewController *smlVc = [[ShanNianMuLuViewController alloc]init];
    [self.navigationController pushViewController:smlVc animated:YES];
}

-(void)playRecord{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *libraryPath = [paths objectAtIndex:0];
    NSString *cachesPath = [NSString stringWithFormat:@"%@%@",libraryPath,@"/asr.pcm"];
    
    // 创建文件夹
    NSString *createDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *createDirPath =  [createDir stringByAppendingString:@"/test"];
    [self createFolder:createDirPath];
    // 把文件拷贝到Test目录
    BOOL filesPresent1 = [self copyMissingFile:cachesPath toPath:createDirPath];
    if (filesPresent1) {
        NSLog(@"OK");
    }
    else
    {
        NSLog(@"NO");
    }
    
    NSString *newpath = [createDirPath stringByAppendingString:@"/asr.pcm"];
    
//    _audioPlayer = [[PcmPlayer alloc] init];
    
    NSError *error = nil;
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&error];
    _audioPlayer = [[PcmPlayer alloc] initWithFilePath:newpath sampleRate:[@"16000" integerValue]];
    [_audioPlayer play];
    [self.waveView Animating];

    NSString *volumParth = [createDirPath stringByAppendingString:@"/volum.xml"];
    NSArray *resultArray = [NSArray arrayWithContentsOfFile:volumParth];
    
//    for (int i = 0;i < resultArray.count;i ++ ) {
//        NSString * volume = resultArray[i];
        _waveView.targetWaveHeight = 0.15;

//    }
    __weak typeof(self) weakSelf = self;
    _audioPlayer.playEnd = ^(BOOL playEnd) {
        if (playEnd) {
//            _waveView.targetWaveHeight = 0;
            [weakSelf.waveView stopAnimating];
        }
    };
    
}


#pragma mark speechRecordDelegate

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [_waveView stopAnimating];
    NSLog(@"in pcmPlayer audioPlayerDidFinishPlaying");
}
-(void)onPlayCompleted{
    
}

- (BOOL)copyMissingFile:(NSString *)sourcePath toPath:(NSString *)toPath
{
    BOOL retVal = YES; // If the file already exists, we'll return success…
    NSString * finalLocation = [toPath stringByAppendingPathComponent:[sourcePath lastPathComponent]];
    if (![[NSFileManager defaultManager] fileExistsAtPath:finalLocation])
    {
        retVal = [[NSFileManager defaultManager] copyItemAtPath:sourcePath toPath:finalLocation error:NULL];
    }
    return retVal;
}

- (void)createFolder:(NSString *)createDir
{
    BOOL isDir = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existed = [fileManager fileExistsAtPath:createDir isDirectory:&isDir];
    if ( !(isDir == YES && existed == YES) )
    {
        [fileManager createDirectoryAtPath:createDir withIntermediateDirectories:YES attributes:nil error:nil];
    }
}

#pragma mark - ===========Button 点击事件 =============

/**
 start speech recognition
 **/

- (void)XiaYiPaiButtonClick:(UIButton *)button{
    switch (button.tag) {
        case XiaYiPaiClickActionShanChu:
            [self createDismissSpeakViewAnimation];
            break;
            
        default:
            break;
    }
}
//处理所有View
- (void)chuLiSuoYouView{
    if (!self.speakView) {
        [self createSpeakView];
    }else{
        [self.speakView removeFromSuperview];
        [self createSpeakView];
    }
    [self.speakSubLayer removeFromSuperlayer];
    
    if (!self.webFatherView) {
        [self createWebView];
    }else{
        [self.webFatherView removeFromSuperview];
        [self createWebView];
    }
    [self.webViewSubLayer removeFromSuperlayer];
}




#pragma mark ===========WebView=============


// 页面开始加载时调用
-(void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    
}
// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    
}
// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{//这里修改导航栏的标题，动态改变
    self.title = webView.title;
}
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation{
    
}
// 接收到服务器跳转请求之后再执行
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation{
    
}
// 在收到响应后，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    
    NSLog(@"%@",webView);
    NSLog(@"%@",navigationResponse);
    
    WKNavigationResponsePolicy actionPolicy = WKNavigationResponsePolicyAllow;
    //这句是必须加上的，不然会异常
    decisionHandler(actionPolicy);
    
}
// 在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    
    self.title = webView.title;
    
    WKNavigationActionPolicy actionPolicy = WKNavigationActionPolicyAllow;
    
    
    if (navigationAction.navigationType==WKNavigationTypeBackForward) {//判断是返回类型
        
        //同时设置返回按钮和关闭按钮为导航栏左边的按钮 这里可以监听左滑返回事件，仿微信添加关闭按钮。
        //        self.navigationItem.leftBarButtonItems = @[self.backBtn, self.closeBtn];
        //可以在这里找到指定的历史页面做跳转
        //        if (webView.backForwardList.backList.count>0) {                                  //得到栈里面的list
        //            NSLog(@"%@",webView.backForwardList.backList);
        //            NSLog(@"%@",webView.backForwardList.currentItem);
        //            WKBackForwardListItem * item = webView.backForwardList.currentItem;          //得到现在加载的list
        //            for (WKBackForwardListItem * backItem in webView.backForwardList.backList) { //循环遍历，得到你想退出到
        //                //添加判断条件
        //                [webView goToBackForwardListItem:[webView.backForwardList.backList firstObject]];
        //            }
        //        }
    }
    //这句是必须加上的，不然会异常
    decisionHandler(actionPolicy);
}

//显示一个JS的Alert（与JS交互）
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    NSLog(@"弹窗alert");
    NSLog(@"%@",message);
    NSLog(@"%@",frame);
    //    [self.view makeToast:message];
    completionHandler();
}

//弹出一个输入框（与JS交互的）
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * __nullable result))completionHandler{
    NSLog(@"弹窗输入框");
    NSLog(@"%@",prompt);
    NSLog(@"%@",defaultText);
    NSLog(@"%@",frame);
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:prompt message:defaultText preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *a1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        //这里必须执行不然页面会加载不出来
        completionHandler(@"");
    }];
    UIAlertAction *a2 = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"%@",
              [alert.textFields firstObject].text);
        completionHandler([alert.textFields firstObject].text);
    }];
    [alert addAction:a1];
    [alert addAction:a2];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        NSLog(@"%@",textField.text);
    }];
    [self presentViewController:alert animated:YES completion:nil];
}

//显示一个确认框（JS的）
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler{
    NSLog(@"弹窗确认框");
    NSLog(@"%@",message);
    NSLog(@"%@",frame);
    
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:message message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}


//-(void)backNative{
//    //判断是否有上一层H5页面
//    if ([self.webView canGoBack]) {
//        //如果有则返回
//        [self.webView goBack];
//        //同时设置返回按钮和关闭按钮为导航栏左边的按钮
//        self.navigationItem.leftBarButtonItems = @[self.backBtn, self.closeBtn];
//    } else {
//        [self closeNative];
//    }
//}




@end

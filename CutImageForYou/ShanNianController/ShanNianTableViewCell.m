//
//  ShanNianTableViewCell.m
//  CutImageForYou
//
//  Created by chenxi on 2018/5/24.
//  Copyright © 2018年 chenxi. All rights reserved.
//

#import "ShanNianTableViewCell.h"

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

#define DEF_UICOLORFROMRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
@implementation ShanNianTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _label = [[UIView alloc]initWithFrame:CGRectMake(10, 5, ScreenWidth-20, 50)];
    _label.backgroundColor = [UIColor whiteColor];
    _label.layer.cornerRadius= 10;
    _label.layer.shadowColor=[UIColor grayColor].CGColor;
    _label.layer.shadowOffset=CGSizeMake(0, 4);
    _label.layer.shadowOpacity=0.4f;
    _label.layer.shadowRadius=12;
    _label.layer.borderColor = [UIColor whiteColor].CGColor;
    _label.layer.borderWidth = 2;
    [self.contentView addSubview:_label];
    _label.alpha = 0.8;
    self.textLabel.font = [UIFont fontWithName:@"Heiti SC" size:13.f];
    
    self.playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.playBtn.frame = CGRectMake(ScreenWidth - 40, self.contentView.frame.size.height - 35, 30, 30);
    [_label addSubview:self.playBtn];
    [self.playBtn setImage:[UIImage imageNamed:@"暂停"] forState:UIControlStateNormal];
    [self.playBtn setImage:[UIImage imageNamed:@"播放-暂停"] forState:UIControlStateSelected];
    [self.playBtn addTarget:self action:@selector(clickPlayBtn:) forControlEvents:UIControlEventTouchUpInside];
 
    [_label addSubview:self.waveView];
    
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    [_label addSubview:self.titleLabel];
    self.titleLabel.font = [UIFont systemFontOfSize:15];
    self.titleLabel.numberOfLines = 0;
}

- (void)setContentModel:(LZDataModel *)model{
    self.model = model;
    
    self.titleLabel.text = self.model.titleString;
    CGSize size = [self.model.titleString sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(ScreenWidth-30, 1000.0f) lineBreakMode:UILineBreakModeWordWrap];
    
    if (size.height > 50) {
        self.label.frame = CGRectMake(10, 5 , ScreenWidth - 20, size.height  + 20);
        self.titleLabel.frame = CGRectMake(5, 10 , ScreenWidth - 60, size.height);
    }else{
        self.label.frame = CGRectMake(10, 5 , ScreenWidth - 20, 50);
        self.titleLabel.frame = CGRectMake(5, 0 , ScreenWidth - 60, 50);
    }
    self.playBtn.frame = CGRectMake(ScreenWidth - 50,5, 30, 30);

}

- (WaveView *)waveView{
    if (!_waveView) {
        _waveView = [[WaveView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth  - kAUTOWIDTH(20), 50)];
        _waveView.backgroundColor = [UIColor whiteColor];
        _waveView.targetWaveHeight = 0;
        _waveView.backgroundColor = [UIColor clearColor];
        _waveView.hidden = YES;
    }
    return _waveView;
}

- (void)clickPlayBtn:(UIButton*)sender{
    sender.selected = YES;
    sender.enabled = NO;
    [self.playBtn setImage:[UIImage imageNamed:@"播放-暂停"] forState:UIControlStateNormal];

    // 先缩小
    sender.transform = CGAffineTransformMakeScale(0.8, 0.8);
    
    // 弹簧动画，参数分别为：时长，延时，弹性（越小弹性越大），初始速度
    [UIView animateWithDuration: 0.7 delay:0 usingSpringWithDamping:0.3 initialSpringVelocity:0.3 options:0 animations:^{
        // 放大
        sender.transform = CGAffineTransformMakeScale(1, 1);
    } completion:nil];
    
    
    
    NSData *pcmData =  [self decodeEchoImageBaseWith:self.model.pcmData];
    [self playPcmWith:pcmData];
    _waveView.hidden = NO;
    [_waveView Animating];
    _waveView.targetWaveHeight = 0.4;
    
    __weak typeof(self) weakSelf = self;
    _audioPlayer.playEnd = ^(BOOL playEnd) {
        sender.selected = NO;
        sender.enabled = YES;
        weakSelf.waveView.hidden = YES;
        [weakSelf.waveView stopAnimating];
        [self.playBtn setImage:[UIImage imageNamed:@"暂停"] forState:UIControlStateNormal];
    };
    
    if (_cellPlayBlock != nil) {
        _cellPlayBlock();
    }
}
- (void)playPcmWith:(NSData *)pcmData{
    
    NSError *error = nil;
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&error];
    _audioPlayer = [[PcmPlayer alloc] initWithData:pcmData sampleRate:[@"16000" integerValue]];
    [_audioPlayer play];
    
}

-(NSData *)decodeEchoImageBaseWith:(NSString *)str{
    //先解base64
    NSData * decompressData =[[NSData alloc] initWithBase64EncodedString:str options:NSDataBase64DecodingIgnoreUnknownCharacters];
    //在解GZIP压缩
    NSData * decompressResultData = [BCShanNianKaPianManager decompressData:decompressData];
    return  decompressResultData;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end


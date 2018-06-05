//
//  ShanNianVoiceSetViewController.m
//  CutImageForYou
//
//  Created by chenxi on 2018/6/5.
//  Copyright © 2018 chenxi. All rights reserved.
//

#import "ShanNianVoiceSetViewController.h"
#import "IATConfig.h"
#import "Definition.h"
#import "MainContentCell.h"

@interface ShanNianVoiceSetViewController ()
@property (nonatomic,strong) SAMultisectorSector *bosSec;
@property (nonatomic,strong) SAMultisectorSector *eosSec;
@property (nonatomic,strong) SAMultisectorSector *recSec;
@end

@implementation ShanNianVoiceSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setBaseView];
    [self setupMultisectorControl];
    [self needUpdateView];

}

- (void)setBaseView{
    self.backScrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:self.backScrollView];
    
    UILabel *chaoShiLabel = [[UILabel alloc]initWithFrame:CGRectMake(kAUTOWIDTH(20), kAUTOHEIGHT(64), ScreenWidth, 66)];
    chaoShiLabel.text = @"超时时间设置";
    chaoShiLabel.font = [UIFont fontWithName:@"Helvetica-BoldOblique" size:27];
    chaoShiLabel.textColor = [UIColor blackColor];
    [self.backScrollView addSubview:chaoShiLabel];
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(kAUTOWIDTH(20), CGRectGetMaxY(chaoShiLabel.frame) + kAUTOHEIGHT(10), ScreenWidth - kAUTOWIDTH(40), ScreenWidth - kAUTOWIDTH(40))];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.layer.cornerRadius= kAUTOHEIGHT(12);
    bgView.layer.shadowColor=[UIColor grayColor].CGColor;
    bgView.layer.shadowOffset=CGSizeMake(0, 4);
    bgView.layer.shadowOpacity=0.4f;
    bgView.layer.shadowRadius=12;
    [ self.backScrollView addSubview:bgView];
    
    self.roundSlider = [[SAMultisectorControl alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth - kAUTOWIDTH(40), ScreenWidth - kAUTOWIDTH(40))];
    
//    self.roundSlider.layer.cornerRadius= 10;
    self.roundSlider.layer.shadowColor=[UIColor grayColor].CGColor;
    self.roundSlider.layer.shadowOffset=CGSizeMake(0, 4);
    self.roundSlider.layer.shadowOpacity=0.4f;
    self.roundSlider.layer.shadowRadius=12;
    
    [bgView addSubview:self.roundSlider];
    
    self.recTimeoutLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.roundSlider.frame) + kAUTOHEIGHT(10), 100, 44)];
        self.bosLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.roundSlider.frame) + kAUTOHEIGHT(10), 100, 44)];
        self.eosLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.roundSlider.frame) + kAUTOHEIGHT(10), 100, 44)];
    [self.backScrollView addSubview:self.recTimeoutLabel];
    [self.backScrollView addSubview:self.bosLabel];
    [self.backScrollView addSubview:self.eosLabel];

    self.accentPicker = [[AKPickerView alloc]initWithFrame:CGRectMake(kAUTOWIDTH(20), CGRectGetMaxY(bgView.frame),50, kAUTOHEIGHT(44))];
    [self.backScrollView addSubview:self.accentPicker];
    _accentPicker.delegate = self;
    _accentPicker.dataSource = self;
    _accentPicker.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    _accentPicker.textColor = [UIColor whiteColor];
    _accentPicker.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17];
    _accentPicker.highlightedFont = [UIFont fontWithName:@"HelveticaNeue" size:17];
    _accentPicker.highlightedTextColor = [UIColor colorWithRed:0.0 green:168.0/255.0 blue:255.0/255.0 alpha:1.0];
    _accentPicker.interitemSpacing = 10.0;
    _accentPicker.fisheyeFactor = 0.001;
    _accentPicker.pickerViewStyle = AKPickerViewStyleFlat;
    _accentPicker.maskDisabled = false;
    
    
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(bgView.frame) + kAUTOHEIGHT(20), ScreenWidth, ScreenHeight) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.backScrollView addSubview:self.tableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"MainContentCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.sectionHeaderHeight = 5;
    self.tableView.sectionFooterHeight = 0;
    if (PNCisIPHONEX) {
        //        self.tableView.sectionHeaderHeight = 24;
        self.tableView.sectionFooterHeight = 0;
    }
}


-(void)viewDidLayoutSubviews
{
    CGSize size = [UIScreen mainScreen].bounds.size;
    _backScrollView.contentSize = CGSizeMake(size.width ,size.height+300);
}
- (void)setupMultisectorControl{
    
    [_roundSlider addTarget:self action:@selector(multisectorValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    
    UIColor *blueColor = [UIColor colorWithRed:0.0 green:168.0/255.0 blue:255.0/255.0 alpha:1.0];
    UIColor *redColor = [UIColor colorWithRed:245.0/255.0 green:76.0/255.0 blue:76.0/255.0 alpha:1.0];
    UIColor *greenColor = [UIColor colorWithRed:29.0/255.0 green:207.0/255.0 blue:0.0 alpha:1.0];
    
    _bosSec = [SAMultisectorSector sectorWithColor:redColor maxValue:10000];//timeout of Beginning Of Speech
    _eosSec = [SAMultisectorSector sectorWithColor:blueColor maxValue:10000];//timeout of End Of Speech
    _recSec = [SAMultisectorSector sectorWithColor:greenColor maxValue:60000];//timeout of Recording
    
    _bosSec.endValue = (double)[IATConfig sharedInstance].vadBos.integerValue;
    
    
    _eosSec.endValue = [IATConfig sharedInstance].vadEos.integerValue;
    _recSec.endValue = [IATConfig sharedInstance].speechTimeout.integerValue;
    
    [_roundSlider addSector:_bosSec];
    [_roundSlider addSector:_eosSec];
    [_roundSlider addSector:_recSec];
    
    _backScrollView.canCancelContentTouches = YES;
    _backScrollView.delaysContentTouches = NO;
    
}

#pragma mark - Event Handling

- (void)multisectorValueChanged:(id)sender{
    [self updateDataView];
}

- (void)updateDataView{
    
    IATConfig *config = [IATConfig sharedInstance];
    config.speechTimeout =  [NSString stringWithFormat:@"%ld", (long)_recSec.endValue];
    config.vadBos =  [NSString stringWithFormat:@"%ld", (long)_bosSec.endValue];
    config.vadEos =  [NSString stringWithFormat:@"%ld", (long)_eosSec.endValue];
    
    
    _bosLabel.text = config.vadBos;
    _eosLabel.text = config.vadEos;
    _recTimeoutLabel.text = config.speechTimeout;
    
    _recSec.endValue = [config.speechTimeout integerValue];
    _bosSec.endValue = [config.vadBos integerValue];
    _eosSec.endValue = [config.vadEos integerValue];
    
}

-(void)needUpdateView {
    
    IATConfig *instance = [IATConfig sharedInstance];
    
    _recTimeoutLabel.text = instance.speechTimeout;
    _eosLabel.text = instance.vadEos;
    _bosLabel.text = instance.vadBos;
    
    _recSec.endValue = instance.speechTimeout.integerValue;
    _bosSec.endValue = instance.vadBos.integerValue;
    _eosSec.endValue = instance.vadEos.integerValue;
    
    
    //update language and accent
    if ([instance.language isEqualToString:[IFlySpeechConstant LANGUAGE_CHINESE]]) {
        if ([instance.accent isEqualToString:[IFlySpeechConstant ACCENT_CANTONESE]]) {
            [_accentPicker selectItem:0 animated:NO];
            
        }else if ([instance.accent isEqualToString:[IFlySpeechConstant ACCENT_MANDARIN]]) {
            [_accentPicker selectItem:1 animated:NO];
            
        }else if ([instance.accent isEqualToString:[IFlySpeechConstant ACCENT_SICHUANESE]]) {
            [_accentPicker selectItem:3 animated:NO];
            
        }
    }else if ([instance.language isEqualToString:[IFlySpeechConstant LANGUAGE_ENGLISH]]) {
        [_accentPicker selectItem:2 animated:NO];
    }
    
    //update punctuation setting
    if ([instance.dot isEqualToString:[IFlySpeechConstant ASR_PTT_HAVEDOT]]) {
        _dotSeg.selectedSegmentIndex = 0;
        
    }else if ([instance.dot isEqualToString:[IFlySpeechConstant ASR_PTT_NODOT]]) {
        _dotSeg.selectedSegmentIndex = 1;
        
    }
    
    if([IATConfig sharedInstance].isTranslate){
        _transSeg.selectedSegmentIndex = 0;
    }
    else{
        _transSeg.selectedSegmentIndex = 1;
    }
    
    if (instance.haveView == NO) {
        _viewSeg.selectedSegmentIndex = 0;
        
    }else if (instance.haveView == 1) {
        _viewSeg.selectedSegmentIndex = 1;
        
    }
    
}


#pragma mark - AKPickerViewDataSource Delegate

- (NSUInteger)numberOfItemsInPickerView:(AKPickerView *)pickerView
{
    IATConfig* instance = [IATConfig sharedInstance];
    return instance.accentNickName.count;
}
- (NSString *)pickerView:(AKPickerView *)pickerView titleForItem:(NSInteger)item;
{
    IATConfig* instance = [IATConfig sharedInstance];
    return  [instance.accentNickName objectAtIndex:item];
}


- (void)pickerView:(AKPickerView *)pickerView didSelectItem:(NSInteger)item
{
    IATConfig *instance = [IATConfig sharedInstance];
    
    if (item == 0) { //Cantonese
        instance.language = [IFlySpeechConstant LANGUAGE_CHINESE];
        instance.accent = [IFlySpeechConstant ACCENT_CANTONESE];
    }else if (item == 1) {//Mandarin
        instance.language = [IFlySpeechConstant LANGUAGE_CHINESE];
        instance.accent = [IFlySpeechConstant ACCENT_MANDARIN];
    }else if (item == 3) {//Szechuan
        instance.language = [IFlySpeechConstant LANGUAGE_CHINESE];
        instance.accent = [IFlySpeechConstant ACCENT_SICHUANESE];
    }else if (item == 2) {//English
        instance.language = [IFlySpeechConstant LANGUAGE_ENGLISH];
        instance.accent = @"";
    }
    
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (PNCisIPHONEX) {
        return 65;
    }
    return 55;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    IATConfig* instance = [IATConfig sharedInstance];
    return instance.accentNickName.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 62;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MainContentCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
   
    IATConfig* instance = [IATConfig sharedInstance];
    cell.textLabel.text = [instance.accentNickName objectAtIndex:indexPath.row];
    
    return  cell;
}






@end

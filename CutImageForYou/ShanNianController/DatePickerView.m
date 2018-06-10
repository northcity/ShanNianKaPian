//
//  DatePickerView.m
//  库存管理
//
//  Created by liuyang on 2017/7/12.
//  Copyright © 2017年 同牛科技. All rights reserved.
//

#import "DatePickerView.h"
@interface DatePickerView ()
@property (nonatomic, strong) NSString *selectDate;

@end

@implementation DatePickerView

+(id)datePickerView
{
    return [[self alloc] initWithFrame:CGRectZero];
}

-(id)initWithFrame:(CGRect)frame
{
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        UIView * toolView = [[UIView alloc]init];
        [self addSubview:toolView];
        toolView.frame = CGRectMake(0, 0, ScreenWidth, 42);
        
        _sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _sureBtn.frame = CGRectMake(ScreenWidth-18-48, 10, 50, 22);
        [toolView addSubview:_sureBtn];
//        [_sureBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_sureBtn setTitleColor:PNCColorWithHex(0x90959E) forState:UIControlStateNormal];
        [_sureBtn setTitle:NSLocalizedString(@"确定", nil) forState:UIControlStateNormal];
        _sureBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        
        _cannelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _cannelBtn.frame = CGRectMake(18, 10, 50, 22);
        [toolView addSubview:_cannelBtn];
        
        [_cannelBtn addTarget:self action:@selector(cannelBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_cannelBtn setTitleColor:PNCColorWithHex(0x90959E) forState:UIControlStateNormal];
        [_cannelBtn setTitle:NSLocalizedString(@"取消", nil) forState:UIControlStateNormal];
        _cannelBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        
        UILabel * titleLab = [[UILabel alloc]init];
        [toolView addSubview:titleLab];
        titleLab.frame = CGRectMake((ScreenWidth-220)/2, 12, 220, 17);
        titleLab.text = NSLocalizedString(@"请选择送达日期", nil) ;
        titleLab.font = [UIFont systemFontOfSize:13];
        titleLab.textColor = PNCColorWithHex(0x061631);
        titleLab.textAlignment = NSTextAlignmentCenter;
        UIView * lineView = [[UIView alloc]init];
        [self addSubview:lineView];
        lineView.frame = CGRectMake(0, 42, ScreenWidth, 0.5);
        lineView.backgroundColor = PNCColorWithHex(0xBDBDBD);
        
        
        _datePickerView = [[UIDatePicker alloc]init];
         [_datePickerView setDatePickerMode:UIDatePickerModeDate];
        _datePickerView.locale = [[NSLocale alloc]
                             initWithLocaleIdentifier:@"zh_CN"];
        _datePickerView.frame = CGRectMake(0, 52, ScreenWidth, 195);
        [self addSubview:_datePickerView];
        
        
    }
    return self;
}


- (void)awakeFromNib
{
    [super awakeFromNib];
    
}

- (NSString *)timeFormat
{
    NSDate *selected = [self.datePickerView date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy/MM/dd"];
    NSString *currentOlderOneDateStr = [dateFormatter stringFromDate:selected];
    return currentOlderOneDateStr;
}


-(void)cannelBtnClick{
   
}

//-(void)sureBtnClick
//{
//    self.selectDate = [self timeFormat];
//    //delegate
//    [self.delegate getSelectDate:self.selectDate type:self.type];
//}

@end

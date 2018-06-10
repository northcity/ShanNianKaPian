//
//  MainTextViewController.m
//  shijianjiaonang
//
//  Created by chenxi on 2018/3/12.
//  Copyright © 2018年 chenxi. All rights reserved.
//

#import "MainTextViewController.h"

#import "DatePickerView.h"

#import "JXPopoverView.h"

#import <AudioToolbox/AudioToolbox.h>

#import "MSNumberScrollAnimatedView.h"

#import "ZJViewShow.h"

#import <StoreKit/StoreKit.h>


#define IMAGE_PER_HEIGIT   PNCisIPAD ? 220/3 : (ScreenHeight - kAUTOHEIGHT(94))/3
#define FRAME_WIDTH     PNCisIPAD ? 297 : ScreenWidth - kAUTOWIDTH(40)


@interface MainTextViewController ()<UITextViewDelegate,DatePickerViewDelegate,UIGestureRecognizerDelegate>{
    UIView * _backWindowView;
    SystemSoundID soundFileObject;
}

@property(nonatomic,strong)UIColor *textColor;


@property(nonatomic,strong) UIView *lineViewX1;
@property(nonatomic,strong) UIView *lineViewX2;
@property(nonatomic,strong) UIView *lineViewY1;
@property(nonatomic,strong) UIView *lineViewY2;
@property(nonatomic,strong)NSDictionary *attributes;
@property(nonatomic,strong)NSMutableParagraphStyle *paragraphStyle;

@property(nonatomic ,strong) UIView *mainView;
@property(nonatomic,strong)CALayer *subLayer;
@property(nonatomic,strong)UIImageView * imageback;
@property(nonatomic,strong)UITextView *contentTextView;

@property (nonatomic, assign) CGRect keyboardHeight;


@property (nonatomic, strong) UIImageView *one;
@property (nonatomic, strong) UIImageView *three;
@property (nonatomic, strong) UIImageView *four;

@property (nonatomic, strong) UIView *zongMainView;


@property (nonatomic, strong) UIView *threeShadowView;


@property(nonatomic,strong)UIView *bgView;
@property(nonatomic,strong)UIImageView *shadowImageView;
@property(nonatomic,strong)UIImageView *backImageView;
@property(nonatomic,strong)UIImageView *coverImageView;
@property(nonatomic,strong)UIImageView *topImageView;
@property(nonatomic,strong)UIImageView *topShadowImageView;
@property(nonatomic,strong)UIView *letterView;

@property(nonatomic,strong)UIView *blackView;

@property(nonatomic,strong)UIButton *progressBtn;


@property(nonatomic,strong)DatePickerView * pikerView;
@property(nonatomic,copy)NSString * selectValue;
@property(nonatomic,copy)NSString *isOrNoToShow;
@property(nonatomic,strong)UISwitch *kaiGuanButon;

@property(nonatomic,strong)UIView *popBgView;
@property(nonatomic,strong)UILabel *popLabel;
@property(nonatomic,strong)UIImageView *popImageView;
@property(nonatomic,strong)UITextField *popTextField;
@property(nonatomic,strong)UIVisualEffectView *effectView;
@property(nonatomic,strong)UIBlurEffect *effect;
@property(nonatomic,strong) UIButton *popNextButton;
@property(nonatomic,strong) UIButton *popCancleButton;

@property(nonatomic,strong) UIImageView *pin;

@end

@implementation MainTextViewController

-(void)textFieldBecomeSecoend{
    [_popTextField resignFirstResponder];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent: (nullable UIEvent *)event{
    [self textFieldBecomeSecoend];
}
- (void)viewDidLoad {
    [super viewDidLoad];
//    [self showAppStoreReView];
    UILabel *titleLabel = [Factory createLabelWithTitle:@"" frame:CGRectMake(30, 20, ScreenWidth - 60, 44)];
    titleLabel.text = NSLocalizedString(@"时间胶囊", nil);
    [self.view addSubview:titleLabel];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont fontWithName:@"Wyue-GutiFangsong-NC" size:24];
    titleLabel.textColor = [UIColor blackColor];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createMainView];
    [self createToolButton];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(textFieldBecomeSecoend)];
    tapGesture.delegate = self;
    [self.bgView addGestureRecognizer:tapGesture];
    self.bgView.userInteractionEnabled = YES;
    
    UIButton * backBtn = [Factory createButtonWithTitle:@"" frame:CGRectMake(20, 30, 28, 28) backgroundColor:[UIColor clearColor] backgroundImage:[UIImage imageNamed:@""] target:self action:@selector(backAction)];
    
    if (PNCisIPHONEX) {
        backBtn.frame = CGRectMake(self.view.frame.size.width - 50, 50, 28, 28);
    }
    
    [backBtn setImage:[UIImage imageNamed:@"返回 (3).png"] forState:UIControlStateNormal];
    [self.view addSubview:backBtn];
    
    UILabel * label = [Factory createLabelWithTitle:@"设置" frame:CGRectMake(80, 20, 60, 40) fontSize:16.f];
    label.font = [UIFont fontWithName:@"Heiti SC" size:20.f];
    
    
    if (PNCisIPHONEX) {
        titleLabel.frame = CGRectMake(30, 40, ScreenWidth - 60, 44);
        backBtn.frame = CGRectMake(20, 50, 28, 28);
        label.frame = CGRectMake(80, 40, 60, 40);
    }
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor blackColor];
//    [self.view addSubview:label];
    
    UIView *label111 = [[UIView alloc]initWithFrame:CGRectMake((ScreenWidth-80)/2, ScreenHeight-150, 80, 80)];
    label111.backgroundColor = [UIColor whiteColor];
    label111.layer.cornerRadius=12;
    label111.layer.shadowColor=[UIColor grayColor].CGColor;
    label111.layer.shadowOffset=CGSizeMake(0.5, 0.5);
    label111.layer.shadowOpacity=0.8;
    label111.layer.shadowRadius=1.2;
    
    [self createToolButton];
    [self initOtherUI];
    self.navigationController.toolbarHidden = YES;
}


- (void)initOtherUI{
    
    _titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, PCTopBarHeight)];
    _titleView.backgroundColor = [UIColor whiteColor];
    _titleView.layer.shadowColor=[UIColor grayColor].CGColor;
    _titleView.layer.shadowOffset=CGSizeMake(0, 2);
    _titleView.layer.shadowOpacity=0.1f;
    _titleView.layer.shadowRadius=12;
    [self.view addSubview:_titleView];
    [self.view insertSubview:_titleView atIndex:99];
    
    _navTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth/2 - kAUTOWIDTH(150)/2, kAUTOHEIGHT(5), kAUTOWIDTH(150), kAUTOHEIGHT(66))];
    _navTitleLabel.text = @"卡片";
    _navTitleLabel.font = [UIFont fontWithName:@"HeiTi SC" size:18];
    _navTitleLabel.textColor = [UIColor blackColor];
    _navTitleLabel.textAlignment = NSTextAlignmentCenter;
    [_titleView addSubview:_navTitleLabel];
    
    
    _backBtn = [Factory createButtonWithTitle:@"" frame:CGRectMake(20, 28, 25, 25) backgroundColor:[UIColor clearColor] backgroundImage:[UIImage imageNamed:@""] target:self action:@selector(backAction)];
    [_backBtn setImage:[UIImage imageNamed:@"关闭2"] forState:UIControlStateNormal];
    if (PNCisIPHONEX) {
        _backBtn.frame = CGRectMake(20, 48, 25, 25);
    }
    [_titleView addSubview:_backBtn];
    
    _doneBtn = [Factory createButtonWithTitle:@"" frame:CGRectMake(ScreenWidth - 45, 28, 25, 25) backgroundColor:[UIColor clearColor] backgroundImage:[UIImage imageNamed:@""] target:self action:@selector(saveToDb)];
    [_doneBtn setImage:[UIImage imageNamed:@"dkw_完成"] forState:UIControlStateNormal];
    if (PNCisIPHONEX) {
        _doneBtn.frame = CGRectMake(ScreenWidth - 45, 48, 25, 25);
    }
    [_titleView addSubview:_doneBtn];
    
    _backBtn.transform = CGAffineTransformMakeRotation(M_PI_4);
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CABasicAnimation* rotationAnimation;
        
        rotationAnimation =[CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        //        rotationAnimation.fromValue =[NSNumber numberWithFloat: 0M_PI_4];
        
        rotationAnimation.toValue =[NSNumber numberWithFloat: 0];
        rotationAnimation.duration =0.4;
        rotationAnimation.repeatCount =1;
        rotationAnimation.removedOnCompletion = NO;
        rotationAnimation.fillMode = kCAFillModeForwards;
        [_backBtn.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
        
    });
}

- (void)saveToDb{
    LZDataModel *model = [[LZDataModel alloc]init];
    model = self.model;
    model.titleString = self.contentTextView.text;
    NSLog(@"%@",model);

    [LZSqliteTool LZUpdateTable:LZSqliteDataTableName model:model];
    [SVProgressHUD showInfoWithStatus:@"更新成功"];
    
    NSArray* array = [LZSqliteTool LZSelectAllElementsFromTable:LZSqliteDataTableName];
    NSLog(@"array");
}



- (void)backAction{
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}


- (void)createToolButton{
    self.progressBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.progressBtn.frame = CGRectMake(self.view.frame.size.width - 50, 30, 28, 28);
    
    if (PNCisIPHONEX) {
        self.progressBtn.frame = CGRectMake(self.view.frame.size.width - 50, 50, 28, 28);
    }
//    [self.progressBtn setTitle:@"完成" forState:UIControlStateNormal];
//    [self.progressBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.progressBtn setImage:[UIImage imageNamed:@"完成 (1).png"] forState:UIControlStateNormal];
    [self.progressBtn setImage:[UIImage imageNamed:@"完成 (1).png"] forState:UIControlStateSelected];
    [self.progressBtn addTarget:self action:@selector(datePickShow) forControlEvents:UIControlEventTouchUpInside];
    [self.progressBtn setImage:[UIImage imageNamed: @"完成 (1).png"] forState:UIControlStateDisabled];
    [self.view addSubview:self.progressBtn];
    
    UIButton *zhuTIButton = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth - 100, 27.5, 32, 32)];
    [self.view addSubview:zhuTIButton];
    [zhuTIButton setImage:[UIImage imageNamed:@"旅游主题_导视牌.png"] forState:UIControlStateNormal];
    if (PNCisIPHONEX) {
        zhuTIButton.frame = CGRectMake(self.view.frame.size.width - 100, 47.5, 32, 32);
    }
    [zhuTIButton addTarget:self action:@selector(qieHuanZhuTi:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)qieHuanZhuTi:(UIButton *)sender{
    JXPopoverView *popoverView = [JXPopoverView popoverView];
    JXPopoverAction *action1 = [JXPopoverAction actionWithTitle:NSLocalizedString(@"杏仁黄", nil) handler:^(JXPopoverAction *action) {
   
        
        [[NSUserDefaults standardUserDefaults] setObject:@"xingrenhuang" forKey:@"beijingyanse"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        self.mainView.backgroundColor = PNCColorWithHex(0xFAF9DE);
        self.contentTextView.textColor = [UIColor blackColor];
        self.contentTextView.tintColor = [UIColor blackColor];
        _lineViewX1.layer.borderColor = [UIColor blackColor].CGColor;
        _lineViewX2.layer.borderColor = [UIColor blackColor].CGColor;
        _lineViewY1.layer.borderColor = [UIColor blackColor].CGColor;
        _lineViewY2.layer.borderColor = [UIColor blackColor].CGColor;
        [self.view layoutIfNeeded];

    }];
    
    JXPopoverAction *action2 = [JXPopoverAction actionWithTitle:NSLocalizedString(@"秋叶褐", nil) handler:^(JXPopoverAction *action) {
        [[NSUserDefaults standardUserDefaults] setObject:@"qiuyehe" forKey:@"beijingyanse"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        self.mainView.backgroundColor = PNCColorWithHex(0xFFF2E2);
        self.contentTextView.textColor = [UIColor blackColor];
        self.contentTextView.tintColor = [UIColor blackColor];
        _lineViewX1.layer.borderColor = [UIColor blackColor].CGColor;
        _lineViewX2.layer.borderColor = [UIColor blackColor].CGColor;
        _lineViewY1.layer.borderColor = [UIColor blackColor].CGColor;
        _lineViewY2.layer.borderColor = [UIColor blackColor].CGColor;
        [self.view layoutIfNeeded];

    }];
    
    JXPopoverAction *action3 = [JXPopoverAction actionWithTitle:NSLocalizedString(@"胭脂红", nil) handler:^(JXPopoverAction *action) {
        [[NSUserDefaults standardUserDefaults] setObject:@"yanzhihong" forKey:@"beijingyanse"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        self.mainView.backgroundColor = PNCColorWithHex(0xFDE6E0);
        self.contentTextView.textColor = [UIColor blackColor];
        self.contentTextView.tintColor = [UIColor blackColor];
        _lineViewX1.layer.borderColor = [UIColor blackColor].CGColor;
        _lineViewX2.layer.borderColor = [UIColor blackColor].CGColor;
        _lineViewY1.layer.borderColor = [UIColor blackColor].CGColor;
        _lineViewY2.layer.borderColor = [UIColor blackColor].CGColor;
        [self.view layoutIfNeeded];

    }];
    
    JXPopoverAction *action4 = [JXPopoverAction actionWithTitle:NSLocalizedString(@"海天蓝", nil) handler:^(JXPopoverAction *action) {
        [[NSUserDefaults standardUserDefaults] setObject:@"haitianlan" forKey:@"beijingyanse"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        self.mainView.backgroundColor = PNCColorWithHex(0xDCE2F1);
        self.contentTextView.textColor = [UIColor blackColor];
        self.contentTextView.tintColor = [UIColor blackColor];
        _lineViewX1.layer.borderColor = [UIColor blackColor].CGColor;
        _lineViewX2.layer.borderColor = [UIColor blackColor].CGColor;
        _lineViewY1.layer.borderColor = [UIColor blackColor].CGColor;
        _lineViewY2.layer.borderColor = [UIColor blackColor].CGColor;
        [self.view layoutIfNeeded];

    }];
    
    JXPopoverAction *action5 = [JXPopoverAction actionWithTitle:NSLocalizedString(@"极光灰", nil) handler:^(JXPopoverAction *action) {
        [[NSUserDefaults standardUserDefaults] setObject:@"jiguanghui" forKey:@"beijingyanse"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        self.mainView.backgroundColor = PNCColorWithHex(0xEAEAEF);
        self.contentTextView.textColor = [UIColor blackColor];
        self.contentTextView.tintColor = [UIColor blackColor];
        _lineViewX1.layer.borderColor = [UIColor blackColor].CGColor;
        _lineViewX2.layer.borderColor = [UIColor blackColor].CGColor;
        _lineViewY1.layer.borderColor = [UIColor blackColor].CGColor;
        _lineViewY2.layer.borderColor = [UIColor blackColor].CGColor;
        [self.view layoutIfNeeded];
    }];
    
    JXPopoverAction *action6 = [JXPopoverAction actionWithTitle:NSLocalizedString(@"曜石黑", nil) handler:^(JXPopoverAction *action) {
        [[NSUserDefaults standardUserDefaults] setObject:@"yaoshihei" forKey:@"beijingyanse"];
        [[NSUserDefaults standardUserDefaults] synchronize];
     
        [UIView animateWithDuration:1 animations:^{
            self.mainView.backgroundColor = PNCColorWithHex(0x000000);
            self.contentTextView.textColor = [UIColor whiteColor];
            self.contentTextView.tintColor = [UIColor whiteColor];
            _lineViewX1.layer.borderColor = [UIColor whiteColor].CGColor;
            _lineViewX2.layer.borderColor = [UIColor whiteColor].CGColor;
            _lineViewY1.layer.borderColor = [UIColor whiteColor].CGColor;
            _lineViewY2.layer.borderColor = [UIColor whiteColor].CGColor;
            
            [self.view layoutIfNeeded];
        }];
        
     

    }];
    
    [popoverView showToView:sender withActions:@[action1,action2,action3,action4,action5,action6]];

}

#pragma mark =================弹出视图=============
- (void)createPopView{
    
    
    
    
    self.effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    self.effectView = [[UIVisualEffectView alloc] initWithEffect:self.effect];
    self.effectView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    self.effectView.alpha = 1;
    self.effectView.userInteractionEnabled = YES;
    self.popBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    self.popBgView.alpha = 0;
    [self.view addSubview:self.popBgView];
    [self.popBgView addSubview:self.effectView];
    
    
    
    [UIView animateWithDuration:0.7
                          delay:0
         usingSpringWithDamping:1.0
          initialSpringVelocity:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         
                         self.popBgView.alpha = 1;
                     } completion:^(BOOL finished) {

                     }];
    
    
    
    
    UIView *kuangView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kAUTOWIDTH(300), kAUTOHEIGHT(200))];
    kuangView.backgroundColor = [UIColor whiteColor];
    kuangView.center = self.view.center;
//    [self.popBgView addSubview:kuangView];
    
    UILabel *shanQingLaben = [[UILabel alloc]initWithFrame:CGRectMake(kAUTOWIDTH(20), ScreenHeight/2 + kAUTOHEIGHT(20), ScreenWidth - 80,300)];
    shanQingLaben.text = NSLocalizedString(@"时间不问归处\n这封寄往未来的信\n不可查找\n不可撤回\n就此消失\n直到那一天\n枝繁叶茂\n等待收获。", nil) ;
    shanQingLaben.textColor = [UIColor whiteColor];
    shanQingLaben.textAlignment  = NSTextAlignmentLeft;
    shanQingLaben.numberOfLines = 0;
    [self.popBgView addSubview:shanQingLaben];
    shanQingLaben.font = [UIFont fontWithName:@"Wyue-GutiFangsong-NC" size:17];
    
    UILabel *shuPaiLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, kAUTOHEIGHT(60), 120,44)];
    shuPaiLabel.text = NSLocalizedString(@"寄给：", nil) ;
    shuPaiLabel.textColor = [UIColor whiteColor];
    shuPaiLabel.textAlignment  = NSTextAlignmentCenter;
    shuPaiLabel.numberOfLines = [shuPaiLabel.text length];
    [self.popBgView addSubview:shuPaiLabel];
    shuPaiLabel.font = [UIFont fontWithName:@"Wyue-GutiFangsong-NC" size:25];
    
    self.popTextField = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMinX(shuPaiLabel.frame) + kAUTOWIDTH(30), CGRectGetMaxY(shuPaiLabel.frame) + 20, ScreenWidth - 60, 44)];
    self.popTextField.tintColor = [UIColor whiteColor];
    self.popTextField.textColor = [UIColor whiteColor];
    self.popTextField.placeholder = NSLocalizedString(@"请输入邮箱......", nil);
    self.popTextField.font  =[ UIFont boldSystemFontOfSize:20];
    self.popTextField.textAlignment = NSTextAlignmentCenter;
    [self.popTextField becomeFirstResponder];
    //    self.popTextField.backgroundColor = [UIColor redColor];
    [self.popBgView addSubview:self.popTextField];
    [self.popTextField setValue:[UIColor whiteColor]
              forKeyPath:@"_placeholderLabel.textColor"];
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(self.popTextField.frame), ScreenWidth - 40, 0.5f)];
    lineView.backgroundColor = [UIColor whiteColor];
    [self.popBgView addSubview:lineView];
    
    
    UILabel *jiWangLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(lineView.frame) + kAUTOHEIGHT(20), 120,44)];
    jiWangLabel.text = NSLocalizedString(@"寄往：", nil) ;
    jiWangLabel.textColor = [UIColor whiteColor];
    jiWangLabel.textAlignment  = NSTextAlignmentCenter;
//    jiWangLabel.numberOfLines = [jiWangLabel.text length];
    [self.popBgView addSubview:jiWangLabel];
    jiWangLabel.font = [UIFont fontWithName:@"Wyue-GutiFangsong-NC" size:25];
    
    
//    UILabel *shiJianLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, CGRectGetMaxY(jiWangLabel.frame) + kAUTOHEIGHT(20), ScreenWidth - 120,44)];
//    shiJianLabel.text =_selectValue;
//    shiJianLabel.textColor = [UIColor whiteColor];
//    shiJianLabel.textAlignment  = NSTextAlignmentCenter;
////    shiJianLabel.numberOfLines = [shuPaiLabel.text length];
//    [self.popBgView addSubview:shiJianLabel];
//    shiJianLabel.font = [UIFont fontWithName:@"Avenri-Next" size:25];
//    shiJianLabel.font = [UIFont boldSystemFontOfSize:25];
    
    
    
    
    
    
    
    
    
    
    
    MSNumberScrollAnimatedView *nianView = [[MSNumberScrollAnimatedView alloc]initWithFrame:CGRectMake(kAUTOWIDTH(30), CGRectGetMaxY(jiWangLabel.frame) + kAUTOHEIGHT(20), kAUTOWIDTH(100), 44)];
    [self.popBgView addSubview:nianView];
    nianView.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:36];
    nianView.textColor = [UIColor whiteColor];
    nianView.minLength = 3;
    nianView.density = 200;
    nianView.number = [NSNumber numberWithInteger:[[self.selectValue substringWithRange:NSMakeRange(0, 4)] integerValue]];
    [nianView startAnimation];
    
    

    UILabel *nianLabel = [Factory createLabelWithTitle:@"" frame:CGRectMake(CGRectGetMaxX(nianView.frame), CGRectGetMaxY(jiWangLabel.frame) +kAUTOHEIGHT(20), kAUTOWIDTH(40), 40)];
    nianLabel.font =  [UIFont fontWithName:@"Wyue-GutiFangsong-NC" size:36];
    nianLabel.textColor = [UIColor whiteColor];
    nianLabel.text = @"年";
    [self.popBgView addSubview:nianLabel];
    
    MSNumberScrollAnimatedView *yueView = [[MSNumberScrollAnimatedView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(nianLabel.frame), CGRectGetMaxY(jiWangLabel.frame) + kAUTOHEIGHT(20), kAUTOWIDTH(44), 44)];
    [self.popBgView addSubview:yueView];
    yueView.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:36];
    yueView.textColor = [UIColor whiteColor];
    yueView.minLength = 2;
    yueView.density = 200;
    yueView.number = [NSNumber numberWithInteger:[[self.selectValue substringWithRange:NSMakeRange(5, 2)] integerValue]];
    [yueView startAnimation];
    
    
    UILabel *yueLabel = [Factory createLabelWithTitle:@"" frame:CGRectMake(CGRectGetMaxX(yueView.frame), CGRectGetMaxY(jiWangLabel.frame) +kAUTOHEIGHT(20), kAUTOWIDTH(44), 40)];
    yueLabel.font =  [UIFont fontWithName:@"Wyue-GutiFangsong-NC" size:36];
    yueLabel.textColor = [UIColor whiteColor];
    yueLabel.text = @"月";
    [self.popBgView addSubview:yueLabel];
    
    MSNumberScrollAnimatedView *riView = [[MSNumberScrollAnimatedView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(yueLabel.frame), CGRectGetMaxY(jiWangLabel.frame) + kAUTOHEIGHT(20), kAUTOWIDTH(44), 44)];
    [self.popBgView addSubview:riView];
    riView.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:36];
    riView.textColor = [UIColor whiteColor];
    riView.minLength = 2;
    riView.density = 200;
    riView.number = [NSNumber numberWithInteger:[[self.selectValue substringWithRange:NSMakeRange(8, 2)] integerValue]];
    [riView startAnimation];
    
    
    UILabel *riLabel = [Factory createLabelWithTitle:@"" frame:CGRectMake(CGRectGetMaxX(riView.frame), CGRectGetMaxY(jiWangLabel.frame) +kAUTOHEIGHT(20), kAUTOWIDTH(44), 40)];
    riLabel.font =  [UIFont fontWithName:@"Wyue-GutiFangsong-NC" size:36];
    riLabel.textColor = [UIColor whiteColor];
    riLabel.text = @"日";
    [self.popBgView addSubview:riLabel];
    
    
    


    
    self.popLabel = [Factory createLabelWithTitle:NSLocalizedString(@"允许放入公开邮箱\n勾选后，将在某一天，某一刻出现在某一人的公开信箱中", nil)  frame:CGRectMake(20, CGRectGetMaxY(nianView.frame) +kAUTOHEIGHT(20) , ScreenWidth - 100,kAUTOHEIGHT(90))];
    [self.popBgView addSubview:self.popLabel];
    self.popLabel.numberOfLines = 0;
    self.popLabel.textColor = [UIColor whiteColor];
    self.popLabel.font =  [UIFont fontWithName:@"Heiti SC" size:10.f];
    self.popLabel.textAlignment = NSTextAlignmentLeft;
    
    self.popImageView = [[UIImageView alloc]initWithFrame:CGRectMake(30, CGRectGetMaxY(self.popLabel.frame) + 44, 30, 30)];
//    [self.popBgView addSubview:self.popImageView];
    self.popImageView.image = [UIImage imageNamed:@"加号.png"];
    

    
    self.popNextButton = [Factory createButtonWithTitle:NSLocalizedString(@"确定发送", nil)  frame:CGRectMake(ScreenWidth - kAUTOWIDTH(120), CGRectGetMaxY(shanQingLaben.frame) - kAUTOWIDTH(65), 90, 44) target:self action:@selector(popNextBtnClicked)];
    self.popNextButton.backgroundColor = [UIColor whiteColor];
    self.popNextButton.titleLabel.font = [UIFont fontWithName:@"Wyue-GutiFangsong-NC" size:20];
    self.popNextButton.layer.cornerRadius = 6.f;
    self.popNextButton.layer.masksToBounds = YES;
    [self.popNextButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.popCancleButton = [Factory createButtonWithTitle:@"" frame:CGRectMake(ScreenWidth - kAUTOWIDTH(50), 35, 30, 30) target:self
                                                   action:@selector(popCancleClicked)];
    
    if (PNCisIPHONEX) {
        self.popCancleButton.frame = CGRectMake(ScreenWidth - kAUTOWIDTH(50), 55, 30, 30);
    }
    [self.popCancleButton setImage:[UIImage imageNamed:@"取消111"] forState:UIControlStateNormal];
    
    self.popCancleButton.backgroundColor = [UIColor clearColor];
    if (PNCisIPHONEX) {
        self.popNextButton.frame = CGRectMake(ScreenWidth - kAUTOWIDTH(120), CGRectGetMaxY(shanQingLaben.frame) - kAUTOWIDTH(65), 90, 44);
    }
    [self.popBgView addSubview:self.popNextButton];
    [self.popBgView addSubview:self.popCancleButton];

    
    _kaiGuanButon = [[UISwitch alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.popLabel.frame), CGRectGetMinY(self.popLabel.frame) + kAUTOHEIGHT(30), 40, 40)];
    _kaiGuanButon.transform = CGAffineTransformMakeScale(0.6,0.6);
    [self.popBgView addSubview:_kaiGuanButon];
  
    if (_kaiGuanButon.on) {
        _kaiGuanButon.thumbTintColor = [UIColor blackColor];
        _kaiGuanButon.tintColor = [UIColor whiteColor];
    }else{
        _kaiGuanButon.tintColor = [UIColor whiteColor];
        _kaiGuanButon.onTintColor = [UIColor blackColor];
        _kaiGuanButon.thumbTintColor = [UIColor whiteColor];
    }
    _kaiGuanButon.on = YES;
    
    UIView *lineSwitchView  = [[UIView alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(self.popLabel.frame), ScreenWidth - 40, 0.5f)];
    lineSwitchView.backgroundColor = [UIColor whiteColor];
    [self.popBgView addSubview:lineSwitchView];
   
}


#pragma mark ======发送=======


- (void)popNextBtnClicked{
    
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    BOOL  isTrue =  [emailTest evaluateWithObject:_popTextField.text];
    
    if (isTrue) {
        [self.popBgView removeFromSuperview];
        self.popBgView = nil;
        [self GuanBiClick:nil];
    }else{
        ZJViewShow * showbeginView = [[ZJViewShow alloc]initWithFrame:self.view.frame WithTitleString:@"邮箱输入有误" WithIamgeName:@"c13"];
        [self.view addSubview:showbeginView];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [showbeginView removeFromSuperview];
        });
    }
    

}
- (void)popCancleClicked{
    
    [self.popBgView removeFromSuperview];
    self.popBgView = nil;
}

- (void)TiShiTongZhi{
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    _bgViews = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _bgViews.alpha = 0.6;
    _bgViews.backgroundColor = [UIColor blackColor];
    [window addSubview:_bgViews];
    
    
    
    _MbgView = [[UIView alloc]initWithFrame:CGRectMake((ScreenWidth -kAUTOWIDTH(260))/2, ScreenHeight / 2 - kAUTOHEIGHT(100), kAUTOWIDTH(260), kAUTOHEIGHT(180))];
    [window addSubview:_MbgView];
    
    
    _bgImageView = [[UIImageView alloc] initWithFrame:_MbgView.frame];
    _bgImageView.image = [UIImage imageNamed:@"d.png"];
    [window addSubview: _bgImageView];
    
    _bgImageView.transform = CGAffineTransformMakeScale(0.1, 0.1);
    [UIView animateWithDuration:0.5f
                          delay:0
         usingSpringWithDamping:1.0
          initialSpringVelocity:0.3
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         _bgImageView.transform = CGAffineTransformMakeScale(1, 1);
                     } completion:nil];
    
    
    
    UIView * bg1 = [[UIView alloc]initWithFrame:CGRectMake(kAUTOWIDTH(260)/2 - 30.5f, 10, 61, 61)];
    [_bgImageView addSubview:bg1];
    
    UIImageView * bgImageView1 = [[UIImageView alloc] initWithFrame:bg1.frame];
    bgImageView1.image = [UIImage imageNamed:@"c1.png"];
    //    [bgImageView addSubview:bgImageView1];
    
    UIImageView *bgImageView2 = [[UIImageView alloc] initWithFrame:bg1.frame];
    bgImageView2.image = [UIImage imageNamed:@"c13"];
    [_bgImageView addSubview:bgImageView2];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(kAUTOWIDTH(20), bgImageView1.frame.origin.y + 55, kAUTOWIDTH(220), kAUTOHEIGHT(91))];
    [label setFont:[UIFont systemFontOfSize:17]];
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    label.font = [UIFont fontWithName:@"Heiti SC" size:14.f];
    label.text = NSLocalizedString(@"字数太少(最少20字)\n(如寄出无意义的信将被拉进小黑屋)", nil);
    [_bgImageView addSubview:label];
    
    UIButton *button1 = [[UIButton alloc]initWithFrame:CGRectMake(kAUTOWIDTH(20), label.frame.origin.y + 75, kAUTOWIDTH(220), 44)];
    button1.backgroundColor = [UIColor clearColor];
    [_bgImageView addSubview:button1];
    [button1 setTitle:NSLocalizedString(@"知道了" , nil) forState:UIControlStateNormal];
    button1.titleLabel.font = [UIFont boldSystemFontOfSize:16.f];
    [button1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(dismissContactView) forControlEvents:UIControlEventTouchUpInside];
    _bgImageView.userInteractionEnabled = YES;
    //    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    //        [_bgView removeFromSuperview];
    //        [_bgViews removeFromSuperview];
    //        [_bgImageView removeFromSuperview];
    //    });
    
    
}
-(void)dismissContactView{
    [_MbgView removeFromSuperview];
            [_bgViews removeFromSuperview];
            [_bgImageView removeFromSuperview];
}

-(void)datePickShow{
    
    if (_contentTextView.text.length < 20) {
        
        [self TiShiTongZhi];
//        ZJViewShow * showbeginView = [[ZJViewShow alloc]initWithFrame:self.view.frame WithTitleString:@"字数太少(如寄出无意义的信将被拉进小黑屋)" WithIamgeName:@"c13"];
//        [self.view addSubview:showbeginView];
//
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [showbeginView removeFromSuperview];
//        });
    }else{
    
    [_contentTextView resignFirstResponder];
    if(_pikerView==nil){
        _backWindowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        _backWindowView.backgroundColor = [UIColor blackColor];
        _backWindowView.alpha = 0.5;
        [[UIApplication sharedApplication].keyWindow addSubview:_backWindowView];
        _pikerView = [DatePickerView datePickerView];
        _pikerView.delegate = self;
        _pikerView.type = 1;
        _pikerView.frame= CGRectMake(0, ScreenHeight, ScreenWidth, 257);
      
        _pikerView.datePickerView.minimumDate = [NSDate date];
    

        
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    //  设置日期格式
                    [formatter setDateFormat:@"yyyy-MM-dd"];
                    //  根据指定格式的字符串获取NSDate
                    NSDate *minDate = [formatter dateFromString:@"2100-01-01 00:00:00"];
        
        NSDate *maxDate = minDate;
        _pikerView.datePickerView.maximumDate = maxDate;
        
        [[UIApplication sharedApplication].keyWindow addSubview:_pikerView];
    
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            _pikerView.frame = CGRectMake(0, ScreenHeight-257, ScreenWidth, 257);
        } completion:^(BOOL finished) {
        }];
        
        [_pikerView.sureBtn addTarget:self action:@selector(sureBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [_pikerView.cannelBtn addTarget:self action:@selector(cancleBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    }else{
        
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            [_backWindowView removeFromSuperview];
            _backWindowView = nil;
            _pikerView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, 257);
        } completion:^(BOOL finished) {
            [self.pikerView removeFromSuperview];
            self.pikerView = nil;
        }];
    }

    
    }
}


- (void)sureBtnClicked{

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    _selectValue = [dateFormatter stringFromDate:self.pikerView.datePickerView.date];
    NSLog(@"确定 = %@",_selectValue);
    
    [UIView animateWithDuration:0.5 animations:^{
        [_backWindowView removeFromSuperview];
        _backWindowView = nil;
        _pikerView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, 257);
    } completion:^(BOOL finished) {
        [self createPopView];
    }];
  

}

-(void)cancleBtnClicked{
    [_backWindowView removeFromSuperview];
    [self.pikerView removeFromSuperview];
    self.pikerView = nil;
    NSLog(@"取消");
}

#pragma mark ============弹出视图结束================



- (void)GuanBiClick:(id)sender {
    [self.pin removeFromSuperview];

    
    self.blackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view insertSubview:self.blackView atIndex:0];
    self.blackView.backgroundColor = [UIColor blackColor];
    self.blackView.alpha = 0;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.blackView.alpha = 0.6;
    }];
    
//    self.letterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
//    [self.view addSubview:self.letterView];
//
//
//    self.mainView = [[UIView alloc] initWithFrame:CGRectMake(kAUTOWIDTH(40), kAUTOHEIGHT(100), ScreenWidth - kAUTOWIDTH(80), IMAGE_PER_HEIGIT*4)];
//    [self.letterView addSubview:_mainView];
    
    self.zongMainView = [[UIView alloc]init];
    self.zongMainView.frame = _mainView.frame;
    [self.letterView addSubview:_zongMainView];
    
    
   
    
    // 把kiluya这张图，分成平均分成4个部分的imageview
    _one = [[UIImageView alloc] init];
    _one.image = [self convertViewToImage:_mainView];
    _one.layer.contentsRect = CGRectMake(0, 0, 1, 0.33f);
    _one.layer.anchorPoint = CGPointMake(0.5, 1.0);
    _one.frame = CGRectMake(0, 0, FRAME_WIDTH, IMAGE_PER_HEIGIT);
    
    
    _three = [[UIImageView alloc] init];
    _three.image = [self convertViewToImage:_mainView];
    _three.layer.contentsRect = CGRectMake(0, 0.33f, 1, 0.67f);
    _three.layer.anchorPoint = CGPointMake(0.5, 0.0);
    _three.frame = CGRectMake(0, IMAGE_PER_HEIGIT, FRAME_WIDTH, IMAGE_PER_HEIGIT);
    
    _four = [[UIImageView alloc] init];
    _four.image =  [self convertViewToImage:_mainView];
    _four.layer.contentsRect = CGRectMake(0, 0.67f, 1, 0.33f);
    _four.layer.anchorPoint = CGPointMake(0.5, 0.0);
    _four.frame = CGRectMake(0, IMAGE_PER_HEIGIT*2, FRAME_WIDTH, IMAGE_PER_HEIGIT);
    
    [_zongMainView addSubview:_one];
    [_zongMainView addSubview:_three];
    [_zongMainView addSubview:_four];
    
    
    
    _threeShadowView = [[UIView alloc] initWithFrame:_three.bounds];
    _threeShadowView.backgroundColor = [UIColor blackColor];
    _threeShadowView.alpha = 0.0;
    
    [_three addSubview:_threeShadowView];
    
    
    self.shadowImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0,self.view.frame.size.height/2 - kAUTOHEIGHT(6.6f) , self.view.frame.size.width, kAUTOHEIGHT(274))];
    //    [self.letterView addSubview:self.shadowImageView];
    self.shadowImageView.image = [UIImage imageNamed:@"letter_shadow.png"];
    self.shadowImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    self.backImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0,self.view.frame.size.height/2 - kAUTOHEIGHT(7.6f) , self.view.frame.size.width, kAUTOHEIGHT(274))];
    [self.letterView addSubview:self.backImageView];
    self.backImageView.image = [UIImage imageNamed:@"mailer_back.png"];
    self.backImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.backImageView.transform = CGAffineTransformMakeScale(1.06f, 1.06f);
    
    
    self.coverImageView = [[UIImageView alloc]initWithFrame:CGRectMake((ScreenWidth - kAUTOWIDTH(297))/2, self.view.frame.size.height/2, kAUTOWIDTH(297), kAUTOHEIGHT(193))];
    [self.letterView addSubview:self.coverImageView];
    self.coverImageView.image = [UIImage imageNamed:@"mailer_cover.png"];
    self.coverImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    self.topImageView = [[UIImageView alloc]init];
    self.topImageView.frame = CGRectMake((ScreenWidth - kAUTOWIDTH(297))/2, CGRectGetMinY(_coverImageView.frame) - kAUTOHEIGHT(60.75f), kAUTOWIDTH(297), kAUTOHEIGHT(121.5f));
    [self.letterView addSubview:self.topImageView];
    self.topImageView.image = [UIImage imageNamed:@"mailer_top.png"];
    self.topImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.topImageView.layer.anchorPoint = CGPointMake(0.5, 1.0);
    //    self.topImageView.layer.contentsRect = CGRectMake(0, 0, 1, 0.25);
    
    
    self.topShadowImageView = [[UIImageView alloc]init];
    self.topShadowImageView.frame = CGRectMake((ScreenWidth - kAUTOWIDTH(297))/2, CGRectGetMinY(_coverImageView.frame) , kAUTOWIDTH(297), kAUTOHEIGHT(167.5f));
    [self.letterView addSubview:self.topShadowImageView];
    self.topShadowImageView.image = [UIImage imageNamed:@"mailer_top_shadow.png"];
    self.topShadowImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.topShadowImageView.alpha = 0;
    
    [self.letterView insertSubview:_zongMainView aboveSubview:self.topImageView];
    [self.letterView bringSubviewToFront:_coverImageView];
    
    _mainView.hidden = YES;
    [_mainView removeFromSuperview];
    _mainView = nil;
    [_subLayer removeFromSuperlayer];
    _subLayer = nil;
    [self zheDieDongHua:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        
        if(PNCisIPHONEX){
            [_zongMainView.layer addAnimation:[self moveX:2 X:[NSNumber numberWithFloat:kAUTOHEIGHT(30)]] forKey:@"y"];

        }else{
            [_zongMainView.layer addAnimation:[self moveX:2 X:[NSNumber numberWithFloat:kAUTOHEIGHT(30)]] forKey:@"y"];

        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.letterView bringSubviewToFront:_topImageView];
            [UIView animateWithDuration:1.0 delay:0 usingSpringWithDamping:1.0 initialSpringVelocity:0 options:UIViewAnimationOptionCurveLinear
                             animations:^{
                                 
                                 // 折叠
                                 _topImageView.layer.transform = [self config3DTransformWithRotateAngle:-178.0
                                                                                           andPositionY:0];
                                 _topShadowImageView.alpha = 1;
                                 [self.letterView bringSubviewToFront:_topShadowImageView];
                                 
                             } completion:^(BOOL finished) {
                                 
                                 [_letterView.layer addAnimation:[self moveX:2 X:[NSNumber numberWithFloat:kAUTOHEIGHT(-800)]] forKey:@"y"];
                                 [UIView animateWithDuration:2 animations:^{
                                     self.blackView.alpha = 0;
                                 } completion:^(BOOL finished) {
                                     [self.letterView removeFromSuperview];
                                     [self beginRequestNetWork];
                                 
                                 }];
                             }];
        });
    });
}

-(UIImage*)convertViewToImage:(UIView*)v{
    CGSize s = v.bounds.size;
    // 下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了
    UIGraphicsBeginImageContextWithOptions(s, NO, [UIScreen mainScreen].scale);
    [v.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage*image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark =====缩放-=============
-(CABasicAnimation *)scale:(NSNumber *)Multiple orgin:(NSNumber *)orginMultiple durTimes:(float)time Rep:(float)repertTimes
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.fromValue = Multiple;
    animation.toValue = orginMultiple;
    animation.autoreverses = YES;
    animation.repeatCount = repertTimes;
    animation.duration = time;//不设置时候的话，有一个默认的缩放时间.
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    return  animation;
}
#pragma mark =====横向、纵向移动===========
-(CABasicAnimation *)moveX:(float)time X:(NSNumber *)x
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];///.y的话就向下移动。
    animation.toValue = x;
    animation.duration = time;
    animation.removedOnCompletion = NO;//yes的话，又返回原位置了。
    animation.repeatCount = 0;
    animation.fillMode = kCAFillModeForwards;
    return animation;
}
#pragma mark =====3D ==========

- (CATransform3D)config3DTransformWithRotateAngle:(double)angle andPositionY:(double)y
{
    CATransform3D transform = CATransform3DIdentity;
    // 立体
    transform.m34 = -1/1000.0;
    // 旋转
    CATransform3D rotateTransform = CATransform3DRotate(transform, M_PI*angle/180, 1, 0, 0);
    // 移动(这里的y坐标是平面移动的的距离,我们要把他转换成3D移动的距离.这是关键,没有它图片就没办法很好地对接。)
    CATransform3D moveTransform = CATransform3DMakeAffineTransform(CGAffineTransformMakeTranslation(0, y));
    // 合并
    CATransform3D concatTransform = CATransform3DConcat(rotateTransform, moveTransform);
    return concatTransform;
}

// 动效是否执行中
static bool isFolding = NO;

- (void)zheDieDongHua:(id)sender
{
    if(!isFolding)
    {
        isFolding = YES;
        
        [UIView animateWithDuration:1.0
                              delay:0
             usingSpringWithDamping:1.0
              initialSpringVelocity:0
                            options:UIViewAnimationOptionCurveLinear
                         animations:^{
                           
                     
                             if (PNCisIPAD) {
                                 self.zongMainView.frame = CGRectMake(CGRectGetMinX(self.coverImageView.frame) + 260, ScreenHeight/2, 297, 193);
                                 self.zongMainView.transform = CGAffineTransformMakeScale(0.97f, 0.97f);
                             }else if(PNCisIPHONEX){
                               self.zongMainView.frame = CGRectMake(kAUTOWIDTH(20), ScreenHeight/2 - kAUTOHEIGHT(250), FRAME_WIDTH,IMAGE_PER_HEIGIT );
                                 self.zongMainView.transform = CGAffineTransformMakeScale(0.85f, 0.75f);

                             }else{
                                 self.zongMainView.frame = CGRectMake(kAUTOWIDTH(20), ScreenHeight/2 - kAUTOHEIGHT(200), FRAME_WIDTH,IMAGE_PER_HEIGIT );
                                 self.zongMainView.transform = CGAffineTransformMakeScale(0.85f, 0.85f);
                             }
                             
                             // 阴影显示
                             //            _oneShadowView.alpha = 0.2;
                             _threeShadowView.alpha = 0.3;
                             
                             // 折叠
                             _one.layer.transform = [self config3DTransformWithRotateAngle:-178.0
                                                                              andPositionY:0];
                             _four.layer.transform = [self config3DTransformWithRotateAngle:178.0
                                                                               andPositionY:0];
                             
                         } completion:^(BOOL finished) {
                             
                             if(finished)
                             {
                                 isFolding = NO;
                             }
                         }];
    }
}

























































-(void)pop{
    
    [self playSoundEffect:nil type:nil];
    CATransition *anima = [CATransition animation];
    [anima setType:kCATransitionFade];
    [anima setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    
    
    anima.duration = 1;
    //@"cube"－ 立方体效果  @"suckEffect"－收缩效果，如一块布被抽走   @"oglFlip"－上下翻转效果   @"rippleEffect"－滴水效果  @"pageCurl"－向上翻一页  @"pageUnCurl"－向下翻一页 @"rotate" 旋转效果 @"cameraIrisHollowOpen"     相机镜头打开效果(不支持过渡方向)  @"cameraIrisHollowClose"    相机镜头关上效果(不支持过渡方向)
    //动画类型
    //kCATransitionFade    新视图逐渐显示在屏幕上，旧视图逐渐淡化出视野
    //kCATransitionMoveIn  新视图移动到旧视图上面，好像盖在上面
    //kCATransitionPush    新视图将旧视图退出去
    //kCATransitionReveal  将旧视图移开显示下面的新视图
    anima.type = @"pageUnCurl";
    anima.subtype = kCATransitionFromRight;
    
    //放到 导航的view 的layer   两个子视图控制器的view 都在 导航的view上
    [self.navigationController.view.layer addAnimation:anima forKey:nil];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)createMainView{
    
    self.letterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:self.letterView];
//    self.letterView.backgroundColor = [UIColor redColor];

    
    self.mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
//                     CGRectMake(20, 74, self.view.frame.size.width - 40, self.view.frame.size.height - 94)];
    [self.view addSubview:self.mainView];
    self.mainView.center = self.view.center;
    self.mainView.backgroundColor = PNCColor(234, 234, 239);
    self.mainView.alpha = 0.9;
    self.mainView.layer.cornerRadius = 12;
    self.mainView.layer.masksToBounds = YES;
    
    [UIView animateWithDuration: 0 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.mainView.frame = CGRectMake(kAUTOWIDTH(20), kAUTOHEIGHT(84), ScreenWidth - kAUTOWIDTH(40), ScreenHeight - kAUTOHEIGHT(124));
        
        if (PNCisIPHONEX) {
            self.mainView.frame = CGRectMake(kAUTOWIDTH(20), kAUTOHEIGHT(104), ScreenWidth - kAUTOWIDTH(40), ScreenHeight - kAUTOHEIGHT(164));
        }
    } completion:^(BOOL finished) {
        
        self.mainView.transform = CGAffineTransformMakeScale(0.95f, 0.95f);
        // 弹簧动画，参数分别为：时长，延时，弹性（越小弹性越大），初始速度
        [UIView animateWithDuration: 0.4 delay:0.7 usingSpringWithDamping:0.3 initialSpringVelocity:0.3 options:0 animations:^{
            // 放大
             self.mainView.transform = CGAffineTransformMakeScale(1, 1);
        } completion:^(BOOL finished) {
            _subLayer=[CALayer layer];
            CGRect fixframe= self.mainView.layer.frame;
            _subLayer.frame = fixframe;
            _subLayer.cornerRadius = 12;
            _subLayer.backgroundColor=[[UIColor grayColor] colorWithAlphaComponent:0.5].CGColor;
            _subLayer.masksToBounds=NO;
            _subLayer.shadowColor=[UIColor grayColor].CGColor;
            _subLayer.shadowOffset=CGSizeMake(0,5);
            _subLayer.shadowOpacity=0.8f;
            _subLayer.shadowRadius= 6;
            [self.view.layer insertSublayer:_subLayer below: self.mainView.layer];
        }];
        
        
    }];
    
//    self.mainView.transform = CGAffineTransformMakeScale(0.9, 0.9);
//    // 弹簧动画，参数分别为：时长，延时，弹性（越小弹性越大），初始速度
//    [UIView animateWithDuration: 0.7 delay:0 usingSpringWithDamping:0.3 initialSpringVelocity:0.3 options:0 animations:^{
//        // 放大
//        self.mainView.transform = CGAffineTransformMakeScale(1, 1);
//    } completion:nil];
    
    
//    [self showGifImageWithYLImageView];
    
    [self createTextView];
    
    
    _pin = [[UIImageView alloc]initWithFrame:CGRectMake(18, 90, 50, 25)];
    if (PNCisIPHONEX) {
        _pin.frame = CGRectMake(17, 110, 50, 25);
    }
    _pin.image = [UIImage imageNamed:@"pin.png"];
    _pin.transform  = CGAffineTransformRotate (_pin.transform, M_PI - M_PI/15);
    [self.view addSubview:_pin];
    
}

- (void)createTextView{
    self.contentTextView = [[UITextView alloc]initWithFrame:CGRectMake(20, 20, self.mainView.frame.size.width - 40, self.mainView.frame.size.height - 40)];
    self.contentTextView.backgroundColor = [UIColor redColor];
   
    NSString *yanseString = [[NSUserDefaults standardUserDefaults] objectForKey:@"beijingyanse"];
    
    if (yanseString == nil) {
        yanseString = @"heiyaoshi";
    }
    
    if ([yanseString isEqualToString:@"yaoshihei"]) {
        _textColor = [UIColor blackColor];
        _mainView.backgroundColor = [UIColor whiteColor];
    }else if ([yanseString isEqualToString:@"xingrenhuang"]){
        self.mainView.backgroundColor = PNCColorWithHex(0xFAF9DE);
        _textColor = [UIColor blackColor];

    }else if ([yanseString isEqualToString:@"qiuyehe"]){
        self.mainView.backgroundColor = PNCColorWithHex(0xFFF2E2);
        _textColor = [UIColor blackColor];

    }else if ([yanseString isEqualToString:@"yanzhihong"]){
        self.mainView.backgroundColor = PNCColorWithHex(0xFDE6E0);
        _textColor = [UIColor blackColor];

    }else if ([yanseString isEqualToString:@"haitianlan"]){
        self.mainView.backgroundColor = PNCColorWithHex(0xDCE2F1);
        _textColor = [UIColor blackColor];

    }else if ([yanseString isEqualToString:@"jiguanghui"]){
        self.mainView.backgroundColor = PNCColorWithHex(0xEAEAEF);
        _textColor = [UIColor blackColor];

    }
    else{
        _textColor = [UIColor blackColor];
        _mainView.backgroundColor = [UIColor whiteColor];

    }
    
    self.contentTextView.tintColor = _textColor;
    [self.mainView addSubview:self.contentTextView];
    self.contentTextView.text = self.model.titleString;
    self.contentTextView.font = [UIFont fontWithName:@"FZSKBXKFW--GB1-0" size:15];

    self.contentTextView.textColor = _textColor;
    self.contentTextView.scrollEnabled = YES;
    self.contentTextView.returnKeyType = UIReturnKeyDefault;
    self.contentTextView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.contentTextView.delegate = self;

    
    
    [[NSNotificationCenter defaultCenter]addObserver:self
     
                                            selector:@selector(handleKeyboardDidShow:)
     
                                                name:UIKeyboardDidShowNotification
     
                                              object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self
     
                                            selector:@selector(handleKeyboardDidHidden)
     
                                                name:UIKeyboardDidHideNotification
     
                                              object:nil];
    
   
    _lineViewX1 = [[UIView alloc]initWithFrame:CGRectMake(10, 10, self.mainView.frame.size.width - 20, 2)];
    _lineViewX1.backgroundColor = [UIColor clearColor];
    _lineViewX1.layer.borderColor =  [UIColor redColor].CGColor;
    _lineViewX1.layer.borderWidth = 0.5f;
    [self.mainView addSubview:_lineViewX1];
    
   _lineViewX2 = [[UIView alloc]initWithFrame:CGRectMake(10,self.mainView.frame.size.height - 10, self.mainView.frame.size.width - 19, 2)];
    _lineViewX2.backgroundColor = [UIColor clearColor];
    _lineViewX2.layer.borderColor =  [UIColor redColor].CGColor;
    _lineViewX2.layer.borderWidth = 0.5f;
    [self.mainView addSubview:_lineViewX2];
    
    _lineViewY1 = [[UIView alloc]initWithFrame:CGRectMake(10, 10, 2, self.mainView.frame.size.height - 20)];
    _lineViewY1.backgroundColor = [UIColor clearColor];
    _lineViewY1.layer.borderColor =   [UIColor redColor].CGColor;
    _lineViewY1.layer.borderWidth = 0.5f;
    [self.mainView addSubview:_lineViewY1];

    _lineViewY2 = [[UIView alloc]initWithFrame:CGRectMake(self.mainView.frame.size.width - 10, 10, 2, self.mainView.frame.size.height - 19)];
    _lineViewY2.backgroundColor = [UIColor clearColor];
    _lineViewY2.layer.borderColor =  [UIColor redColor].CGColor;
    _lineViewY2.layer.borderWidth = 0.5f;
    [self.mainView addSubview:_lineViewY2];
    
    
    
}



- (void)textViewDidChange:(UITextView *)textView{
    
    //    textview 改变字体的行间距
    
     NSString *yanseString = [[NSUserDefaults standardUserDefaults] objectForKey:@"beijingyanse"];
    if (yanseString == nil) {
        yanseString = @"heiyaoshi";
    }
    
    _paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    _paragraphStyle.lineSpacing = 3;// 字体的行间距
    
//    self.contentTextView.font = [UIFont fontWithName:@"FZSKBXKFW--GB1-0" size:15];

    if ([yanseString isEqualToString:@"yaoshihei"]) {
        self.attributes = @{
                            NSFontAttributeName: [UIFont fontWithName:@"FZSKBXKFW--GB1-0" size:15],NSForegroundColorAttributeName:[UIColor blackColor],
                            NSParagraphStyleAttributeName:_paragraphStyle
                            };
        
    }else if ([yanseString isEqualToString:@"xingrenhuang"]){
        self.attributes = @{
                            NSFontAttributeName: [UIFont fontWithName:@"Heiti SC" size:15.f],NSForegroundColorAttributeName:[UIColor blackColor],
                            NSParagraphStyleAttributeName:_paragraphStyle
                            };
    }else if ([yanseString isEqualToString:@"qiuyehe"]){
        self.attributes = @{
                            NSFontAttributeName: [UIFont fontWithName:@"Heiti SC" size:15.f],NSForegroundColorAttributeName:[UIColor blackColor],
                            NSParagraphStyleAttributeName:_paragraphStyle
                            };
        
    }else if ([yanseString isEqualToString:@"yanzhihong"]){
        self.attributes = @{
                            NSFontAttributeName: [UIFont fontWithName:@"Heiti SC" size:15.f],NSForegroundColorAttributeName:[UIColor blackColor],
                            NSParagraphStyleAttributeName:_paragraphStyle
                            };
        
    }else if ([yanseString isEqualToString:@"haitianlan"]){
        self.attributes = @{
                            NSFontAttributeName: [UIFont fontWithName:@"Heiti SC" size:15.f],NSForegroundColorAttributeName:[UIColor blackColor],
                            NSParagraphStyleAttributeName:_paragraphStyle
                            };
    }else if ([yanseString isEqualToString:@"jiguanghui"]){
        self.attributes = @{
                            NSFontAttributeName: [UIFont fontWithName:@"Heiti SC" size:15.f],NSForegroundColorAttributeName:[UIColor blackColor],
                            NSParagraphStyleAttributeName:_paragraphStyle
                            };
    }
    else{
        self.attributes = @{
                            NSFontAttributeName: [UIFont fontWithName:@"FZSKBXKFW--GB1-0" size:15.f],NSForegroundColorAttributeName:[UIColor blackColor],
                            NSParagraphStyleAttributeName:_paragraphStyle
                            };
    }
//    
//    if (yanseString && [yanseString isEqualToString:@"yaoshihei"]) {
//        self.attributes = @{
//                            NSFontAttributeName: [UIFont fontWithName:@"Heiti SC" size:15.f],NSForegroundColorAttributeName:[UIColor whiteColor],
//                            NSParagraphStyleAttributeName:_paragraphStyle
//                            };
//    }else{
//        self.attributes = @{
//                            NSFontAttributeName: [UIFont fontWithName:@"Heiti SC" size:15.f],NSForegroundColorAttributeName:[UIColor blackColor],
//                            NSParagraphStyleAttributeName:_paragraphStyle
//                            };
//    }
  
//    字间距
//    NSKernAttributeName:@(0.5)
//    NSDictionary *attributes2 = @{NSKernAttributeName:@(2)};
    textView.attributedText = [[NSAttributedString alloc] initWithString:textView.text attributes:self.attributes];
    
}
- (void)handleKeyboardDidHidden{
    
    [UIView animateWithDuration:0.5f
                          delay:0
         usingSpringWithDamping:1.0
          initialSpringVelocity:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
        self.contentTextView.contentInset = UIEdgeInsetsZero;
    } completion:nil];
    
}
- (void)handleKeyboardDidShow:(NSNotification*)paramNotification{
    
    NSLog(@"监听方法");
    
    //获取键盘高度
    
    NSValue *keyboardObject =[[paramNotification userInfo]objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGRect keyboardRect;
    
    [keyboardObject getValue:&keyboardRect];
    
    self.keyboardHeight = keyboardRect;
    
    float animationTime = [paramNotification.userInfo[@"UIKeyboardAnimationDurationUserInfoKey"] floatValue];
    
    [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.contentTextView.contentInset=UIEdgeInsetsMake(0, 0,keyboardRect.size.height, 0);
    } completion:^(BOOL finished) {
        
    }];
    
    [UIView animateWithDuration:0.5f
                          delay:0
         usingSpringWithDamping:1.0
          initialSpringVelocity:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.contentTextView.contentInset=UIEdgeInsetsMake(0, 0,keyboardRect.size.height, 0);
                     } completion:nil];

}


//- (void)showGifImageWithYLImageView{
//    YLImageView* imageView = [[YLImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 500)];
//    imageView.contentMode = UIViewContentModeScaleAspectFill;
//    CGFloat centerX = self.view.center.x;
//    [imageView setCenter:CGPointMake(centerX, 402)];
//    [self.view addSubview:imageView];
//    imageView.image = [YLGIFImage imageNamed:@"newcity.gif"];
//}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    NSLog(@"释放");
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)playSoundEffect:(NSString*)name type:(NSString*)type{
    //得到音效文件的地址
    NSString*soundFilePath =[[NSBundle mainBundle] pathForResource:@"Liquid Water Bubble Popping Single 01" ofType:@"wav"];
    //将地址字符串转换成url
    NSURL*soundURL = [NSURL fileURLWithPath:soundFilePath];
    //生成系统音效id
    AudioServicesCreateSystemSoundID((__bridge CFURLRef) soundURL , &soundFileObject);
    //播放系统音效
    AudioServicesPlaySystemSound(soundFileObject);
}


-(void)beginRequestNetWork{
    
    ZJViewShow * showbeginView = [[ZJViewShow alloc]initWithFrame:self.view.frame WithTitleString:NSLocalizedString(@"发送中......" , nil) WithIamgeName:@"c11"];
    [self.view addSubview:showbeginView];
    
    //往GameScore表添加一条playerName为小明，分数为78的数据
    BmobObject *gameScore = [BmobObject objectWithClassName:@"XinList"];
    NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserID"];
    [gameScore setObject:userID forKey:@"UserID"];
    [gameScore setObject:@"" forKey:@"ID"];
    [gameScore setObject:_contentTextView.text forKey:@"xinContent"];
    [gameScore setObject:self.selectValue forKey:@"xinSendTime"];
    [gameScore setObject:[self getCurrentTimes] forKey:@"xinCreateTime"];
    [gameScore setObject:_popTextField.text forKey:@"xinSendToEmail"];
    
    if (_kaiGuanButon.on  == YES) {
        _isOrNoToShow = @"YES";
    }else if(_kaiGuanButon.on == NO){
        _isOrNoToShow = @"NO";
    }
    [gameScore setObject: _isOrNoToShow forKey:@"xinYesOrNoShow"];

    [gameScore saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [showbeginView removeFromSuperview];
        });
        
        ZJViewShow * showEndView =  [[ZJViewShow alloc]initWithFrame:self.view.frame WithTitleString:NSLocalizedString( @"邮件已发往未来", nil) WithIamgeName:@"c122"];
        [self.view addSubview:showEndView];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [showEndView removeFromSuperview];
            [self backToPre];
        });
    }];
}

- (void)showAppStoreReView{
    NSString *systemVersion = [UIDevice currentDevice].systemVersion;

    //仅支持iOS10.3+（需要做校验） 且每个APP内每年最多弹出3次评分alart
    
    if ([systemVersion doubleValue] > 10.3) {
        if([SKStoreReviewController respondsToSelector:@selector(requestReview)]) {
            //防止键盘遮挡
            [[UIApplication sharedApplication].keyWindow endEditing:YES];
            [SKStoreReviewController requestReview];
        }
    }
   
    
}
- (void)backToPre{
    CATransition *anima = [CATransition animation];
    [anima setType:kCATransitionFade];
    [anima setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    
    
    anima.duration = 1;
    //@"cube"－ 立方体效果  @"suckEffect"－收缩效果，如一块布被抽走   @"oglFlip"－上下翻转效果   @"rippleEffect"－滴水效果  @"pageCurl"－向上翻一页  @"pageUnCurl"－向下翻一页 @"rotate" 旋转效果 @"cameraIrisHollowOpen"     相机镜头打开效果(不支持过渡方向)  @"cameraIrisHollowClose"    相机镜头关上效果(不支持过渡方向)
    //动画类型
    //kCATransitionFade    新视图逐渐显示在屏幕上，旧视图逐渐淡化出视野
    //kCATransitionMoveIn  新视图移动到旧视图上面，好像盖在上面
    //kCATransitionPush    新视图将旧视图退出去
    //kCATransitionReveal  将旧视图移开显示下面的新视图
    anima.type = @"pageUnCurl";
    anima.subtype = kCATransitionFromRight;
    
    //放到 导航的view 的layer   两个子视图控制器的view 都在 导航的view上
    [self.navigationController.view.layer addAnimation:anima forKey:nil];
    [self.navigationController popViewControllerAnimated:YES];
    
        if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstText"]){
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstText"];
            //第一次启动
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self showAppStoreReView];
            });
        }else{
            //不是第一次启动了
        }
        
    
}

-(NSString*)getCurrentTimes{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    
    //现在时间,你可以输出来看下是什么格式
    
    NSDate *datenow = [NSDate date];
    
    //----------将nsdate按formatter格式转成nsstring
    
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    
    NSLog(@"currentTimeString =  %@",currentTimeString);
    
    return currentTimeString;
    
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text{
    
    //在输入过程中 判断加上输入的字符 是否超过限定字数
    NSString *str = [NSString stringWithFormat:@"%@%@", textView.text, text];
    if (str.length > 1000)
    {
        textView.text = [textView.text substringToIndex:999];
        return NO;
    }
    return YES;
}
@end

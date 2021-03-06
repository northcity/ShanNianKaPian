//
//  MEEEEViewController.m
//  leisure
//
//  Created by qianfeng0 on 16/3/3.
//  Copyright © 2016年 陈希. All rights reserved.
//

#import "SettingViewController.h"
//#import "CollectionViewController.h"
//#import "HXViewController.h"
//#import "SDCycleScrollView.h"
//#import "UserFeedBackViewController.h"
#import "MainContentCell.h"
#import <StoreKit/StoreKit.h>
#import <MessageUI/MessageUI.h>
//#import "AboutUSViewController.h"
#import "AboutViewController.h"
#import "ShanNianVoiceSetViewController.h"

#import "BCMiMaYuJieSuoViewController.h"
#import "LZBaseNavigationController.h"
#import "LZiCloudViewController.h"

const CGFloat kNavigationBarHeight = 44;
const CGFloat kStatusBarHeight = 20;
@interface SettingViewController ()<UITableViewDataSource,SKStoreProductViewControllerDelegate, UITableViewDelegate,MFMailComposeViewControllerDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIColor *backColor;
@property (nonatomic, assign) CGFloat headerHeight;

@property (nonatomic, strong) UIView *headerContentView;
@property (nonatomic, strong) UIImageView *headerImageView;
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, assign) CGFloat scale;

@property(nonatomic,strong)UIAlertController *alert;


//@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)UIImageView * backGroundImage;
@property(nonatomic,strong)UIVisualEffectView *effectView;
@property(nonatomic,strong)UIBlurEffect *effect;
@property(nonatomic,strong)UILabel *desginLabel;

@property(nonatomic,strong)UILabel *zhuTiDetailLabel;
@property(nonatomic,strong)UISwitch *zhuTiKaiGuanButon;

@end


@implementation SettingViewController

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
    _navTitleLabel.text = @"通用设置";
    _navTitleLabel.font = [UIFont fontWithName:@"HeiTi SC" size:18];
    _navTitleLabel.textColor = [UIColor blackColor];
    _navTitleLabel.textAlignment = NSTextAlignmentCenter;
    [_titleView addSubview:_navTitleLabel];
    
    
    _backBtn = [Factory createButtonWithTitle:@"" frame:CGRectMake(20, 28, 25, 25) backgroundColor:[UIColor clearColor] backgroundImage:[UIImage imageNamed:@""] target:self action:@selector(backAction)];
    [_backBtn setImage:[UIImage imageNamed:@"返回箭头2"] forState:UIControlStateNormal];
    if (PNCisIPHONEX) {
        _backBtn.frame = CGRectMake(20, 48, 25, 25);
    }
    [_titleView addSubview:_backBtn];
    
    
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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIImageView *pin = [[UIImageView alloc]initWithFrame:CGRectMake(10, 35, 60, 30)];
    pin.image = [UIImage imageNamed:@"pin"];
    
    [self.navigationController.navigationBar addSubview:pin];
    
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 44)];
    image.image = [UIImage imageNamed:@"titlebar_shadow"];
    
    //    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"titlebar_bg1.png"] forBarMetrics:(UIBarMetricsDefault)];
    //    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    self.title =@"ME";
    
    //信息内容
    [self createUI];
    [self.view insertSubview:image aboveSubview:self.tableView];
    [self initOtherUI];

    
}
- (void)viewWillAppear:(BOOL)animated{
    
    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.tabBar.hidden = YES;

}
- (void)backAction{
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
- (void)createUI{
    
  
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"MainContentCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.sectionHeaderHeight = 5;
    self.tableView.sectionFooterHeight = 0;
    if (PNCisIPHONEX) {
        //        self.tableView.sectionHeaderHeight = 24;
        self.tableView.sectionFooterHeight = 0;
    }
//    tableView!.cellLayoutMarginsFollowReadableWidth = false
    if (PNCisIPAD) {
        self.tableView.cellLayoutMarginsFollowReadableWidth = false;
    }
    UIImageView * backimage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    //    [self.view addSubview:backimage];
    backimage.image = [[UIImage imageNamed:@"QQ20180311-1.jpg"] applyBlurWithRadius:5 tintColor:nil saturationDeltaFactor:1 maskImage:nil];
    backimage.contentMode = UIViewContentModeScaleAspectFill;
    [self.view insertSubview:self.tableView aboveSubview:backimage];
    
    UIButton * backBtn = [Factory createButtonWithTitle:@"" frame:CGRectMake(20, 32, 25, 25) backgroundColor:[UIColor clearColor] backgroundImage:[UIImage imageNamed:@""] target:self action:@selector(backAction)];
    
    [backBtn setImage:[UIImage imageNamed:@"返回 (3).png"] forState:UIControlStateNormal];
//    [self.view addSubview:backBtn];
    
    UILabel * label = [Factory createLabelWithTitle: NSLocalizedString(@"关于", nil)  frame:CGRectMake(60, 25, 100, 40) fontSize:14.f];
    label.font = [UIFont fontWithName:@"Heiti SC" size:16.f];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor blackColor];
//    [self.view addSubview:label];
    
    if (PNCisIPHONEX) {
        backBtn.frame = CGRectMake(20, 48, 25, 25);
        label.frame = CGRectMake(60, 40, 60, 40);
    }
    
    UIView *label111 = [[UIView alloc]initWithFrame:CGRectMake((ScreenWidth-80)/2, ScreenHeight-150, 80, 80)];
    label111.backgroundColor = [UIColor whiteColor];
    label111.layer.cornerRadius=12;
    label111.layer.shadowColor=[UIColor grayColor].CGColor;
    label111.layer.shadowOffset=CGSizeMake(0.5, 0.5);
    label111.layer.shadowOpacity=0.8;
    label111.layer.shadowRadius=1.2;
    //    [self.view addSubview:label111];
    
    self.desginLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, ScreenHeight - kAUTOHEIGHT(60), ScreenWidth - 40, 44)];
    self.desginLabel.text = @"- - Create By NorthCity - -";
    self.desginLabel.textColor = [UIColor blackColor];
    self.desginLabel.textAlignment = NSTextAlignmentCenter;
    self.desginLabel.font = [UIFont fontWithName:@"HeiTi SC" size:8];
    self.desginLabel.alpha = 0.9;
    [self.view addSubview:self.desginLabel];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return UITableViewAutomaticDimension;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return @"基本通用设置";
    } else {
        
        return @"更多设置";
    }
}
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//
//    return 10;
//}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (PNCisIPHONEX) {
        if (section == 0) {
            
            return 85;
        } else {
            
            return 35;
        }
    }
    if (section == 0) {
        
        return 75;
    } else {
        
        return 35;
    }}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 4;
    }else{
        return 3;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 6) {
        return 180;
    }
    
    if (indexPath.row == 0) {
        NSString *statusString = [[NSUserDefaults standardUserDefaults] objectForKey:@"KaiGuanShiFouDaKai"];
        if ([statusString isEqualToString:@"关"]) {
            return 1;
            
        }else if ([statusString isEqualToString:@"开"]){
            return 62;
        }else{
            return 1;
        }
    }
    
    
    return 62;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MainContentCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.imageView.image = [UIImage imageNamed:@"语音1"];
        cell.textLabel.text = @"语音识别设置";
    }
    if (indexPath.section == 0 && indexPath.row == 1) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.imageView.image = [UIImage imageNamed:@"云1"];
        cell.textLabel.text = @"iCloud设置";
    }
    if (indexPath.section == 0 && indexPath.row == 2) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.imageView.image = [UIImage imageNamed:@"密码1"];
        cell.textLabel.text = @"密码与解锁";
    }
    if (indexPath.section == 0 && indexPath.row == 3) {
        cell.imageView.image = [UIImage imageNamed:@"主题前.png"];
        if (!_zhuTiKaiGuanButon) {
            _zhuTiKaiGuanButon = [[UISwitch alloc]initWithFrame:CGRectMake(cell.bounds.size.width - kAUTOWIDTH(70), CGRectGetMinY(cell.label.frame) + 10, kAUTOWIDTH(50), 50)];
            if (PNCisIPAD) {
                _zhuTiKaiGuanButon.frame = CGRectMake(cell.bounds.size.width - 70, CGRectGetMinY(cell.label.frame) + 10, 50, 50);
            }
        }
        [cell.contentView addSubview:_zhuTiKaiGuanButon];
        [_zhuTiKaiGuanButon addTarget:self action:@selector(qieHuanZhuTiAction:) forControlEvents:UIControlEventTouchUpInside];
        _zhuTiKaiGuanButon.transform = CGAffineTransformMakeScale(0.8,0.8);
        _zhuTiKaiGuanButon.tintColor = [UIColor blackColor];
        _zhuTiKaiGuanButon.onTintColor = [UIColor blackColor];
        
        if ([[BCUserDeafaults objectForKey:@"ZHUTI"] isEqualToString:@"1"]) {
            _zhuTiKaiGuanButon.on = YES;
            cell.textLabel.text = NSLocalizedString(@"默认主题", nil) ;
            
        }else if([[BCUserDeafaults objectForKey:@"ZHUTI"] isEqualToString:@"0"]){
            _zhuTiKaiGuanButon.on = NO;
            cell.textLabel.text = NSLocalizedString(@"情怀主题", nil) ;
            
        }else{
            _zhuTiKaiGuanButon.on = YES;
            cell.textLabel.text = NSLocalizedString(@"默认主题", nil) ;
            
        }
        
        if (!_zhuTiDetailLabel) {
            _zhuTiDetailLabel = [Factory createLabelWithTitle:@"" frame:CGRectMake(cell.bounds.size.width - kAUTOWIDTH(195), 5, kAUTOWIDTH(120), 50)];
            if (PNCisIPAD) {
                _zhuTiDetailLabel.frame = CGRectMake(cell.bounds.size.width - 215, 5, 140, 50);
            }
//            _zhuTiDetailLabel.text =  NSLocalizedString(@"切换后需重启App生效", nil) ;
            _zhuTiDetailLabel.font = [UIFont fontWithName:@"Heiti SC" size:10];
            _zhuTiDetailLabel.textAlignment = NSTextAlignmentRight;
            
            if (ScreenWidth < 375) {
                _zhuTiDetailLabel.font = [UIFont fontWithName:@"Heiti SC" size:8];
            }
        }
        [cell.contentView addSubview:_zhuTiDetailLabel];
        
    
//        cell.textLabel.text = @"主题设置";
    }
    
    if (indexPath.section == 1 && indexPath.row == 0) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.imageView.image = [UIImage imageNamed:@"反馈11"];
        cell.textLabel.text = @"发送反馈";
    }
    if (indexPath.section == 1 && indexPath.row == 1) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.imageView.image = [UIImage imageNamed:@"发送11"];
        cell.textLabel.text = @"分享给朋友";
    }
    if (indexPath.section == 1 && indexPath.row == 2) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.imageView.image = [UIImage imageNamed:@"点赞11"];
        cell.textLabel.text = @"给个小心心";
    }
    if (indexPath.section == 1 && indexPath.row == 3) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.imageView.image = [UIImage imageNamed:@"个人111"];
        cell.textLabel.text = @"关于";
    }
    
    return  cell;
}

- (void)qieHuanZhuTiAction:(UISwitch *)kaiGuanBtn{
    
    NSIndexPath *path=[NSIndexPath indexPathForRow:3 inSection:0];
    MainContentCell *cell = (MainContentCell *)[_tableView cellForRowAtIndexPath:path];
    
    CABasicAnimation *baseAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    baseAnimation.duration = 0.4;
    baseAnimation.repeatCount = 1;
    baseAnimation.fromValue = [NSNumber numberWithFloat:0.0]; // 起始角度
    baseAnimation.toValue = [NSNumber numberWithFloat:M_PI]; // 终止角度
    [cell.imageView.layer addAnimation:baseAnimation forKey:@"rotate-layer"];
    
    
    if (kaiGuanBtn.on == YES) {
        [BCUserDeafaults setObject:@"1" forKey:@"ZHUTI"];
        [BCUserDeafaults synchronize];
        cell.textLabel .text =  NSLocalizedString(@"默认主题", nil) ;
        [[NSNotificationCenter defaultCenter ] postNotificationName:@"CHANGEZHUTIDEFAULT" object:self];
        
    }else{
        [BCUserDeafaults setObject:@"0" forKey:@"ZHUTI"];
        [BCUserDeafaults synchronize];
        
        cell.textLabel.text = NSLocalizedString(@"情怀主题", nil) ;
        [[NSNotificationCenter defaultCenter ] postNotificationName:@"CHANGEZHUTI" object:nil];

    }
    
}

- (void)loadAppStoreController{
    // 初始化控制器
    SKStoreProductViewController *storeProductViewContorller = [[SKStoreProductViewController alloc] init];
    // 设置代理请求为当前控制器本身
    storeProductViewContorller.delegate = self;
    [storeProductViewContorller loadProductWithParameters:@{SKStoreProductParameterITunesItemIdentifier:@"1397149726"} completionBlock:^(BOOL result, NSError *error){
        if(error){
            NSLog(@"error %@ with userInfo %@",error,[error userInfo]);
        }else{
            // 模态弹出appstore
            [self presentViewController:storeProductViewContorller animated:YES completion:nil];
        }
    }];
}
//AppStore取消按钮监听
- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController{
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        ShanNianVoiceSetViewController *svc = [[ShanNianVoiceSetViewController alloc]init];
        [self presentViewController:svc animated:YES completion:nil];
    }
    
    if (indexPath.section == 0 && indexPath.row == 1) {
        LZiCloudViewController *bvc = [[LZiCloudViewController alloc]init];
        LZBaseNavigationController *nav = [[LZBaseNavigationController alloc]initWithRootViewController:bvc];
        [self presentViewController:nav animated:YES completion:nil];
    }
    
    if (indexPath.section == 0 && indexPath.row == 2) {
        BCMiMaYuJieSuoViewController *bvc = [[BCMiMaYuJieSuoViewController alloc]init];
        LZBaseNavigationController *nav = [[LZBaseNavigationController alloc]initWithRootViewController:bvc];
        [self presentViewController:nav animated:YES completion:nil];
    }
    
    if (indexPath.section == 0 && indexPath.row == 3) {
      
    
    }
    
    if (indexPath.section == 1 && indexPath.row == 0) {
        [self pushEmail];
    }
    
    if (indexPath.section == 1 && indexPath.row == 1) {
        [self shareImage];
    }
    
    if (indexPath.section == 1 && indexPath.row == 2) {
        NSString *itunesurl = @"itms-apps://itunes.apple.com/cn/app/id1397149726?mt=8&action=write-review";
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:itunesurl]];
        
    }
    
    
    

    
    if (indexPath.row == 4) {
        
        
    }else if (indexPath.row == 1){
        
        MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
        if (!controller) {
            // 在设备还没有添加邮件账户的时候mailViewController为空，下面的present view controller会导致程序崩溃，这里要作出判断
            NSLog(@"设备还没有添加邮件账户");
        }else{
            controller.mailComposeDelegate = self;
            [controller setSubject:@"九宫格切图(iOS版)反馈"];
            NSString * device = [[UIDevice currentDevice] model];
            NSString * ios = [[UIDevice currentDevice] systemVersion];
            NSString *body = [NSString stringWithFormat:@"请留下您的宝贵建议和意见：\n\n\n以下信息有助于我们确认您的问题，建议保留。\nDevice: %@\nOS Version: %@\n", device, ios];
            [controller setMessageBody:body isHTML:NO];
            NSArray *toRecipients = [NSArray arrayWithObject:@"506343891@qq.com"];
            [controller setToRecipients:toRecipients];
            
            [self presentViewController:controller animated:YES completion:nil];
            
        }
    }
    
    else if (indexPath.row == 0){
        ShanNianVoiceSetViewController *svc = [[ShanNianVoiceSetViewController alloc]init];
        [self presentViewController:svc animated:YES completion:nil];
        //        AboutViewController * ab = [[AboutViewController alloc]init];
//        [self presentViewController:ab animated:YES completion:nil];
    }else if (indexPath.row == 3){
        
//        [self TiShiTongZhi];
        
    }
    
}


- (void)shareImage{
    
    
    
    NSString *text = @"闪念灵感";
    //    NSString *imageName = @"QQ20180311-1.jpg";
    //    NSString *path = [[NSBundle mainBundle] pathForResource:imageName ofType:nil];
    //    UIImage *image2 = nil;
    //
    //    UIImageView *imageView1 = [[UIImageView alloc]init];
    //    imageView1.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - 130);
    //    imageView1.image = image2;
    //    imageView1.contentMode = UIViewContentModeScaleAspectFit;
    //
    //    UIImageView *imageView2 = [[UIImageView alloc]init];
    //    imageView2.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    //    [imageView2 addSubview:imageView1];
    //
    //    UIImageView  *iconImage3 = [[UIImageView alloc]init];
    //    iconImage3.frame = CGRectMake(20, ScreenHeight - 100, 60, 60);
    //    iconImage3.image = [UIImage imageNamed:@"shareicon.jpeg"];
    //    [imageView2 addSubview:iconImage3];
    //
    //
    //    UILabel *label = [Factory createLabelWithTitle:@"时间胶囊" frame:CGRectMake(20, ScreenHeight - 40, 60, 20)];
    //    label.font = [UIFont fontWithName:@"Heiti SC" size:9];
    //    label.textAlignment = NSTextAlignmentCenter;
    //    [imageView2 addSubview:label];
    //
    //    imageView2.backgroundColor = [UIColor whiteColor];
    ////    UIImage *zuihouImage = [self convertImageViewToImage:imageView2];
    
    NSURL *urlToShare = [NSURL URLWithString:@"https://itunes.apple.com/cn/app/id1397149726?mt=8"];
    NSArray *activityItems = @[text,urlToShare];
    

    UIActivityViewController *activityViewController =[[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    
    activityViewController.popoverPresentationController.sourceView = self.view;
    
    [self presentViewController:activityViewController animated:YES completion:nil];
    // 分享类型
    [activityViewController setCompletionWithItemsHandler:^(NSString * __nullable activityType, BOOL completed, NSArray * __nullable returnedItems, NSError * __nullable activityError){
        // 显示选中的分享类型
        NSLog(@"当前选择分享平台 %@",activityType);
        if (completed) {
            [SVProgressHUD showInfoWithStatus:@"分享成功"];
            NSLog(@"分享成功");
        }else {
            [SVProgressHUD showInfoWithStatus:@"分享失败"];
            
            NSLog(@"分享失败");
        }
        
    }];
    
}

-(void)pushEmail{
    MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
    if (!controller) {
        // 在设备还没有添加邮件账户的时候mailViewController为空，下面的present view controller会导致程序崩溃，这里要作出判断
        NSLog(@"设备还没有添加邮件账户");
    }else{
        controller.mailComposeDelegate = self;
        [controller setSubject:@"闪念灵感(iOS版)反馈"];
        NSString * device = [[UIDevice currentDevice] model];
        NSString * ios = [[UIDevice currentDevice] systemVersion];
        NSString *body = [NSString stringWithFormat:@"请留下您的宝贵建议和意见：\n\n\n以下信息有助于我们确认您的问题，建议保留。\nDevice: %@\nOS Version: %@\n", device, ios];
        [controller setMessageBody:body isHTML:NO];
        NSArray *toRecipients = [NSArray arrayWithObject:@"506343891@qq.com"];
        [controller setToRecipients:toRecipients];
        
        [self presentViewController:controller animated:YES completion:nil];
        
    }
}

- (void)TiShiTongZhi{
    
    
    
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    _bgViews = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _bgViews.alpha = 0.6;
    //    _bgViews.backgroundColor = [UIColor blackColor];
    [window addSubview:_bgViews];
    
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView * effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    effectView.frame = _bgViews.frame;
    effectView.alpha = 1.f;
    effectView.userInteractionEnabled = YES;
    [window addSubview:effectView];
    
    _bgView = [[UIView alloc]initWithFrame:CGRectMake((ScreenWidth -kAUTOWIDTH(260))/2, ScreenHeight / 2 - kAUTOHEIGHT(100), kAUTOWIDTH(260), kAUTOHEIGHT(180))];
    [window addSubview:_bgView];
    
    
    _bgImageView = [[UIImageView alloc] initWithFrame:_bgView.frame];
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
    
    
    
    UIView * bg1 = [[UIView alloc]initWithFrame:CGRectMake(kAUTOWIDTH(260)/2 - 20.f, 19, 35, 35)];
    [_bgImageView addSubview:bg1];
    
    UIImageView * bgImageView1 = [[UIImageView alloc] initWithFrame:bg1.frame];
    bgImageView1.image = [UIImage imageNamed:@"c1.png"];
    //    [bgImageView addSubview:bgImageView1];
    
    UIImageView *bgImageView2 = [[UIImageView alloc] initWithFrame:bg1.frame];
    bgImageView2.image = [UIImage imageNamed:@"增值服务2.png"];
    [_bgImageView addSubview:bgImageView2];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(kAUTOWIDTH(20), bgImageView1.frame.origin.y + 40, kAUTOWIDTH(220), kAUTOHEIGHT(91))];
    [label setFont:[UIFont systemFontOfSize:17]];
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    label.font = [UIFont fontWithName:@"Heiti SC" size:14.f];
    
    
    
    label.text = NSLocalizedString(@"您将购买增值服务\n只需要花费¥ 6\n您就可以永久获取不限字数的信纸", nil);
    
    
    
    
    NSString *string = label.text;
    const CGFloat fontSize = 14.0;
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:string];
    NSUInteger length = [string length];
    //设置字体
    UIFont *baseFont = [UIFont fontWithName:@"Heiti SC" size:12.f];
    [attrString addAttribute:NSFontAttributeName value:baseFont range:NSMakeRange(0, length)];//设置所有的字体
    UIFont *boldFont = [UIFont boldSystemFontOfSize:15.f];
    [attrString addAttribute:NSFontAttributeName value:boldFont range:[string rangeOfString:@"20"]];//设置Text这四个字母的字体为粗体
    [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:[string rangeOfString:@"20"]];
    label.attributedText = attrString;
    
    
    
    
    [_bgImageView addSubview:label];
    
    UIButton *button1 = [[UIButton alloc]initWithFrame:CGRectMake(kAUTOWIDTH(20), CGRectGetMinY(label.frame) + kAUTOHEIGHT(75), kAUTOWIDTH(220), 44)];
    button1.backgroundColor = [UIColor clearColor];
    [_bgImageView addSubview:button1];
    [button1 setTitle:NSLocalizedString(@"立即购买" , nil) forState:UIControlStateNormal];
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

- (void)openAppWithIdentifier:(NSString *)appId {
    SKStoreProductViewController *storeProductVC = [[SKStoreProductViewController alloc] init];
    storeProductVC.delegate = self;
    
    NSDictionary *dict = [NSDictionary dictionaryWithObject:appId forKey:SKStoreProductParameterITunesItemIdentifier];
    [storeProductVC loadProductWithParameters:dict completionBlock:^(BOOL result, NSError *error) {
        if (result) {
            [self presentViewController:storeProductVC animated:YES completion:nil];
        }
    }];
    //- (void)productViewControllerDidFinish:(SKStoreProductViewController *)storeProductVC {
    //    [storeProductVC dismissViewControllerAnimated:YES completion:^{
    //
    //        [self.navigationController popToRootViewControllerAnimated:YES];
    //    }];
}


- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error;
{
    if (result == MFMailComposeResultSent) {
        NSLog(@"It's away!");
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"您的反馈发送成功。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

//- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController{
//    [self dismissViewControllerAnimated:YES completion:^{
//    }];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}






@end


//
//-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    MainContentCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
//
//    cell.backgroundColor = [UIColor clearColor];
//    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
//
//    if (indexPath.row == 0) {
//
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//        cell.textLabel.text = NSLocalizedString( @"更多独立精品App", nil);
//        cell.imageView.image = [UIImage imageNamed:@"沙漏"];
//
//        NSString *statusString = [[NSUserDefaults standardUserDefaults] objectForKey:@"KaiGuanShiFouDaKai"];
//        if ([statusString isEqualToString:@"开"]) {
//            cell.contentView.hidden = NO;
//            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//        }else if ([statusString isEqualToString:@"关"]){
//            cell.contentView.hidden = YES;
//            cell.accessoryType = UITableViewCellAccessoryNone;
//        }else{
//            cell.contentView.hidden = YES;
//            cell.accessoryType = UITableViewCellAccessoryNone;
//        }
//
//    }else if (indexPath.row == 6){
//        cell.textLabel.text = @"我的收藏";
//        cell.imageView.image = [UIImage imageNamed:@"星级2"];
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//
//    }else if (indexPath.row == 1){
//        cell.textLabel.text = NSLocalizedString(@"意见反馈", nil) ;
//        cell.imageView.image = [UIImage imageNamed:@"反馈问题"];
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//
//    }else if (indexPath.row == 7){
//
//        cell.textLabel.text = @"清除缓存";
//        cell.imageView.image = [UIImage imageNamed:@"new2清除缓存"];
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//
//
//
//    }else if (indexPath.row == 2){
//        cell.textLabel.text = NSLocalizedString(@"给个赞", nil) ;
//        cell.imageView.image = [UIImage imageNamed:@"星级2"];
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//
//    }else if (indexPath.row == 8){
//
//        cell.textLabel.text = NSLocalizedString(@"升级信纸", nil) ;
//        cell.imageView.image = [UIImage imageNamed:@"增值服务1.png"];
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//
//        UILabel *detailLabel = [Factory createLabelWithTitle:  NSLocalizedString(@"¥6 购买", nil) frame:CGRectMake(cell.bounds.size.width - kAUTOWIDTH(180), 5, kAUTOWIDTH(150), 50)];
//        [cell.contentView addSubview:detailLabel];
//        detailLabel.numberOfLines = 1;
//        detailLabel.font = [UIFont fontWithName:@"Heiti SC" size:13.f];
//        detailLabel.textAlignment = NSTextAlignmentRight;
//    }else if (indexPath.section == 2 && indexPath.row == 3){
//
//        cell.label.frame = CGRectMake(10, 10, ScreenWidth-20, 180);
//        if (!_backGroundImage) {
//            _backGroundImage = [[UIImageView alloc]initWithFrame:cell.label.bounds];
//        }
//        [cell.label addSubview:_backGroundImage];
//        _backGroundImage.backgroundColor = [UIColor clearColor];
//        _backGroundImage.image = [UIImage imageNamed:@"QQ20180311-1.jpg"];
//        _backGroundImage.layer.cornerRadius = 6;
//        _backGroundImage.layer.masksToBounds = YES;
//        _backGroundImage.alpha = 0.6;
//        _backGroundImage.contentMode = UIViewContentModeScaleAspectFill;
//
//        self.effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
//
//        self.effectView = [[UIVisualEffectView alloc] initWithEffect:self.effect];
//
//        self.effectView.frame = cell.label.bounds;
//
//        self.effectView.alpha = 1.f;
//        self.effectView.userInteractionEnabled = YES;
//        [_backGroundImage addSubview:self.effectView];
//
//        UILabel * label2 = [Factory createLabelWithTitle:@"* 这就是我心里的一座城池，其他人眼中的一片废墟。" frame:CGRectMake(5,20 ,ScreenWidth-40,55) fontSize:12.f];
//        label2.numberOfLines = 0;
//        label2.textAlignment = NSTextAlignmentLeft;
//        label2.font = [UIFont fontWithName:@"Heiti SC" size:12.f];
//        label2.textAlignment = NSTextAlignmentCenter;
//        label2.backgroundColor = [UIColor clearColor];
//        label2.textColor = [UIColor whiteColor];
//        //        [cell addSubview:label2];
//
//        UILabel * label1 = [Factory createLabelWithTitle:NSLocalizedString(@"春日傍晚\n落日西斜\n远海的岛屿渐渐看不见了\n忽然岛上亮起了一盏盏灯火\n指明了它们的所在\n— 正冈子规", nil) frame:CGRectMake(0,20 ,ScreenWidth-20,170) fontSize:12.f];
//        label1.numberOfLines = 0;
//
//        label1.font = [UIFont fontWithName:@"Heiti SC" size:13.f];
//        label1.textAlignment = NSTextAlignmentCenter;
//        //        label1.backgroundColor = [UIColor redColor];
//        label1.textColor = [UIColor blackColor];
//        [cell.contentView addSubview:label1];
//
//        //        cell.label.backgroundColor = [UIColor blackColor];
//        cell.label.alpha = 0.5f;
//
//
//
//        cell.label.layer.shadowColor=[UIColor grayColor].CGColor;
//        cell.label.layer.shadowOffset=CGSizeMake(0, 4);
//        cell.label.layer.shadowOpacity=0.6f;
//        cell.label.layer.shadowRadius=12;
//        //        [self.contentView addSubview:cell.label];
//        cell.label.alpha = 0.8;
//
//    }
//
//
//
//    return cell;
//}


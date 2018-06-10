//
//  ShanNianMuLuViewController.m
//  CutImageForYou
//
//  Created by chenxi on 2018/5/24.
//  Copyright © 2018年 chenxi. All rights reserved.
//

#import "ShanNianMuLuViewController.h"
#import "ShanNianTableViewCell.h"
#import "iCloudHandle.h"
#import "PcmPlayer.h"
#import "PcmPlayerDelegate.h"
#import "LZSqliteTool.h"
#import "ShanNianMuLuDetailViewController.h"
#import "MainTextViewController.h"

@interface ShanNianMuLuViewController ()<UITableViewDataSource, UITableViewDelegate,PcmPlayerDelegate,UIViewControllerTransitioningDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic ,copy)   NSArray                   *dataArr;
@property (nonatomic, strong) PcmPlayer *audioPlayer;

@property(nonatomic,strong)NSMutableArray *dataSourceArray;
@end

@implementation ShanNianMuLuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self setUpNotification];
    [self createUI];
    self.view.backgroundColor = [UIColor whiteColor];
//    [self getData];
//    [self loadData];
    [self initOtherUI];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadData];
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
    _navTitleLabel.text = @"我的灵感";
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

//- (void)backAction{
//    [self dismissViewControllerAnimated:YES completion:^{
//    }];
//}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.view.backgroundColor = [UIColor whiteColor];

}
- (void)loadData {
    
    self.dataSourceArray =[[NSMutableArray alloc]init];
    
    NSArray* array = [LZSqliteTool LZSelectAllElementsFromTable:LZSqliteDataTableName];
    

    if (self.dataArr.count > 0) {
        [self.dataSourceArray removeAllObjects];
    }
    
    [self.dataSourceArray addObjectsFromArray:array];
    
    [self.tableView reloadData];
}


- (void)getData
{
    [iCloudHandle queryCloudKitData];
}

- (void)setUpNotification
{
    //获取最新数据完成
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishedGetNewCloudData:) name:@"CloudDataQueryFinished" object:nil];
    
}

#pragma mark -
#pragma mark - notification

- (void)finishedGetNewCloudData:(NSNotification *)notification
{
    dispatch_sync(dispatch_get_main_queue(), ^{
        
        self.dataArr = notification.userInfo[@"key"];
        [self.tableView reloadData];
        
    });
    
}


- (void)createUI{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStyleGrouped];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"ShanNianTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.sectionHeaderHeight = 5;
    self.tableView.sectionFooterHeight = 0;
    self.tableView.backgroundColor = [UIColor clearColor];
    if (PNCisIPHONEX) {
        //        self.tableView.sectionHeaderHeight = 24;
        self.tableView.sectionFooterHeight = 0;
    }
    UIImageView * backimage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    //    [self.view addSubview:backimage];
    backimage.image = [[UIImage imageNamed:@"QQ20180311-1.jpg"] applyBlurWithRadius:5 tintColor:nil saturationDeltaFactor:1 maskImage:nil];
    backimage.contentMode = UIViewContentModeScaleAspectFill;
    [self.view insertSubview:self.tableView aboveSubview:backimage];
    
    UIButton * backBtn = [Factory createButtonWithTitle:@"" frame:CGRectMake(20, 32, 25, 25) backgroundColor:[UIColor clearColor] backgroundImage:[UIImage imageNamed:@""] target:self action:@selector(backAction)];
    
    [backBtn setImage:[UIImage imageNamed:@"返回 (3).png"] forState:UIControlStateNormal];
    [self.view addSubview:backBtn];
    
    UILabel * label = [Factory createLabelWithTitle: NSLocalizedString(@"关于", nil)  frame:CGRectMake(60, 25, 100, 40) fontSize:14.f];
    label.font = [UIFont fontWithName:@"Heiti SC" size:16.f];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor blackColor];
    [self.view addSubview:label];
    
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
    
}
- (void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (PNCisIPHONEX) {
        return 65;
        
    }
    return 55;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataSourceArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row=indexPath.row;
    
    CGFloat contentWidth = self.view.frame.size.width;
    
    //
    
    UIFont *font = [UIFont systemFontOfSize:14];
    
    //
    
    LZDataModel *model =  [_dataSourceArray objectAtIndex:row];
    NSString *content = model.titleString;
    
    //
    
    CGSize size = [content sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(ScreenWidth - 60, 1000.0f) lineBreakMode:UILineBreakModeWordWrap];
    
    NSLog(@"3");
    
    //
    if (size.height > 50) {
        return size.height+32;
    }else{
        return 62;
    }
    
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ShanNianTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
//    CKRecord *record = [self.dataArr objectAtIndex:indexPath.row];
//    cell.textLabel.text = [record objectForKey:@"titleString"];
    
    LZDataModel *model = self.dataSourceArray[indexPath.row];
//    cell.textLabel.text = model.titleString;
    NSData *pcmData =  [self decodeEchoImageBaseWith:model.pcmData];
    if (model.colorString.length > 0) {
        cell.label.backgroundColor = [BCShanNianKaPianManager yingSheFromCOlorString:model.colorString];

    }else{
        cell.label.backgroundColor = [UIColor whiteColor];
    }


    if (indexPath.row == 1) {
        cell.label.backgroundColor  = PNCColor(164, 185, 277);
    }
    __weak typeof(self)weakSelf= self;
    [cell setContentModel:model];
  
    
//    cell.cellPlayBlock = ^{
//    
////        cell.label.hidden = YES;
//        [cell.contentView addSubview:_waveView];
//        [_waveView Animating];
//        _waveView.targetWaveHeight = 1;
//        
////        [weakSelf playPcmWith:pcmData];
//        
//        
//        _audioPlayer.playEnd = ^(BOOL playEnd) {
//            if (playEnd) {
//                //            _waveView.targetWaveHeight = 0;
//                //            [weakSelf.waveView stopAnimating];
//                [weakSelf.waveView stopAnimating];
//                [weakSelf.waveView removeFromSuperview];
//            }
//        };
//        
//    };
//    
 
    
    return cell;
}

- (WaveView *)waveView{
    if (!_waveView) {
        _waveView = [[WaveView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth  - kAUTOWIDTH(40), 52)];
        _waveView.backgroundColor = [UIColor whiteColor];
        _waveView.targetWaveHeight = 0;
    }
    return _waveView;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    LZDataModel *model = self.dataSourceArray[indexPath.row];
    self.modalPresentationStyle = UIModalPresentationCustom;
    self.transitioningDelegate = self;
    
//    ShanNianMuLuDetailViewController *mldVc = [[ShanNianMuLuDetailViewController alloc]init];
//    [self presentViewController:mldVc animated:YES completion:nil];
    
    MainTextViewController *mldVc = [[MainTextViewController alloc]init];
    mldVc.model = model;
    [self presentViewController:mldVc animated:YES completion:nil];
}




- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"数据删除后,不可恢复,是否确定删除?" preferredStyle:UIAlertControllerStyleAlert];
    
    LZWeakSelf(ws)
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [LZSqliteTool LZDeleteFromTable:LZSqliteDataTableName element:[ws.dataSourceArray objectAtIndex:indexPath.row]];
        [ws.dataSourceArray removeObjectAtIndex:indexPath.row];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        // 当为0时 删除分组?
        //        if (self.dataArray == 0) {
        //
        //            [LZSqliteTool LZDeleteFromGroupTable:LZSqliteGroupTableName element:self.groupModel];
        //        }
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:ok];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return @"删除";
}

-(NSData *)decodeEchoImageBaseWith:(NSString *)str{
    //先解base64
    NSData * decompressData =[[NSData alloc] initWithBase64EncodedString:str options:NSDataBase64DecodingIgnoreUnknownCharacters];
    //在解GZIP压缩
    NSData * decompressResultData = [BCShanNianKaPianManager decompressData:decompressData];
    return  decompressResultData;
}


- (void)playPcmWith:(NSData *)pcmData{
    
    NSError *error = nil;
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&error];
    _audioPlayer = [[PcmPlayer alloc] initWithData:pcmData sampleRate:[@"16000" integerValue]];
    [_audioPlayer play];
    
}


@end











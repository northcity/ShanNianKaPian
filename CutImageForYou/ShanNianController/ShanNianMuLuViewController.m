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
    [self loadData];
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
    return 62;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ShanNianTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    
//    CKRecord *record = [self.dataArr objectAtIndex:indexPath.row];
//    cell.textLabel.text = [record objectForKey:@"titleString"];
    
    LZDataModel *model = self.dataSourceArray[indexPath.row];
    cell.textLabel.text = model.titleString;
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
    
    cell.cellPlayBlock = ^{
    

//        CKAsset *pcmAsset = [record objectForKey:@"image"];
//        NSData *pcmData = [NSData dataWithContentsOfFile:pcmAsset.fileURL.path];
        [weakSelf playPcmWith:pcmData];
    };
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    LZDataModel *model = self.dataSourceArray[indexPath.row];
    self.modalPresentationStyle = UIModalPresentationCustom;
    self.transitioningDelegate = self;
    
    ShanNianMuLuDetailViewController *mldVc = [[ShanNianMuLuDetailViewController alloc]init];
    [self presentViewController:mldVc animated:YES completion:nil];
    

}

-(id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    self.isPresnted = YES;
    return self;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    self.isPresnted = NO;
    return self;
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 1.0;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    if (self.isPresnted == YES) {
        //1.取出view
        UIView *presentedView = [transitionContext viewForKey:UITransitionContextToViewKey];
        //2.放入containerView
        [[transitionContext containerView]addSubview:presentedView];
        //3.设置基本属性
        presentedView.alpha = 0;
        //4.动画
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            presentedView.alpha = 1.0;
        }completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
            
        }];
        
    } else {
        //1.取出view
        UIView *dismissedView = [transitionContext viewForKey:UITransitionContextFromViewKey];
        //2.放入containerView
        [[transitionContext containerView]addSubview:dismissedView];
        //3.设置基本属性
        dismissedView.alpha = 1;
        //4.动画
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            dismissedView.alpha = 0;
        }completion:^(BOOL finished) {
            
            [transitionContext completeTransition:YES];
        }];
    }
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











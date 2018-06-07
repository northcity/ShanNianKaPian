//
//  AppDelegate.m
//  CutImageForYou
//
//  Created by chenxi on 2018/5/11.
//  Copyright © 2018年 chenxi. All rights reserved.
//

#import "AppDelegate.h"
#import "LaunchViewController.h"
#import "ShanNianViewController.h"

// 10.18
#import "LZGestureTool.h"
#import "LZGestureScreen.h"
#import "TouchIdUnlock.h"
#import "LZSqliteTool.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self verifyPassword];
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    ShanNianViewController *Lvc = [[ShanNianViewController alloc]init];
    UINavigationController*nav = [[UINavigationController alloc]initWithRootViewController:Lvc];
    self.window.rootViewController = nav;
    
    //Set APPID
    NSString *initString = [[NSString alloc] initWithFormat:@"appid=%@",XUNFEIAPPID_VALUE];
    
    //Configure and initialize iflytek services.(This interface must been invoked in application:didFinishLaunchingWithOptions:)
    [IFlySpeechUtility createUtility:initString];
    
    [self chuShiHuaBomb];
    [self createSqlite];

    return YES;
}

- (void)createSqlite {
    
    [LZSqliteTool LZCreateSqliteWithName:LZSqliteName];
    [LZSqliteTool LZDefaultDataBase];
    [LZSqliteTool LZCreateDataTableWithName:LZSqliteDataTableName];
    [LZSqliteTool LZCreateGroupTableWithName:LZSqliteGroupTableName];
    [LZSqliteTool createPswTableWithName:LZSqliteDataPasswordKey];
    
    NSInteger groups = [LZSqliteTool LZSelectElementCountFromTable:LZSqliteGroupTableName];
    NSInteger count = [LZSqliteTool LZSelectElementCountFromTable:LZSqliteDataTableName];
    NSUserDefaults *us = [NSUserDefaults standardUserDefaults];
    BOOL isDataInit = [[us objectForKey:@"dataAlreadyInit"] boolValue];
//    if (count <= 0 && groups <= 0 && !isDataInit) {
//        [self creatData];
//    }
    
    NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
    BOOL isPswAlreadySaved = [[df objectForKey:@"pswAlreadySavedKey"] boolValue];
    
    if (!isPswAlreadySaved) {
        NSString *psw = [df objectForKey:@"redomSavedKey"];
        
        if (psw.length > 0) {
            
            [LZSqliteTool LZInsertToPswTable:LZSqliteDataPasswordKey passwordKey:LZSqliteDataPasswordKey passwordValue:psw];
        }
        
        [df setBool:YES forKey:@"pswAlreadySavedKey"];
    }
}


- (void)creatData {
    
//    LZGroupModel *group = [[LZGroupModel alloc]init];
//    group.groupName = @"未分组";
//
//    [LZSqliteTool LZInsertToGroupTable:LZSqliteGroupTableName model:group];
//
//    NSUserDefaults *us = [NSUserDefaults standardUserDefaults];
//    [us setBool:YES forKey:@"dataAlreadyInit"];
//    [us synchronize];
//
//    return;
//    LZGroupModel *group1 = [[LZGroupModel alloc]init];
//    group1.groupName = @"社交";
//
//    [LZSqliteTool LZInsertToGroupTable:LZSqliteGroupTableName model:group1];
    
//    LZGroupModel *group2 = [[LZGroupModel alloc]init];
//    group2.groupName = @"博客";
    
//    [LZSqliteTool LZInsertToGroupTable:LZSqliteGroupTableName model:group2];
    
    LZDataModel *model = [[LZDataModel alloc]init];
    model.userName = @"lqq200912408";
    model.nickName = @"流火绯瞳";
    model.password = @"123456789";
    model.urlString = @"http://blog.csdn.net/lqq200912408";
    model.groupName = @"博客";
    model.email = @"lqq200912408@163.com";
    model.dsc = @"CSDN博客";
//    model.groupID = group2.identifier;
    model.titleString = @"我草你妈";
    model.contentString = @"傻狗";
    model.colorString = @"二笔";
    
    [LZSqliteTool LZInsertToTable:LZSqliteDataTableName model:model];
    
    LZDataModel *model1 = [[LZDataModel alloc]init];
    model1.userName = @"302934443";
    model1.nickName = @"麦的守护";
    model1.password = @"123456789";
//    model1.groupID = group1.identifier;
    model1.groupName = @"社交";
    model1.email = @"302934443@qq.com";
    model1.dsc = @"QQ号";
    model1.titleString = @"我草你妈";
    model1.contentString = @"傻狗";
    model1.colorString = @"二笔";
    [LZSqliteTool LZInsertToTable:LZSqliteDataTableName model:model1];
    
    LZDataModel *model2 = [[LZDataModel alloc]init];
    model2.userName = @"lqq200912408";
    model2.nickName = @"追梦";
    model2.password = @"123456789";
    
    model2.groupName = @"未分组";
    model2.email = @"lqq200912408@163.com";
//    model2.groupID = group.identifier;
    model2.titleString = @"我草你妈";
    model2.contentString = @"傻狗";
    model2.colorString = @"二笔";
    
    [LZSqliteTool LZInsertToTable:LZSqliteDataTableName model:model2];
    
    LZDataModel *model3 = [[LZDataModel alloc]init];
    model3.userName = @"lqq200912408";
    model3.nickName = @"简书";
    model3.password = @"123456789";
    model3.urlString = @"http://blog.csdn.net/lqq200912408";
    model3.groupName = @"未分组";
//    model3.groupID = group.identifier;
    model3.titleString = @"我草你妈";
    model3.contentString = @"傻狗";
    model3.colorString = @"二笔";
    [LZSqliteTool LZInsertToTable:LZSqliteDataTableName model:model3];
}























- (void)verifyPassword {
    
    if ([LZGestureTool isGestureEnable]) {
        
        [[LZGestureScreen shared] show];
        
        if ([[TouchIdUnlock sharedInstance] canVerifyTouchID]) {
            
            [[TouchIdUnlock sharedInstance] startVerifyTouchID:^{
                
                [[LZGestureScreen shared] dismiss];
            }];
        }
    }
}

- (void)chuShiHuaBomb{
    [Bmob registerWithAppKey:@"075c9e426a01a48a81aa12305924e532"];
    
//                //往GameScore表添加一条playerName为小明，分数为78的数据
//                BmobObject *gameScore = [BmobObject objectWithClassName:@"appKaiGuan"];
//                [gameScore setObject:@"关" forKey:@"JiuGongGeDuLiApp"];
//                [gameScore saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
//    
//                }];
    
    
    NSString *nowStatus = [[NSUserDefaults standardUserDefaults] objectForKey:@"KaiGuanShiFouDaKai"];
    
    if ([nowStatus isEqualToString:@"开"]) {
        
    }else{
        //查找GameScore表
        BmobQuery   *bquery = [BmobQuery queryWithClassName:@"appKaiGuan"];
        //查找GameScore表里面id为0c6db13c的数据
        [bquery getObjectInBackgroundWithId:@"e337a46d78" block:^(BmobObject *object,NSError *error){
            if (error){
                //进行错误处理
            }else{
                //表里有id为0c6db13c的数据
                if (object) {
                    //得到playerName和cheatMode
                    NSString *KaiGuanStatus = [object objectForKey:@"JiuGongGeDuLiApp"];
                    NSLog(@"%@=========",KaiGuanStatus);
                    [[NSUserDefaults standardUserDefaults] setObject:KaiGuanStatus forKey:@"KaiGuanShiFouDaKai"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }
            }
        }];
    }
    
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [self verifyPassword];

}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end

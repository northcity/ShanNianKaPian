//
//  BCShanNianDateManager.m
//  CutImageForYou
//
//  Created by 北城 on 2018/6/4.
//  Copyright © 2018年 chenxi. All rights reserved.
//

#import "BCShanNianDateManager.h"
#import <CloudKit/CloudKit.h>


#define RECORD_TYPE_NAME   @"Note"

@implementation BCShanNianDateManager

+ (void)saveCloudKitModelWithTitle:(NSString *)title content:(NSString *)content photoImage:(UIImage *)image

{
    
    //获取容器
    
    CKContainer *container = [CKContainer defaultContainer];
    
    //公共数据
    
    CKDatabase *datebase = container.publicCloudDatabase;
    
    // //私有数据
    
    // CKDatabase *datebase = container.privateCloudDatabase;
    
    // //创建主键
    
    // CKRecordID *noteID = [[CKRecordID alloc] initWithRecordName:@"NoteID"];
    
    //创建保存数据
    
    CKRecord *noteRecord = [[CKRecord alloc] initWithRecordType:RECORD_TYPE_NAME];
    
    NSData *imageData = UIImagePNGRepresentation(image);
    
    if (imageData == nil)
        
    {
        
        imageData = UIImageJPEGRepresentation(image, 0.6);
        
    }
    
    NSString *tempPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/imagesTemp"];
    
    NSFileManager *manager = [NSFileManager defaultManager];
    
    if (![manager fileExistsAtPath:tempPath]) {
        
        [manager createDirectoryAtPath:tempPath withIntermediateDirectories:YES attributes:nil error:nil];
        
    }
    
    NSDate *dateID = [NSDate dateWithTimeIntervalSinceNow:0];
    
    NSTimeInterval timeInterval = [dateID timeIntervalSince1970] * 1000; //*1000表示到毫秒级，这样可以保证不会同时生成两个同样的id
    
    NSString *idString = [NSString stringWithFormat:@"%.0f", timeInterval];
    
    NSString *filePath = [NSString stringWithFormat:@"%@/%@",tempPath,idString];
    
    NSURL *url = [NSURL fileURLWithPath:filePath];
    
    [imageData writeToURL:url atomically:YES];
    
    CKAsset *asset = [[CKAsset alloc]initWithFileURL:url];
    
    [noteRecord setValue:title forKey:@"title"];
    
    [noteRecord setValue:content forKey:@"content"];
    
    [noteRecord setValue:asset forKey:@"photo"];
    
    [datebase saveRecord:noteRecord completionHandler:^(CKRecord * _Nullable record, NSError * _Nullable error) {
        
        if(!error)
            
        {
            
            NSLog(@"保存成功");
            
        }
        
        else
            
        {
            
            NSLog(@"保存失败");
            
            NSLog(@"%@",error.description);
            
        }
        
    }];
    
}

//查询数据

+ (void)queryCloudKitData

{
    
    //获取位置
    
    CKContainer *container = [CKContainer defaultContainer];
    
    CKDatabase *database = container.publicCloudDatabase;
    
    //添加查询条件
    
    NSPredicate *predicate = [NSPredicate predicateWithValue:YES];
    
    CKQuery *query = [[CKQuery alloc] initWithRecordType:RECORD_TYPE_NAME predicate:predicate];
    
    //开始查询
    
    [database performQuery:query inZoneWithID:nil completionHandler:^(NSArray<CKRecord *> * _Nullable results, NSError * _Nullable error) {
        
        NSLog(@"%@",results);
        
        //把数据做成字典通知出去
        
        NSDictionary *userinfoDic = [NSDictionary dictionaryWithObject:results forKey:@"key"];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"CloudDataQueryFinished" object:nil userInfo:userinfoDic];
        
    }];
    
}

//查询单条数据

+ (void)querySingleRecordWithRecordID:(CKRecordID *)recordID

{
    
    //获取容器
    
    CKContainer *container = [CKContainer defaultContainer];
    
    //获取公有数据库
    
    CKDatabase *database = container.publicCloudDatabase;
    
    [database fetchRecordWithID:recordID completionHandler:^(CKRecord * _Nullable record, NSError * _Nullable error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSLog(@"%@",record);
            
            //把数据做成字典通知出去
            
            NSDictionary *userinfoDic = [NSDictionary dictionaryWithObject:record forKey:@"key"];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"CloudDataSingleQueryFinished" object:nil userInfo:userinfoDic];
            
        });
        
    }];
    
}

//删除数据

+ (void)removeCloudKitDataWithRecordID:(CKRecordID *)recordID

{
    
    CKContainer *container = [CKContainer defaultContainer];
    
    CKDatabase *database = container.publicCloudDatabase;
    
    [database deleteRecordWithID:recordID completionHandler:^(CKRecordID * _Nullable recordID, NSError * _Nullable error) {
        
        if(error)
            
        {
            
            NSLog(@"删除失败");
            
        }
        
        else
            
        {
            
            NSLog(@"删除成功");
            
        }
        
    }];
    
}

//修改数据

+ (void)changeCloudKitWithTitle:(NSString *)title content:(NSString *)content photoImage:(UIImage *)image RecordID:(CKRecordID *)recordID

{
    
    //获取容器
    
    CKContainer *container = [CKContainer defaultContainer];
    
    //获取公有数据库
    
    CKDatabase *database = container.publicCloudDatabase;
    
    [database fetchRecordWithID:recordID completionHandler:^(CKRecord * _Nullable record, NSError * _Nullable error) {
        
        NSData *imageData = UIImagePNGRepresentation(image);
        
        if (imageData == nil)
            
        {
            
            imageData = UIImageJPEGRepresentation(image, 0.6);
            
        }
        
        NSString *tempPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/imagesTemp"];
        
        NSFileManager *manager = [NSFileManager defaultManager];
        
        if (![manager fileExistsAtPath:tempPath]) {
            
            [manager createDirectoryAtPath:tempPath withIntermediateDirectories:YES attributes:nil error:nil];
            
        }
        
        NSDate *dateID = [NSDate dateWithTimeIntervalSinceNow:0];
        
        NSTimeInterval timeInterval = [dateID timeIntervalSince1970] * 1000; //*1000表示到毫秒级，这样可以保证不会同时生成两个同样的id
        
        NSString *idString = [NSString stringWithFormat:@"%.0f", timeInterval];
        
        NSString *filePath = [NSString stringWithFormat:@"%@/%@",tempPath,idString];
        
        NSURL *url = [NSURL fileURLWithPath:filePath];
        
        [imageData writeToURL:url atomically:YES];
        
        CKAsset *asset = [[CKAsset alloc]initWithFileURL:url];
        
        [record setObject:title forKey:@"title"];
        
        [record setObject:content forKey:@"content"];
        
        [record setValue:asset forKey:@"photo"];
        
        [database saveRecord:record completionHandler:^(CKRecord * _Nullable record, NSError * _Nullable error) {
            
            if(error)
                
            {
                
                NSLog(@"修改失败 %@",error.description);
                
            }
            
            else
                
            {
                
                NSLog(@"修改成功");
                
            }
            
        }];
        
    }];
    
}



@end

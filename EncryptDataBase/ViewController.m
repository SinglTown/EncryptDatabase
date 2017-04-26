//
//  ViewController.m
//  EncryptDataBase
//
//  Created by 赵传保 on 17/4/26.
//  Copyright © 2017年 暗夜. All rights reserved.
//

#import "ViewController.h"
#import "sqlite3.h"

#define DB_SECRETKEY @"DB_SECRETKEY"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置
    //1.Build Setting搜索other c f找到Other C Flag添加如下内容
    /**
    -DSQLITE_HAS_CODEC
    -DSQLITE_THREADSAFE
    -DSQLCIPHER_CRYPTO_CC
    -DSQLITE_TEMP_STORE=2
     **/
    //2.Build Setting搜索other link找到Other Linker Flags添加如下内容
    /**
     -framework
     Security
     **/
    
    //关键代码 在FMDatabase中的146行和170行左右添加
    /**
     else{
     [self setKey:@""];//此处为加密key值
     }
     **/
    
    //若将未加密的数据库变为加密数据库
    //以下操作
    
    
}
#pragma mark - 如果有旧版未加密数据库,把旧版未加密的数据库文件拷贝一份到新的数据库
-(void)getOldDataBaseDataToNewDataEncryptedDataBase
{
    NSString *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSArray *subFile = [[NSFileManager defaultManager] subpathsAtPath:documentPath];
    for (NSString *fileName in subFile) {
        NSLog(@"document文件夹的文件==%@",fileName);
    }
    NSString *encrytedDBPath = [documentPath stringByAppendingPathComponent:@"AnyeEncryted.db"];
    NSString *oldDBPath = [documentPath stringByAppendingPathComponent:@"Anye.db"];
    const char *sql = [[NSString stringWithFormat:@"ATTACH DATABASE '%@' AS encrypted KEY '%@';", encrytedDBPath, DB_SECRETKEY] UTF8String];
    const char *exportSql = [[NSString stringWithFormat:@"SELECT sqlcipher_export('encrypted');"] UTF8String];
    const char *detachSql = [[NSString stringWithFormat:@"DETACH DATABASE encrypted;"] UTF8String];
    sqlite3 *unencrypted_DB = NULL;
    if(sqlite3_open([oldDBPath UTF8String], &unencrypted_DB) ==SQLITE_OK){
        int rc;
        char *errmsg = NULL;
        rc =sqlite3_exec(unencrypted_DB, sql,NULL,NULL, &errmsg);
        rc =sqlite3_exec(unencrypted_DB, exportSql,NULL,NULL, &errmsg);
        rc =sqlite3_exec(unencrypted_DB, detachSql,NULL,NULL, &errmsg);
        sqlite3_close(unencrypted_DB);
        //删除数据库
        /**
         if ([[NSFileManager defaultManager] fileExistsAtPath:oldDBPath]) {
         NSError *error;
         [[NSFileManager defaultManager] removeItemAtPath:oldDBPath error:&error];
         DLog(@"%@",error);
         [[AnyeDataManager sharedManager] dataBaseDealloc];
         }
         **/
    }else{
        sqlite3_close(unencrypted_DB);
        NSAssert1(NO,@"Failed to open database with message '%s'.", sqlite3_errmsg(unencrypted_DB));
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

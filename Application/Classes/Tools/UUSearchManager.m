//
//  ZXSearchManager.m
//  CartoonStar
//
//  Created by 尤锐 on 15/8/22.
//  Copyright (c) 2015年 尤锐. All rights reserved.
//

#import "ZXSearchManager.h"
#import "FMDatabase.h"
#define kTableName  @"searchtable"
@interface ZXSearchManager ()

@property (nonatomic,strong)FMDatabase *database;
@end
@implementation ZXSearchManager

static ZXSearchManager *manager = nil;

+ (ZXSearchManager *)sharedManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[ZXSearchManager alloc]init];
    });
    return manager;
    
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [super allocWithZone:zone];
    });
    return manager;
}

-(instancetype)init{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [super init];
        [manager prepare];
    });
    return manager;
}

- (void)prepare{
    
    NSString *dbPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/search.sqlite"];
    _database = [[FMDatabase alloc]initWithPath:dbPath];
    if ([_database open]) {
        NSLog(@"打开数据库成功");
    }else{
        return;
    }
    
    NSString *sql = [NSString stringWithFormat:@"create table if not exists %@(searchtext varchar(128))",kTableName];
    BOOL isSuccess = [self.database executeUpdate:sql];
    if (isSuccess) {
        NSLog(@"创表成功");
    }
    [self.database close];
}

- (BOOL)insert:(NSString *)string{
    [_database open];
    NSString *sql = [NSString stringWithFormat:@"insert into %@ values(?)",kTableName];
    BOOL isSuccess = [_database executeUpdate:sql,string];
    if (isSuccess) {
        NSLog(@"插入成功");
    }else{
        NSLog(@"插入失败");
    }
    [_database close];
    return isSuccess;
}

- (BOOL)delete:(NSString *)string{
    [_database open];
    
    NSString *sql = [NSString stringWithFormat:@"delete from %@ where searchtext=?",kTableName];
    BOOL isSuccess = [_database executeUpdate:sql,string];
    if (isSuccess) {
        NSLog(@"删除成功");
    }else{
        NSLog(@"删除失败");
    }
    [_database close];
    return isSuccess;
}

- (NSMutableArray *)fetchAll{
    [_database open];
    NSString *sql = [NSString stringWithFormat:@"select * from %@",kTableName];
    FMResultSet *set = [_database executeQuery:sql];
    NSMutableArray *array = [[NSMutableArray alloc]init];
    while ([set next]) {
        NSString *string = [set stringForColumn:@"searchtext"];
        [array addObject:string];
    }
    [_database close];
    return array;
}
- (BOOL)deleteAll{
    [_database open];
    NSString *sql = [NSString stringWithFormat:@"delete from %@",kTableName];
    BOOL isSuccess = [_database executeUpdate:sql];
    [_database close];
    return isSuccess;
}

@end

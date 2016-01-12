//
//  ZXHistoryManager.m
//  CartoonStar
//
//  Created by 尤锐 on 15/8/24.
//  Copyright (c) 2015年 尤锐. All rights reserved.
//

#import "ZXHistoryManager.h"
#import "FMDatabase.h"
#import "ZXLIstModel.h"

#define kTableName @"history"
@interface ZXHistoryManager ()

@property (nonatomic,strong)FMDatabase *database1;

@end

@implementation ZXHistoryManager

static ZXHistoryManager *manager1 = nil;
+ (ZXHistoryManager *)sharedManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager1 = [[ZXHistoryManager alloc]init];
    });
    return manager1;
    
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager1 = [super allocWithZone:zone];
    });
    return manager1;
}

-(instancetype)init{
    if (self = [super init]) {
        [manager1  prepare];
    }
    
    return self;
}
- (void)prepare{
    //NSLog(@"%@",NSHomeDirectory());
    
    NSString *dbPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/history.sqlite"];
    if (!_database1) {
        NSLog(@"ddd");
        _database1 = [[FMDatabase alloc]initWithPath:dbPath];
    }
    
    if ([_database1 open]) {
        NSLog(@"打开数据库成功");
    }else{
        return;
    }
    NSString *sql = [NSString stringWithFormat:@"create table if not exists %@(comicid integer primary key autoincrement not null,name varchar(128),cover varchar(1024),chapter_name varchar(128))",kTableName];
    BOOL isSuccess = [self.database1 executeUpdate:sql];
    [_database1 close];
    if (isSuccess) {
        NSLog(@"创表成功");
    }
    
}
- (BOOL)insert:(ZXLIstModel *)model andChapterName:(NSString *)chapterName{
    [_database1 open];
    NSString *sql = [NSString stringWithFormat:@"insert into %@ values(?,?,?,?)",kTableName];
    BOOL isSuccess = [self.database1 executeUpdate:sql,model.comic_id,model.name,model.cover,chapterName];
    [_database1 close];
    return isSuccess;
    
}
- (BOOL)delete:(ZXLIstModel *)model{
    return [self deleteById:model.comic_id];
}
- (BOOL)deleteById:(NSString *)comic_id{
    [_database1 open];
    NSString *sql = [NSString stringWithFormat:@"delete from %@ where comicid=?",kTableName];
    BOOL isSuccess = [_database1 executeUpdate:sql,comic_id];
    [_database1 close];
    return isSuccess;
}
- (NSMutableArray *)fetchAll{
    [_database1 open];
    NSString *sql = [NSString stringWithFormat:@"select * from %@",kTableName];
    FMResultSet *set = [_database1 executeQuery:sql];
    NSMutableArray *array = [NSMutableArray array];
    while ([set next]) {
        ZXLIstModel *model = [[ZXLIstModel alloc]init];
        model.comic_id = [NSString stringWithFormat:@"%d",[set intForColumn:@"comicid"]];
        model.name = [set stringForColumn:@"name"];
        model.cover = [set stringForColumn:@"cover"];
        model.author_name = [set stringForColumn:@"chapter_name"];
        [array addObject:model];
    }
    [_database1 close];
    return array;
}
- (BOOL)findModel:(ZXLIstModel *)model{
    [_database1 open];
    NSString *sql = [NSString stringWithFormat:@"select count(*) from %@ where comicid=?",kTableName];
    FMResultSet *set = [self.database1 executeQuery:sql,model.comic_id];
    int count = 0;
    while ([set next]) {
        count = [set intForColumnIndex:0];
    }
    [_database1 close];
    return count;
}
- (BOOL)deleteAll{
    [_database1 open];
    NSString *sql = [NSString stringWithFormat:@"delete from %@",kTableName];
    BOOL isSuccess = [_database1 executeUpdate:sql];
    [_database1 close];
    return isSuccess;
}



@end

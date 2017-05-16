//
//  CacheTool.m
//  DingYouMing
//
//  Created by ceyu on 2017/2/21.
//  Copyright © 2017年 吴宏佳. All rights reserved.
//

#import "CacheTool.h"
///第三方类
#import "FMDB.h"
#import <BaiduMapAPI_Search/BMKPoiSearchType.h>
#import "PackageEntranceObj.h"

#define CacheFile [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"Cache.sqlite"]

@implementation CacheTool


static FMDatabaseQueue *_queue;

+ (void)initialize
{
    // 0.获得沙盒中的数据库文件名
    NSLog(@"%@",CacheFile);
    // 1.创建队列
    _queue = [FMDatabaseQueue databaseQueueWithPath:CacheFile];
    
    // 2.创表
    [_queue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"CREATE TABLE IF NOT EXISTS address (id integer primary key autoincrement, address TEXT, name TEXT ,latitude REAL,longitude REAL)"];
        [db executeUpdate:@"CREATE TABLE IF NOT EXISTS packageEntrance ( img TEXT, name TEXT , id INTEGER)"];
        
        //
        //        [db executeUpdate:@"create table if not exists SubMenus (id integer primary key autoincrement, subMenu_ID text, name text);"];
    }];
}
#pragma mark - BMKPoiInfo相关
+(void)addBMKPoiInfo:(BMKPoiInfo *)poiInfo{
    
    [_queue inDatabase:^(FMDatabase *db) {
        
        FMResultSet *rs = nil;
        rs = [db executeQueryWithFormat:@"SELECT address FROM address where address = %@ ",poiInfo.address];
        
        if (!rs.next) {
            BOOL loob =   [db executeUpdateWithFormat:@"INSERT  INTO address (address, name , latitude  ,longitude) values(%@,%@,%f,%f)", poiInfo.address,poiInfo.name,poiInfo.pt.latitude,poiInfo.pt.longitude];
            if (!loob) {
                NSLog(@"数据存储-失败！");
            }
        }
        [rs close];
        
    }];
    
}
+ (NSArray<BMKPoiInfo*> *)obtainBMKPoiInfos{
    
    // 1.定义数组
    __block NSMutableArray *poiInfos = nil;
    
    // 2.使用数据库
    [_queue inDatabase:^(FMDatabase *db) {
        // 创建数组
        poiInfos = [NSMutableArray array];
        FMResultSet *rs = nil;
        rs = [db executeQuery:@"SELECT * FROM address ORDER BY id DESC  "];
        while (rs.next) {
            BMKPoiInfo *poiInfo = [[BMKPoiInfo alloc]init];
            poiInfo.name = [rs stringForColumn:@"name"];
            poiInfo.address = [rs stringForColumn:@"address"];
            CLLocationDegrees latitude = [rs doubleForColumn:@"latitude"];
            CLLocationDegrees longitude = [rs doubleForColumn:@"longitude"];
            poiInfo.pt = CLLocationCoordinate2DMake( latitude, longitude);
            
            [poiInfos addObject:poiInfo];
        }
        
        [rs close];
    }];
    
    // 3.返回数据
    return poiInfos;
}

#pragma mark - PackageEntranceObj相关
+(void)addPackageEntranceObjs:(NSArray <PackageEntranceObj*>*)packageEntranceObjs{
    
    [_queue inDatabase:^(FMDatabase *db) {
        
        for (PackageEntranceObj *obj in packageEntranceObjs) {
            
            FMResultSet *rs = nil;
            rs = [db executeQueryWithFormat:@"SELECT id FROM packageEntrance where id = %d ",obj.ID ];
            
            if (!rs.next) {
                BOOL loob =   [db executeUpdateWithFormat:@"INSERT  INTO packageEntrance (id ,img, name ) values(%d,%@,%@)", obj.ID,obj.img,obj.name];
                if (!loob) {
                    NSLog(@"数据存储-失败！");
                }
            }
            [rs close];
        }
    }];
    
}

+ (NSArray<PackageEntranceObj*> *)obtainPackageEntranceObjs{
    // 1.定义数组
    __block NSMutableArray *packageEntranceObjs = nil;
    
    // 2.使用数据库
    [_queue inDatabase:^(FMDatabase *db) {
        // 创建数组
        packageEntranceObjs = [NSMutableArray array];
        FMResultSet *rs = nil;
        rs = [db executeQuery:@"SELECT * FROM packageEntrance "];
        while (rs.next) {
            PackageEntranceObj *obj = [[PackageEntranceObj alloc]init];
            obj.name = [rs stringForColumn:@"name"];
            obj.img = [rs stringForColumn:@"img"];
            obj.ID  = [rs intForColumn:@"id"];
            
            [packageEntranceObjs addObject:obj];
        }
        
        [rs close];
    }];
    
    // 3.返回数据
    return packageEntranceObjs;
}
#pragma mark - 数据删除

+(void)removeHuoWuMenuDatas{
    [_queue inDatabase:^(FMDatabase *db) {
        // 删除数据
        BOOL loob =  [db executeUpdate:@"DELETE FROM address "];
        loob =  [db executeUpdate:@"DELETE FROM packageEntrance "];
        //        loob =  [db executeUpdate:@"DELETE FROM SubMenus "];
        if (loob) {
            NSLog(@"数据删除成功！");
        }else{
            NSLog(@"数据删除—失败！");
            
        }
    }];
    
}

+(BOOL)removeHuoWuMenuFile{
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    BOOL bRet = [fileMgr fileExistsAtPath:CacheFile];
    if (bRet) {
        //
        NSError *err;
        return  [fileMgr removeItemAtPath:CacheFile error:&err];
        
    }
    return bRet;
}

@end

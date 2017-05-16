//
//  CacheTool.h
//  DingYouMing
//
//  Created by ceyu on 2017/2/21.
//  Copyright © 2017年 吴宏佳. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BMKPoiInfo;
@class PackageEntranceObj;
@interface CacheTool : NSObject


#pragma mark - BMKPoiInfo相关
///查询 地址 数据
+(NSArray<BMKPoiInfo*> *)obtainBMKPoiInfos;
///存储 地址 数据
+(void)addBMKPoiInfo:(BMKPoiInfo *)poiInfo;

#pragma mark - PackageEntranceObj相关
///查询 套餐区 数据
+(void)addPackageEntranceObjs:(NSArray <PackageEntranceObj*>*)packageEntranceObjs;
///存储 套餐区 数据
+ (NSArray<PackageEntranceObj*> *)obtainPackageEntranceObjs;


#pragma mark - 数据删除
///删除数据
+(void)removeHuoWuMenuDatas;
///删除文件
+(BOOL)removeHuoWuMenuFile;
@end

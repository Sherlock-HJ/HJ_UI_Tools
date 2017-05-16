//
//  LocationTool.h
//  YiXiXinCourier
//
//  Created by ceyu on 2017/2/13.
//  Copyright © 2017年 吴宏佳. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BaiduMapAPI_Base/BMKMapManager.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Base/BMKTypes.h>

typedef void(^GetUserLocationBlock)(BMKUserLocation* userLocation);
typedef void(^GetAddressBlock)(BMKReverseGeoCodeResult* addressResult);
typedef void(^GetSuggestionBlock)(BMKSuggestionResult* suggestionResult);

@interface LocationTool : NSObject

/**当前地址*/
@property (strong, nonatomic,readonly) NSString* address;

///单例--注册APPKEY
+(instancetype)shareLocationTool;

///当前经纬度
-(void)currentUserLocation:(GetUserLocationBlock)block;

///当前地址
-(void)currentAddress:(GetAddressBlock)block;

@end

@interface NSString (SuggestionAddress)
///在线地址查询建议结果集
-(void)suggestionResult:(GetSuggestionBlock)block;

@end

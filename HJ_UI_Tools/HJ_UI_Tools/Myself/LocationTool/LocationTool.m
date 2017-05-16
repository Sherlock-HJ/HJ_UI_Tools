//
//  LocationTool.m
//  YiXiXinCourier
//
//  Created by ceyu on 2017/2/13.
//  Copyright © 2017年 吴宏佳. All rights reserved.
//

#import "LocationTool.h"
typedef void(^LocationEndBlock)(void);

@interface LocationTool ()<BMKGeneralDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate,BMKSuggestionSearchDelegate>
{
    BMKMapManager *_mapManager;
    
}
@property (strong, nonatomic) BMKLocationService *locationService;
@property (strong, nonatomic) BMKGeoCodeSearch *geoCodeSearch;
@property (strong, nonatomic) BMKSuggestionSearch* suggestionSearcher;
@property (copy, nonatomic) LocationEndBlock locationEndBlock;



@property (assign, nonatomic) BOOL permissionState;
/**当前地址*/
@property (strong, nonatomic) NSString* address;
///当前城市
@property (strong, nonatomic) NSString* city;


@property (copy, nonatomic) GetAddressBlock addressBlock;
@property (copy, nonatomic) GetSuggestionBlock suggestionBlock;
@property (copy, nonatomic) GetUserLocationBlock userLocationBlock;

@end

@implementation LocationTool
+(instancetype)shareLocationTool{
    static LocationTool *tool ;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tool = [[self alloc]init];
    });
    return tool;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _mapManager = [[BMKMapManager alloc]init];
        // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
        BOOL ret = [_mapManager start:@"RKkFf9PULZiw67vIgeHBoIIpnMx4bGgZ"  generalDelegate:self];
        if (!ret) {
            NSLog(@"manager start 失败!");
        }
        
    }
    return self;
}
#pragma mark - 重写set
-(void)setPermissionState:(BOOL)permissionState{
    _permissionState = permissionState;
    if (permissionState) {
        if (self.locationEndBlock) {
            self.locationEndBlock();
        }
    }
}
#pragma mark - 重写get
-(BMKLocationService *)locationService{
    if (!_locationService) {
        _locationService = [[BMKLocationService alloc]init];
        _locationService.delegate = self;
    }
    return _locationService;
}
-(BMKGeoCodeSearch *)geoCodeSearch{
    
    if (!_geoCodeSearch) {
        _geoCodeSearch = [[BMKGeoCodeSearch alloc]init];
        _geoCodeSearch.delegate = self;
        
    }
    return _geoCodeSearch;
}
-(BMKSuggestionSearch *)suggestionSearcher{
    if (!_suggestionSearcher) {
        _suggestionSearcher = [[BMKSuggestionSearch alloc]init];
        _suggestionSearcher.delegate = self;
        
    }
    return _suggestionSearcher;
}
#pragma mark - BMKGeneralDelegate
-(void)onGetNetworkState:(int)iError{
    if (E_PERMISSIONCHECK_OK == iError) {
        NSLog(@"地图成功!");
    }else{
        NSLog(@"地图失败!");
        
    }
    
}
-(void)onGetPermissionState:(int)iError{
    
    if (E_PERMISSIONCHECK_OK == iError) {
        NSLog(@"地图授权成功!");
        self.permissionState = YES;
        
    }else{
        NSLog(@"地图授权失败!");
        self.permissionState = NO;
        
    }
}
#pragma mark - BMKLocationServiceDelegate

- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{
    
    BMKReverseGeoCodeOption *reverse = [[BMKReverseGeoCodeOption alloc]init];
    reverse.reverseGeoPoint = userLocation.location.coordinate;
    if (self.userLocationBlock) {
        self.userLocationBlock(userLocation);
    }else{
        BOOL loob = [self.geoCodeSearch reverseGeoCode:reverse];
        if (!loob) {
            
        }
    }
    
    
    [self.locationService stopUserLocationService];
    self.locationService.delegate = nil;
    self.locationService = nil;
}
#pragma mark - BMKGeoCodeSearchDelegate
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
    
    if (error == BMK_SEARCH_NO_ERROR) {
        self.address = result.address;
        self.city = result.addressDetail.city;
        if (self.addressBlock) {
            self.addressBlock(result);
        }
        
    }else{
        
    }
    
    self.geoCodeSearch.delegate = nil;
    self.geoCodeSearch = nil;
}
#pragma mark -     发起在线建议检索
-(void)suggestionSearchBegin:(NSString*)key{
    if (key.length == 0) return;
    
    BMKSuggestionSearchOption* option = [[BMKSuggestionSearchOption alloc] init];
    option.keyword  = key;
    option.cityname  = self.city;
    option.cityLimit = YES;
    BOOL flag = [self.suggestionSearcher suggestionSearch:option];
    if(flag)
    {
        NSLog(@"建议检索发送成功");
    }
    else
    {
        NSLog(@"建议检索发送失败");
    }
    
}
#pragma mark - BMKSuggestionSearchDelegate
//在线建议 回调结果
- (void)onGetSuggestionResult:(BMKSuggestionSearch*)searcher result:(BMKSuggestionResult*)result errorCode:(BMKSearchErrorCode)error{
    if (error == BMK_SEARCH_NO_ERROR) {
        // 在此处理正常结果
        if (self.suggestionBlock) {
            self.suggestionBlock(result);
        }
        
    }
    else {
        NSLog(@"抱歉，未找到结果");
    }
}
#pragma mark - 当前位置
-(void)currentUserLocation:(GetUserLocationBlock)block{
    if (self.permissionState) {
        [self.locationService startUserLocationService];
        
    }else{
        __weak __typeof(self)wself = self;
        self.locationEndBlock = ^{
            [wself.locationService startUserLocationService];
        };
    }
    
    self.userLocationBlock = block;

}
#pragma mark - 当前地址
-(void)currentAddress:(GetAddressBlock)block{
    
    if (self.permissionState) {
        [self.locationService startUserLocationService];
        
    }else{
        __weak __typeof(self)wself = self;
        self.locationEndBlock = ^{
            [wself.locationService startUserLocationService];
        };
    }
    
    self.addressBlock = block;
}
#pragma mark -  地址搜索结果集
-(void)suggestionText:(NSString*)text Result:(GetSuggestionBlock)block{
    if (self.permissionState) {
        [self suggestionSearchBegin:text];
        
    }else{
        __weak __typeof(self)wself = self;
        self.locationEndBlock = ^{
            [wself suggestionSearchBegin:text];
        };
    }
    self.suggestionBlock = block;
    
}
@end
@implementation NSString (Tool)
-(void)suggestionResult:(GetSuggestionBlock)block{
    
    [[LocationTool shareLocationTool] suggestionText:self Result:block];
    
}

@end

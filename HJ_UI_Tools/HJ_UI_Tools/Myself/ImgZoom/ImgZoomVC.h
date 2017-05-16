//
//  ImgZoomVC.h
//  CeDaYeWu
//
//  Created by ceyu on 2017/4/6.
//  Copyright © 2017年 吴宏佳. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImgZoomVC : UICollectionViewController
/**图片地址数组*/
@property (copy, nonatomic) NSArray<NSString*>* imgURLs;

@end


@protocol ImgZoomCellDelegate <NSObject>

@required
-(void)back;

@end

@interface ImgZoomCell : UICollectionViewCell
/**图片地址*/
@property (copy, nonatomic) NSString* imgURL;

@property (weak, nonatomic) id<ImgZoomCellDelegate> delegate;

@end

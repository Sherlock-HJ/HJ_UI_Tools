//
//  QrCodeScanningVC.h
//  KuGuan
//
//  Created by ceyu on 16/7/21.
//  Copyright © 2016年 吴宏佳. All rights reserved.
//

#import <UIKit/UIKit.h>
@class QrCodeScanningVC;
@protocol QrCodeScanningVCDelegate <NSObject>
@optional
-(void)scanSuccess:(QrCodeScanningVC*)qrCodeScanningVC withString:(NSString*)string;

@end

@interface QrCodeScanningVC : UIViewController
/**代理*/
@property (weak, nonatomic) id<QrCodeScanningVCDelegate> delegate;

@property (strong, nonatomic) id object;

@end

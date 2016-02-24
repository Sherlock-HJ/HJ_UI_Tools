//
//  SudokuModel.h
//  officeHelper
//
//  Created by whj0123 on 16/1/3.
//  Copyright © 2016年 whj0123. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
/**控件frame  循环标签*/
typedef void(^SudokuBlock)(CGRect frame,NSInteger index );
/**九宫格*/
@interface HJSudokuModel : NSObject
/**@sudokuY九宫格y坐标
 @cellWidth 控件宽度
 @height 控件高度
 @column 控件列数
 @total 控件总个数
 @sudokuBlock 控件frame  循环标签
 */
+ (void)sudokuWithsudokuY:(CGFloat)sudokuY Width:(CGFloat)cellWidth height:(CGFloat)cellHeight column:(NSInteger)column total:(NSInteger)total block:(SudokuBlock)sudokuBlock;

@end

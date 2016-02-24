//
//  SudokuModel.m
//  officeHelper
//
//  Created by whj0123 on 16/1/3.
//  Copyright © 2016年 whj0123. All rights reserved.
//

#import "HJSudokuModel.h"
#define widthView  [UIScreen mainScreen].bounds.size.width

@implementation HJSudokuModel 


+ (void)sudokuWithsudokuY:(CGFloat)sudokuY Width:(CGFloat)cellWidth height:(CGFloat)cellHeight column:(NSInteger)column total:(NSInteger)total block:(SudokuBlock)sudokuBlock
{
    CGFloat gap = (widthView - (column * cellWidth))/(column + 1);
    for (NSInteger index = 0; index < total; index++) {
        NSInteger row = index/column;
        NSInteger col = index%column;
        CGFloat demoViewX = gap +(cellWidth + gap)*col;
        CGFloat demoViewY = sudokuY +(cellHeight + gap)*row;

        sudokuBlock(CGRectMake(demoViewX, demoViewY, cellWidth, cellHeight),index);
        
    }
}
@end


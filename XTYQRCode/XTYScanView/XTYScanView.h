//
//  XTYScanView.h
//  JingXi
//
//  Created by lakala on 15/5/13.
//  Copyright (c) 2015年 lakala.com. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  二维码扫描覆盖层
 */
@interface XTYScanView : UIView
//提示内容 默认是:(把二维码放入框内,即可自动扫描)
@property(nonatomic,strong)NSString *tipsText;
//扫描线  默认是绿色
@property(nonatomic,strong)UIImage *scanLine;
/**
 *  停止timer
 */
-(void)stopTimer;
/**
 *  通过RGB 设置边角颜色 (默认是绿色)
 *
 *  @param red   红
 *  @param green 绿
 *  @param blue  蓝
 *  @param alpha 透明度
 */
-(void)setCornerColorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha;
@end

//
//  XTYScanView.m
//  JingXi
//
//  Created by lakala on 15/5/13.
//  Copyright (c) 2015年 lakala.com. All rights reserved.
//

#import "XTYScanView.h"
#define ScreenHeight [[UIScreen mainScreen] bounds].size.height
#define ScreenWidth [[UIScreen mainScreen] bounds].size.width
static NSTimeInterval XTYLineanimateDuration = 0.01;
@interface XTYScanView ()
{
    UIImageView *qrLine;
    CGFloat qrLineY;
    CGFloat scanArea;
    NSTimer *timer;
    CGFloat _red;
    CGFloat _green;
    CGFloat _blue;
    CGFloat _alpha;
}

@end
@implementation XTYScanView
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        scanArea = frame.size.width/3*2;
    }
    return self;
}
-(void)stopTimer
{
    [timer invalidate];
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    if (!qrLine) {
        qrLine = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width/2-scanArea/2, (self.frame.size.height-64) /2-scanArea/2, scanArea, 2)];
        if (self.scanLine) {
            qrLine.image = self.scanLine;
        }else
            qrLine.image = [UIImage imageNamed:@"line"];
        qrLine.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:qrLine];
        qrLineY = qrLine.frame.origin.y;
         timer = [NSTimer scheduledTimerWithTimeInterval:XTYLineanimateDuration target:self selector:@selector(show) userInfo:nil repeats:YES];
        [timer fire];
        
        UILabel *tipsLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, qrLine.frame.origin.y-40, self.frame.size.width, 30)];
        tipsLabel.font = [UIFont systemFontOfSize:15];
        tipsLabel.text = self.tipsText?self.tipsText:@"把二维码放入框内,即可自动扫描";
        tipsLabel.textColor = [UIColor whiteColor];
        tipsLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:tipsLabel];
    }
}
/**
 *  显示扫描条上下移动
 */
- (void)show {
    
    [UIView animateWithDuration:XTYLineanimateDuration animations:^{
        
        CGRect rect = qrLine.frame;
        rect.origin.y = qrLineY;
        qrLine.frame = rect;
        
    } completion:^(BOOL finished) {
        
        CGFloat maxBorder = (self.frame.size.height-64)/ 2 + scanArea/ 2 - 4;
        if (qrLineY > maxBorder) {
            
            qrLineY = (self.frame.size.height-64)/ 2 - scanArea /2;
        }
        qrLineY++;
    }];
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGRect screenDrawRect = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    CGRect clearDrawRect = CGRectMake(rect.size.width/2-scanArea/2, (rect.size.height -64)/2-scanArea/2,scanArea, scanArea);
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    [self addScreenFillRect:contextRef rect:screenDrawRect];
    [self addCenterClearRect:contextRef rect:clearDrawRect];
    [self addWhiteRect:contextRef rect:clearDrawRect];
    [self addCornerLineWithContext:contextRef rect:clearDrawRect];
}
/**
 *  画笔填充view的其他区域(除中间之外)
 *
 *  @param ctx  画笔
 *  @param rect rect
 */
- (void)addScreenFillRect:(CGContextRef)contextRef rect:(CGRect)rect {
    
    CGContextSetRGBFillColor(contextRef, 40 / 255.0,40 / 255.0,40 / 255.0,0.5);
    CGContextFillRect(contextRef, rect);
}
/**
 *  清除中心矩形范围
 *
 *  @param ctx  CGContextRef对象
 *  @param rect frame
 */
- (void)addCenterClearRect :(CGContextRef)contextRef rect:(CGRect)rect {
    
    CGContextClearRect(contextRef, rect);
}
/**
 *  添加白色边框线
 *
 *  @param ctx  CGContextRef对象
 *  @param rect 需要添加白线的frame
 */
- (void)addWhiteRect:(CGContextRef)contextRef rect:(CGRect)rect {
    
    CGContextStrokeRect(contextRef, rect);
    CGContextSetRGBStrokeColor(contextRef, 1, 1, 1, 1);
    CGContextSetLineWidth(contextRef, 0.8);
    CGContextAddRect(contextRef, rect);
    CGContextStrokePath(contextRef);
}
bool isSetCornerColor ;
-(void)setCornerColorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha
{
    _red = red;
    _green = green;
    _blue = blue;
    _alpha = alpha;
    isSetCornerColor = YES;
}
/**
 *  添加四个边角
 *
 *  @param ctx  CGContextRef对象
 *  @param rect 该区域的frame
 */
- (void)addCornerLineWithContext:(CGContextRef)contextRef rect:(CGRect)rect{
    
    CGContextSetLineWidth(contextRef, 2);
    if (isSetCornerColor) {
         CGContextSetRGBStrokeColor(contextRef, _red /255.0, _green/255.0, _blue/255.0, 1);
    }else
        CGContextSetRGBStrokeColor(contextRef, 84 /255.0, 216/255.0, 56/255.0, 1);
    
    CGPoint poinsTopLeftA[] = {
        CGPointMake(rect.origin.x+0.7, rect.origin.y),
        CGPointMake(rect.origin.x+0.7 , rect.origin.y + 15)
    };
    
    CGPoint poinsTopLeftB[] = {CGPointMake(rect.origin.x, rect.origin.y +0.7),CGPointMake(rect.origin.x + 15, rect.origin.y+0.7)};
    [self addLine:poinsTopLeftA pointB:poinsTopLeftB ctx:contextRef];
    
    //左下角
    CGPoint poinsBottomLeftA[] = {CGPointMake(rect.origin.x+ 0.7, rect.origin.y + rect.size.height - 15),CGPointMake(rect.origin.x +0.7,rect.origin.y + rect.size.height)};
    CGPoint poinsBottomLeftB[] = {CGPointMake(rect.origin.x , rect.origin.y + rect.size.height - 0.7) ,CGPointMake(rect.origin.x+0.7 +15, rect.origin.y + rect.size.height - 0.7)};
    [self addLine:poinsBottomLeftA pointB:poinsBottomLeftB ctx:contextRef];
    
    //右上角
    CGPoint poinsTopRightA[] = {CGPointMake(rect.origin.x+ rect.size.width - 15, rect.origin.y+0.7),CGPointMake(rect.origin.x + rect.size.width,rect.origin.y +0.7 )};
    CGPoint poinsTopRightB[] = {CGPointMake(rect.origin.x+ rect.size.width-0.7, rect.origin.y),CGPointMake(rect.origin.x + rect.size.width-0.7,rect.origin.y + 15 +0.7 )};
    [self addLine:poinsTopRightA pointB:poinsTopRightB ctx:contextRef];
    
    CGPoint poinsBottomRightA[] = {CGPointMake(rect.origin.x+ rect.size.width -0.7 , rect.origin.y+rect.size.height+ -15),CGPointMake(rect.origin.x-0.7 + rect.size.width,rect.origin.y +rect.size.height )};
    CGPoint poinsBottomRightB[] = {CGPointMake(rect.origin.x+ rect.size.width - 15 , rect.origin.y + rect.size.height-0.7),CGPointMake(rect.origin.x + rect.size.width,rect.origin.y + rect.size.height - 0.7 )};
    [self addLine:poinsBottomRightA pointB:poinsBottomRightB ctx:contextRef];
    CGContextStrokePath(contextRef);
}
- (void)addLine:(CGPoint[])pointA pointB:(CGPoint[])pointB ctx:(CGContextRef)contextRef {
    CGContextAddLines(contextRef, pointA, 2);
    CGContextAddLines(contextRef, pointB, 2);
}
@end

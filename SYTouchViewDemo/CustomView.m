//
//  CustomView.m
//  SYTouchViewDemo
//
//  Created by sunyu on 16/4/25.
//  Copyright © 2016年 sunyu. All rights reserved.
//

#import "CustomView.h"

@interface CustomView ()

@property (nonatomic, copy) void (^touchBlock)(CGPoint touchPoint);

@property (nonatomic, assign) CGSize startSize;

@end

@implementation CustomView

- (instancetype)initWithTouchBlock:(void(^)(CGPoint touchPoint))touchBlock
{
    if (self = [super init]) {
        _coordinates = [NSMutableArray array];
        
        _touchBlock = touchBlock;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onTapClick:)];
        [self addGestureRecognizer:tap];
        
        UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(onPinchClick:)];
        [self addGestureRecognizer:pinch];
        
        
    }
    return self;
}

- (void)onTapClick:(UITapGestureRecognizer *)sender
{
    if (_touchBlock) {
        CGPoint touchPoint = [sender locationInView:self];
        _touchBlock(touchPoint);
    }
}

- (void)onPinchClick:(UIPinchGestureRecognizer *)pinch
{
    if (UIGestureRecognizerStateBegan == pinch.state) {
        _startSize = self.frame.size;
    }
    
    CGRect frame = self.frame;
    frame.size = CGSizeMake(_startSize.width*pinch.scale, _startSize.height*pinch.scale);
    self.frame = frame;
    if (_drawCompleteBlock) {
        _drawCompleteBlock(self);
    }
}



//设置图片并设置控件初始大小
- (void)setImage:(UIImage *)image
{
    _image = image;
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, _image.size.width, _image.size.height);
    [self setNeedsDisplay];
}

//设置数据
-(void)setDicOfARequestareasArr:(NSMutableArray *)dicOfARequestareasArr
{
    _dicOfARequestareasArr = dicOfARequestareasArr;
    [self setNeedsDisplay];
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    [self setBackgroundColor:[UIColor whiteColor]];
}

//绘制控件内容
- (void)drawRect:(CGRect)rect
{
    //绘制图像
    [_image drawInRect:rect];
    
    //这部分跟原来一样，没有任何区别
    CGContextRef context = UIGraphicsGetCurrentContext();
    for (NSInteger i = 0; i < _dicOfARequestareasArr.count; i++) {
        
        SYCoordinatesModel *model = [[SYCoordinatesModel alloc]init];
        
        NSMutableArray *area = [_dicOfARequestareasArr[i] valueForKey:@"area"];
        model.name = [_dicOfARequestareasArr[i] valueForKey:@"name"];
        
        CGPoint aPoints[area.count];
        for ( int c= 0; c<area.count; c++) {
            aPoints[c].x =  [[area[c] valueForKey:@"x"]doubleValue] ;
            aPoints[c].y =  [[area[c] valueForKey:@"y"]doubleValue] ;
            
            CGPoint point = CGPointMake(aPoints[c].x, aPoints[c].y);
            [model.coordes addObject:[NSValue valueWithCGPoint:point]];
        }
        
        [_coordinates addObject:model];
        
        CGContextSetRGBStrokeColor(context, 0.0, 0.0, 0.0, 0.0);
        CGContextSetRGBFillColor(context, 0.0, 0.0, 0.0, 0.4);
        CGContextSetLineWidth(context, 4.0);
        CGContextAddLines(context, aPoints, area.count);
        CGContextDrawPath(context, kCGPathFillStroke);
        CGContextFillPath(context);
    }
    //绘制完成回调
    if (_drawCompleteBlock){
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width*self.frame.size.height/self.frame.size.width);
        _drawCompleteBlock(self);
    }
}


- (BOOL)pointInRegion:(CGPoint)pt region:(SYCoordinatesModel *)rObj
{
    int nCross = 0;
    
    //这里计算绘制之后图片缩放的比例
    CGFloat scale = _image.size.width/self.frame.size.width;
    
    pt = CGPointMake(pt.x*scale, pt.y*scale);
    
    for (int i = 0; i < rObj.coordes.count; i++) {
        
        CGPoint p1;
        CGPoint p2;
        
        [[rObj.coordes objectAtIndex: i] getValue: &p1];
        [[rObj.coordes objectAtIndex: (i + 1) % rObj.coordes.count] getValue: &p2];
        
        if ( p1.y == p2.y )
            continue;
        if ( pt.y < MIN(p1.y, p2.y))
            continue;
        
        if ( pt.y >= MAX(p1.y, p2.y))
            continue;
        
        double x = (double)(pt.y - p1.y) * (double)(p2.x - p1.x) / (double)(p2.y - p1.y) + p1.x;
        
        if ( x > pt.x ) 
            nCross++;
    } 
    
    if (nCross % 2 == 1) {
        
        return YES;
    }
    else {
        
        return NO;
    }
    
}






@end

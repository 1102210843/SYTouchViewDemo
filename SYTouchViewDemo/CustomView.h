//
//  CustomView.h
//  SYTouchViewDemo
//
//  Created by sunyu on 16/4/25.
//  Copyright © 2016年 sunyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYCoordinatesModel.h"

@interface CustomView : UIView

//block回调触摸事件，返回触摸的坐标
- (instancetype)initWithTouchBlock:(void(^)(CGPoint touchPoint))touchBlock;

//图片指针
@property (nonatomic, strong) UIImage *image;

//区域块顶点坐标数据
@property (nonatomic, strong) NSMutableArray *dicOfARequestareasArr;


@property (nonatomic, strong) NSMutableArray *coordinates;

//绘制完成回调
@property (nonatomic, copy) void (^drawCompleteBlock)(CustomView *customView);

//判断点击位置
- (BOOL)pointInRegion:(CGPoint)pt region:(SYCoordinatesModel *)rObj;

@end

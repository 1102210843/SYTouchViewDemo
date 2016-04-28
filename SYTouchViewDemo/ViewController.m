//
//  ViewController.m
//  SYTouchViewDemo
//
//  Created by sunyu on 16/4/22.
//  Copyright © 2016年 sunyu. All rights reserved.
//

#import "ViewController.h"
#import "CustomView.h"


@interface ViewController () <UIScrollViewDelegate>

@end

@implementation ViewController
{
    UIScrollView *_scroller;
    CustomView *_view;
    
    UILabel *_label;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    _scroller = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    _scroller.delegate = self;
    [self.view addSubview:_scroller];
    
    __weak typeof(self)mySelf = self;
    
    _view = [[CustomView alloc]initWithTouchBlock:^(CGPoint touchPoint) {
        [mySelf touchClick:touchPoint];
    }];
    [_scroller addSubview:_view];
    
    //获取本地图片，实际可用SDWebImage或其他异步加载图片方法下载图片
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"touchAreaImage" ofType:@"png"];
    UIImage* myImageObj = [[UIImage alloc] initWithContentsOfFile:imagePath];
    _view.image = myImageObj;
    
    //获取本地区域顶点坐标数据
    NSString *path = [[NSBundle mainBundle]pathForResource:@"mapTwo" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    [_view setDicOfARequestareasArr:dict[@"areas"]];
    
    //控件绘制完成block回调
    _view.drawCompleteBlock = ^(CustomView *customView){
        [mySelf setScrollerViewSizeWithView:customView];
    };
    
    _label = [[UILabel alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-40, [UIScreen mainScreen].bounds.size.width, 30)];
    _label.font = [UIFont systemFontOfSize:25];
    _label.textAlignment = NSTextAlignmentCenter;
    _label.textColor = [UIColor redColor];
    _label.text = @"点击的位置名：";
    [self.view addSubview:_label];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//由于绘图时是以图片原始尺寸绘制，所以在绘制完成之后，重置控件大小，按比例设置为我们指定的大小
- (void)setScrollerViewSizeWithView:(UIView *)view
{
    [_scroller setContentSize:CGSizeMake(view.frame.size.width, view.frame.size.height)];
}

//点击事件
- (void)touchClick:(CGPoint)point
{
    for (NSInteger i = 0; i < _view.coordinates.count; i++) {
        SYCoordinatesModel *model = _view.coordinates[i];
        if ([_view pointInRegion:point region:model]) {
            NSLog(@"点击的位置名：%@", model.name);
            
            _label.text = [NSString stringWithFormat:@"点击的位置名：%@", model.name];
            
            break;
        }
    }
}





@end

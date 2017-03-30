//
//  SPDrawView.m
//  绘制学习
//
//  Created by 四维图新SP on 17/3/7.
//  Copyright © 2017年 TracyMcSong. All rights reserved.
//

#import "SPDrawView.h"

@interface SPDrawView ()<UIGestureRecognizerDelegate>

@property (nonatomic) float currrentAngle;
// 中心点
@property (nonatomic) CGPoint centerPoint;
// 初始点
@property (nonatomic) CGPoint initPoint;
/// 红色小圆的半径
@property (nonatomic) float smallRadius;
/// 中心大圆的半径
@property (nonatomic) float bigRadius;
/// 小圆圆心坐标
@property (nonatomic) CGPoint smallCPoint;

@property (nonatomic,strong) UIImageView *imageView;

@end

@implementation SPDrawView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.smallRadius = 20;
        
        self.bigRadius = 140;
        
        self.centerPoint = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
        
        float sY =  self.centerPoint.y - (self.smallRadius + self.bigRadius);
        
        self.initPoint = CGPointMake(self.centerPoint.x, sY);
        
        self.smallCPoint = self.initPoint;
        
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
        
        panGesture.delegate = self;
        
        [self addGestureRecognizer:panGesture];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width / 3, self.frame.size.height/4)];
        
        imageView.backgroundColor = [UIColor yellowColor];
        
        imageView.center = self.center;
        
        [self addSubview:imageView];
        
        self.imageView = imageView;
    }
    
    return self;
}

- (void)setImage:(UIImage *)image
{
    self.imageView.image = image;
}

- (void)setAngle:(float)angle
{
    self.currrentAngle = angle;
    
    [self changeAngel];
}

- (void)panAction:(UIPanGestureRecognizer *)panGesture
{
    if (panGesture.state == UIGestureRecognizerStateBegan)
    {
        
    }
    else if (panGesture.state == UIGestureRecognizerStateChanged)
    {
        CGPoint point = [panGesture locationInView:self];
        
        float angle;
    
        // 触摸点x与中心点x的差值
        float diffX = point.x - self.frame.size.width / 2;
        // 触摸点y与中心点y的差值
        float diffY = point.y - self.frame.size.height / 2;
        // 计算角度
        angle = atan(diffX / diffY);// diffX与diffY异号 angle即为负数
        
        // 调整相对于y轴的角度 因为起始点在y轴上方
        if (diffX > 0 && diffY < 0)
        {
            angle *= -1;
        }
        else if (diffX > 0 && diffY > 0)
        {
            angle = M_PI - angle;
        }
        else if (diffX < 0 && diffY > 0)
        {
            angle = M_PI - angle;
        }
        else if (diffX < 0 && diffY < 0)
        {
            angle = 2*M_PI - angle;
        }
        else if (diffX == 0 && diffY < 0)
        {
            angle = 0;
        }
        else if (diffX == 0 && diffY > 0)
        {
            angle = M_PI;
        }
        else if (diffX > 0 && diffY == 0)
        {
            angle = M_PI / 2;
        }
        else if (diffX < 0 && diffY == 0)
        {
            angle = 3*M_PI / 2;
        }
        
        self.currrentAngle = angle;
        
        [self changeAngel];
    }
    else if (panGesture.state == UIGestureRecognizerStateEnded)
    {
        
    }
}

#pragma mark UIGestureRecognizerDelegate  控制触摸生效范围
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    CGPoint point = [gestureRecognizer locationInView:self];
    // 利用触摸点和小圆中心点的横纵左边差  可以求出触摸点距离小圆中心点的距离
    float distance = sqrtf(pow(point.x - self.smallCPoint.x, 2) + pow(point.y - self.smallCPoint.y, 2));
    
    if (distance < self.smallRadius + 10) {
        
        return YES;
    }
    
    return NO;
}

- (void)changeAngel
{
    self.imageView.transform = CGAffineTransformMakeRotation(self.currrentAngle);
    
    float r = self.smallRadius + self.bigRadius;
    
    float x = sin(self.currrentAngle)*r + self.centerPoint.x;
    
    float y = self.centerPoint.y - cos(self.currrentAngle)*r;
    
    self.smallCPoint = CGPointMake(x, y);
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    UIBezierPath *path = nil;
    //画曲线
    path = [UIBezierPath bezierPathWithArcCenter:self.center radius:self.bigRadius startAngle:M_PI/180 * 0 endAngle:M_PI/180*360 clockwise:YES];
    
//    path.lineWidth = 15;
    
    [[UIColor blueColor] set];
    
//    CGFloat length[] = {2,1};
//    
//    [path setLineDash:length count:1 phase:0];
    
    [path fill];
    
    path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(self.smallCPoint.x - self.smallRadius, self.smallCPoint.y - self.smallRadius, self.smallRadius * 2, self.smallRadius * 2)];
    
    [[UIColor redColor] set];
    
    [path fill];
}

@end

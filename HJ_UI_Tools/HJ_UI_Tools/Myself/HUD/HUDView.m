//
//  HUDView.m
//  DingYouMing
//
//  Created by ceyu on 2017/5/9.
//  Copyright © 2017年 吴宏佳. All rights reserved.
//

#import "HUDView.h"

@interface HUDView ()
@property (strong, nonatomic) BackgroundView* backgroundView;


@end

@implementation HUDView
+ (instancetype)showHUDAddedTo:(UIView *)view {
    HUDView *hud = [[self alloc] initWithView:view];
    [view addSubview:hud];
    return hud;
}
- (instancetype)initWithView:(UIView*)view{
    return [self initWithFrame:view.bounds];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        BackgroundView* backgroundView = [[BackgroundView alloc]init];
        backgroundView.center = CGPointMake(frame.size.width/2.f, frame.size.height/2.f);
        [self addSubview:backgroundView];
        backgroundView.backgroundColor = [[UIColor groupTableViewBackgroundColor]colorWithAlphaComponent:0.8];
        backgroundView.layer.cornerRadius = 15.f;
        
    }
    return self;
}

@end

@interface BackgroundView ()
{
    NSInteger _index;
}
//@property (strong, nonatomic) AnimationView* animationView;
@property (strong, nonatomic) CADisplayLink * display;
@property (weak, nonatomic) UILabel * lab;
@property (strong, nonatomic) NSArray *array;

@end

@implementation BackgroundView
- (instancetype)init
{
    self = [super init];
    if (self) {
        
        UIView *contentView = [[UIView alloc]init];
        [self addSubview:contentView];
        
        CGRect rectA;
        rectA.size.width = 115.f;//图像尺寸
        rectA.size.height = 66.f;//图像尺寸
        rectA.origin = CGPointZero;
        AnimationView* animationView = [[AnimationView alloc]initWithFrame:rectA];
        [contentView addSubview:animationView];
        
        CGRect rectL;
        rectL.size.width = 80.f;
        rectL.size.height = 21.f;
        rectL.origin.x = rectA.origin.x + rectA.size.width/2.f - rectL.size.width/2.f + 15.f;//补差15.f 省略号
        rectL.origin.y = CGRectGetMaxY(rectA)+10.f;
        UILabel *lab  = [[UILabel alloc]initWithFrame:rectL];
        [contentView addSubview:lab];
        self.lab = lab;
        
        contentView.frame = CGRectMake(10.f, 10.f, MAX(rectL.size.width, rectA.size.width), CGRectGetMaxY(lab.frame));
        self.bounds = CGRectMake(0, 0, CGRectGetMaxX(contentView.frame)+10.f, CGRectGetMaxY(contentView.frame)+10.f);
    
        self.display = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateLabText:)];
        self.display.frameInterval = 25;
        [self.display addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
        
        self.array = @[@"加载中",@"加载中.",@"加载中..",@"加载中..."];
    }
    return self;
}
-(void)removeFromSuperview{//TODO:没这个dealloc不调用，还不清楚原因
    [super removeFromSuperview];
    [self.display invalidate];
    self.display = nil;

}
-(void)dealloc{
    
    [self.display invalidate];
    self.display = nil;
}
-(void)updateLabText:(CADisplayLink*)display{

    self.lab.text = self.array[_index++];
    
    if (_index == self.array.count) {
        _index = 0;
    }
}

@end

@interface AnimationView ()
{
    CALayer * _carLayer;
    CALayer * _beforeLayer;
    CALayer * _afterLayer;
}

@end

@implementation AnimationView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImage *img = [UIImage imageNamed:@"carBody.png"];
        CGRect rect = CGRectMake(0, 0, img.size.width/3.f, img.size.height/3.f);
        //自定义一个图层
        _carLayer=[[CALayer alloc]init];
        _carLayer.bounds = rect;
        _carLayer.contents = (id)img.CGImage;
        [self.layer addSublayer:_carLayer];
        
        
        img = [UIImage imageNamed:@"wheels.png"];
        rect = CGRectMake(0, 0, img.size.width/3.f, img.size.height/3.f);
        
        //自定义一个图层
        _beforeLayer=[[CALayer alloc]init];
        _beforeLayer.bounds = rect;
        _beforeLayer.contents = (id)img.CGImage;
        [self.layer addSublayer:_beforeLayer];
        
        //自定义一个图层
        _afterLayer=[[CALayer alloc]init];
        _afterLayer.bounds = rect;
        _afterLayer.contents = (id)img.CGImage;
        [self.layer addSublayer:_afterLayer];

    }
    return self;
}
-(void)layoutSubviews{
    [super layoutSubviews];
    
    CGPoint pt = CGPointMake(self.frame.size.width/2.f, self.frame.size.height/2.f - 3.f);
    _carLayer.position = pt;
    _beforeLayer.position = CGPointMake(pt.x - 36.f, pt.y + 25.f);
    _afterLayer.position = CGPointMake(pt.x + 30.f, pt.y + 25.f);
    
    [self animation];
    
}
-(void)animation{
    
    //1.创建关键帧动画并设置动画属性
    CAKeyframeAnimation *keyframeAnimation=[CAKeyframeAnimation animationWithKeyPath:@"position"];
    
    //2.设置路径
    CGMutablePathRef path=CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, _carLayer.position.x, _carLayer.position.y);//移动到起始点
    CGPathAddLineToPoint(path, NULL, _carLayer.position.x, _carLayer.position.y+1.f);
    CGPathAddLineToPoint(path, NULL, _carLayer.position.x, _carLayer.position.y);//移动到起始点
    
    keyframeAnimation.path=path;//设置path属性
    CGPathRelease(path);//释放路径对象
    //设置其他属性
    keyframeAnimation.repeatCount=HUGE_VALF;//设置重复次数,HUGE_VALF可看做无穷大，起到循环动画的效果
    keyframeAnimation.removedOnCompletion=NO;//运行一次是否移除动画
    
    
    //3.添加动画到图层，添加动画后就会执行动画
    [_carLayer addAnimation:keyframeAnimation forKey:@"KCKeyframeAnimation_Position"];
    
    
    
    //
    CABasicAnimation *basicAnimation=[CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    
    basicAnimation.fromValue=[NSNumber numberWithInt:M_PI *2];
    basicAnimation.toValue=[NSNumber numberWithFloat:0];
    
    basicAnimation.repeatCount=HUGE_VALF;
    basicAnimation.removedOnCompletion=NO;
    
    
    [_beforeLayer addAnimation:basicAnimation forKey:@"KCBasicAnimation_Rotation"];
    
    [_afterLayer addAnimation:basicAnimation forKey:@"KCBasicAnimation_Rotation"];
    
}

@end


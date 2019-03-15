//
//  YJDColorPickView.m
//  YJDEffectText
//
//  Created by BURNING on 2019/3/14.
//  Copyright © 2019年 com.yy. All rights reserved.
//

#import "YJDColorPickView.h"
#import "UIColor+YJDColor.h"

#define kColorViewWidth 26
#define kColorViewBorderWidth 3
#define kColorViewSpacing 10

@interface YJDColorPickView ()<CAAnimationDelegate>

@property (nonatomic, strong) NSArray * colorArr;
@property (nonatomic, strong) UIImageView * checkView;

@end


@implementation YJDColorPickView

- (instancetype)initWithColorArray:(NSArray *)colorArr {
    if(self = [super init]) {
        _colorArr = colorArr;
        
        [self initView];
    }
    
    return self;
}

- (void)onColorViewTap:(UITapGestureRecognizer *)tap {
    
    [self.checkView removeFromSuperview];
    
    NSUInteger color = [[self.colorArr objectAtIndex:tap.view.tag] integerValue];
    if(color == 0x0) {
        [self.checkView setImage:[UIImage imageNamed:@"whiteChecked"]];
    } else {
        [self.checkView setImage:[UIImage imageNamed:@"blackChecked"]];
    }
    
    [tap.view addSubview:self.checkView];
    
    if(_selectColor) {
        _selectColor(color);
    }
    
    //缩放动画
    CAKeyframeAnimation *scaleAnimation =
    [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.values = @[@1, @0.8, @1];
    scaleAnimation.keyTimes = @[@0.0,@0.5,@1.0];
    
    [scaleAnimation setDuration:0.1];
    [scaleAnimation setRemovedOnCompletion:NO];
    [scaleAnimation setFillMode:kCAFillModeBoth];
    [scaleAnimation setValue:tap.view.layer forKey:@"scaleAnimation"];
    scaleAnimation.delegate = self;
    [tap.view.layer addAnimation:scaleAnimation forKey:nil];
    
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    CALayer* layer = (CALayer*)[anim valueForKey:@"scaleAnimation"];
    if(layer){
        [layer removeAllAnimations];
    }
}

- (void)setCheckWithIndex:(NSUInteger)index {
    [self.checkView removeFromSuperview];
    
    NSUInteger color = [[self.colorArr objectAtIndex:index] integerValue];
    if(color == 0x0) {
        [self.checkView setImage:[UIImage imageNamed:@"whiteChecked"]];
    } else {
        [self.checkView setImage:[UIImage imageNamed:@"blackChecked"]];
    }
    
    if(_selectColor) {
        _selectColor(color);
    }
    
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if(obj.tag == index) {
            [obj addSubview:self.checkView];
        }
    }];
}

- (void)initView {
    [self.colorArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSNumber * colorNum = obj;
        UIColor * color = [UIColor yjd_colorWithHex:colorNum.integerValue];
        
        UIView * colorView = [[UIView alloc] initWithFrame:CGRectMake((kColorViewWidth + kColorViewSpacing) * idx, 0, kColorViewWidth, kColorViewWidth)];
        colorView.backgroundColor = [UIColor whiteColor];
        colorView.layer.cornerRadius = kColorViewWidth / 2.0;
        colorView.layer.masksToBounds = YES;
        //        colorView.layer.edgeAntialiasingMask = YES;
        colorView.userInteractionEnabled = YES;
        colorView.tag = idx;
        
        CALayer * insideLayer = [CALayer layer];
        insideLayer.frame = self.checkView.frame;
        insideLayer.cornerRadius = self.checkView.layer.cornerRadius;
        insideLayer.masksToBounds = YES;
        insideLayer.borderColor = [UIColor blackColor].CGColor;
        insideLayer.borderWidth = self.checkView.layer.borderWidth;
        insideLayer.backgroundColor = color.CGColor;
        
        [colorView.layer addSublayer:insideLayer];
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onColorViewTap:)];
        [colorView addGestureRecognizer:tap];
        
        [self addSubview:colorView];
    }];
    
    CGRect frame = self.frame;
    frame.size = CGSizeMake(self.colorArr.count * kColorViewWidth + (self.colorArr.count - 1) * kColorViewSpacing, kColorViewWidth);
    self.frame = frame;
    
//    self.size = CGSizeMake(self.colorArr.count * kColorViewWidth + (self.colorArr.count - 1) * kColorViewSpacing, kColorViewWidth);
    
    
}

#pragma mark - getter and setter

- (UIImageView *)checkView {
    if(!_checkView) {
        CGFloat checkWidth = kColorViewWidth - 2 * kColorViewBorderWidth;
        _checkView = [[UIImageView alloc] initWithFrame:CGRectMake(3, 3, checkWidth, checkWidth)];
        [_checkView setImage:[UIImage imageNamed:@"blackChecked"]];
        _checkView.layer.borderWidth = 1;
        _checkView.layer.borderColor = [UIColor blackColor].CGColor;
        _checkView.layer.cornerRadius = checkWidth / 2.f;
        _checkView.layer.masksToBounds = YES;
    }
    
    return _checkView;
}

@end

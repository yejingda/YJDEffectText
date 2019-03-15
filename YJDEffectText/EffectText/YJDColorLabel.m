//
//  YJDColorLabel.m
//  YJDEffectText
//
//  Created by BURNING on 2019/3/14.
//  Copyright © 2019年 com.yy. All rights reserved.
//

#import "YJDColorLabel.h"

@implementation YJDColorLabel

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init {
    self = [super init];
    if (self) {
        self.numberOfLines = 0;
    }
    return self;
}

- (void)setText:(NSString *)text {
    [super setText:text];
    [self setNeedsDisplay];
}

- (NSMutableParagraphStyle *)paragraphStyle {
    if (!_paragraphStyle) {
        _paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        _paragraphStyle.lineSpacing = 0;
        _paragraphStyle.lineBreakMode = UILineBreakModeWordWrap;
        _paragraphStyle.alignment = self.textAlignment;
    }
    return _paragraphStyle;
}

- (void)drawRect:(CGRect)rect {
    //    [super drawRect:rect];
    if (self.text.length > 0) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        // 获取文字mask
        [self.text drawInRect:self.bounds withAttributes:@{NSFontAttributeName : self.font, NSParagraphStyleAttributeName : self.paragraphStyle}];
        //        [self.text drawInRect:self.bounds withAttributes:@{NSFontAttributeName : self.font}];
        CGImageRef textMask = CGBitmapContextCreateImage(context);
        
        // 清空画布
        CGContextClearRect(context, rect);
        
        // 设置蒙层
        CGContextTranslateCTM(context, 0.0, self.bounds.size.height);
        CGContextScaleCTM(context, 1.0, -1.0);
        CGContextClipToMask(context, rect, textMask);
        
        // 绘制渐变
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGFloat locations[] = {0,0.3,0.6,1};
        CGFloat colors[] = {1.0,46.0/255.0,0.0,1.0,
            241.0/255,1,85.0/255.0,1.0,
            62.0/255,1.0,104.0/255.0,1.0,
            0,125.0/255.0,1.0,1.0
        };
        CGGradientRef gradient=CGGradientCreateWithColorComponents(colorSpace, colors, locations, 4);
        CGPoint start = CGPointMake(0, self.bounds.size.height / 2.0);
        CGPoint end = CGPointMake(self.bounds.size.width, self.bounds.size.height / 2.0);
        CGContextDrawLinearGradient(context, gradient, start, end, kCGGradientDrawsBeforeStartLocation);
        
        // 释放
        CGColorSpaceRelease(colorSpace);
        CGGradientRelease(gradient);
        CGImageRelease(textMask);
    }
}

@end

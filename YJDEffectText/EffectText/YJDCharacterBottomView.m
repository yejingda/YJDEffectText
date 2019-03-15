//
//  YJDCharacterBottomView.m
//  YJDEffectText
//
//  Created by BURNING on 2019/3/14.
//  Copyright © 2019年 com.yy. All rights reserved.
//

#import "YJDCharacterBottomView.h"
#import "YJDCharacterItemView.h"
#import "YYText.h"
#import "NSAttributedString+YYText.h"

@interface YJDCharacterBottomView ()
@property (nonatomic, strong) YJDCharacterItemView *fontItemView1;
@property (nonatomic, strong) YJDCharacterItemView *fontItemView2;
@property (nonatomic, strong) YJDCharacterItemView *fontItemView3;
@property (nonatomic, strong) YJDCharacterItemView *fontItemView4;
@property (nonatomic, strong) YJDColorPickView *colorPickView;
@property (nonatomic, strong) UIButton *backColorButton;

@end


@implementation YJDCharacterBottomView

- (instancetype)initWithColors:(NSArray <NSNumber *> *)colorArray {
    self = [super init];
    if (self) {
        _colorArray = colorArray;
        [self addSubview:self.backColorButton];
        [self addSubview:self.colorPickView];
        [self addSubview:self.fontItemView1];
        [self addSubview:self.fontItemView2];
        [self addSubview:self.fontItemView3];
        [self addSubview:self.fontItemView4];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat size = 26;
    CGFloat left = 15;
    
    if (self.currentSelectedStyle == YJDCharacterEditClassicsSyle) {
        self.backColorButton.frame = CGRectMake(left, 11, 30, 30);
        self.colorPickView.frame = CGRectMake(61, 13, CGRectGetWidth(self.bounds) - 100, size);
    } else {
        self.colorPickView.frame = CGRectMake(left, 13, CGRectGetWidth(self.bounds) - 100, size);
    }
    CGFloat offY = 59;
    CGFloat width = 74;
    CGFloat middleSpacing = 8;
    CGFloat height = 30;
    self.fontItemView1.frame = CGRectMake(left, offY, width, height);
    self.fontItemView2.frame = CGRectMake(left + width + middleSpacing, offY, width, height);
    self.fontItemView3.frame = CGRectMake(left + width * 2 + middleSpacing * 2, offY, width, height);
    self.fontItemView4.frame = CGRectMake(left + width * 3 + middleSpacing * 3, offY, width, height);
}

- (void)didSelectedItemView:(YJDCharacterItemView *)itemView {
    
    self.currentSelectedStyle = itemView.editSyle;
    if (self.selectEditStyle) {
        self.selectEditStyle(itemView.editSyle);
    }
}

- (void)setCurrentSelectedStyle:(YJDCharacterEditStyle)currentSelectedStyle {
    _currentSelectedStyle = currentSelectedStyle;
    self.fontItemView1.selected = NO;
    self.fontItemView2.selected = NO;
    self.fontItemView3.selected = NO;
    self.fontItemView4.selected = NO;
    
    self.backColorButton.hidden = YES;
    if (currentSelectedStyle == YJDCharacterEditClassicsSyle) {
        self.backColorButton.hidden = NO;
        self.fontItemView1.selected = YES;
    }
    if (currentSelectedStyle == YJDCharacterEditRainbowSyle) {
        self.fontItemView2.selected = YES;
    }
    if (currentSelectedStyle == YJDCharacterEditShineSyle) {
        self.fontItemView3.selected = YES;
    }
    if (currentSelectedStyle == YJDCharacterEditOutlineSyle) {
        self.fontItemView4.selected = YES;
    }
    [self setNeedsLayout];
}

- (YJDCharacterItemView *)fontItemView1 {
    
    if (!_fontItemView1) {
        _fontItemView1 = [[YJDCharacterItemView alloc] init];
        _fontItemView1.editSyle = YJDCharacterEditClassicsSyle;
        [_fontItemView1 addTarget:self action:@selector(didSelectedItemView:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _fontItemView1;
}

- (YJDCharacterItemView *)fontItemView2 {
    
    if (!_fontItemView2) {
        _fontItemView2 = [[YJDCharacterItemView alloc] init];
        _fontItemView2.editSyle = YJDCharacterEditRainbowSyle;
        [_fontItemView2 addTarget:self action:@selector(didSelectedItemView:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _fontItemView2;
}

- (YJDCharacterItemView *)fontItemView3 {
    
    if (!_fontItemView3) {
        _fontItemView3 = [[YJDCharacterItemView alloc] init];
        _fontItemView3.editSyle = YJDCharacterEditShineSyle;
        [_fontItemView3 addTarget:self action:@selector(didSelectedItemView:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _fontItemView3;
}

- (YJDCharacterItemView *)fontItemView4 {
    
    if (!_fontItemView4) {
        _fontItemView4 = [[YJDCharacterItemView alloc] init];//NSStrokeWidthAttributeName:@(1),
        _fontItemView4.editSyle = YJDCharacterEditOutlineSyle;
        [_fontItemView4 addTarget:self action:@selector(didSelectedItemView:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _fontItemView4;
}

- (YJDColorPickView *)colorPickView {
    if(!_colorPickView) {
        _colorPickView = [[YJDColorPickView alloc] initWithColorArray:self.colorArray];
        
        __weak typeof(self) weakself = self;
        _colorPickView.selectColor = ^(NSUInteger index) {
            //            NSNumber *colorNo = weakself.colorArray[index];
            //            UIColor *color = [UIColor bbc_colorWithHex:index];
            
            if (weakself.selectColor) {
                weakself.selectColor(index);
            }
        };
    }
    
    return _colorPickView;
}

- (UIButton *)backColorButton {
    if (!_backColorButton) {
        _backColorButton = [[UIButton alloc] init];
        UIImage *image = [UIImage imageNamed:@"shoot_char_back_nor"];
        [_backColorButton setBackgroundImage:image forState:UIControlStateNormal];
    }
    return _backColorButton;
}

- (void)setCurrentSelectedColor:(UIColor *)currentSelectedColor {
    _currentSelectedColor = currentSelectedColor;
    NSString *colorString = [YJDCharacterBottomView hexFromUIColor:currentSelectedColor];
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber *numTemp = [numberFormatter numberFromString:colorString];
    NSInteger index = [self.colorArray containsObject:numTemp];
    [self.colorPickView setCheckWithIndex:index];
}

+ (NSString *)hexFromUIColor:(UIColor *)color {
    if (CGColorGetNumberOfComponents(color.CGColor) < 4) {
        const CGFloat *components = CGColorGetComponents(color.CGColor);
        color = [UIColor colorWithRed:components[0]
                                green:components[0]
                                 blue:components[0]
                                alpha:components[1]];
    }
    
    if (CGColorSpaceGetModel(CGColorGetColorSpace(color.CGColor)) != kCGColorSpaceModelRGB) {
        return [NSString stringWithFormat:@"0xFFFFFF"];
    }
    
    return [NSString stringWithFormat:@"0x%x%x%x", (int)((CGColorGetComponents(color.CGColor))[0]*255.0),
            (int)((CGColorGetComponents(color.CGColor))[1]*255.0),
            (int)((CGColorGetComponents(color.CGColor))[2]*255.0)];
}

@end

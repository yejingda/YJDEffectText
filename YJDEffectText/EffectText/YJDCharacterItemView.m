//
//  YJDCharacterItemView.m
//  YJDEffectText
//
//  Created by BURNING on 2019/3/14.
//  Copyright © 2019年 com.yy. All rights reserved.
//

#import "YJDCharacterItemView.h"
#import "Masonry.h"
#import "UIColor+YJDColor.h"

@interface YJDCharacterItemView ()
@property (nonatomic, strong) YYTextView *titleLabel;
@property (nonatomic, strong) YJDColorLabel *colorLabel;
@end

@implementation YJDCharacterItemView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _titleLabel = [[YYTextView alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.userInteractionEnabled = NO;
        
        _colorLabel = [[YJDColorLabel alloc] init];
        _colorLabel.textAlignment = NSTextAlignmentCenter;
        _colorLabel.font = [UIFont boldSystemFontOfSize:15];
        
        [self addSubview:_titleLabel];
        [self addSubview:_colorLabel];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.top.equalTo(self);
        }];
        [_colorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.centerY.equalTo(self);
            make.height.equalTo(@(17));
            make.width.equalTo(@(65));
        }];
        self.clipsToBounds = YES;
        self.layer.cornerRadius = 3;
    }
    return self;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if (selected) {
        self.backgroundColor = [UIColor yjd_colorWithHex:0xffffff alpha:0.2];
    } else {
        self.backgroundColor = [UIColor clearColor];
    }
}

- (void)setEditSyle:(YJDCharacterEditStyle)editSyle {
    _editSyle = editSyle;
    if (editSyle == YJDCharacterEditClassicsSyle) {
        self.colorLabel.hidden = YES;
        NSDictionary *attributes = @{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont boldSystemFontOfSize:15],NSParagraphStyleAttributeName:[NSParagraphStyle alloc]};
        self.titleLabel.attributedText = [[NSAttributedString alloc]
                                          initWithString: @"Classics"
                                          attributes:attributes];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    if (editSyle == YJDCharacterEditRainbowSyle) {
        self.colorLabel.text = @"Rainbow";
        self.colorLabel.textAlignment = NSTextAlignmentCenter;
    }
    if (editSyle == YJDCharacterEditShineSyle) {
        self.colorLabel.hidden = YES;
        NSShadow *shadow = [[NSShadow alloc] init];
        shadow.shadowOffset = CGSizeMake(-0.1, 0.1);
        shadow.shadowColor = [UIColor yjd_colorWithHex:0xFF0F36];
        shadow.shadowBlurRadius = 4;
        NSDictionary *attributes = @{NSShadowAttributeName:shadow,NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont boldSystemFontOfSize:15]};
        self.titleLabel.attributedText = [[NSAttributedString alloc]
                                          initWithString:@"Shine"
                                          attributes:attributes];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    if (editSyle == YJDCharacterEditOutlineSyle) {
        self.colorLabel.hidden = YES;
        NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:@"Outline"];
        [attri yy_setFont:[UIFont boldSystemFontOfSize:15.0] range:attri.yy_rangeOfAll];
        [attri yy_setColor:[UIColor whiteColor] range:attri.yy_rangeOfAll];
        [attri yy_setStrokeColor:[UIColor yjd_colorWithHex:0xDF424D] range:attri.yy_rangeOfAll];
        [attri yy_setStrokeWidth:@(-4.0) range:attri.yy_rangeOfAll];
        self.titleLabel.attributedText = attri;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
}

@end

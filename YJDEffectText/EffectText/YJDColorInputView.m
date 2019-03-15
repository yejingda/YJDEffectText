//
//  YJDColorInputView.m
//  YJDEffectText
//
//  Created by BURNING on 2019/3/14.
//  Copyright © 2019年 com.yy. All rights reserved.
//

#import "YJDColorInputView.h"
#import "UIColor+YJDColor.h"

#define BSLeftAndRight          15
#define MixWidth                20
#define MixHeight               45


@interface YJDColorInputView () <YYTextViewDelegate>
@property (nonatomic, strong) UIView *viewContainer;
@property (nonatomic, strong) YYTextView *textLabel;
@property (nonatomic, strong) YYTextView *textView;
@property (nonatomic, strong) CAGradientLayer *gradientLayer;
@property (nonatomic, strong) NSMutableString *editString;
@property (nonatomic, strong) NSMutableParagraphStyle *paragraphStyle;
@property (nonatomic, strong) NSString *lastRefreshString;
@end


@implementation YJDColorInputView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.viewContainer];
        [self.viewContainer addSubview:self.textLabel];
        [self addSubview:self.textView];
    }
    return self;
}

- (void)setMaxRect:(CGRect)maxRect {
    _maxRect = maxRect;
    self.frame = maxRect;
    [self remakeViewConstraint];
}

- (void)setEditItem:(YJDCharacterItem *)editItem {
    
    _editItem = editItem;
    _editString = nil;
    if (editItem.editSyle == YJDCharacterEditRainbowSyle || editItem.editSyle == YJDCharacterEditClassicsSyle) {
        [self setTextLabelText:editItem.attributedString.string];
        self.textView.attributedText = editItem.attributedString;
        [self refreshStyle];
        
    } else if([editItem.attributedString.string isEqualToString:@" "]){
        [self.editString replaceCharactersInRange:NSMakeRange(0, self.editString.length) withString:editItem.attributedString.string];
        [self refreshStyle];
    } else {
        self.textView.attributedText = editItem.attributedString;
        [self.textView setSelectedRange:(NSRange){ .location = editItem.attributedString.string.length, .length = 0 }];
    }
}

- (void)remakeViewConstraint {
    if (!_editItem) {
        return;
    }
    
    if (self.editString.length == 0)
        return;
    
    NSMutableAttributedString *attributedString = [self getMutableAtrributedString:self.editString];
    YYTextView *textView = [[YYTextView alloc] init];
    textView.font = [UIFont systemFontOfSize:27];
    if (!attributedString) {
        textView.text = self.editString;
    } else {
        textView.attributedText = attributedString;
    }
    CGFloat maxWidth = CGRectGetWidth(self.bounds) - BSLeftAndRight * 2;
    CGSize textSize = [textView sizeThatFits:CGSizeMake(maxWidth, CGFLOAT_MAX)];
    
    if (textSize.width + 5 < maxWidth) {
        textSize.width = textSize.width + 5;
    }
    
    if (textSize.width < MixWidth) {
        textSize.width = MixWidth;
    }
    if (textSize.height < MixHeight) {
        textSize.height = MixHeight;
    }
    
    
    CGFloat offX = (CGRectGetWidth(self.bounds) - textSize.width) / 2;
    CGFloat offY = (CGRectGetHeight(self.bounds) - textSize.height) / 2;
    
    self.textView.frame = CGRectMake(offX, offY, textSize.width, textSize.height);
    if (self.editItem.editSyle == YJDCharacterEditRainbowSyle) {
        if (![self.gradientLayer superlayer]) {
            [self.viewContainer.layer addSublayer:self.gradientLayer];
            self.viewContainer.maskView = self.textLabel;
        }
        CGRect rect = self.textView.frame;
        rect.origin.x = rect.origin.x + 2;
        self.viewContainer.frame = rect;
        self.textLabel.frame = self.viewContainer.bounds;
    }
}

- (NSMutableAttributedString *)getMutableAtrributedString:(NSString *)string {
    NSMutableAttributedString * attributedString = nil;
    if (self.editItem.editSyle == YJDCharacterEditClassicsSyle) {
        if (self.editItem.selectedBackgroudColor) {
            NSMutableDictionary *attributes = [[NSMutableDictionary alloc] init];
            [attributes setObject:self.editItem.selectedColor forKeyedSubscript:NSBackgroundColorAttributeName];
            [attributes setObject:[UIFont systemFontOfSize:27] forKeyedSubscript:NSFontAttributeName];
            [attributes setObject:self.paragraphStyle forKey:NSParagraphStyleAttributeName];
            if (self.editItem.colorIndex == 0) {
                [attributes setObject:[UIColor blackColor] forKeyedSubscript:NSForegroundColorAttributeName];
            } else {
                [attributes setObject:[UIColor whiteColor] forKeyedSubscript:NSForegroundColorAttributeName];
            }
            attributedString = [[NSMutableAttributedString alloc]
                                initWithString:string ?: @""
                                attributes:attributes];
        } else {
            
            NSMutableDictionary *attributes = [[NSMutableDictionary alloc] init];
            [attributes setObject:[UIColor clearColor] forKeyedSubscript:NSBackgroundColorAttributeName];
            [attributes setObject:[UIFont systemFontOfSize:27] forKeyedSubscript:NSFontAttributeName];
            [attributes setObject:self.editItem.selectedColor forKeyedSubscript:NSForegroundColorAttributeName];
            [attributes setObject:self.paragraphStyle forKey:NSParagraphStyleAttributeName];
            attributedString = [[NSMutableAttributedString alloc]
                                initWithString:string ?: @""
                                attributes:attributes];
        }
    }
    
    
    if (self.editItem.editSyle == YJDCharacterEditRainbowSyle) {
        NSMutableDictionary *attributes = [[NSMutableDictionary alloc] init];
        [attributes setObject:[UIFont systemFontOfSize:27] forKeyedSubscript:NSFontAttributeName];
        [attributes setObject:self.paragraphStyle forKey:NSParagraphStyleAttributeName];
        [attributes setObject:[UIColor clearColor] forKey:NSForegroundColorAttributeName];
        
        attributedString = [[NSMutableAttributedString alloc]
                            initWithString:string ?: @""
                            attributes:attributes];
    }
    
    if (self.editItem.editSyle == YJDCharacterEditShineSyle) {
        NSShadow *shadow = [[NSShadow alloc] init];
        shadow.shadowOffset = CGSizeMake(-0.1, 0.1);
        shadow.shadowColor = self.editItem.selectedColor;//[UIColor yjd__colorWithHex:0xFF0F36];
        shadow.shadowBlurRadius = 4;
        NSDictionary *attributes = @{NSShadowAttributeName:shadow,NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:27],NSParagraphStyleAttributeName :self.paragraphStyle};
        attributedString = [[NSMutableAttributedString alloc]
                            initWithString:string ?: @""
                            attributes:attributes];
    }
    
    if (self.editItem.editSyle == YJDCharacterEditOutlineSyle) {
        
        if (self.editItem.colorIndex == 0) {
            attributedString = [[NSMutableAttributedString alloc] initWithString:string ?: @""];
            [attributedString yy_setFont:[UIFont systemFontOfSize:27.0] range:attributedString.yy_rangeOfAll];
            [attributedString yy_setColor:[UIColor blackColor] range:attributedString.yy_rangeOfAll];
            [attributedString yy_setStrokeColor:self.editItem.selectedColor range:attributedString.yy_rangeOfAll];
            [attributedString yy_setStrokeWidth:@(-4.0) range:attributedString.yy_rangeOfAll];
            [attributedString yy_setParagraphStyle:self.paragraphStyle range:attributedString.yy_rangeOfAll];
        } else {
            attributedString = [[NSMutableAttributedString alloc] initWithString:string ?: @""];
            [attributedString yy_setFont:[UIFont systemFontOfSize:27.0] range:attributedString.yy_rangeOfAll];
            [attributedString yy_setColor:[UIColor whiteColor] range:attributedString.yy_rangeOfAll];
            [attributedString yy_setStrokeColor:self.editItem.selectedColor range:attributedString.yy_rangeOfAll];
            [attributedString yy_setStrokeWidth:@(-4.0) range:attributedString.yy_rangeOfAll];
            [attributedString yy_setParagraphStyle:self.paragraphStyle range:attributedString.yy_rangeOfAll];
        }
    }
    return attributedString;
}

- (BOOL)firstColor:(UIColor*)firstColor secondColor:(UIColor*)secondColor {
    if (CGColorEqualToColor(firstColor.CGColor, secondColor.CGColor)) {
        return YES;
    } else {
        return NO;
    }
}

- (void)refreshStyle {
    if (!self.editItem) {
        return;
    }
    if (self.editItem.editSyle == YJDCharacterEditClassicsSyle) {
        if (self.editItem.selectedBackgroudColor) {
            self.textView.attributedText = [self getMutableAtrributedString:self.editString];
            if (self.editItem.colorIndex == 0) {
                self.textView.textColor = [UIColor blackColor];
            } else {
                self.textView.textColor = [UIColor whiteColor];
            }
            [self.textView setSelectedRange:(NSRange){ .location = self.textView.text.length, .length = 0 }];
            self.textView.backgroundColor = self.editItem.selectedColor;
        } else {
            self.textView.attributedText = [self getMutableAtrributedString:self.editString];
            [self.textView setSelectedRange:(NSRange){ .location = self.textView.text.length, .length = 0 }];
            self.textView.backgroundColor = [UIColor clearColor];
            self.textView.textColor = self.editItem.selectedColor;
        }
    }
    
    self.viewContainer.hidden = YES;
    self.textLabel.hidden = YES;
    if (self.editItem.editSyle == YJDCharacterEditRainbowSyle) {
        [self setTextLabelText:self.textView.text];
        
        [self remakeViewConstraint];
        self.viewContainer.hidden = NO;
        self.textLabel.hidden = NO;
        self.textView.attributedText = [self getMutableAtrributedString:self.editString];
        [self.textView setSelectedRange:(NSRange){ .location = self.textView.text.length, .length = 0 }];
        self.textView.textColor = [UIColor clearColor];
        self.textView.backgroundColor = [UIColor clearColor];
    }
    
    if (self.editItem.editSyle == YJDCharacterEditShineSyle) {
        self.textView.attributedText = [self getMutableAtrributedString:self.editString];
        [self.textView setSelectedRange:(NSRange){ .location = self.textView.text.length, .length = 0 }];
        self.textView.backgroundColor = [UIColor clearColor];
    }
    
    if (self.editItem.editSyle == YJDCharacterEditOutlineSyle) {
        self.textView.attributedText = [self getMutableAtrributedString:self.editString];
        [self.textView setSelectedRange:(NSRange){ .location = self.textView.text.length, .length = 0 }];
        self.textView.backgroundColor = [UIColor clearColor];
    }
    
    //这是一行神奇的代码！！！！！
    if ([self.textView.attributedText.string isEqualToString:@" "]) {
        [self.textView setSelectedRange:(NSRange){ .location = 0, .length = 0 }];
    }
}


//- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//
//    UITouch *touch = [touches anyObject];
//    CGPoint touchLocation = [touch locationInView:self];
//    if (!CGRectContainsPoint(self.textView.frame, touchLocation)) {
//        if ([self.delegate respondsToSelector:@selector(inputView:didSelectedUnEditArea:)]) {
//            [self.delegate inputView:self didSelectedUnEditArea:self.editItem];
//        }
//    } else {
//        [super touchesEnded:touches withEvent:event];
//    }
//}

#pragma -mark UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if (text == 0) {
        return YES;
    } else {
        if ([text isEqualToString:@""] && range.length > 0) {
            //删除字符肯定是安全的
            
            if ((range.location + range.length) <= self.editString.length) {
                [self.editString replaceCharactersInRange:range withString:text];
            }
            [self remakeViewConstraint];
            
            return YES;
        } else {
            if (textView.text.length - range.length + text.length > 50) {
                if (![self.editString isEqualToString:textView.text]) {
                    NSMutableAttributedString *attributedString = [self getMutableAtrributedString:self.editString];
                    if (!attributedString) {
                        textView.text = self.editString;
                    } else {
                        textView.attributedText = attributedString;
                    }
                }
                else {
                    [self remakeViewConstraint];
                }
                
                return NO;
            }
        }
        
    }
    
    if ((range.location + range.length) <= self.editString.length) {
        [self.editString replaceCharactersInRange:range withString:text];
    }
    [self remakeViewConstraint];
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    if (self.textView.text.length > 50) {
        NSString *string = [self.textView.text substringToIndex:50];
        _editString = nil;
        [self.editString appendString:string];
        self.textView.text = string;
        return;
    }
    
    if (textView.text.length > 0) {
        [self.editString replaceCharactersInRange:NSMakeRange(0, self.editString.length) withString:textView.text];
    }
    
    if (self.editItem.editSyle == YJDCharacterEditRainbowSyle) {
        self.textView.textColor = [UIColor clearColor];
        self.textView.backgroundColor = [UIColor clearColor];
        [self setTextLabelText:self.editString];
    }
    if ([self.delegate respondsToSelector:@selector(inputView:textViewValueChange:)]) {
        [self.delegate inputView:self textViewValueChange:self.textView];
    }
}

#pragma -mark getter setter

- (YYTextView *)textView {
    if (_textView == nil) {
        _textView = [[YYTextView alloc] init];
        _textView.delegate = self;
        _textView.layer.cornerRadius = 5;
        _textView.clipsToBounds = YES;
    }
    _textView.font = [UIFont systemFontOfSize:27];
    
    return _textView;
}

- (YYTextView *)textLabel {
    if (_textLabel == nil) {
        _textLabel = [[YYTextView alloc] init];
        _textLabel.layer.cornerRadius = 5;
        _textLabel.clipsToBounds = YES;
        _textLabel.userInteractionEnabled = NO;
    }
    _textLabel.font = [UIFont systemFontOfSize:27];
    
    return _textLabel;
}

- (UIView *)viewContainer {
    if (!_viewContainer) {
        _viewContainer = [[UIView alloc] init];
    }
    return _viewContainer;
}

- (CAGradientLayer *)gradientLayer {
    if (!_gradientLayer) {
        _gradientLayer = [CAGradientLayer layer];
        _gradientLayer.colors = @[(__bridge id)[[UIColor yjd_colorWithHex:0xFF2E00] colorWithAlphaComponent:1.0].CGColor,
                                  (__bridge id)[[UIColor yjd_colorWithHex:0xF1FF55] colorWithAlphaComponent:1.0].CGColor,
                                  (__bridge id)[[UIColor yjd_colorWithHex:0x3EFF68] colorWithAlphaComponent:1.0].CGColor,
                                  (__bridge id)[[UIColor yjd_colorWithHex:0x007DFF] colorWithAlphaComponent:1.0].CGColor];
        _gradientLayer.startPoint = CGPointMake(0, 0.5);
        _gradientLayer.endPoint =  CGPointMake(1.0, 0.5);
        _gradientLayer.frame = self.bounds;
    }
    return _gradientLayer;
}

- (NSMutableString *)editString {
    if (!_editString) {
        _editString = [[NSMutableString alloc] init];
    }
    return _editString;
}

- (NSMutableParagraphStyle *)paragraphStyle {
    if (!_paragraphStyle) {
        _paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        _paragraphStyle.lineSpacing = 4;
        _paragraphStyle.alignment = self.textView.textAlignment;
        _paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    }
    return _paragraphStyle;
}

- (void) setTextLabelText:(NSString *) text {
    if (text.length == 0) {
        self.textLabel.attributedText = nil;
        return;
    }
    
    NSMutableAttributedString * attributedString = nil;
    if (self.editItem.editSyle == YJDCharacterEditClassicsSyle) {
        if (self.editItem.selectedBackgroudColor) {
            NSMutableDictionary *attributes = [[NSMutableDictionary alloc] init];
            [attributes setObject:self.editItem.selectedColor forKeyedSubscript:NSBackgroundColorAttributeName];
            [attributes setObject:[UIFont systemFontOfSize:27] forKeyedSubscript:NSFontAttributeName];
            [attributes setObject:self.paragraphStyle forKey:NSParagraphStyleAttributeName];
            if (self.editItem.colorIndex == 0) {
                [attributes setObject:[UIColor blackColor] forKeyedSubscript:NSForegroundColorAttributeName];
            } else {
                [attributes setObject:[UIColor whiteColor] forKeyedSubscript:NSForegroundColorAttributeName];
            }
            attributedString = [[NSMutableAttributedString alloc]
                                initWithString:text ?: @""
                                attributes:attributes];
        } else {
            
            NSMutableDictionary *attributes = [[NSMutableDictionary alloc] init];
            [attributes setObject:[UIColor clearColor] forKeyedSubscript:NSBackgroundColorAttributeName];
            [attributes setObject:[UIFont systemFontOfSize:27] forKeyedSubscript:NSFontAttributeName];
            [attributes setObject:self.editItem.selectedColor forKeyedSubscript:NSForegroundColorAttributeName];
            [attributes setObject:self.paragraphStyle forKey:NSParagraphStyleAttributeName];
            attributedString = [[NSMutableAttributedString alloc]
                                initWithString:text ?: @""
                                attributes:attributes];
        }
    }
    
    
    if (self.editItem.editSyle == YJDCharacterEditRainbowSyle) {
        NSMutableDictionary *attributes = [[NSMutableDictionary alloc] init];
        [attributes setObject:[UIFont systemFontOfSize:27] forKeyedSubscript:NSFontAttributeName];
        [attributes setObject:self.paragraphStyle forKey:NSParagraphStyleAttributeName];
        
        attributedString = [[NSMutableAttributedString alloc]
                            initWithString:text ?: @""
                            attributes:attributes];
    }
    
    if (self.editItem.editSyle == YJDCharacterEditShineSyle) {
        NSShadow *shadow = [[NSShadow alloc] init];
        shadow.shadowOffset = CGSizeMake(-0.1, 0.1);
        shadow.shadowColor = self.editItem.selectedColor;//[UIColor yjd__colorWithHex:0xFF0F36];
        shadow.shadowBlurRadius = 4;
        NSDictionary *attributes = @{NSShadowAttributeName:shadow,NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:27],NSParagraphStyleAttributeName :self.paragraphStyle};
        attributedString = [[NSMutableAttributedString alloc]
                            initWithString:text ?: @""
                            attributes:attributes];
    }
    
    if (self.editItem.editSyle == YJDCharacterEditOutlineSyle) {
        
        if (self.editItem.colorIndex == 0) {
            attributedString = [[NSMutableAttributedString alloc] initWithString:text ?: @""];
            [attributedString yy_setFont:[UIFont systemFontOfSize:27.0] range:attributedString.yy_rangeOfAll];
            [attributedString yy_setColor:[UIColor blackColor] range:attributedString.yy_rangeOfAll];
            [attributedString yy_setStrokeColor:self.editItem.selectedColor range:attributedString.yy_rangeOfAll];
            [attributedString yy_setStrokeWidth:@(-4.0) range:attributedString.yy_rangeOfAll];
            [attributedString yy_setParagraphStyle:self.paragraphStyle range:attributedString.yy_rangeOfAll];
        } else {
            attributedString = [[NSMutableAttributedString alloc] initWithString:text ?: @""];
            [attributedString yy_setFont:[UIFont systemFontOfSize:27.0] range:attributedString.yy_rangeOfAll];
            [attributedString yy_setColor:[UIColor whiteColor] range:attributedString.yy_rangeOfAll];
            [attributedString yy_setStrokeColor:self.editItem.selectedColor range:attributedString.yy_rangeOfAll];
            [attributedString yy_setStrokeWidth:@(-4.0) range:attributedString.yy_rangeOfAll];
            [attributedString yy_setParagraphStyle:self.paragraphStyle range:attributedString.yy_rangeOfAll];
        }
    }
    
    self.textLabel.attributedText = attributedString;
    
}


@end

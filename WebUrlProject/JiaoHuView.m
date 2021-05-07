//
//  JiaoHuView.m
//  WebUrlProject
//
//  Created by LHWen on 2020/10/15.
//  Copyright © 2020 LHWen. All rights reserved.
//

#import "JiaoHuView.h"

#define kSCREENWIDTH  [UIScreen mainScreen].bounds.size.width   // 获取屏幕宽度

@interface JiaoHuView() <UITextViewDelegate>

@property (nonatomic, strong) UITextView *funcNameTextView;

@property (nonatomic, strong) UILabel *promptLbl;

@property (nonatomic, strong) UIButton *sumbitBtn;

@end

@implementation JiaoHuView

- (UITextView *)funcNameTextView {
    
    if (!_funcNameTextView) {
        
        _funcNameTextView = [UITextView new];
        _funcNameTextView.delegate = self;
        _funcNameTextView.font = [UIFont systemFontOfSize:15];
        _funcNameTextView.returnKeyType = UIReturnKeyDone;
        _funcNameTextView.frame = CGRectMake(24, 70, kSCREENWIDTH - 48, 80);
    }
    return _funcNameTextView;
}

- (UILabel *)promptLbl {
    
    if (!_promptLbl) {
        _promptLbl = [[UILabel alloc] init];
        _promptLbl.text = @"请输入方法名和参数";
        _promptLbl.font = [UIFont systemFontOfSize:15];
        _promptLbl.textColor = UIColor.darkGrayColor;
        _promptLbl.frame = CGRectMake(29, 75, 200, 20);
    }
    return _promptLbl;
}

- (UIButton *)sumbitBtn {
    
    if (!_sumbitBtn) {
        _sumbitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sumbitBtn setTitle:@"调用方法" forState:UIControlStateNormal];
        [_sumbitBtn setBackgroundImage:[self createImageWithColor:[UIColor colorWithRed:30/255.0 green:144/255.0 blue:255/255.0 alpha:1.0]] forState:UIControlStateNormal];
        [_sumbitBtn setBackgroundImage:[self createImageWithColor:[UIColor lightGrayColor]] forState:UIControlStateHighlighted];
        _sumbitBtn.frame = CGRectMake((kSCREENWIDTH - 160)/2, 165, 160, 44);
        [_sumbitBtn addTarget:self action:@selector(clickSumbitButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sumbitBtn;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        UILabel *tiShiLbl = [UILabel new];
        tiShiLbl.backgroundColor = [UIColor colorWithRed:1.0 green:220/255.0 blue:170/255.0 alpha:1.0];
        tiShiLbl.text = @"调用方法输入须自己检查，应用未检查\n无参调用：testFunc()\n有参调用：testfunction(c1,c2,...)";
        tiShiLbl.font = [UIFont systemFontOfSize:14];
        tiShiLbl.textColor = UIColor.redColor;
        tiShiLbl.numberOfLines = 3;
        tiShiLbl.frame = CGRectMake(24, 10, frame.size.width - 48, 60);
        tiShiLbl.textAlignment = NSTextAlignmentLeft;
        [self addSubview:tiShiLbl];
        
        self.backgroundColor = [UIColor colorWithRed:1.0 green:220/255.0 blue:170/255.0 alpha:1.0];
        [self addSubview:self.funcNameTextView];
        [self addSubview:self.promptLbl];
        [self addSubview:self.sumbitBtn];
    }
    return self;
}

- (void)clickSumbitButton:(UIButton *)sender {
    
    [self.funcNameTextView resignFirstResponder];
    NSLog(@"func:%@", self.funcNameTextView.text);
    self.makeFunction(self.funcNameTextView.text);
}

#pragma mark - textViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView {
    
    if ([textView.text isEqualToString:@""]) {
        _promptLbl.hidden = NO;
    }
}

- (void)textViewDidChange:(UITextView *)textView {
    
    if (textView.text.length == 0) {
        _promptLbl.hidden = NO;
    } else {
        _promptLbl.hidden = YES;
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if ([text isEqualToString:@"\n"]) {
        
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

#pragma mark - 生成纯色图片
- (UIImage*)createImageWithColor: (UIColor*) color {
    
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}


@end

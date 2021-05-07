//
//  ViewController.m
//  WebUrlProject
//
//  Created by LHWen on 2020/10/13.
//  Copyright © 2020 LHWen. All rights reserved.
//

#import "ViewController.h"
#import "WebViewController.h"

#define kSCREENWIDTH  [UIScreen mainScreen].bounds.size.width   // 获取屏幕宽度
#define kSCREENHEIGHT  [UIScreen mainScreen].bounds.size.height   // 获取屏幕高度
#define kIsiPhoneX ([UIScreen mainScreen].bounds.size.height >= 812.0)

@interface ViewController () <UITextViewDelegate>

@property (nonatomic, strong) UITextView *webUrlTextView;
@property (nonatomic, strong) UILabel *promptLbl;
// 跳转 webView
@property (nonatomic, strong) UIButton *sumbitBtn;

@end

@implementation ViewController

- (UITextView *)webUrlTextView {
    
    if (!_webUrlTextView) {
        
        _webUrlTextView = [UITextView new];
        _webUrlTextView.delegate = self;
//        _webUrlTextView.text = @"http://www.baidu.com";
        _webUrlTextView.font = [UIFont systemFontOfSize:15];
        _webUrlTextView.returnKeyType = UIReturnKeyDone;
        _webUrlTextView.frame = CGRectMake(48, kIsiPhoneX ? 350 : 308, kSCREENWIDTH - 96, 120);
    }
    return _webUrlTextView;
}

- (UILabel *)promptLbl {
    
    if (!_promptLbl) {
        _promptLbl = [[UILabel alloc] init];
        _promptLbl.text = @"请输入链接地址...";
        _promptLbl.font = [UIFont systemFontOfSize:15];
        _promptLbl.textColor = UIColor.darkGrayColor;
        _promptLbl.frame = CGRectMake(54, kIsiPhoneX ? 355 : 313, 160, 20);
    }
    return _promptLbl;
}

- (UIButton *)sumbitBtn {
    
    if (!_sumbitBtn) {
        _sumbitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_sumbitBtn setBackgroundColor:[UIColor colorWithRed:30/255.0 green:144/255.0 blue:255/255.0 alpha:1.0]];
        [_sumbitBtn setBackgroundImage:[UIImage imageNamed:@"an"] forState:UIControlStateNormal];
        [_sumbitBtn setBackgroundImage:[self createImageWithColor:[UIColor lightGrayColor]] forState:UIControlStateHighlighted];
        _sumbitBtn.frame = CGRectMake((kSCREENWIDTH - 240)/2, kIsiPhoneX ? 510 : 468, 240, 42);
        [_sumbitBtn addTarget:self action:@selector(clickSumbitButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sumbitBtn;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:0 green:50/255.0 blue:155/255.0 alpha:1.0];
    
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"LOGO"]];
    imgView.frame = CGRectMake(kSCREENWIDTH/2 - 61, kIsiPhoneX ? 106 : 64, 122, 66);
    [self.view addSubview:imgView];
    
    UIImageView *tubiao = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tubiao"]];
    tubiao.frame = CGRectMake(kSCREENWIDTH/2 - 120, kIsiPhoneX ? 210 : 168, 240, 112);
    [self.view addSubview:tubiao];
    
    
    UIImageView *erweima = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"erweima"]];
    erweima.frame = CGRectMake(kSCREENWIDTH/2 - 120, kSCREENHEIGHT - (kIsiPhoneX ? 120 : 88), 240, 54);
    [self.view addSubview:erweima];
    
    
    
    [self.view addSubview:self.webUrlTextView];
    [self.view addSubview:self.promptLbl];
    [self.view addSubview:self.sumbitBtn];
}

- (void)clickSumbitButton:(UIButton *)sender {
    
    // 检查输入的URL是否合法
    NSURL *resultURL = [self smartURLForString:self.webUrlTextView.text];
    if (resultURL) {
        WebViewController *webVC = [[WebViewController alloc] init];
        // 全屏显示
        webVC.modalPresentationStyle = UIModalPresentationFullScreen;
        webVC.loadWebUrl = self.webUrlTextView.text;
        [self presentViewController:webVC animated:YES completion:nil];
    } else {
        [self showAlert:@"请输入合法链接地址"];
    }
}

- (void)showAlert:(NSString *)message {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"点击了OK");
    }];

    [alertController addAction:okAction];

    [self presentViewController:alertController animated:YES completion:nil];
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

#pragma mark - 检测输入的链接是否有效
- (NSURL *)smartURLForString:(NSString *)str {
    
    NSURL *result;
    NSString *trimmedStr;
    NSRange schemeMarkerRange;
    NSString *scheme;

    assert(str != nil);

    result = nil;

    trimmedStr = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ( (trimmedStr != nil) && (trimmedStr.length != 0) ) {
        schemeMarkerRange = [trimmedStr rangeOfString:@"://"];

        if (schemeMarkerRange.location == NSNotFound) {
            result = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@", trimmedStr]];
        } else {
            scheme = [trimmedStr substringWithRange:NSMakeRange(0, schemeMarkerRange.location)];
            assert(scheme != nil);

            if ( ([scheme compare:@"http"  options:NSCaseInsensitiveSearch] == NSOrderedSame)
                || ([scheme compare:@"https" options:NSCaseInsensitiveSearch] == NSOrderedSame) ) {
                result = [NSURL URLWithString:trimmedStr];
            } else {
                // It looks like this is some unsupported URL scheme.
            }
        }
    }

    return result;
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

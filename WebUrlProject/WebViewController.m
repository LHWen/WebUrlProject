//
//  WebViewController.m
//  WebUrlProject
//
//  Created by LHWen on 2020/10/14.
//  Copyright © 2020 LHWen. All rights reserved.
//

#import "WebViewController.h"
#import <WebKit/WebKit.h>
#import "JiaoHuView.h"

@interface WebViewController () <WKNavigationDelegate, WKUIDelegate, UIScrollViewDelegate, WKScriptMessageHandler>

// webView 承载视图
@property (nonatomic, strong) WKWebView *kWebView;
// 返回页面
@property (nonatomic, strong) UIView *dismissView;
// 交互页面
@property (nonatomic, strong) JiaoHuView *jiaoHuView;

@end

@implementation WebViewController

- (WKWebView *)kWebView {
    
    if (!_kWebView) {
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        // 设置偏好设置
        config.preferences = [[WKPreferences alloc] init];
        // 默认为0
        config.preferences.minimumFontSize = 10;
        // 默认认为YES
        config.preferences.javaScriptEnabled = YES;
        // 在iOS上默认为NO，表示不能自动通过窗口打开
        config.preferences.javaScriptCanOpenWindowsAutomatically = NO;
        // web内容处理池，由于没有属性可以设置，也没有方法可以调用，不用手动创建
        config.processPool = [[WKProcessPool alloc] init];
        // 通过JS与webview内容交互 注册 前端需要知晓 标识名称（不与安卓共用）JSANDIOSINTERACTION
        config.userContentController = [[WKUserContentController alloc] init];
        [config.userContentController addScriptMessageHandler:self name:@"JSANDIOSINTERACTION"];
        
        _kWebView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:config];
        _kWebView.backgroundColor = UIColor.whiteColor;
        _kWebView.scrollView.bounces = NO;
        _kWebView.navigationDelegate = self;
        _kWebView.scrollView.delegate = self;
        _kWebView.UIDelegate = self;
        if (@available(iOS 11.0, *)) {
            _kWebView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        
//        NSURL *webUrlPath = [[NSBundle mainBundle]URLForResource:@"ceshi.html" withExtension:nil];
//        [_kWebView loadRequest:[NSURLRequest requestWithURL:webUrlPath]];
        [_kWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.loadWebUrl]]];
    }
    return _kWebView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColor.whiteColor;
    
    [self.view addSubview:self.kWebView];
    [self.view addSubview:self.dismissView];
    [self.view addSubview:self.jiaoHuView];
}

#pragma mark -- WKNavigationDelegate
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    NSLog(@"开始加载...");
}

// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    NSLog(@"内容开始返回...");
}

// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NSLog(@"网页加载成功，在此做其他操作");
}

// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation {
    NSLog(@"页面加载失败...");
    [self p_webViewLoadFailAlertMSG:@"页面加载失败"];
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    
    NSLog(@"页面加载出错：%@", error);
    [self p_webViewLoadFailAlertMSG:@"页面加载出错"];
}

// 系统访问异常提示，并杀死进程
- (void)p_webViewLoadFailAlertMSG:(NSString *)message {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"点击了OK");
    }];

    [alertController addAction:okAction];

    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:alertController animated:YES completion:nil];
    });
}

#pragma mark -- WKUIDelegate

//// 创建一个新的WebView
- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures {
    
        if (navigationAction.request.URL) {
            
            NSLog(@"navigationAction.request: %@", navigationAction.request);
            NSURL *url = navigationAction.request.URL;
            NSLog(@"navigationAction.request.URL: %@", url);
            NSString *scheme = [url scheme];
            NSLog(@"scheme: %@", scheme);
            if (navigationAction.targetFrame == nil || !navigationAction.targetFrame.isMainFrame) {
                // 本web页面加载新页面
                   [webView loadRequest:navigationAction.request];
                // 跳转浏览器
//                [[UIApplication sharedApplication] openURL:url];
               }
           }
        

//    WKWebView *newsWKWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 300, self.view.bounds.size.width, self.view.bounds.size.height-300)];
//    newsWKWebView.navigationDelegate = self;
//    newsWKWebView.UIDelegate = self;
//    [newsWKWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.jianshu.com"]]];    // 注意 https

    return nil;
}

/** 显示一个JS的Alert（与JS交互）
 *  web界面中有弹出警告框时调用
 *  @param webView           实现该代理的webview
 *  @param message           警告框中的内容
 *  @param frame             主窗口
 *  @param completionHandler 警告框消失调用
 */
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    
    NSString *host = webView.URL.host;
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:host?:@"提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
}

///** 显示一个确认框（JS的）
// *  @abstract显示一个JavaScript确认面板。
// *  @param webView web视图调用委托方法。
// *  @param消息显示的消息。
// *  @param帧的信息帧的JavaScript发起这个调用。
// *  @param completionHandler确认后完成处理程序调用面板已经被开除。
// *  是的如果用户选择OK,如果用户选择取消。
// *  @discussion用户安全,您的应用程序应该调用注意这样一个事实一个特定的网站控制面板中的内容。
// * 一个简单的forumla对于识别frame.request.URL.host控制的网站。该小组应该有两个按钮,如可以取消。
// * 如果你不实现这个方法,web视图会像如果用户选择取消按钮。
// */
//- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler {
//
//}

/** 弹出一个输入框（与JS交互的）
 *  @abstract JavaScript显示一个文本输入面板。
 *  @param webView web视图调用委托方法。
 *  @param 消息显示的消息。
 *  @param defaultText初始文本显示在文本输入字段。
 *  @param 帧的信息帧的JavaScript发起这个调用。
 *  @param completionHandler后完成处理器调用文本输入面板已被撤职。如果用户选择了通过输入文本好吧,否则零。
 *  @discussion用户安全,您的应用程序应该调用注意这样一个事实一个特定的网站控制面板中的内容。
 *  一个简单的forumla对于识别frame.request.URL.host控制的网站。该小组应该有两个按钮,可以取消,和一个字段等输入文本。
 *  如果你不实现这个方法,web视图会像如果用户选择取消按钮。
 */
//- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler {
//
//}

// 处理拨打电话以及url跳转等等
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    NSURL *url = navigationAction.request.URL;
    NSString *scheme = [url scheme];
    NSLog(@"scheme: %@", scheme);
    if ([scheme isEqualToString:@"tel"]) {
        NSString *resourceSpecifier = [url resourceSpecifier];
        NSString *callPhone = [NSString stringWithFormat:@"telprompt://%@", resourceSpecifier];
        // 防止iOS 10及其之后，拨打电话系统弹出框延迟出现
        dispatch_async(dispatch_get_global_queue(0,0), ^{
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone]];
        });
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}

#pragma mark -- WKScriptMessageHandler  从web界面中接收到一个脚本时调用
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    /* js 调用原生方法
     window.webkit.messageHandlers.JSANDIOSINTERACTION.postMessage({
     info:'使用js调用原生的方法，触发原生调用js方法(测试)',
     state:2
     });
     */
    NSDictionary *dict = message.body;
    NSInteger state = [dict[@"state"] integerValue];
    NSString *aMassage = [NSString stringWithFormat:@"state is : %@\ninfo is : %@", dict[@"state"], dict[@"info"]];
    [self p_webViewLoadFailAlertMSG:aMassage];
    
    if (state == 1) {   // 获取js信息 触发原生方法 监听网络
        
    }
    //    if (state == 2) {  // 原生 调用 js 方法
    //        [self.kWebView evaluateJavaScript:@"jsfunction()" completionHandler:nil];
    //    }
}

#pragma mark - url 编码
- (NSString *)urlEncode:(NSString *)string {
    
    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                            (CFStringRef)string,
                                            NULL,
                                            CFSTR("!*'();:@&amp;=+$,/?%#[]"),
                                            kCFStringEncodingUTF8));
}

#pragma mark - 交互页面
- (JiaoHuView *)jiaoHuView {
    
    if (!_jiaoHuView) {
        _jiaoHuView = [[JiaoHuView alloc] initWithFrame:CGRectMake(0, 120, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 120)];
        _jiaoHuView.hidden = YES;
        __weak typeof(self) weakSelf = self;
        _jiaoHuView.makeFunction = ^(NSString * _Nonnull funcString) {
            [weakSelf.kWebView evaluateJavaScript:funcString completionHandler:nil];
            weakSelf.jiaoHuView.hidden = YES;
        };
    }
    return _jiaoHuView;
}

#pragma mark - 返回|交互视图
- (UIView *)dismissView {
    
    if (!_dismissView) {
        
        CGFloat kHeight = [UIScreen mainScreen].bounds.size.height;
        CGFloat kWidth = [UIScreen mainScreen].bounds.size.width;
        
        _dismissView = [UIView new];
        _dismissView.frame = CGRectMake(kWidth - 108, kHeight - 88, 88, 44);
        _dismissView.layer.cornerRadius = 22;
        _dismissView.layer.masksToBounds = YES;
        _dismissView.backgroundColor = [UIColor colorWithRed:30/255.0 green:144/255.0 blue:255/255.0 alpha:1.0];
         [_dismissView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDismissLable:)]];
         [_dismissView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dismissViewPan:)]];
        
        
        UILabel *titleLbl = [UILabel new];
        titleLbl.frame = CGRectMake(0, 0, 44, 44);
        titleLbl.layer.cornerRadius = 22;
        titleLbl.layer.masksToBounds = YES;
        titleLbl.text = @"返回";
        titleLbl.textColor = UIColor.whiteColor;
        titleLbl.textAlignment = NSTextAlignmentCenter;
        titleLbl.font = [UIFont systemFontOfSize:14];
        titleLbl.backgroundColor = [UIColor colorWithRed:30/255.0 green:144/255.0 blue:255/255.0 alpha:1.0];
        [self.dismissView addSubview:titleLbl];
        
        UIButton *jhBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        jhBtn.frame = CGRectMake(44, 0, 44, 44);
        [jhBtn setTitle:@"交互" forState:UIControlStateNormal];
        jhBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [jhBtn addTarget:self action:@selector(clickJiaoHu:) forControlEvents:UIControlEventTouchUpInside];
        [self.dismissView addSubview:jhBtn];
    }
    return _dismissView;
}

- (void)clickJiaoHu:(UIButton *)sender {
    NSLog(@"点击交互按钮");
    self.jiaoHuView.hidden = NO;
}

// 滑动
- (void)dismissViewPan:(UIPanGestureRecognizer *)sender {
    
    CGPoint translation = [sender translationInView:self.dismissView];
    
//    sender.view.center = CGPointMake(sender.view.center.x + translation.x, sender.view.center.y + translation.y);
    //每次移动完，将移动量置为0，否则下次移动会加上这次移动量
    [sender setTranslation:CGPointMake(0, 0) inView:self.view];
    
    CGFloat kHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat kWidth = [UIScreen mainScreen].bounds.size.width;

    CGFloat dismissX = self.dismissView.frame.origin.x;
    CGFloat dismissY = self.dismissView.frame.origin.y;

    if (sender.state == UIGestureRecognizerStateChanged) {
        CGFloat changeX = dismissX + translation.x;
        CGFloat changeY = dismissY + translation.y;
        if (changeX < 0) {
            changeX = 20;
        } else if (changeX > (kWidth - 44)) {
            changeX = kWidth - 108;
        }
        if (changeY < 0) {
            changeY = 88;
        } else if (changeY > (kHeight - 44)) {
            changeY = kHeight - 88;
        }
        self.dismissView.frame = CGRectMake(changeX, changeY, 88, 44);

    }
}

// 返回
- (void)tapDismissLable:(UITapGestureRecognizer *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end

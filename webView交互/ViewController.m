//
//  ViewController.m
//  webView交互
//
//  Created by 王立震 on 17/4/5.
//  Copyright © 2017年 王立震. All rights reserved.
//

#import "ViewController.h"
#import <WebKit/WebKit.h>

#define kWidth [UIScreen mainScreen].bounds.size.width

@interface ViewController ()<WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler>{

    WKWebView *_wkWebView;
    WKUserContentController * userContentController;

    UILabel *label;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self creatView];
}


- (void)creatView {
    
    //创建一个WKWebView的配置对象
    WKWebViewConfiguration *configur = [[WKWebViewConfiguration alloc] init];
    
    //设置configur对象的preferences属性的信息
    WKPreferences *preferences = [[WKPreferences alloc] init];
    configur.preferences = preferences;
    
    //是否允许与js进行交互，默认是YES的，如果设置为NO，js的代码就不起作用了
    preferences.javaScriptEnabled = YES;
    
    //注册供js调用的方法
    userContentController =[[WKUserContentController alloc]init];
    configur.userContentController = userContentController;
    configur.preferences.javaScriptEnabled = YES;
    configur.allowsInlineMediaPlayback = NO;
    
    [userContentController addScriptMessageHandler:self name:@"viewChange"];
    configur.userContentController = userContentController;
    if (!_wkWebView) {
        _wkWebView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 400) configuration:configur];
    }
    _wkWebView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _wkWebView.backgroundColor = [UIColor clearColor];
    _wkWebView.UIDelegate = self;
    //如果只是调用 loadRequest 这个代理不能写
    _wkWebView.navigationDelegate = self;
    _wkWebView.allowsBackForwardNavigationGestures =YES;//打开网页间的 滑动返回
    _wkWebView.scrollView.bounces = NO;
    _wkWebView.scrollView.scrollEnabled = NO;
    [self.view addSubview:_wkWebView];
    /*
    //1，最基本的加载网页 还是一样
    [_wkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.baidu.com"]]];
     */
    
     //2，加载本地html
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"html"];
    NSString *htmlStr = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    NSString *stylePath = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"css"];
    [_wkWebView loadHTMLString:htmlStr baseURL:[NSURL fileURLWithPath:stylePath]];
    
    /*
    // 3,本地编写js代码执行  图片缩放的js代码
    NSString *js = @"var count = document.images.length;for (var i = 0; i < count; i++) {var image = document.images[i];image.style.width=320;};window.alert('找到' + count + '张图');";
    // 根据JS字符串初始化WKUserScript对象
    WKUserScript *script = [[WKUserScript alloc] initWithSource:js injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    // 根据生成的WKUserScript对象，初始化WKWebViewConfiguration
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    [config.userContentController addUserScript:script];
    _wkWebView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:config];
    [_wkWebView loadHTMLString:@"<head></head><img src='http://www.nsu.edu.cn/v/2014v3/img/background/3.jpg' />"baseURL:nil];
    [self.view addSubview:_wkWebView];
     */
    

    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(30, 410, kWidth-60, 30)];
    [btn setTitle:@"原生按钮改变webView的视图" forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor redColor];
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(doSomeThing) forControlEvents:UIControlEventTouchUpInside];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(0, 450, kWidth, 30)];
    label.backgroundColor = [UIColor purpleColor];
    label.text = @"原生按钮";
    [self.view addSubview:label];
}

- (void)doSomeThing{
    
    //原生界面调用webView的方法
    [_wkWebView evaluateJavaScript:@"changeView('hehe')" completionHandler:nil];
}
- (void)labelChange:(NSString *)str{
    //webView调用原生界面的方法
    label.backgroundColor = [UIColor yellowColor];
    label.text = str;
}
- (void)dealloc
{
    [userContentController removeScriptMessageHandlerForName:@"viewChange"];
}

#pragma mark - 加载的状态回调 （WKNavigationDelegate）
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation{

}

//
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{

}

// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation{

}

// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation{

}

// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{

    
}

//
- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler{

}
#pragma mark - 页面跳转的代理方法 （WKNavigationDelegate）
// 接收到服务器跳转请求之后调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation{

}
// 在收到响应后，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{

}
// 在发送请求之前，决定是否跳
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{

        decisionHandler(WKNavigationActionPolicyAllow);
}
#pragma mark - 三种提示框 WKUIDelegate
//这个协议主要用于WKWebView处理web界面的三种提示框(警告框、确认框、输入框)，下面是警告框的例子:
/**
 *  web界面中有弹出警告框时调用
 *
 *   webView           实现该代理的webview
 *   message           警告框中的内容
 *   frame             主窗口
 *   completionHandler 警告框消失调用
 */
//调用JS的alert()方法
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(void (^)())completionHandler{
    


}

#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    
    NSDictionary *dic = message.body;
    NSString *method = [dic objectForKey:@"methodName"];
    if ([method isEqualToString:@"labelChange:"]) {
        NSString *str = [dic objectForKey:@"canshu"];
        [self labelChange:str];
        
    }else{
    
    }
}





@end

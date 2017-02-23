//
//  ViewController.m
//  WebView
//
//  Created by CC on 2017/2/21.
//  Copyright © 2017年 CC. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self layoutUI];
}

#pragma mark - 构建 UI
- (void)layoutUI {
    _webView = [[UIWebView alloc]initWithFrame:self.view.frame];
    [self.view addSubview:_webView];
    _webView.delegate = self;
    
    // 加载本地 HTML
    NSString *htmlPath = [[NSBundle mainBundle]pathForResource:@"File.html" ofType:nil];
    NSString *html = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
    NSURL *baseUrl = [NSURL fileURLWithPath:htmlPath];
    [_webView loadHTMLString:html baseURL:baseUrl];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor redColor];
    [button addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"缩放按钮" forState:UIControlStateNormal];
    [_webView addSubview:button];
    button.frame = CGRectMake(100, 300, 100, 100);
}

#pragma mark - 按钮点击事件
- (void)click {
    [_webView stringByEvaluatingJavaScriptFromString:
     @"var script = document.createElement('script');"
     "script.type = 'text/javascript';"
     "script.text = \"function ResizeImages() { "
     "var myimg,oldwidth;"
     "var maxwidth=380;" //缩放系数
     "for(i=0;i <document.images.length;i++){"
     "myimg = document.images[i];"
     "if(myimg.width > maxwidth){"
     "oldwidth = myimg.width;"
     "myimg.width = maxwidth;"
     "myimg.height = myimg.height * (maxwidth/oldwidth);"
     "}"
     "}"
     "}\";"
     "document.getElementsByTagName('head')[0].appendChild(script);"];
    [_webView stringByEvaluatingJavaScriptFromString:@"ResizeImages();"];
}

#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    // 获取界面的 title
    NSString *title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    NSLog(@"title:%@",title);
    
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        NSURL *url = [request URL];
        if ([[url scheme]isEqualToString:@"devzeng"]) {
            // 处理 JavaScript 和 Objective-C 交互
            if ([[url host]isEqualToString:@"login"]) {
                // 获取上面的 url 参数
                [webView stringByEvaluatingJavaScriptFromString:@"alert('登录成功')"];
                return YES;
            }
            return NO;
        }
    }
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    // 检查是否插入了并执行了这个函数, typeof alertTest 检查了 alertTest 这个函数是否存在,若存在则不执行
    BOOL isExist = [[webView stringByEvaluatingJavaScriptFromString:@"typeof alertTest == \'function\';"] isEqualToString:@"true"];
    if (!isExist) {
        [webView stringByEvaluatingJavaScriptFromString:
         @"var script = document.createElement('script');"
         "script.type = 'text/javascript';"
         "script.text = \"function alertTest(str) { "
         "alert(str)"
         "}\";"
         "document.getElementsByTagName('head')[0].appendChild(script);"];
        [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"alertTest('%@');", @"test"]];
    }
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end

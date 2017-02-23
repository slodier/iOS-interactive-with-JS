# iOS-interactive-with-JS
##1.注意点
` stringByEvaluatingJavaScriptFromString:` 只能在主线程执行
该函数执行 `JS` 是一笔不小的时间开销,应该尽可能减少使用它去执行复杂的 `JS` 代码
##2.同步和异步的问题
(1).`Objective-C` 调用 `JavaScript` 代码的时候是同步的
```Objective-C
- (nullable NSString *)stringByEvaluatingJavaScriptFromString:(NSString *)script;
```
(2).`JavaScript` 调用 `Objective-C` 代码是异步的
```Objective-C
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;
```
###3.常见的 `JS` 调用
(1).获取界面 title 
```Objective-C
NSString *title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
```
(2).获取当前的 URL
```Objective-C
NSString *url = [webView stringByEvaluatingJavaScriptFromString:@"document.location.href"];
```
###4.第三方库 
[WebViewJavaScriptBridge](https://github.com/marcuswestin/WebViewJavascriptBridge)
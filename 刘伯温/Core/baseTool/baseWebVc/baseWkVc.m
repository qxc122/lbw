//
//  baseWkVc.m
//  portal
//
//  Created by Store on 2017/8/31.
//  Copyright © 2017年 qxc122@126.com. All rights reserved.
//

#import "baseWkVc.h"
#import "Masonry.h"
#import "HeaderBase.h"
#import "LBShowRemendView.h"
#import "LBLoginViewController.h"

@interface baseWkVc ()<WKNavigationDelegate,WKUIDelegate>

@property (weak,nonatomic) UIProgressView *pro1;

@property (assign,nonatomic) BOOL islogSuccessfully;
@end

@implementation baseWkVc

- (void)viewDidLoad {
    [super viewDidLoad];
    WKWebView *webView = [[WKWebView alloc]initWithFrame:CGRectZero];
    //打开左划回退功能
    webView.allowsBackForwardNavigationGestures =YES;
    [self.view addSubview:webView];
    webView.UIDelegate = self;
    webView.navigationDelegate = self;
    self.webView = webView;
    webView.scrollView.showsHorizontalScrollIndicator = NO;
    webView.scrollView.showsVerticalScrollIndicator = NO;
    
    [webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    
    UIProgressView *pro1=[[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
    //设置的高度对进度条的高度没影响，整个高度=进度条的高度，进度条也是个圆角矩形
    //但slider滑动控件：设置的高度对slider也没影响，但整个高度=设置的高度，可以设置背景来检验
    [self.webView addSubview:pro1];
    [pro1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.webView);
        make.right.equalTo(self.webView);
        make.top.equalTo(self.webView);
        make.height.equalTo(@2);
    }];
    self.pro1 = pro1;
    //设置进度条颜色
    pro1.trackTintColor = [UIColor clearColor];
    //设置进度默认值，这个相当于百分比，范围在0~1之间，不可以设置最大最小值
    pro1.progress=0.0;
    //设置进度条上进度的颜色
    pro1.progressTintColor= [UIColor greenColor];
    
    [webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    
    LBGetVerCodeModel *dataBase =  [NSKeyedUnarchiver unarchiveObjectWithFile:PATH_base];
    NSString *reqUrl = @"";
    if (self.tabBarController.selectedIndex == 1){
        reqUrl = dataBase.WBW;
        self.title = dataBase.tab_cpTitle;
        self.islogSuccessfully = YES;
    }else if (self.tabBarController.selectedIndex == 3){
        reqUrl = dataBase.CFLT;
        if(ISLOGIN){
            NSString *token =  [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
            reqUrl = [reqUrl stringByAppendingString:token];
        }
        self.title = dataBase.tab_ltTitle;
        self.islogSuccessfully = NO;
    }
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:reqUrl]];
    [webView loadRequest:request];

    [MBProgressHUD showLoadingMessage:@"正在努力加载中..." toView:self.view];
    [self sendFront];
    
    self.webView.opaque = NO;
    [self setNavBtn];
    
    
//        NSLog(@"url =%@",reqUrl);
}


- (void)sendFront{
    
}

- (void)hideBottomBarWhenPush
{
//    self.hidesBottomBarWhenPushed = YES;
}

- (void)setNavBtn{
    UIButton *reloadButton = [UIButton buttonWithType:0];
    reloadButton.size = CGSizeMake(20, 20);
    [reloadButton setImage:[UIImage imageNamed:@"action_refresh"] forState:0];
    [reloadButton addTarget:self action:@selector(reloadButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *signButton = [UIButton buttonWithType:0];
    signButton.size = CGSizeMake(40, 20);
    [signButton setTitle:@"签到" forState:0];
    signButton.titleLabel.font = CustomUIFont(14);
    [signButton setTitleColor:[UIColor whiteColor] forState:0];
    [signButton addTarget:self action:@selector(signButtonClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItems = @[[[UIBarButtonItem alloc] initWithCustomView:reloadButton],[[UIBarButtonItem alloc] initWithCustomView:signButton]];
    
    UIButton *leftBackButton = [UIButton buttonWithType:0];
    leftBackButton.size = CGSizeMake(20, 20);
    [leftBackButton setImage:[UIImage imageNamed:@"action_back"] forState:0];
    [leftBackButton addTarget:self action:@selector(leftBackButtonClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBackButton];
    self.navigationItem.leftBarButtonItem = leftItem;
}
- (void)setUrl:(id)url{
    _url = url;
    if (url) {
        if ([self.url isKindOfClass:[NSURL class]]) {
            [self.webView loadRequest:[NSURLRequest requestWithURL:self.url]];
        }else if ([self.url isKindOfClass:[NSString class]]) {
            [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
        }
    }
}
- (void)dealloc{
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
    NSLog(@"%s",__func__);
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if (object == self.webView && [keyPath isEqualToString:@"estimatedProgress"] ) {
        // 这里就不写进度条了，把加载的进度打印出来，进度条可以自己加上去！
        CGFloat newProgress = [[change objectForKey:NSKeyValueChangeNewKey] floatValue];
        NSLog(@"%f",newProgress);
        [self.pro1 setAlpha:1.0f];
        [self.pro1 setProgress:newProgress animated:YES];
        if (newProgress >= 1.0f) {
            [UIView animateWithDuration:0.3 delay:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
                [self.pro1 setAlpha:0.0f];
            } completion:^(BOOL finished) {
                [self.pro1 setProgress:0.0f animated:NO];
            }];
        }
    } else if (object == self.webView && [keyPath isEqualToString:@"title"] ) {
        if (self.webView.title.length) {
//            self.title = self.webView.title;
//            [self.navigationItem setTitle:self.webView.title];
        }
    }else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    MJExtensionLog(@"navigationAction.request.URL.absoluteString=%@ \n",navigationAction.request.URL.absoluteString);
    if (ISLOGIN) {
        if ([navigationAction.request.URL.absoluteString hasSuffix:@"regist/Login"]) {
            [MBProgressHUD hideHUDForView:self.view];
            [MBProgressHUD showLoadingMessage:@"登陆成功，精彩马上呈现～" toView:self.view];
            [self sendFront];
        } else if ([navigationAction.request.URL.absoluteString containsString:@"location"]) {
            [MBProgressHUD hideHUDForView:self.view];
            self.islogSuccessfully = YES;
        }
    }

    decisionHandler(WKNavigationActionPolicyAllow);
}

//alert 警告框
-(void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }]];
    [self presentViewController:alert animated:YES completion:nil];
    NSLog(@"alert message:%@",message);
}


//confirm 确认框
-(void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请确认" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }]];
    [self presentViewController:alert animated:YES completion:NULL];
    
    NSLog(@"confirm message:%@", message);
    
}

//prompt 输入框函数：

- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * __nullable result))completionHandler {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"输入框" message:prompt preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.textColor = [UIColor blackColor];
    }];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler([[alert.textFields lastObject] text]);
    }]];
    
    [self presentViewController:alert animated:YES completion:NULL];
}

#pragma mark - WKUIDelegate
-(WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures
{
    if (!navigationAction.targetFrame.isMainFrame) {
        [webView loadRequest:navigationAction.request];
    }
    return nil;
}
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
    [MBProgressHUD hideHUDForView:self.view];
//    [MBProgressHUD showPrompt:@"请刷新试试" toView:self.view];
}
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation{
    if (self.islogSuccessfully) {
        [MBProgressHUD hideHUDForView:self.view];
    }
}

#pragma mark --签到
- (void)signButtonClick{
    [self basicVcsignButtonClick];
}

- (void)reloadButtonClick{
    if (self.webView.isLoading) {
        [MBProgressHUD showPrompt:@"正在加载中,请稍后刷新！" toView:self.view];
        [self sendFront];
    }else{
        [self.webView reloadFromOrigin];
        [MBProgressHUD showLoadingMessage:@"正在刷新中..." toView:self.view];
        [self sendFront];
    }
}

- (void)leftBackButtonClick{
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    }else if(self.navigationController.childViewControllers.count>1){
        [self popSelf];
    }
}
@end

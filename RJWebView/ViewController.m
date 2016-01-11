//
//  ViewController.m
//  RJWebView
//
//  Created by RongJun on 16/1/10.
//  Copyright © 2016年 RJ. All rights reserved.
//

#import "ViewController.h"
#import "RJWebView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    RJWebView *webView = [[RJWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    webView.url = @"http://www.baidu.com"; //设置网页地址
    webView.webViewType = WEBVIEWTYPETWO; //设置webview是否显示底部功能按钮 WEBVIEWONE 不显示 WEBVIEWTWO 显示
    [self.view addSubview:webView];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

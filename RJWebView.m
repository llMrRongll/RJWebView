//
//  RJWebView.m
//  RJWebView
//
//  Created by RongJun on 16/1/10.
//  Copyright © 2016年 RJ. All rights reserved.
//

#import "RJWebView.h"
@interface RJWebView()<UIWebViewDelegate>

@property (strong, nonatomic) UIToolbar *toolBar;
@property (strong, nonatomic) UIBarButtonItem *backBarItem;
@property (strong, nonatomic) UIBarButtonItem *forwardBarItem;
@property (strong, nonatomic) UIBarButtonItem *stopLoadingBarItem;
@property (strong, nonatomic) UIProgressView *progressBar;
@property (strong, nonatomic) NSTimer *progressTimer;

@end

@implementation RJWebView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = self;
    }
    return self;
}

- (void)orientChanged:(NSNotification *)notification{
    NSDictionary *dic = [notification userInfo];
    UIDeviceOrientation orient = [UIDevice currentDevice].orientation;
    /*
     UIDeviceOrientationUnknown,
     UIDeviceOrientationPortrait,            // Device oriented vertically, home button on the bottom
     UIDeviceOrientationPortraitUpsideDown,  // Device oriented vertically, home button on the top
     UIDeviceOrientationLandscapeLeft,       // Device oriented horizontally, home button on the right
     UIDeviceOrientationLandscapeRight,      // Device oriented horizontally, home button on the left
     UIDeviceOrientationFaceUp,              // Device oriented flat, face up
     UIDeviceOrientationFaceDown             // Device oriented flat, face down   */
    switch (orient) {
        case UIDeviceOrientationPortrait:
            [self updateFramesWhenOrientationChanged];
            break;
        case UIDeviceOrientationPortraitUpsideDown:
            //do nothing
            break;
        case UIDeviceOrientationLandscapeLeft:
            [self updateFramesWhenOrientationChanged];
            break;
        case UIDeviceOrientationLandscapeRight:
            [self updateFramesWhenOrientationChanged];
            break;
            
        default:
            break;
    }
}

- (void)updateFramesWhenOrientationChanged {

    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    self.progressBar.frame = CGRectMake(self.progressBar.frame.origin.x, self.progressBar.frame.origin.y, self.frame.size.width, self.progressBar.frame.size.height);
    self.toolBar.frame = CGRectMake(self.toolBar.frame.origin.x, self.frame.size.height - 40, self.frame.size.width, 40);
}

- (void)setWebViewType:(WEBVIEWTYPE)webViewType {
    if (webViewType == WEBVIEWTYPETWO) {
        [self addSubview:self.toolBar];
        [self addSubview:self.progressBar];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientChanged:) name:UIDeviceOrientationDidChangeNotification object:nil];
    }
}

- (void)setUrl:(NSString *)url {
    if (url) {
        
        [self loadRequest:[self requestWithURLString:url]];
        self.scrollView.contentOffset = CGPointMake(0, 40);

    }
}

- (UIProgressView *)progressBar {
    if (!_progressBar) {
        _progressBar = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 4)];
        _progressBar.progressTintColor = [UIColor blueColor];
    }
    return _progressBar;
}

- (NSTimer *)progressTimer {
    if (!_progressTimer) {
        _progressTimer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(timerRepeatAction:) userInfo:nil repeats:YES];
    }
    return _progressTimer;
}

- (void)timerRepeatAction:(NSTimer *)timer {
    float timerInterval = timer.timeInterval;
    if (self.progressBar.progress >= self.progressBar.frame.size.width*0.8) {
        [self.progressTimer invalidate];
        return;
    }
    [self updateProgressWithProgress:timerInterval/3];
    
}

- (void)updateProgressWithProgress:(float)progress {
    self.progressBar.progress = progress;
}

- (UIToolbar *) toolBar {
    
    if (!_toolBar) {
        _toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.frame.size.height-40, self.frame.size.width, 40)];
        UIBarButtonItem *flexibleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:(UIBarButtonSystemItemFlexibleSpace) target:self action:nil];
        
        _toolBar.items = @[self.backBarItem, self.forwardBarItem, flexibleItem, self.stopLoadingBarItem];
    }
    return _toolBar;
    
}

- (NSURLRequest *)requestWithURLString:(NSString *)url {
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    return request;
}

- (UIBarButtonItem *)backBarItem {
    if (!_backBarItem) {
        UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        [backButton setTitle:@"<" forState:(UIControlStateNormal)];
        [backButton setTitleColor:[UIColor colorWithRed:94/255 green:197/255 blue:248/255 alpha:1] forState:(UIControlStateNormal)];
        [backButton addTarget:self action:@selector(backWard) forControlEvents:(UIControlEventTouchUpInside)];
        _backBarItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    }
    return _backBarItem;
}

- (UIBarButtonItem *)forwardBarItem {
    if (!_forwardBarItem) {
        UIButton *forwardButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        [forwardButton setTitle:@">" forState:(UIControlStateNormal)];
        [forwardButton setTitleColor:[UIColor colorWithRed:94/255 green:197/255 blue:248/255 alpha:1] forState:(UIControlStateNormal)];
        [forwardButton addTarget:self action:@selector(forward) forControlEvents:(UIControlEventTouchUpInside)];
        _forwardBarItem = [[UIBarButtonItem alloc] initWithCustomView:forwardButton];
    }
    return _forwardBarItem;
}

- (UIBarButtonItem *)stopLoadingBarItem {
    if (!_stopLoadingBarItem) {
        _stopLoadingBarItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:(UIBarButtonSystemItemCancel) target:self action:@selector(stop)];
        _stopLoadingBarItem.tintColor = [UIColor redColor];
    }
    return _stopLoadingBarItem;
}

- (void)backWard {
    NSLog(@"back");
    [self goBack];
}

- (void)forward {
    NSLog(@"forward");
    [self goForward];
}

- (void)stop {
    NSLog(@"stop");
    [self stopLoading];
    [self goBack];
}

#pragma mark UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    self.stopLoadingBarItem.enabled = NO;
    self.backBarItem.enabled = [self canGoBack];
    self.forwardBarItem.enabled = [self canGoForward];
    [self updateProgressWithProgress:self.frame.size.width];
    [UIView animateWithDuration:0.2 animations:^{
        self.progressBar.alpha = 0;
    }];
}

- (void) webViewDidStartLoad:(UIWebView *)webView {
    self.stopLoadingBarItem.enabled = YES;
    self.progressBar.progress = 0;
    [self.progressTimer fire];
    self.progressBar.alpha = 1;
    
}

@end

//
//  RJWebView.h
//  RJWebView
//
//  Created by RongJun on 16/1/10.
//  Copyright © 2016年 RJ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, WEBVIEWTYPE){
    ///普通无按钮
    WEBVIEWTYPEONE = 0,
    ///附带功能按钮
    WEBVIEWTYPETWO
};

@interface RJWebView : UIWebView

///浏览模式
@property (nonatomic, assign) WEBVIEWTYPE webViewType;

///网页地址
@property (nonatomic, strong) NSString *url;

@end

//
//  WebViewController.h
//  Lyrics
//
//  Created by 中島 克己 on 2014/06/19.
//  Copyright (c) 2014年 katsumi nakashima. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LyricsViewController.h"

@interface WebViewController : UIViewController

@property (nonatomic ,retain) NSString *searchWord;
@property (nonatomic ,retain) UIWebView *kWebView;
@property (nonatomic ,retain) NSString *url;
@property (nonatomic ,assign) NSInteger tableId;
@property (nonatomic ,assign) NSInteger lyricsIndexPath;


@end

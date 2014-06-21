//
//  WebViewController.m
//  Lyrics
//
//  Created by 中島 克己 on 2014/06/19.
//  Copyright (c) 2014年 katsumi nakashima. All rights reserved.
//

#import "WebViewController.h"
#import "LyricsDB.h"
#import "Lyrics.h"

@interface WebViewController ()<UIWebViewDelegate>
{
    LyricsDB *ldb;
    Lyrics *lyrics;
    NSMutableArray *lyricsArr;
    NSURL *urlPath;
    UIBarButtonItem *backBtn;
    UIBarButtonItem *nextBtn;
    UIBarButtonItem *stopBtn;
    UIBarButtonItem *refreshBtn;

}
@end

@implementation WebViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"Google検索"];
    //WebView生成
    self.kWebView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    self.kWebView.delegate = self;
    self.kWebView.scalesPageToFit = YES;
    self.kWebView.frame = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height);
  
    //toolbar
    UIToolbar *tb = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0f, self.kWebView.frame.size.height-44.0, self.view.frame.size.width, 44.0f)];
    
    //Toolbarのボタン
    backBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:101 target:self action:@selector(backDidAction:)];
    nextBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:102 target:self action:@selector(nextDidAction:)];
    //UIToolbar *backBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 44.0f, 44.0f)];
    //backBar.tintColor = [BaseColor ServiceBaseColor];
    //backBar.transform = CGAffineTransformMakeScale(-1,1);
    //[backBar setItems:[NSArray arrayWithObject:backBtn]];
//    UIBarButtonItem *makeBackBtn = [[UIBarButtonItem alloc] initWithCustomView:backBar];
//    
//    refreshBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshDidAction:)];
//    stopBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(stopDidAction:)];
    
    //ボタン間隔
    UIBarButtonItem *fixspacer1 = [[UIBarButtonItem alloc]
                                   initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                   target:nil action:nil];
    fixspacer1.width = 20.0;
    
    
    
    NSArray *items = [NSArray arrayWithObjects:backBtn,fixspacer1,nextBtn, nil];
    
    //self.url
    self.url = [[NSString alloc] init];
    
    //DB
    ldb = [[LyricsDB alloc] initWithId:self.tableId];
    
    //Array
    lyricsArr = (NSMutableArray*)[ldb lyricsArr];
    
    //GlobalLyrics
    lyrics = [lyricsArr objectAtIndex:self.lyricsIndexPath];
    
    //self.url
    self.url = lyrics.url;
    
    //self.url判定
    if (self.url && ![self.url isEqualToString:@""]) {
        //self.urlをNSURLに変換
        urlPath = [NSURL URLWithString:[self.url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        NSLog(@"urlpath %@",self.url);
    }else{
        //空だったらgoogleで検索
        urlPath = [NSURL URLWithString:[[NSString stringWithFormat:@"https://www.google.co.jp/search?q=%@",self.searchWord] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
    //開く処理
    NSURLRequest *req = [NSURLRequest requestWithURL:urlPath];
    [self.kWebView loadRequest:req];
    
    [self.view addSubview:self.kWebView];
    [self.view addSubview:tb];
    [tb setItems:items];


}

//戻るボタン
-(void)backDidAction:(id)sender
{
    if(self.kWebView.canGoBack == YES)
    {
        [self.kWebView goBack];
    }
}

//進むボタン
-(void)nextDidAction:(id)sender
{
    if(self.kWebView.canGoForward == YES)
    {
        [self.kWebView goForward];
    }
}


// ページ読込開始時
-(void)webViewDidStartLoad:(UIWebView*)webView{
    NSLog(@"begin %@",lyrics.url);
    //インジゲータくるくる
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

}

// ページ読込完了時
-(void)webViewDidFinishLoad:(UIWebView*)webView{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    //URL取得
    NSLog(@"url mae %@",lyrics.url);
    NSString *nowURL = [[webView stringByEvaluatingJavaScriptFromString:@"document.URL"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *nowURL25 = [nowURL stringByReplacingOccurrencesOfString:@"%2525" withString:@"%"];
    NSString *nowURL2 = [nowURL25 stringByReplacingOccurrencesOfString:@"%25" withString:@"%"];
    [self setTitle:[webView stringByEvaluatingJavaScriptFromString:@"document.title"]];
    //lyricsにいれる
    lyrics.url = nowURL2;
    NSLog(@"nowurl2%@",nowURL2);
    [ldb update:lyrics];


}


@end

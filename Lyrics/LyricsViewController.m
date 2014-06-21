//
//  LyricsViewController.m
//  Lyrics
//
//  Created by 中島 克己 on 2014/06/15.
//  Copyright (c) 2014年 katsumi nakashima. All rights reserved.
//

#import "LyricsViewController.h"
#import "CustomCell.h"
#import "Lyrics.h"
#import "LyricsDB.h"
#import "WebViewController.h"


@interface LyricsViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *lyricsArr;
    NSString *lyricsTitle;
    LyricsDB *ldb;
    UIButton *editButton;
}
@end

@implementation LyricsViewController

@synthesize ViewId;

-(void)loadView
{
    self.view =[[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.view setBackgroundColor:[UIColor whiteColor]];
}


-(void)viewDidLoad
{
    [super viewDidLoad];
    
    //IDの取得
    
    
    //最上部View
    UIView *toolView = [[UIView alloc] initWithFrame:CGRectMake(0, 65, self.view.frame.size.width, 40)];
    toolView.backgroundColor = [UIColor whiteColor];
    
    // Add a bottomBorder.
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0.0f, 40.0, toolView.frame.size.width, 1.0f);
    bottomBorder.backgroundColor = [UIColor colorWithWhite:0.8f
                                                     alpha:1.0f].CGColor;    
    [toolView.layer addSublayer:bottomBorder];
    
    //Viewにのせるもの
    editButton = [[UIButton alloc] init];
    editButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    editButton.frame = CGRectMake(0, 0, self.view.frame.size.width/3, 40);
    [editButton setTitle:@"編集" forState:UIControlStateNormal];
    [editButton addTarget:self action:@selector(editButton:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *button2 = [[UIButton alloc] init];
    button2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button2.frame = CGRectMake((self.view.frame.size.width/3)*2, 0, self.view.frame.size.width/3, 40);
    [button2 setTitle:@"追加" forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(pushButton2:) forControlEvents:UIControlEventTouchUpInside];
    
//    UILabel *toolLabel3 = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/3, 0, self.view.frame.size.width/3, 40)];
//    toolLabel3.text = @"編集";
//    toolLabel3.textAlignment = NSTextAlignmentCenter;

    
    [toolView addSubview:editButton];
    [toolView addSubview:button2];
  //  [toolView addSubview:toolLabel3];
    
    //tableView
    self.kTableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    [self.kTableView registerClass:[CustomCell class] forCellReuseIdentifier:@"Cell"];
    
    self.kTableView.frame = (CGRectMake(0, 40, self.view.frame.size.width, self.view.frame.size.height));
    self.kTableView.delegate = self;
    self.kTableView.dataSource = self;
    
    [self.view addSubview:self.kTableView];
    [self.view addSubview:toolView];

    //DB
    ldb = [[LyricsDB alloc] initWithId:ViewId];
    
    //Array
    lyricsArr = (NSMutableArray*)[ldb lyricsArr];
    
}



//編集ボタンおしたら
-(void)editButton:(id)sender
{
    [self.kTableView setEditing:YES animated:YES];
    [editButton setTitle:@"完了" forState:UIControlStateNormal];
    [editButton addTarget:self action:@selector(endEditButton:) forControlEvents:UIControlEventTouchUpInside];

}

//完了ボタンおしたら
-(void)endEditButton:(id)sender
{
    [self.kTableView setEditing:NO animated:YES];
    [editButton setTitle:@"編集" forState:UIControlStateNormal];
    [editButton addTarget:self action:@selector(editButton:) forControlEvents:UIControlEventTouchUpInside];

}

//AlertView Tag
static const NSInteger kTagAlert1 = 1;
static const NSInteger kTagAlert2 = 2;

//追加ボタン押したら
-(void)pushButton2:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"新規歌詞"
                                                    message:@"タイトルを入力してください。"
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"OK", nil
                          ];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    alert.tag = kTagAlert1;
    
    
    [alert show];
}

//タップしたときの処理
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Lyricsを生成
    Lyrics *lyrics = [[Lyrics alloc] init];
    lyrics = [lyricsArr objectAtIndex:indexPath.row];
    //WebViewに移動 検索ワードを設定
    WebViewController *wvc = [[WebViewController alloc] init];
    wvc.searchWord = lyrics.name;
    wvc.tableId = self.ViewId;
    wvc.lyricsIndexPath = indexPath.row;
    [self.navigationController pushViewController:wvc animated:YES];
    
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"歌詞検索"
//                                                    message:@"検索ワードを入力してください。"
//                                                   delegate:self
//                                          cancelButtonTitle:@"Cancel"
//                                          otherButtonTitles:@"OK", nil
//                          ];
//    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
//    alert.tag = kTagAlert2;
//    
//    
//    [alert show];
}

//追加処理
#define CANCEL 0
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //tag判定
    if (kTagAlert1 == alertView.tag) {
        
        //Cancelじゃなかったら
        if (buttonIndex != CANCEL) {
            lyricsTitle = [[alertView textFieldAtIndex:0] text];
            
            //Titleに中身があったら
            if ((lyricsTitle && ![lyricsTitle isEqualToString:@""])) {
                Lyrics *lyrics1 = [[Lyrics alloc] initWithName:lyricsTitle];
                
                [ldb add:lyrics1];
                [lyricsArr addObject:lyrics1];
                
                //            NSLog(@"added playlistId is %ld",(long)lyrics1.playListId);
                //            NSLog(@"added name is %@",lyrics1.name);
                
                
                [self.kTableView reloadData];
            }
        }
    }
    
    //tag判定
    if (kTagAlert2 == alertView.tag) {
        
        //Cancelじゃなかったら
        if (buttonIndex != CANCEL) {
            lyricsTitle = [[alertView textFieldAtIndex:0] text];
            
            //Titleに中身があったら
            if ((lyricsTitle && ![lyricsTitle isEqualToString:@""])) {
                
                //WebViewに移動
                WebViewController *wvc = [[WebViewController alloc] init];
                wvc.searchWord = lyricsTitle;
                [self.navigationController pushViewController:wvc animated:YES];
                
            }
        }
    }
}





//Deleteボタンが押されたら
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //indexPath番目の配列に入ってるオブジェクトのidを抜く
        Lyrics *deleteObject = [lyricsArr objectAtIndex:indexPath.row];
        NSInteger deleteId = deleteObject.playListId;
        
        //        NSLog(@"deleted delete id is %ld",(long)deleteId);
        //        NSLog(@"deleted playListname is %@",deleteObject.name);
        //        NSLog(@"deleted indexPath row is %ld",(long)indexPath.row);
        
        
        [lyricsArr removeObjectAtIndex:indexPath.row];
        [ldb remove:deleteId];
        
        [self.kTableView reloadData];
    }
    
}


//セクション数をかえす（必須）
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

//セルの数（必須）
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return lyricsArr.count;   //セルの数をLyricsArr配列の長さで指定
}

//セルの中身
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    Lyrics *lyrics = [[Lyrics alloc] init];
    lyrics = [lyricsArr objectAtIndex:indexPath.row];
    
    //static（静的変数）
    static NSString *cellIdentifier = @"Cell";
    
    //使用可能なセルを取得
    CustomCell *cell = (CustomCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier]; //セルの再利用系メソッド
    
    //CustomCellクラスの各ラベルに指定されたレイアウトでテキストラベルを設置
    cell.titleLabel.text = lyrics.name;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    
    
    return cell;
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





@end

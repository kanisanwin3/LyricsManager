//
//  ViewController.m
//  Lyrics
//
//  Created by 中島 克己 on 2014/06/15.
//  Copyright (c) 2014年 katsumi nakashima. All rights reserved.
//

#import "PlayListViewController.h"
#import "PlayList.h"
#import "CustomCell.h"
#import "PlayListDB.h"
#import "LyricsViewController.h"

@interface PlayListViewController () <UIAlertViewDelegate, UITableViewDelegate, UITableViewDataSource>
{
    NSString *playListTitle;
    NSMutableArray *playLists;
    PlayListDB *pldb;
}


@end

@implementation PlayListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"歌詞リスト"];
    
    //NavBar
    UIBarButtonItem *addButton =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd  // スタイルを指定
                                                                              target:self  // デリゲートのターゲットを指定
                                                                              action:@selector(pushButton:)  // ボタンが押されたときに呼ばれるメソッドを指定
                                 ];
    self.navigationItem.rightBarButtonItem = addButton;
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    //Navibarの色
    [UINavigationBar appearance].barTintColor = [UIColor colorWithRed:0.000 green:0.549 blue:0.890 alpha:1.000];
    [UINavigationBar appearance].tintColor = [UIColor whiteColor];
    [UINavigationBar appearance].titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    
    //TableView
    self.tableView = [[UITableView alloc] initWithFrame:[self.view bounds]];
    [self.tableView registerClass:[CustomCell class] forCellReuseIdentifier:@"Cell"];

    self.tableView.frame = (CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height));
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    //DataBase
    pldb = [[PlayListDB alloc] init];
    
    
    //PlayLists
    playLists = (NSMutableArray*)[pldb playLists];
    
    
    
}

//＋ボタン押したら
-(void)pushButton:(id)sender{
    
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"新規歌詞リスト"
                                                    message:@"タイトルを入力してください。"
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"OK", nil
                          ];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    
    
    [alert show];
}

//UITableViewのSetEditingメソッドを追加
-(void)setEditing:(BOOL)editing animated:(BOOL)animated{
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:animated];
}

//セクション数をかえす（必須）
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

//セルの数（必須）
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return playLists.count;   //セルの数を配列の長さで指定
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50; //セルの縦幅
}


//Deleteボタンが押されたら
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //indexPath番目の配列に入ってるオブジェクトのidを抜く
        PlayList *deleteObject = [playLists objectAtIndex:indexPath.row];
        NSInteger deleteId = deleteObject.playListId;

        
        [playLists removeObjectAtIndex:indexPath.row];
        [pldb remove:deleteId];
        
        [self.tableView reloadData];
    }

}


//セルの中身
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //配列からindexpath番目のobjectを抽出
    PlayList *playList1 = [[PlayList alloc] init];
    playList1 = [playLists objectAtIndex:indexPath.row];

    //static（静的変数）
    static NSString *cellIdentifier = @"Cell";
    
    //使用可能なセルを取得
    CustomCell *cell = (CustomCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier]; //セルの再利用系メソッド
    
    //CustomCellクラスの各ラベルに指定されたレイアウトでテキストラベルを設置
    cell.titleLabel.text = playList1.name;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    
    
    return cell;
    
}



//タップしたときの処理
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LyricsViewController *lvc = [[LyricsViewController alloc] init];
    //PlayListをインスタンス化
    PlayList  *playList = [playLists objectAtIndex:indexPath.row];
    //lvcのtitleにはタップしたセルのname、setViewIdにplayListId（識別番号）を入れる
    lvc.title = playList.name;
    lvc.ViewId = playList.playListId;
    //[lvc setViewId:playList.playListId];//どっちでも動く
    
    [self.navigationController pushViewController:lvc animated:YES];
}

//定数　CANCEL = 0
#define CANCEL 0

//AlertViewの文字入力後
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //Cancelじゃなかったら
    if (buttonIndex != CANCEL) {
        
        playListTitle = [[alertView textFieldAtIndex:0] text];
        if ((playListTitle && ![playListTitle isEqualToString:@""])) {
            PlayList *playList1 = [[PlayList alloc] initWithName:playListTitle];
            
            [pldb add:playList1];
            [playLists addObject:playList1];
            
//            NSLog(@"added playlistId is %ld",(long)playList1.playListId);
//            NSLog(@"added name is %@",playList1.name);
            
            
            [self.tableView reloadData];
        }
    }
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

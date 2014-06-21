//
//  PlayListDB.h
//  Lyrics
//
//  Created by 中島 克己 on 2014/06/15.
//  Copyright (c) 2014年 katsumi nakashima. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PlayList;

//プレイリストの管理
@interface PlayListDB : NSObject

-(PlayList*)add:(PlayList*)playList;
-(NSArray*)playLists;
-(BOOL)remove:(NSInteger)playListId;
-(BOOL)update:(PlayList*)playList;



@end

//
//  LyricsDB.h
//  Lyrics
//
//  Created by 中島 克己 on 2014/06/18.
//  Copyright (c) 2014年 katsumi nakashima. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Lyrics;

@interface LyricsDB : NSObject

@property (nonatomic, assign) NSInteger ViewId;

-(id)setId:(NSInteger)ViewId;
-(id)initWithId:(NSInteger)ViewId;
-(Lyrics*)add:(Lyrics*)lyrics;
-(NSArray*)lyricsArr;
-(BOOL)remove:(NSInteger)lyricsId;
-(BOOL)update:(Lyrics*)lyrics;


@end

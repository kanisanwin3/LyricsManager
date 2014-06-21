//
//  PlayList.h
//  Lyrics
//
//  Created by 中島 克己 on 2014/06/15.
//  Copyright (c) 2014年 katsumi nakashima. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlayList : NSObject

@property (nonatomic, retain) NSString *name;
@property (nonatomic, assign) NSInteger playListId;


-(id)initWithName:(NSString*)name;

@end

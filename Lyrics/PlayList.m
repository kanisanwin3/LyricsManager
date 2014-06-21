//
//  PlayList.m
//  Lyrics
//
//  Created by 中島 克己 on 2014/06/15.
//  Copyright (c) 2014年 katsumi nakashima. All rights reserved.
//

#import "PlayList.h"

@implementation PlayList

-(id)initWithName:(NSString*)name{
    self = [super init];    //initを継承
    if (self) { //もし真なら
        self.name = name;   //受け取った文字列1をself.nameに代入
    }
    return self;
}

@end

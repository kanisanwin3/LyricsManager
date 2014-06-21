//
//  CustomCell.m
//  Lyrics
//
//  Created by 中島 克己 on 2014/06/15.
//  Copyright (c) 2014年 katsumi nakashima. All rights reserved.
//

#import "CustomCell.h"


NSString *Cell = @"Cell";

@implementation CustomCell



- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //タイトル
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 240, 30)];//titlelabelを初期化してサイズを設定
        self.titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth; //UILabelはUIViewを継承しているので、UIViewのプロパティを使える、幅を自動設定
        self.titleLabel.font = [UIFont systemFontOfSize:15];    //Fontを設定
        self.titleLabel.numberOfLines = 0;  //表示可能最大行数を設定
        
        //self.countentViewにaddするのがいいらしい
        [self.contentView addSubview:self.titleLabel];  //titleLabelをtableViewCellにのせる

        
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


@end

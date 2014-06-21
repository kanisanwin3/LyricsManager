//
//  PlayListDB.m
//  Lyrics
//
//  Created by 中島 克己 on 2014/06/15.
//  Copyright (c) 2014年 katsumi nakashima. All rights reserved.
//

#import "PlayListDB.h"
#import "PlayList.h"
#import "FMDatabase.h"
#import "FMResultSet.h"

#define DB_FILE_NAME @"app.db"

#define SQL_CREATE @"CREATE TABLE IF NOT EXISTS playLists (id INTEGER PRIMARY KEY AUTOINCREMENT,  title TEXT);"
#define SQL_INSERT @"INSERT INTO playLists (title) VALUES (?);"
#define SQL_UPDATE @"UPDATE playLists SET title = ? WHERE id = ?;"
#define SQL_SELECT @"SELECT id, title FROM playLists GROUP BY title;"
#define SQL_DELETE @"DELETE FROM playLists WHERE id = ?;"




@interface PlayListDB ()
@property (nonatomic, retain) NSString *dbPath;

-(FMDatabase*)getConnection;
+(NSString*)getDbFilePath;
@end

@implementation PlayListDB

//初期化
- (id)init
{
	self = [super init];
	if( self )
	{
		FMDatabase* db = [self getConnection];
		[db open];
		[db executeUpdate:SQL_CREATE];
		[db close];
	}
    
	return self;
}


//データベースに追加
-(PlayList*)add:(PlayList *)playList
{
	FMDatabase* db = [self getConnection];
	[db open];
    
	[db setShouldCacheStatements:YES];
	if( [db executeUpdate:SQL_INSERT, playList.name] )
	{
        playList.playListId = (int)[db lastInsertRowId];
    }
	else
	{
		playList = nil;
	}
	
	[db close];
    
	return playList;
}

//データベースから取得
- (NSArray *)playLists
{
	FMDatabase* db = [self getConnection];
	[db open];
	
	FMResultSet*    results = [db executeQuery:SQL_SELECT];
	NSMutableArray* playLists1 = [[NSMutableArray alloc] init];
	
	while( [results next] )
	{
		PlayList* playList = [[PlayList alloc] init];
		playList.playListId = [results intForColumnIndex:0];
        playList.name = [results stringForColumnIndex:1];
		
		[playLists1 addObject:playList];
    }
	
	[db close];
	
	return playLists1;
}

//削除処理
-(BOOL)remove:(NSInteger)playListId
{
	FMDatabase* db = [self getConnection];
	[db open];
    
	BOOL isSucceeded = [db executeUpdate:SQL_DELETE, [NSNumber numberWithInteger:playListId]];
	
	[db close];
    
	return isSucceeded;
}

- (BOOL)update:(PlayList *)playList
{
	FMDatabase* db = [self getConnection];
	[db open];
	
	BOOL isSucceeded = [db executeUpdate:SQL_UPDATE, playList.name, [NSNumber numberWithInteger:playList.playListId]];
	
	[db close];
	
	return isSucceeded;
}

/**
 * データベースを取得します。
 *
 * @return データベース。
 */
- (FMDatabase *)getConnection
{
	if( self.dbPath == nil )
	{
		self.dbPath =  [PlayListDB getDbFilePath];
	}
	
	return [FMDatabase databaseWithPath:self.dbPath];
}

/**
 * データベース ファイルのパスを取得します。
 */
+ (NSString*)getDbFilePath
{
	NSArray*  paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES );
	NSString* dir   = [paths objectAtIndex:0];
	
	return [dir stringByAppendingPathComponent:DB_FILE_NAME];
}

@end

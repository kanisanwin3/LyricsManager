//
//  PlayListDB.m
//  Lyrics
//
//  Created by 中島 克己 on 2014/06/15.
//  Copyright (c) 2014年 katsumi nakashima. All rights reserved.
//

#import "LyricsDB.h"
#import "Lyrics.h"
#import "FMDatabase.h"
#import "FMResultSet.h"
#import "LyricsViewController.h"

#define DB_FILE_NAME @"app.db"

#define SQL_CREATE @"CREATE TABLE IF NOT EXISTS lyrics (id INTEGER PRIMARY KEY AUTOINCREMENT,  title TEXT,url TEXT);"
#define SQL_INSERT @"INSERT INTO lyrics (title,url) VALUES (?);"
#define SQL_UPDATE @"UPDATE lyrics SET title = ?, url = ? WHERE id = ?;"
#define SQL_SELECT @"SELECT id, title, url FROM lyrics GROUP BY title;"
#define SQL_DELETE @"DELETE FROM lyrics WHERE id = ?;"




@interface LyricsDB ()
{
    NSString *sql_Create;
    NSString *sql_Insert;
    NSString *sql_Update;
    NSString *sql_Select;
    NSString *sql_Delete;
    
    NSInteger LyricsId;
}
@property (nonatomic, retain) NSString *dbPath;

-(FMDatabase*)getConnection;
+(NSString*)getDbFilePath;
@end

@implementation LyricsDB

//Table識別番号をグローバル変数にセット
-(id)setId:(NSInteger)ViewId
{

    
    return self;
}

//初期化
-(id)initWithId:(NSInteger)ViewId
{
    //識別番号
    LyricsId = ViewId;
    
    //SQL文
    sql_Create = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS lyrics%d (id INTEGER PRIMARY KEY AUTOINCREMENT,  title TEXT,url TEXT);",LyricsId];
    sql_Insert = [NSString stringWithFormat:@"INSERT INTO lyrics%d (title,url) VALUES (?,?);",LyricsId];
    sql_Update = [NSString stringWithFormat:@"UPDATE lyrics%d SET title = ?, url = ? WHERE id = ?;",LyricsId];
    sql_Select = [NSString stringWithFormat:@"SELECT id, title, url FROM lyrics%d GROUP BY title;",LyricsId];
    sql_Delete = [NSString stringWithFormat:@"DELETE FROM lyrics%d WHERE id = ?;",LyricsId];
    
    self = [super init];
    if( self )
	{
		FMDatabase* db = [self getConnection];
		[db open];
        [db executeUpdate:sql_Create];
		//[db executeUpdate:sqlText];
		[db close];
	}
    
    return self;
}



//データベースに追加
-(Lyrics*)add:(Lyrics *)lyrics
{
	FMDatabase* db = [self getConnection];
	[db open];
    
	[db setShouldCacheStatements:YES];
	if( [db executeUpdate:sql_Insert, lyrics.name, lyrics.url] )
	{
        lyrics.playListId = (int)[db lastInsertRowId];
    }
	else
	{
        
		lyrics = nil;
        NSLog(@"insert　error");

	}
	
	[db close];
    
	return lyrics;
}

//データベースから取得
- (NSArray *)lyricsArr
{
	FMDatabase* db = [self getConnection];
	[db open];
	
	FMResultSet*    results = [db executeQuery:sql_Select];
	NSMutableArray* lyricsAll = [[NSMutableArray alloc] init];
	
	while( [results next] )
	{
		Lyrics* lyrics = [[Lyrics alloc] init];
		lyrics.playListId = [results intForColumnIndex:0];
        lyrics.name = [results stringForColumnIndex:1];
        lyrics.url = [results stringForColumnIndex:2];
		
		[lyricsAll addObject:lyrics];
    }
	
	[db close];
	
	return lyricsAll;
}

//削除処理
-(BOOL)remove:(NSInteger)lyricsId
{
	FMDatabase* db = [self getConnection];
	[db open];
    
	BOOL isSucceeded = [db executeUpdate:sql_Delete, [NSNumber numberWithInteger:lyricsId]];
	
	[db close];
    
	return isSucceeded;
}

- (BOOL)update:(Lyrics *)lyrics
{
	FMDatabase* db = [self getConnection];
	[db open];
	
	BOOL isSucceeded = [db executeUpdate:sql_Update, lyrics.name, lyrics.url, [NSNumber numberWithInteger:lyrics.playListId]];
	
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
		self.dbPath =  [LyricsDB getDbFilePath];
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

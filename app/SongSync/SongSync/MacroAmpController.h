//
//  MacroAmpController.h
//  SongSync
//
//  Created by User on 11/18/18.
//  Copyright (c) 2018 dosdude1 Apps. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MacroAmpControllerDelegate <NSObject>
@optional

-(void)startPlayingAudioFile;
-(void)audioFileReceived:(NSData *)fileData;
-(void)didSetPaused:(BOOL)isPaused;
-(void)setPlayerTime:(int)time;

@end

@interface MacroAmpController : NSObject
{
    NSURLSession *session;
    NSString *serverURL;
    BOOL checkLoop;
    int currentHostSessionID;
}

@property (nonatomic, strong) id <MacroAmpControllerDelegate> delegate;

+ (instancetype)sharedInstance;
-(id)init;
-(void)beginNewSessionWithID:(int)ID withSongStartTimestamp:(int)startTimestamp withStartTime:(int)startTime withSongFileData:(NSData *)songData;
-(void)setPaused:(BOOL)paused forSessionID:(int)ID withCurrentSongTime:(int)time;
-(void)deleteSession:(int)ID;
-(long)connectToSession:(int)ID;
-(void)beginAudioFileDownload:(int)ID;
-(void)checkPaused:(int)ID;
-(void)endCheckLoop;
-(void)getCurrentSongTime:(int)ID;
-(void)cleanup;

@end

//
//  MacroAmpController.m
//  SongSync
//
//  Created by User on 11/18/18.
//  Copyright (c) 2018 dosdude1 Apps. All rights reserved.
//

#import "MacroAmpController.h"

@implementation MacroAmpController

-(id)init
{
    self = [super init];
    serverURL = @"http://192.168.1.116";
    currentHostSessionID = 0;
    return self;
}

+ (instancetype)sharedInstance
{
    static MacroAmpController *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[MacroAmpController alloc] init];
        // Do any other initialisation stuff here
    });
    return sharedInstance;
}

-(void)beginNewSessionWithID:(int)ID withSongStartTimestamp:(int)startTimestamp withStartTime:(int)startTime withSongFileData:(NSData *)songData
{
    
    currentHostSessionID = ID;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:@{@"id":[NSNumber numberWithInt:ID], @"start_at":[NSNumber numberWithInt:startTimestamp], @"start_on":[NSNumber numberWithInt:startTime], @"paused":[NSNumber numberWithBool:NO]} options:kNilOptions error:nil];
    
    
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@:8000/session", serverURL]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"iOS" forHTTPHeaderField:@"User-Agent"];
    [request setHTTPBody:postData];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
        if ((long)[httpResponse statusCode] == 200)
        {
            NSData *postData = songData;
            
            NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
            
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
            [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@:8000/session/upload", serverURL]]];
            [request setHTTPMethod:@"POST"];
            [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
            [request setValue:@"text/plain" forHTTPHeaderField:@"Content-Type"];
            [request setValue:@"iOS" forHTTPHeaderField:@"User-Agent"];
            [request setValue:[NSString stringWithFormat:@"%d", ID] forHTTPHeaderField:@"sess_id"];
            [request setHTTPBody:postData];
            NSOperationQueue *queue = [[NSOperationQueue alloc] init];
            [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                if ((long)[httpResponse statusCode] == 200)
                {
                    dispatch_async(dispatch_get_main_queue(), ^(void) {
                        
                        [self.delegate startPlayingAudioFile];
                        
                    });
                }
                else
                {
                    NSLog(@"Could not send file");
                }
            }];
            
        }
        else
        {
            NSLog(@"Could not send JSON");
        }
    }];
}
-(void)setPaused:(BOOL)paused forSessionID:(int)ID withCurrentSongTime:(int)time
{
    int timestamp = [[NSDate date] timeIntervalSince1970];
    NSData *postData = [NSJSONSerialization dataWithJSONObject:@{@"id":[NSNumber numberWithInt:ID], @"start_at":[NSNumber numberWithInt:time], @"start_on":[NSNumber numberWithInt:timestamp], @"paused":[NSNumber numberWithBool:paused]} options:kNilOptions error:nil];
    
    
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@:8000/session/%d", serverURL, ID]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"iOS" forHTTPHeaderField:@"User-Agent"];
    [request setHTTPBody:postData];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
    }];
}
-(void)deleteSession:(int)ID
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@:8000/session/%d", serverURL, ID]]];
    [request setHTTPMethod:@"DELETE"];
    //[request setValue:getLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"iOS" forHTTPHeaderField:@"User-Agent"];
    //[request setHTTPBody:getData];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
        NSLog(@"%ld", (long)[httpResponse statusCode]);
    }];
}
-(long)connectToSession:(int)ID
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@:8000/session/%d", serverURL, ID]]];
    [request setHTTPMethod:@"GET"];
    //[request setValue:getLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"iOS" forHTTPHeaderField:@"User-Agent"];
    //[request setHTTPBody:getData];
    NSURLResponse *response;
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    return (long)[(NSHTTPURLResponse *)response statusCode];
    
}
-(void)beginAudioFileDownload:(int)ID
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@:8000/static/%d.mp3", serverURL, ID]]];
    [request setHTTPMethod:@"GET"];
    //[request setValue:getLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"iOS" forHTTPHeaderField:@"User-Agent"];
    //[request setHTTPBody:getData];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
        if ((long)[httpResponse statusCode] == 200)
        {
            [self.delegate audioFileReceived:data];
        }
    }];
}
-(void)checkPaused:(int)ID
{
    checkLoop = YES;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        BOOL isPaused = NO;
        while (checkLoop)
        {
            //NSData *getData = [NSJSONSerialization dataWithJSONObject:@{"wait":"true" options:kNilOptions error:nil];
            
            
            //NSString *getLength = [NSString stringWithFormat:@"%lu", (unsigned long)[getData length]];
            
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
            [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@:8000/status/%d", serverURL, ID]]];
            [request setHTTPMethod:@"GET"];
            //[request setValue:getLength forHTTPHeaderField:@"Content-Length"];
            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            [request setValue:@"iOS" forHTTPHeaderField:@"User-Agent"];
            //[request setHTTPBody:getData];
            NSURLResponse *response;
            NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
            if ((long)[(NSHTTPURLResponse *)response statusCode] == 200)
            {
                BOOL paused = [[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil] boolValue];
                
                if (paused != isPaused)
                {
                    isPaused = paused;
                    
                    request = [[NSMutableURLRequest alloc] init];
                    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@:8000/session/%d", serverURL, ID]]];
                    [request setHTTPMethod:@"GET"];
                    //[request setValue:getLength forHTTPHeaderField:@"Content-Length"];
                    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
                    [request setValue:@"iOS" forHTTPHeaderField:@"User-Agent"];
                    //[request setHTTPBody:getData];
                    NSURLResponse *response;
                    data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
                    if ([(NSHTTPURLResponse *)response statusCode] == 200)
                    {
                        NSDictionary *dict = [[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil] objectAtIndex:0];
                        NSLog(@"%@", dict);
                        int start = [[dict objectForKey:@"start_at"] intValue];
                        dispatch_async(dispatch_get_main_queue(), ^(void) {
                            
                            NSLog(@"Starting at: %d", start);
                            [self.delegate setPlayerTime:start];
                            [self.delegate didSetPaused:isPaused];
                            
                        });
                    }
                }
            }
            sleep(0.2);
        }
    });
}
-(void)endCheckLoop
{
    checkLoop = NO;
}
-(void)getCurrentSongTime:(int)ID
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@:8000/session/%d", serverURL, ID]]];
    [request setHTTPMethod:@"GET"];
    //[request setValue:getLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"iOS" forHTTPHeaderField:@"User-Agent"];
    //[request setHTTPBody:getData];
    NSURLResponse *response;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    if ([(NSHTTPURLResponse *)response statusCode] == 200)
    {
        NSDictionary *dict = [[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil] objectAtIndex:0];
        NSLog(@"%@", dict);
        int start = [[dict objectForKey:@"start_at"] intValue];
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            
            [self.delegate setPlayerTime:start];
            
        });
    }
}
-(void)cleanup
{
    if (currentHostSessionID != 0)
    {
        [self deleteSession:currentHostSessionID];
    }
}
@end

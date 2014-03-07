//
//  MovieLibraryManager.m
//  DVDLibrary
//
//  Created by Amy Chiu on 3/6/14.
//  Copyright (c) 2014 Ming. All rights reserved.
//

#import "MovieLibraryManager.h"

static MovieLibraryManager *sharedInstance;

@implementation MovieLibraryManager

+(MovieLibraryManager *)sharedInstance{
    if (!sharedInstance){
        sharedInstance = [[MovieLibraryManager alloc] init];
    }
    return sharedInstance;
}

-(id)init{
    self = [super init] ;
    if (self){
        
    }
    return self;
}

-(void)writeToPList:(NSDictionary *)dictionaryToWrite{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    NSString *docfilePath = [basePath stringByAppendingPathComponent:@"movieData.plist"];
    [dictionaryToWrite writeToFile:docfilePath atomically:YES];
}

-(NSDictionary *)readFromPList{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    NSString *docfilePath = [basePath stringByAppendingPathComponent:@"movieData.plist"];
    return [NSDictionary dictionaryWithContentsOfFile:docfilePath];
}

@end

//
//  MovieLibraryManager.m
//  DVDLibrary
//
//  Created by Amy Chiu on 3/6/14.
//  Copyright (c) 2014 Ming. All rights reserved.
//

/******
 * This class is used to manage access to the plist movie library data
 ******/

#import "MovieLibraryManager.h"

static MovieLibraryManager *sharedInstance;

@implementation MovieLibraryManager

/********************************************************************************************
 * @method sharedInstance
 * @abstract if movieLibraryManager does not exist, create it, otherwise use existing one
 * @description used to manage the plist information
 ********************************************************************************************/
+(MovieLibraryManager *)sharedInstance{
    if (!sharedInstance){
        sharedInstance = [[MovieLibraryManager alloc] init];
    }
    return sharedInstance;
}

/********************************************************************************************
 * @method init
 * @abstract initializer
 * @description
 ********************************************************************************************/
-(id)init{
    self = [super init] ;
    if (self){
        
    }
    return self;
}

/********************************************************************************************
 * @method writeToPList
 * @abstract method to write to the plist
 * @description
 ********************************************************************************************/
-(void)writeToPList:(NSDictionary *)dictionaryToWrite
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    NSString *docfilePath = [basePath stringByAppendingPathComponent:@"movieData.plist"];
    [dictionaryToWrite writeToFile:docfilePath atomically:YES];
    NSLog(@"Movie library successfully written to pList!");
}

/********************************************************************************************
 * @method readFromPList
 * @abstract method to read from the plist
 * @description
 ********************************************************************************************/
-(NSMutableDictionary *)readFromPList
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    NSString *docfilePath = [basePath stringByAppendingPathComponent:@"movieData.plist"];
    return [NSDictionary dictionaryWithContentsOfFile:docfilePath];
}

@end

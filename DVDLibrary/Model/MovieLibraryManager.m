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
#import "Movie.h"

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
    NSLog(@">>>>>Movie library successfully written to pList!");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Movie Added" object:self];
    NSLog(@">>>>>notification sent");

}

/********************************************************************************************
 * @method readFromPList
 * @abstract method to read from the plist
 * @description
 ********************************************************************************************/
- (NSMutableDictionary *)readFromPList
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    NSString *docfilePath = [basePath stringByAppendingPathComponent:@"movieData.plist"];
    return [NSDictionary dictionaryWithContentsOfFile:docfilePath];
}

/********************************************************************************************
 * @method getMovieLibrary
 * @abstract method to convert nsdata objects in plist to movie objects
 * @description returns an array that contains movie objects from the plist
 ********************************************************************************************/
- (NSMutableArray *)getMovieLibrary
{
    NSMutableDictionary *readDictionary = [self readFromPList];
    NSMutableArray *readArray = [readDictionary objectForKey:@"list"];
    
    //convert each object in read dictionary to a movie object and add to arraylist
    NSMutableArray *movieLibrary = [[NSMutableArray alloc]init];
    for (NSData *data in readArray) {
        Movie *obj = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        [movieLibrary addObject:obj];
    }
    NSLog(@">>>>>getMovieLibrary method successfully converted to movie object array");
    return movieLibrary;
}

/********************************************************************************************
 * @method writeToMovieLibrary
 * @abstract method to write an array to the plist
 * @description converts all movie objects in an array to nsdata objects to be stored in the
                plist and then saves the plist
 ********************************************************************************************/
- (void)saveMovieLibrary: (NSMutableArray *)movieLibraryArray
{
    //convert all movie objects into data objects to put back into plist
    NSMutableArray *movieDataArray = [[NSMutableArray alloc]init];
    for (Movie *item in movieLibraryArray) {
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:item];
        [movieDataArray addObject:data];
    }
    NSLog(@">>>>>Converts all movie objects in array into NSData objects");
    
    //store plist
    NSDictionary *itemToWrite = @{@"list": movieDataArray};
    [self writeToPList:itemToWrite];
}

@end

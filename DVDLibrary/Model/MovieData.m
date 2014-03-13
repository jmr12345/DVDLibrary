//
//  MovieData.m
//  DVDLibrary
//
//  Created by Ming on 3/1/14.
//  Copyright (c) 2014 Ming. All rights reserved.
//

/******
 * This class is used to pre-populate the library when it is first launched
 ******/

#import "MovieData.h"
#import "Movie.h"
#import "MovieLibraryManager.h"

@implementation MovieData

- (id)init
{
    self = [super init];
    if (self) {
        [self loadInitialData];
    }
    return self;
}

/********************************************************************************************
 * @method loadInitialData
 * @abstract prepopulates the movie library
 * @description populates the movie library with data from an existing pList on first launch
 for example purposes - if for app store, we would not use this
 ********************************************************************************************/
-(void)loadInitialData
{
    NSString* plistPath = [[NSBundle mainBundle] pathForResource:@"launchData" ofType:@"plist"];
    NSMutableDictionary *readDictionary = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    NSMutableArray *readArray = [readDictionary objectForKey:@"list"];
    
    //convert each object in read dictionary to a movie object and add to arraylist
    NSMutableArray *movieLibrary = [[NSMutableArray alloc]init];
    for (NSData *data in readArray) {
        Movie *obj = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        [movieLibrary addObject:obj];
    }
    
    MovieLibraryManager *plist = [[MovieLibraryManager alloc]init];
    //save pList to documents plist
    [plist saveMovieLibrary:movieLibrary];
    NSLog(@">>>>>Uploaded initial data %@", movieLibrary);
}

@end


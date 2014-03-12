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
#import "SearchResult.h"

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
 * @abstract pre-populates the movie library the first time the app is launched
 * @description
 ********************************************************************************************/
- (void)loadInitialData
{
//    NSString *movieTitle = @"21 Jump Street";
//    [self fetchMovieData:movieTitle];
//    
//    movieTitle = @"The Avengers";
//    [self fetchMovieData:movieTitle];
//    
//    movieTitle = @"The Incredibles";
//    [self fetchMovieData:movieTitle];
//    
//    movieTitle = @"Monsters, Inc.";
//    [self fetchMovieData:movieTitle];
//    
//    movieTitle = @"Atonement";
//    [self fetchMovieData:movieTitle];
//    
//    movieTitle = @"Star Wars: The Clone Wars";
//    [self fetchMovieData:movieTitle];
//    
//    movieTitle = @"This Means War";
//    [self fetchMovieData:movieTitle];
//    
//    movieTitle = @"Lincoln";
//    [self fetchMovieData:movieTitle];
//    
//    movieTitle = @"Buffy the Vampire Slayer";
//    [self fetchMovieData:movieTitle];
//    
//    movieTitle = @"Footloose";
//    [self fetchMovieData:movieTitle];
//    
//    movieTitle = @"Patriot Games";
//    [self fetchMovieData:movieTitle];
//    
//    movieTitle = @"Dumb and Dumber";
//    [self fetchMovieData:movieTitle];
}

/********************************************************************************************
 * @method fetchMovieData
 * @abstract searches for a specific movie's information to populate the table
 * @description
 ********************************************************************************************/
- (void)fetchMovieData: (NSString *)movieTitle
{
    SearchResult *search = [[SearchResult alloc]initWithMovieTitle:movieTitle];
    [search titleSearch:movieTitle];
}

@end


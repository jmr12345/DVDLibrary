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
    NSString *movie1Title = @"21 Jump Street";
    SearchResult *movie1 = [[SearchResult alloc]initWithMovieTitle:movie1Title];
    [movie1 titleSearch:movie1Title];
    
    NSString *movie2Title = @"The Avengers";
    SearchResult *movie2 = [[SearchResult alloc]initWithMovieTitle:movie2Title];
    [movie2 titleSearch:movie2Title];
    
    NSString *movie3Title = @"The Incredibles";
    SearchResult *movie3 = [[SearchResult alloc]initWithMovieTitle:movie3Title];
    [movie3 titleSearch:movie3Title];
    
    NSString *movie4Title = @"Monsters, Inc.";
    SearchResult *movie4 = [[SearchResult alloc]initWithMovieTitle:movie4Title];
    [movie4 titleSearch:movie4Title];
    
    NSString *movie5Title = @"Atonement";
    SearchResult *movie5 = [[SearchResult alloc]initWithMovieTitle:movie5Title];
    [movie5 titleSearch:movie5Title];
    
    NSString *movie6Title = @"Star Wars: The Clone Wars";
    SearchResult *movie6 = [[SearchResult alloc]initWithMovieTitle:movie6Title];
    [movie6 titleSearch:movie6Title];
    
    NSString *movie7Title = @"This Means War";
    SearchResult *movie7 = [[SearchResult alloc]initWithMovieTitle:movie7Title];
    [movie7 titleSearch:movie7Title];
    
}

@end


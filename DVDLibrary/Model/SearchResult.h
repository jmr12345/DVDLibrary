//
//  SearchResult.h
//  DVDLibrary
//
//  Created by Amy Chiu on 3/8/14.
//  Copyright (c) 2014 Ming. All rights reserved.
//
/******
 * This class is used to find all the data for a specific movie based on either
 * a movie's upc value or title. It accesses several api's to gather all of the
 * needed information.
 * API's used: searchupc, rovi and the movieDB
 ******/

#import <Foundation/Foundation.h>
#import "Movie.h"

@interface SearchResult : NSObject

//used for the rovi api
@property (strong, nonatomic) NSString *roviApiKey;
@property (strong, nonatomic) NSString *sig;

//used for the movieDB api
@property (strong, nonatomic) NSString *movieDbApiKey;

//what this class populates
@property (strong, nonatomic) Movie *foundMovie;

//
@property (weak, nonatomic) NSURLSession *upcSearch;
@property (weak, nonatomic) NSURLSession *titleSearch;
@property (weak, nonatomic) NSURLSession *movieDBSearch;
@property (weak, nonatomic) NSURLSession *trailerSearch;
@property (weak, nonatomic) NSURLSession *movieInfoSearch;

//initializer methods
- (id)initWithUpc: (NSString *)upcSymbol;
- (id)initWithMovieTitle: (NSString *)title;

//search methods
- (void)titleSearch: (NSString *)title;
- (void)searchForMovieByUpc: (NSString *)upcSymbol;

//counter to prevent repeat loop
@property (nonatomic) __block int *titleNum;
@property (nonatomic) __block int *num;
@property (nonatomic) __block int *loop;

@end

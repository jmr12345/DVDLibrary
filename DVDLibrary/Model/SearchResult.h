//
//  SearchResult.h
//  DVDLibrary
//
//  Created by Amy Chiu on 3/8/14.
//  Copyright (c) 2014 Ming. All rights reserved.
//

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

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

@property (strong, nonatomic) Movie *foundMovie;
@property (strong, nonatomic) NSString *roviApiKey;
@property (strong, nonatomic) NSString *sig;
@property (strong, nonatomic) NSString *movieDbApiKey;

- (id)initWithUpc: (NSString *)upcSymbol;
- (id)initWithMovieTitle: (NSString *)title;
- (void)searchForMovieByUpc: (NSString *)upcSymbol;
- (void)searchForMovieByTitle: (NSString *)movieTitle;
@end

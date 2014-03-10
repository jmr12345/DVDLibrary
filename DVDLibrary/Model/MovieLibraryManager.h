//
//  MovieLibraryManager.h
//  DVDLibrary
//
//  Created by Amy Chiu on 3/6/14.
//  Copyright (c) 2014 Ming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MovieLibraryManager : NSObject

+ (MovieLibraryManager *)sharedInstance;
- (NSMutableArray *)getMovieLibrary;
- (void)saveMovieLibrary: (NSMutableArray *)movieLibraryArray;

@end

//
//  Movie.h
//  DVDLibrary
//
//  Created by Ming on 2/27/14.
//  Copyright (c) 2014 Ming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Movie : NSObject <NSCoding>

@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *genre;
@property (nonatomic,strong) NSString *description;
@property (nonatomic,strong) UIImage *image;
@property (nonatomic,strong) NSURL *url;
@property (nonatomic,strong) NSString *upc;
@property (nonatomic,strong) NSString *movieDbId;
@property (nonatomic,strong) NSString *imdbId;
@property (nonatomic,strong) NSString *duration;
@property (nonatomic,strong) NSString *mpaaRating;
@property (nonatomic,strong) NSDate *releaseDate;
@property (nonatomic,strong) NSMutableArray *directors;
@property (nonatomic,strong) NSMutableArray *cast;

- (id)initWithCoder:(NSCoder *)decoder;
- (void)encodeWithCoder:(NSCoder *)encoder;
@end

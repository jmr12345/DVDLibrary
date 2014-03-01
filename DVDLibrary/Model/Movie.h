//
//  Movie.h
//  DVDLibrary
//
//  Created by Ming on 2/27/14.
//  Copyright (c) 2014 Ming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Movie : NSObject

@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *genre;
@property (nonatomic,strong) NSString *description;
@property (nonatomic,strong) UIImage *image;
@property (nonatomic,strong) NSURL *url;

@end

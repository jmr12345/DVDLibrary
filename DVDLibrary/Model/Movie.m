//
//  Movie.m
//  DVDLibrary
//
//  Created by Ming on 2/27/14.
//  Copyright (c) 2014 Ming. All rights reserved.
//

/******
 * This class defines a movie object and can encode/decode to/from NSData object
 * as well as compares two movie objects with each other
 ******/

#import "Movie.h"

@implementation Movie

/********************************************************************************************
 * @method initWithCoder
 * @abstract transforms NSData object back to a Movie object
 * @description
 ********************************************************************************************/
- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        self.title = [decoder decodeObjectForKey:@"title"];
        self.genre = [decoder decodeObjectForKey:@"genre"];
        self.description = [decoder decodeObjectForKey:@"description"];
        self.image = [[UIImage alloc]initWithData:[decoder decodeObjectForKey:@"image"]];
        self.url = [decoder decodeObjectForKey:@"url"];
        self.upc = [decoder decodeObjectForKey:@"upc"];
        self.movieDbId = [decoder decodeObjectForKey:@"movieDbId"];
        self.imdbId = [decoder decodeObjectForKey:@"imdbID"];
        self.duration = [decoder decodeObjectForKey:@"duration"];
        self.mpaaRating = [decoder decodeObjectForKey:@"mpaaRating"];
        self.releaseDate = [decoder decodeObjectForKey:@"releaseDate"];
        self.directors = [decoder decodeObjectForKey:@"directors"];
        self.cast = [decoder decodeObjectForKey:@"cast"];
        self.trailer = [decoder decodeObjectForKey:@"trailer"];
    }
    NSLog(@"Decoded object: %@", self);
    return self;
}

/********************************************************************************************
 * @method encodeWithCoder
 * @abstract transforms Movie object to an NSData object
 * @description
 ********************************************************************************************/
- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.title forKey:@"title"];
    [encoder encodeObject:self.genre forKey:@"genre"];
    [encoder encodeObject:self.description forKey:@"description"];
    NSData *image = UIImagePNGRepresentation(self.image);
    [encoder encodeObject:image forKey:@"image"];
    [encoder encodeObject:self.url forKey:@"url"];
    [encoder encodeObject:self.upc forKey:@"upc"];
    [encoder encodeObject:self.movieDbId forKey:@"movieDbId"];
    [encoder encodeObject:self.imdbId forKey:@"imdbID"];
    [encoder encodeObject:self.duration forKey:@"duration"];
    [encoder encodeObject:self.mpaaRating forKey:@"mpaaRating"];
    [encoder encodeObject:self.releaseDate forKey:@"releaseDate"];
    [encoder encodeObject:self.directors forKey:@"directors"];
    [encoder encodeObject:self.cast forKey:@"cast"];
    [encoder encodeObject:self.trailer forKey:@"trailer"];
    NSLog(@"Encoded object to be an NSData object");
}

/********************************************************************************************
 * @method compare
 * @abstract compares one Movie object title with another
 * @description
 ********************************************************************************************/
- (NSComparisonResult)compare:(Movie *)otherObject {
    NSLog(@"Compares %@ with %@", self.title, otherObject.title);
    return [self.title compare:otherObject.title];
}
@end

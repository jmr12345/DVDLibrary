//
//  SearchResult.m
//  DVDLibrary
//
//  Created by Amy Chiu on 3/8/14.
//  Copyright (c) 2014 Ming. All rights reserved.
//

#import "SearchResult.h"
#import "Movie.h"
#import <CommonCrypto/CommonDigest.h>

@implementation SearchResult

/********************************************************************************************
 * @method init
 * @abstract general initialize method
 * @description
 ********************************************************************************************/
- (id) init {
    self = [super init];
    if(self){

    }
    return self;
}

/********************************************************************************************
 * @method initWithUpc
 * @abstract initializes a search result with a movie upc
 * @description
 ********************************************************************************************/
- (id)initWithUpc: (NSString *)upcSymbol
{
    self = [self init];
    if(self){
        self.roviApiKey = @"rc3sf8efxtuv28kf9rj6gbwv";
        self.movieDbApiKey = @"a9dc5652da0de21c8fbd3004a590931b";
        self.foundMovie = [[Movie alloc]init];
        self.foundMovie.upc = upcSymbol;
    }
    return self;
}

/********************************************************************************************
 * @method initWithMovieTitle
 * @abstract initializes a search result with a movie title
 * @description
 ********************************************************************************************/
- (id)initWithMovieTitle: (NSString *)title
{
    self = [self init];
    if(self){
        self.roviApiKey = @"rc3sf8efxtuv28kf9rj6gbwv";
        self.movieDbApiKey = @"a9dc5652da0de21c8fbd3004a590931b";
        self.foundMovie = [[Movie alloc]init];
        self.foundMovie.title = title;
    }
    return self;
}

/********************************************************************************************
 * @method searchForMovieByUpc
 * @abstract downloads the json name from the website
 * @description Accesses a database called searchupc that finds the dvd/bluray
 *              tied to to a specific upc after a user scans a barcode.
 *              After finding the product, we grab the name of the product
 ********************************************************************************************/
- (void)searchForMovieByUpc: (NSString *)upcSymbol
{
    //weblink that returns product from scanning upc symbol
    NSString *query = [NSString stringWithFormat:@"http://www.searchupc.com/handlers/upcsearch.ashx?request_type=3&access_token=F4F91C0E-E947-43C4-A649-7D4DE9C08044&upc=%@", upcSymbol];
    
    NSLog(@"Link to searchupc api: %@", query);
    
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:[NSURL URLWithString:query]
            completionHandler:^(NSData *data,NSURLResponse *response,NSError *error) {
                NSError *errorJson = nil;
                NSDictionary *results = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&errorJson];
                
                // Update the Nsmutable Array
                NSMutableDictionary *upcMovieResults = [[results mutableCopy] objectForKey:@"0"];
                NSLog(@"JSON results from upc search: %@", upcMovieResults);
                
                //gets the movie title (and removes the extra appended information such as "(blu-ray)" and "(digital copy)")
                NSString *title = (NSString *)[upcMovieResults objectForKey:@"productname"];
                self.foundMovie.title = [self editTitle:title];
                
                NSLog(@"Movie title: %@", self.foundMovie.title);
                
                //performs a search by movie title
                [self searchForMovieByTitle:self.foundMovie.title];
                
            }] resume];
}

/********************************************************************************************
 * @method editTitle
 * @abstract edits the title
 * @description edits the title to remove excess information from the title and trims the string
 ********************************************************************************************/
- (NSString *)editTitle: (NSString *)title
{
    NSRange range = [title rangeOfString:@"("];
    NSString *movieTitle = [title substringToIndex:range.location];
    return [movieTitle stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

/********************************************************************************************
 * @method searchForMovieByTitle
 * @abstract searches by movie title for the following information: mpaa rating, duration,
 *           directors and cast
 * @description Accesses an api called rovicorp to get a movie's mpaa rating, duration, list
 *              of directors and cast
 ********************************************************************************************/
- (void)searchForMovieByTitle: (NSString *)movieTitle
{
    //gets the sig key to access the api
    self.sig = [self md5ConversionToSig];
    
    //updates movie title to a searchable format
    NSString *title = [movieTitle stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *searchableTitle = [title stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    NSLog(@"Original movie title: %@ and Searchable movie title: %@", movieTitle, searchableTitle);
    
    //api access
    NSString *query = [NSString stringWithFormat:@"http://api.rovicorp.com/search/v2.1/amgvideo/search?apikey=%@&sig=%@&query=%@&entitytype=movie&size=1&format=json&include=all", self.roviApiKey, self.sig, searchableTitle];
    NSLog(@"Link to rovicorp api: %@", query);
    
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:[NSURL URLWithString:query]
            completionHandler:^(NSData *data,NSURLResponse *response,NSError *error) {
                NSError *errorJson = nil;
                NSDictionary *results = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&errorJson];
                
                // Update the Nsmutable Array
                NSMutableDictionary *titleMovieResults = [[results mutableCopy] objectForKey:@"searchResponse"];
                NSMutableDictionary *result = [[titleMovieResults objectForKey:@"results"] objectAtIndex:0];
                NSMutableDictionary *movieInfo = [result objectForKey:@"movie"];
                
                //gets the mpaa rating
                self.foundMovie.mpaaRating = [movieInfo objectForKey:@"mpaa"];
                
                //gets the movie duration
                self.foundMovie.duration = [movieInfo objectForKey:@"duration"];
                
                //gets the list of movie directors
                self.foundMovie.directors = [[NSMutableArray alloc] init];
                NSMutableArray *directors = [movieInfo objectForKey:@"directors"];
                for (NSDictionary *director in directors) {
                    NSString *category = [director objectForKey:@"name"];
                    [self.foundMovie.directors addObject:category];
                }
                
                //gets the list of cast members
                self.foundMovie.cast = [[NSMutableArray alloc] init];
                NSMutableArray *castMembers = [movieInfo objectForKey:@"cast"];
                for (NSDictionary *member in castMembers) {
                    NSString *castName = [member objectForKey:@"name"];
                    [self.foundMovie.cast addObject:castName];
                }
                
                //gets the movie id
                [self getMovieIDandInfo:self.foundMovie.title];
                
            }] resume];
}

/********************************************************************************************
 * @method md5ConversionToSig
 * @abstract helper method to do a sig conversion to access rovi api
 * @description creates the sig access key
 ********************************************************************************************/
- (NSString *) md5ConversionToSig
{
    NSString *sharedSecret = @"rQm5PPRUjg";
    
    //gets the current time for the conversion since 1970
    int unixtime = (int)[[NSNumber numberWithDouble: [[NSDate date] timeIntervalSince1970]] integerValue];
    NSString *time = [NSString stringWithFormat:@"%d", unixtime];
    NSLog(@"Time since 1970: %@", time);
    
    //combines rovi api key, shared secret and time into a string
    NSArray *stringsToConvert = [[NSArray alloc] initWithObjects:self.roviApiKey, sharedSecret, time, nil];
    NSString *concatenatedString = [stringsToConvert componentsJoinedByString:@""];
    NSLog(@"String to be converted to sig key: %@", concatenatedString);
    
    const char *cStr = [concatenatedString UTF8String];
    unsigned char digest[16];
    CC_MD5(cStr, (int)strlen(cStr), digest); // This is the md5 call
    
    //the converted
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    NSLog(@"sig key after concatentated string is converted: %@", output);
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    NSLog(@"created sig key: %@", output.lowercaseString);
    return  output.lowercaseString;
}

/********************************************************************************************
 * @method getMovieID
 * @abstract gets the movie id
 * @description accesses the movie db api to get the unique movie db id to get the movie's 
                information
 ********************************************************************************************/
- (void)getMovieIDandInfo: (NSString *)movieTitle
{
    //updates movie title to a searchable format
    NSString *title = [movieTitle stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *searchableTitle = [title stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    NSLog(@"Original movie title: %@ and Searchable movie title: %@", movieTitle, searchableTitle);
    
    //api access
    NSString *movieQuery = [NSString stringWithFormat:@"http://api.themoviedb.org/3/search/movie?api_key=%@&query=%@", self.movieDbApiKey, searchableTitle];
    NSLog(@"Link to movieDB api for id: %@", movieQuery);
    
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:[NSURL URLWithString:movieQuery]
            completionHandler:^(NSData *data,NSURLResponse *response,NSError *error) {
                NSError *errorJson = nil;
                NSDictionary *results = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&errorJson];
                
                // Update the Nsmutable Array
                NSMutableArray *movieTitleInfo = [[results mutableCopy] objectForKey:@"results"];
                NSMutableDictionary *result = [movieTitleInfo objectAtIndex:0];
                
                //gets the movie's unique movieDB id
                self.foundMovie.movieDbId = (NSString *)[result objectForKey:@"id"];
                [self getMovieInfo:self.foundMovie.movieDbId];
                NSLog(@"%@ unique movie DB id is: %@", movieTitle, self.foundMovie.movieDbId);
                
                //gets the movie trailer
                [self getMovieTrailer:self.foundMovie.movieDbId];
                
                //gets movie info
                [self getMovieInfo:self.foundMovie.movieDbId];
                
            }] resume];
}

/********************************************************************************************
 * @method getMovieTrailer
 * @abstract gets the movie trailer
 * @description accesses the movie db api to get the movie trailer
 ********************************************************************************************/
- (void)getMovieTrailer:(NSString *)movieDbId
{
    //api access
    NSString *movieQuery = [NSString stringWithFormat:@"http://api.themoviedb.org/3/movie/%@/trailers?api_key=%@", movieDbId, self.movieDbApiKey];
    NSLog(@"Link to movieDB api for trailer: %@", movieQuery);
    
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:[NSURL URLWithString:movieQuery]
            completionHandler:^(NSData *data,NSURLResponse *response,NSError *error) {
                NSError *errorJson = nil;
                NSDictionary *results = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&errorJson];
                
                // Update the Nsmutable Array
                NSMutableArray *movieTrailerInfo = [[results mutableCopy] objectForKey:@"youtube"];
                NSMutableDictionary *result = [movieTrailerInfo objectAtIndex:0];
                
                //gets the movie's unique youtube id
                NSString *youtubeID = [result objectForKey:@"source"];
                
                //gets the movie's trailer url
                NSString *youtubeUrl = @"https://www.youtube.com/watch?v=";
                youtubeUrl = [youtubeUrl stringByAppendingString:youtubeID];
                self.foundMovie.trailer = [NSURL URLWithString:youtubeUrl];
                
            }] resume];
}

/********************************************************************************************
 * @method getMovieInfo
 * @abstract gets more information about a particular movie
 * @description accesses the movie db by a particular id for additional information including
 *              including: imdb id, url to imdb, list of genres, the release date and a 
 *              description of the movie
 ********************************************************************************************/
- (void)getMovieInfo:(NSString *)movieDbId
{
    //api access
    NSString *movieQuery = [NSString stringWithFormat:@"https://api.themoviedb.org/3/movie/%@?api_key=%@", movieDbId, self.movieDbApiKey];
    NSLog(@"Link to movieDB api to get movie info by id: %@", movieQuery);
    
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:[NSURL URLWithString:movieQuery]
            completionHandler:^(NSData *data,NSURLResponse *response,NSError *error) {
                NSError *errorJson = nil;
                NSDictionary *results = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&errorJson];
                
                // Update the Nsmutable Array
                NSMutableDictionary *result = [results mutableCopy];
                
                //gets the imdb id
                self.foundMovie.imdbId = [result objectForKey:@"imdb_id"];
                
                //sets the imdb url
                NSString *imdbUrl = @"http://www.imdb.com/title/";
                imdbUrl = [imdbUrl stringByAppendingString:self.foundMovie.imdbId];
                self.foundMovie.url = [NSURL URLWithString:imdbUrl];
                
                //gets the genres
                NSMutableArray *genreResults = [result objectForKey:@"genres"];
                NSMutableArray *genres = [[NSMutableArray alloc]init];
                for (NSDictionary *genre in genreResults) {
                    NSString *category = [genre objectForKey:@"name"];
                    [genres addObject:category];
                }
                //put genres into a string
                self.foundMovie.genre = [genres componentsJoinedByString:@", "];
                
                //gets the movie description
                self.foundMovie.description = [result objectForKey:@"overview"];
                
                //gets the release date and converts it to a date object
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
                [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                NSString *release =[result objectForKey:@"release_date"];
                self.foundMovie.releaseDate = [dateFormatter dateFromString:release];
                
                //gets the url to the image and transforms it to an image object
                NSString *image = (NSString *)[result objectForKey:@"poster_path"];
                NSString *imageURL = @"http://image.tmdb.org/t/p/w500";
                imageURL = [imageURL stringByAppendingString:image];
                self.foundMovie.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]]];
                
            }] resume];
}


@end
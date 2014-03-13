//
//  SearchResult.m
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

#import "SearchResult.h"
#import "Movie.h"
#import <CommonCrypto/CommonDigest.h>
#import "MovieLibraryManager.h"

@implementation SearchResult

#pragma mark - Initializers
/********************************************************************************************
 * @method init
 * @abstract general initialize method
 * @description
 ********************************************************************************************/
- (id) init {
    self = [super init];
    if(self){
        [self initializeSettings];
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
        self.foundMovie.upc = upcSymbol;
        [self initializeSettings];
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
        self.foundMovie.title = title;
        [self initializeSettings];
    }
    return self;
}

- (void)initializeSettings
{
    self.roviApiKey = @"rc3sf8efxtuv28kf9rj6gbwv";
    self.movieDbApiKey = @"a9dc5652da0de21c8fbd3004a590931b";
    self.foundMovie = [[Movie alloc]init];
    self.num = 0;
    self.loop = 0;
    self.titleNum = 0;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receivedNotification:)
                                                 name:@"Entered background"
                                               object:nil];
}

#pragma mark - Helpers
/********************************************************************************************
 * @method movieIsNil
 * @abstract boolean that determines if the movie was found or not
 * @description
 ********************************************************************************************/
- (BOOL)movieIsNil
{
    if (self.foundMovie.title == nil || self.foundMovie.releaseDate == Nil) {
        NSLog(@">>>>>Movie is not found");
        return true;
    }
    NSLog(@">>>>>Movie is found");
    return false;
}

/********************************************************************************************
 * @method editTitle
 * @abstract edits the title
 * @description edits the title to remove excess information from the title and trims the string
 ********************************************************************************************/
- (NSString *)editTitle: (NSString *)title
{
    NSRange range = [title rangeOfString:@"("];
    NSString *movieTitle;
    if (range.length != 0) {
        movieTitle = [title substringToIndex:range.location];
    }
    return [movieTitle stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
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
    NSLog(@">>>>>Time since 1970: %@", time);
    
    //combines rovi api key, shared secret and time into a string
    NSArray *stringsToConvert = [[NSArray alloc] initWithObjects:self.roviApiKey, sharedSecret, time, nil];
    NSString *concatenatedString = [stringsToConvert componentsJoinedByString:@""];
    NSLog(@">>>>>String to be converted to sig key: %@", concatenatedString);
    
    const char *cStr = [concatenatedString UTF8String];
    unsigned char digest[16];
    CC_MD5(cStr, (int)strlen(cStr), digest); // This is the md5 call
    
    //the converted
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    NSLog(@">>>>>sig key after concatentated string is converted: %@", output);
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    NSLog(@">>>>>created sig key: %@", output.lowercaseString);
    return  output.lowercaseString;
}

#pragma mark - Cancel searches
/********************************************************************************************
 * @method cancelSearches
 * @abstract cancels all search threads
 * @description if the NSURLSessions have been instantiated, then invalidate and cancel them
 ********************************************************************************************/
- (void)cancelSearches
{
    if(self.upcSearch != (NSURLSession *) [NSNull null]){
        [self.upcSearch invalidateAndCancel];
        NSLog(@">>>>>UPC search session ended");
    }
    if(self.titleSearch != (NSURLSession *) [NSNull null]){
        [self.titleSearch invalidateAndCancel];
        NSLog(@">>>>>Movie title search session ended");
    }
    if(self.movieDBSearch != (NSURLSession *) [NSNull null]){
        [self.movieDBSearch invalidateAndCancel];
        NSLog(@">>>>>Movie id search session ended");
    }
    if(self.trailerSearch != (NSURLSession *) [NSNull null]){
        [self.trailerSearch invalidateAndCancel];
        NSLog(@">>>>>Movie trailer search session ended");
    }
    if(self.movieInfoSearch != (NSURLSession *) [NSNull null]){
        [self.movieInfoSearch invalidateAndCancel];
        NSLog(@">>>>>Movie info search session ended");
    }
}

/********************************************************************************************
 * @method receivedNotification:
 * @abstract checks if received notification that process is finished
 * @description if process is finished, then clear search text field and hide the spinner
 ********************************************************************************************/
- (void)receivedNotification:(NSNotification *) notification {
    if ([[notification name] isEqualToString:@"Entered background"]) {
        [self cancelSearches];
        NSLog(@">>>>> Entering background notification received by search result");
    }
}


#pragma mark - Alert Messages
/********************************************************************************************
 * @method blankSearch
 * @abstract gives alert view error an empty string is passed
 * @description
 ********************************************************************************************/
- (void)blankSearch
{
    NSString *title = @"Search cannot be blank";
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:title delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
    NSLog(@">>>>>Search cannot be blank alert");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Search done" object:self];
}

/********************************************************************************************
 * @method movieNotFound
 * @abstract gives alert view error when the movie is not found
 * @description
 ********************************************************************************************/
- (void)movieNotFound
{
    NSString *title = @"Sorry! Movie not found.";
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:title delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
    NSLog(@">>>>>Movie not found alert");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Search done" object:self];
}

/********************************************************************************************
 * @method movieAlreadyAdded
 * @abstract gives alert view error when the movie is already in the library
 * @description
 ********************************************************************************************/
- (void)movieAlreadyAdded
{
    NSString *title = @"Sorry! This movie is already in your library.";
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:title delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
    NSLog(@">>>>>Movie in library already alert");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Search done" object:self];
}

/********************************************************************************************
 * @method movieSuccessfullyAdded
 * @abstract gives alert view error when the movie is already in the library
 * @description
 ********************************************************************************************/
- (void)movieSuccessfullyAdded
{
    NSString *title = @"The movie was successfully added!";
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:title delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
    NSLog(@">>>>>Movie successfully added alert");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Search done" object:self];
}

#pragma mark - Search Kickoff
/********************************************************************************************
 * @method titleSearch
 * @abstract checks to make sure title is not blank. If not then it kicks off the search
 * @description
 ********************************************************************************************/
- (void)titleSearch: (NSString *)title
{
    if (title.length == 0) {
        [self blankSearch];
    }
    else{
        [self searchForMovieByTitle:title];
    }
}

#pragma mark - Searches
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
    
    NSLog(@">>>>>Link to searchupc api: %@", query);
    
    self.upcSearch = [NSURLSession sharedSession];
    [[self.upcSearch dataTaskWithURL:[NSURL URLWithString:query]
            completionHandler:^(NSData *data,NSURLResponse *response,NSError *error) {
                NSError *errorJson = nil;
                NSDictionary *results = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&errorJson];
                
                // Update the Nsmutable Array
                NSMutableDictionary *upcMovieResults = [[results mutableCopy] objectForKey:@"0"];
                NSLog(@">>>>>JSON results from upc search: %@", upcMovieResults);
                
                //gets the movie title (and removes the extra appended information such as "(blu-ray)" and "(digital copy)")
                NSString *title = (NSString *)[upcMovieResults objectForKey:@"productname"];
                title = [self editTitle:title];
                
                NSLog(@">>>>>Movie title used for search: %@", title);
                
                //performs a search by movie title
                [self searchForMovieByTitle:title];
                
            }] resume];
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
    NSLog(@">>>>>Original movie title: %@ and Searchable movie title: %@", movieTitle, searchableTitle);
    
    //api access
    NSString *query = [NSString stringWithFormat:@"http://api.rovicorp.com/search/v2.1/amgvideo/search?apikey=%@&sig=%@&query=%@&entitytype=movie&size=1&format=json&include=all", self.roviApiKey, self.sig, searchableTitle];
    NSLog(@">>>>>Link to rovicorp api: %@", query);
    
    self.titleSearch = [NSURLSession sharedSession];
    [[self.titleSearch dataTaskWithURL:[NSURL URLWithString:query]
            completionHandler:^(NSData *data,NSURLResponse *response,NSError *error) {
                NSError *errorJson = nil;
                NSDictionary *results = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&errorJson];
                
                // Update the Nsmutable Array
                NSMutableDictionary *titleMovieResults = [[results mutableCopy] objectForKey:@"searchResponse"];
                NSMutableDictionary *result = [[titleMovieResults objectForKey:@"results"] objectAtIndex:0];
                //if there are results and it is not null or equal to an empty string, then get movie info
                if (result != (NSMutableDictionary *)[NSNull null] && ![(NSString *)result  isEqual: @""]) {
                    NSMutableDictionary *movieInfo = [result objectForKey:@"movie"];
                    
                    //set the official movie title
                    self.foundMovie.title = [movieInfo objectForKey:@"title"];
                    NSLog(@">>>>>Movie title: %@", self.foundMovie.title);
                    
                    //gets the mpaa rating
                    self.foundMovie.mpaaRating = [movieInfo objectForKey:@"mpaa"];
                    NSLog(@">>>>>Movie mpaa rating: %@", self.foundMovie.mpaaRating);
                    
                    //gets the movie duration
                    self.foundMovie.duration = [movieInfo objectForKey:@"duration"];
                    NSLog(@">>>>>Movie running time: %@", self.foundMovie.duration);
                    
                    //gets the list of movie directors
                    self.foundMovie.directors = [[NSMutableArray alloc] init];
                    NSMutableArray *directors = [movieInfo objectForKey:@"directors"];
                    if (directors != (NSMutableArray *)[NSNull null]) {
                        for (NSDictionary *director in directors) {
                            NSString *category = [director objectForKey:@"name"];
                            [self.foundMovie.directors addObject:category];
                        }
                    }
                    //otherwise set it to nil
                    else{
                        self.foundMovie.directors = nil;
                    }
                    
                    
                    NSLog(@">>>>>Movie list of directors: %@", self.foundMovie.directors);
                    
                    //gets the list of cast members
                    self.foundMovie.cast = [[NSMutableArray alloc] init];
                    NSMutableArray *castMembers = [movieInfo objectForKey:@"cast"];
                    if (castMembers != (NSMutableArray *)[NSNull null]) {
                        for (NSDictionary *member in castMembers) {
                            NSString *castName = [member objectForKey:@"name"];
                            [self.foundMovie.cast addObject:castName];
                        }
                    }
                    //otherwise set it to nil
                    else{
                        self.foundMovie.cast = nil;
                    }
                    NSLog(@">>>>>Movie cast list: %@", self.foundMovie.cast);
                    
                    //gets the movie id
                    [self getMovieIDandInfo:self.foundMovie.title];
                }
                //otherwise show movie not found alert
                else{
                    [self movieNotFound];
                    return;
                }
                
                
            }] resume];
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
    NSLog(@">>>>>Original movie title: %@ and Searchable movie title: %@", movieTitle, searchableTitle);
    
    //api access
    NSString *movieQuery = [NSString stringWithFormat:@"http://api.themoviedb.org/3/search/movie?api_key=%@&query=%@", self.movieDbApiKey, searchableTitle];
    NSLog(@">>>>>Link to movieDB api for id: %@", movieQuery);
    
    self.movieDBSearch = [NSURLSession sharedSession];
    [[self.movieDBSearch dataTaskWithURL:[NSURL URLWithString:movieQuery]
            completionHandler:^(NSData *data,NSURLResponse *response,NSError *error) {
                NSError *errorJson = nil;
                NSDictionary *results = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&errorJson];
                
                // Update the Nsmutable Array
                NSMutableArray *movieTitleInfo = [[results mutableCopy] objectForKey:@"results"];
                //if no movie by that title is found, show alert
                if ([movieTitleInfo count]==0) {
                    if (self.titleNum == 0) {
                        self.titleNum++;
                        [self movieNotFound];
                        return;
                    }
                }
                //otherwise get movie db id
                else{
                    NSMutableDictionary *result = [movieTitleInfo objectAtIndex:0];
                    
                    //gets the movie's unique movieDB id
                    self.foundMovie.movieDbId = (NSString *)[result objectForKey:@"id"];
                    [self getMovieInfo:self.foundMovie.movieDbId];
                    NSLog(@">>>>>%@ unique movie DB id is: %@", movieTitle, self.foundMovie.movieDbId);
                    
                    //gets the movie trailer
                    [self getMovieTrailer:self.foundMovie.movieDbId];
                    
                    //gets movie info
                    [self getMovieInfo:self.foundMovie.movieDbId];
                }
                
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
    NSLog(@">>>>>Link to movieDB api for trailer: %@", movieQuery);
    
    self.trailerSearch = [NSURLSession sharedSession];
    [[self.trailerSearch dataTaskWithURL:[NSURL URLWithString:movieQuery]
            completionHandler:^(NSData *data,NSURLResponse *response,NSError *error) {
                NSError *errorJson = nil;
                NSDictionary *results = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&errorJson];
                
                // Update the Nsmutable Array
                NSMutableArray *movieTrailerInfo = [[results mutableCopy] objectForKey:@"youtube"];
                //if there is a movie trailer, add it
                if ([movieTrailerInfo count]!=0) {
                    NSMutableDictionary *result = [movieTrailerInfo objectAtIndex:0];
                    
                    //gets the movie's unique youtube id
                    NSString *youtubeID = [result objectForKey:@"source"];
                    
                    //gets the movie's trailer url
                    NSString *youtubeUrl = @"https://www.youtube.com/watch?v=";
                    youtubeUrl = [youtubeUrl stringByAppendingString:youtubeID];
                    self.foundMovie.trailer = [NSURL URLWithString:youtubeUrl];
                    NSLog(@">>>>>Trailer found: %@", self.foundMovie.trailer);
                }
                //otherwise set it to nil
                else{
                    self.foundMovie.trailer = nil;
                    NSLog(@">>>>>Trailer not found,");
                }
                
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
    NSLog(@">>>>>Link to movieDB api to get movie info by id: %@", movieQuery);
    
    self.movieInfoSearch = [NSURLSession sharedSession];
    [[self.movieInfoSearch dataTaskWithURL:[NSURL URLWithString:movieQuery]
            completionHandler:^(NSData *data,NSURLResponse *response,NSError *error) {
                NSError *errorJson = nil;
                NSDictionary *results = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&errorJson];
                
                // Update the Nsmutable Array
                NSMutableDictionary *result = [results mutableCopy];
                
                //gets the imdb id
                self.foundMovie.imdbId = [result objectForKey:@"imdb_id"];
                NSLog(@">>>>>Imdb id: %@", self.foundMovie.imdbId);
                //if not nil, set it
                if (self.foundMovie.imdbId != (NSString *)[NSNull null]){
                    //sets the imdb url
                    NSString *imdbUrl = @"http://www.imdb.com/title/";
                    imdbUrl = [imdbUrl stringByAppendingString:self.foundMovie.imdbId];
                    self.foundMovie.url = [NSURL URLWithString:imdbUrl];
                }
                //otherwise set it to nil
                else{
                    self.foundMovie.url = nil;
                }
                NSLog(@">>>>>Imdb url: %@", self.foundMovie.url);
                
                //gets the genres
                NSMutableArray *genreResults = [result objectForKey:@"genres"];
                //if not nil, set it
                if (genreResults != (NSMutableArray *)[NSNull null]){
                    NSMutableArray *genres = [[NSMutableArray alloc]init];
                    for (NSDictionary *genre in genreResults) {
                        NSString *category = [genre objectForKey:@"name"];
                        [genres addObject:category];
                    }
                    //put genres into a string
                    self.foundMovie.genre = [genres componentsJoinedByString:@", "];
                }
                //otherwise set it to nil
                else{
                    self.foundMovie.genre = nil;
                }
                NSLog(@">>>>>Genres: %@", self.foundMovie.genre);
                
                //gets the movie description
                self.foundMovie.description = [result objectForKey:@"overview"];
                NSLog(@">>>>>Description: %@", self.foundMovie.description);
                
                //gets the release date and converts it to a date object
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
                [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                NSString *release =[result objectForKey:@"release_date"];
                //if not nil, set it
                if (release != (NSString *)[NSNull null]){
                    self.foundMovie.releaseDate = [dateFormatter dateFromString:release];
                }
                //otherwise set it to nil
                else{
                    self.foundMovie.releaseDate = nil;
                }
                NSLog(@">>>>>Release date: %@", self.foundMovie.releaseDate);
                
                //gets the url to the image and transforms it to an image object
                NSString *image = (NSString *)[result objectForKey:@"poster_path"];
                //if not nil, set it
                if (image != (NSString *)[NSNull null]) {
                    NSString *imageURL = @"http://image.tmdb.org/t/p/w500";
                    imageURL = [imageURL stringByAppendingString:image];
                    UIImage *largeImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]]];
                    //save smaller image
                    self.foundMovie.image = [self imageWithImage:largeImage scaledToSize:CGSizeMake(80,120)];
                }
                //otherwise set it to nil
                else{
                    self.foundMovie.image = [UIImage imageNamed:@"no_image"];
                }
                NSLog(@">>>>>Image: %@", self.foundMovie.image);
                
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    //checks if the movie is nil. If so, show alert.
                    if ([self movieIsNil]) {
                        if (self.num==0) {
                            self.num++;
                            [self movieNotFound];
                            return;
                        }
                    }
                    //otherwise add object to library after checking if already exists
                    else{
                        if (self.num==0) {
                            self.num++;
                            [self readAndWritePList];
                        }                        
                    }
                });
      
            }] resume];
}

#pragma mark - Writing
/********************************************************************************************
 * @method readAndWritePList
 * @abstract takes found movie and adds it to library if not already in it
 * @description Reads the plist from phone's documents folder and checks if the found movie
                already exists in the library. If so, then an alert appears otherwise the
                movie is added, the library converted and resaved.
 ********************************************************************************************/
- (void)readAndWritePList
{
    if (self.loop == 0) {
        self.loop++;
        //read data from plist
        MovieLibraryManager *plistManager = [MovieLibraryManager sharedInstance];
        //convert each object in read dictionary to a movie object and add to arraylist
        NSMutableArray *movieLibrary = [[NSMutableArray alloc]initWithArray:[plistManager getMovieLibrary]];
        
        //check to see if movie is already in the library
        bool movieFound = false;
        for (Movie *movie in movieLibrary) {
            if ([movie.title isEqualToString:self.foundMovie.title]) {
                movieFound = true;
                break;
            }
        }
        
        //if movie is found in the dictionary, then that means it's already in the library
        if (movieFound) {
            [self movieAlreadyAdded];
            return;
        }
        else{
            //add the found movie to the library
            [movieLibrary addObject:self.foundMovie];
            NSLog(@">>>>>Movie with title: %@ added to the library successfully!", self.foundMovie.title);
                    
            //saves the plist
            [plistManager saveMovieLibrary:movieLibrary];
            
            //show the alert
            [self movieSuccessfullyAdded];
            
        }

    }
}

#pragma mark - Image Resizing
/********************************************************************************************
 * @method imageWithImage: scaledToSize:
 * @abstract resizes image
 * @description method from http://stackoverflow.com/questions/2658738/the-simplest-way-to-resize-an-uiimage
 ********************************************************************************************/
- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


@end

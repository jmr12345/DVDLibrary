//
//  MovieData.m
//  DVDLibrary
//
//  Created by Ming on 3/1/14.
//  Copyright (c) 2014 Ming. All rights reserved.
//

#import "MovieData.h"
#import "movie.h"

@implementation MovieData

- (id)init
{
    self = [super init];
    if (self) {
        [self loadInitialData];
    }
    return self;
}

- (void)loadInitialData
{
    Movie *movie1 = [[Movie alloc] init];
    movie1.title = @"The Avengers";
    UIImage *image1 = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://ia.media-imdb.com/images/M/MV5BMTk2NTI1MTU4N15BMl5BanBnXkFtZTcwODg0OTY0Nw@@._V1_SY317_CR0,0,214,317_.jpg"]]];
    movie1.image = image1;
    [movie1.genre addObject:@"Action"];
    movie1.description = @"This is the description of the movie.";
    
    Movie *movie2 = [[Movie alloc] init];
    movie2.title = @"Monsters, Inc.";
    UIImage *image2 = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://ia.media-imdb.com/images/M/MV5BMTY1NTI0ODUyOF5BMl5BanBnXkFtZTgwNTEyNjQ0MDE@._V1_SX214_.jpg"]]];
    movie2.image = image2;
    [movie2.genre addObject:@"Animation"];
    movie2.description = @"A city of monsters with no humans called Monstropolis centers around the city's power company, Monsters, Inc. The lovable, confident, tough, furry blue behemoth-like giant monster named James P. Sullivan (better known as Sulley) and his wisecracking best friend, short, green cyclops monster Mike Wazowski, discover what happens when the real world interacts with theirs in the form of a 2-year-old baby girl dubbed \"Boo,\" who accidentally sneaks into the monster world with Sulley one night. And now it's up to Sulley and Mike to send Boo back in her door before anybody finds out, especially two evil villains such as Sulley's main rival as a scarer, chameleon-like Randall (a monster that Boo is very afraid of), who possesses the ability to change the color of his skin, and Mike and Sulley's boss Mr. Waternoose, the chairman and chief executive officer of Monsters, Inc.";
    
    Movie *movie3 = [[Movie alloc] init];
    movie3.title = @"The Incredibles";
    UIImage *image3 = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://ia.media-imdb.com/images/M/MV5BMTY5OTU0OTc2NV5BMl5BanBnXkFtZTcwMzU4MDcyMQ@@._V1_SY317_CR0,0,214,317_.jpg"]]];
    movie3.image = image3;
    [movie3.genre addObject:@"Animation"];
    movie3.description = @"This is the description of the movie.";
    
    Movie *movie4 = [[Movie alloc] init];
    movie4.title = @"Star Wars: The Clone Wars";
        UIImage *image4 = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://ia.media-imdb.com/images/M/MV5BMTI1MDIwMTczOV5BMl5BanBnXkFtZTcwNTI4MDE3MQ@@._V1_SY317_CR0,0,214,317_.jpg"]]];
    movie4.image = image4;
    [movie4.genre addObject:@"Sci-Fi"];
    movie4.description = @"This is the description of the movie.";
    
    Movie *movie5 = [[Movie alloc] init];
    movie5.title = @"The Godfather";
    UIImage *image5 = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://ia.media-imdb.com/images/M/MV5BMjEyMjcyNDI4MF5BMl5BanBnXkFtZTcwMDA5Mzg3OA@@._V1_SX214_.jpg"]]];
    movie5.image = image5;
    [movie5.genre addObject:@"Drama"];
    movie5.description = @"This is the description of the movie.";
    
    Movie *movie6 = [[Movie alloc] init];
    movie6.title = @"Atonement";
       UIImage *image6 = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://ia.media-imdb.com/images/M/MV5BMTM0ODc2Mzg1Nl5BMl5BanBnXkFtZTcwMTg4MDU1MQ@@._V1_SY317_CR0,0,214,317_.jpg"]]];
    movie6.image = image6;
    [movie6.genre addObject:@"Drama"];
    movie6.description = @"This is the description of the movie.";
    
    Movie *movie7 = [[Movie alloc] init];
    movie7.title = @"Totoro";
    UIImage *image7 = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://ia.media-imdb.com/images/M/MV5BMjE3NzY5ODQwMV5BMl5BanBnXkFtZTcwNzY1NzcxNw@@._V1_SY317_CR8,0,214,317_.jpg"]]];
    movie7.image = image7;
    [movie7.genre addObject:@"Animation"];
    movie7.description = @"This is the description of the movie.";
    
    
    self.movieData = [[NSArray alloc] initWithObjects:
                         movie1, movie2, movie3, movie4, movie5, movie6, movie7,
                         nil ];
}

@end


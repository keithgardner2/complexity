//
//  InfoViewController.m
//  complexity
//
//  Created by Patrick Madden on 12/7/13.
//  Copyright (c) 2013 Optimality Research Group. All rights reserved.
//

#import "InfoViewController.h"

@interface InfoViewController ()

@end

@implementation InfoViewController
@synthesize wv, fileToLoad;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated
{
    // NSString *dir = [NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES) lastObject];
    // NSString *path = [NSString stringWithFormat:@"%@/about.html"];
    // [wv loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://optimal.cs.binghamton.edu"]]];
    if (fileToLoad != nil)
    {
        [wv loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:fileToLoad ofType:@"html"] isDirectory:NO]]];
        // NSLog(@"Loading file %@", fileToLoad);
    }
    else
    {
        // NSLog(@"Loading about");
        [wv loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"about" ofType:@"html"] isDirectory:NO]]];
    }


}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    // NSLog(@"Dealloc the WV");
    [self setWv:nil];
}

@end

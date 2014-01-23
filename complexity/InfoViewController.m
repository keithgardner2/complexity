//
//  InfoViewController.m
//  complexity
//
//  Created by Patrick Madden on 12/7/13.
//  Copyright (c) 2013 Optimality Research Group. All rights reserved.
//

#import "InfoViewController.h"
#import "ExperimentViewController.h"

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
    NSLog(@"info view has appeared");
    NSLog(@"%@", fileToLoad);

    //basics is for basics button
    //"So whats this all about" is null
    if (fileToLoad != nil)
    {
        [wv loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:fileToLoad ofType:@"html"] isDirectory:NO]]];
        NSLog(@"Loading file %@", fileToLoad);
    }
    else
    {
        //want to use some sort of tag on the buttons, use:         int algType = [sender tag];
        //but how to retrieve the tag?
        NSLog(@"Loading about");
        [wv loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"about" ofType:@"html"] isDirectory:NO]]];
    }
    
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    NSNumber *htmlTag = nil;
    
    if (standardUserDefaults)
        htmlTag = [standardUserDefaults objectForKey:@"age"];
    
    int html = [htmlTag intValue];
    
    switch (html){
        case 0:
            NSLog(@"bubbleSort HTML");
            //[self bubbleSort];
            break;
        case 1://hoare
            NSLog(@"quickSort hoare HTML");
            //[self quickSort];
            break;
        case 2:
            NSLog(@"insertionSort HTML");
            //[self insertionSort];
            break;
        case 3:
            NSLog(@"merge sort HMTL");
            break;
        case 4:
            NSLog(@"selectionSort HTML");
            //[self selectionSort];
            break;
        case 5:
            NSLog(@"rankSort HTML");
            //[self rankSort];
            break;
        case 6:
            NSLog(@"heapSort HTML");
            //[self heapSort];
            break;
        case 7:
            NSLog(@"quickSort Lomuto HTML");
            break;
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

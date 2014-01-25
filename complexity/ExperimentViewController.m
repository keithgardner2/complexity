//
//  ExperimentViewController.m
//  complexity
//
//  Created by Patrick Madden on 12/7/13.
//  Copyright (c) 2013 Optimality Research Group. All rights reserved.
//

#include <stdio.h>
#include <stdlib.h>
#include<stdio.h>
#include <errno.h>
#include <assert.h>
#include <strings.h>

#import "ExperimentViewController.h"

#define LDBG 0
#define ValType double

#define RAND_LIMIT      1000

#define LOMUTO_NO_RAND  0
#define LOMUTO_RAND     1
#define HOARE_NO_RAND   2
#define HOARE_RAND      3

#define QUICKSORT_ALGO HOARE_RAND

#define SWAP(arr, x, y)     \
do {                    \
int t = arr[x];     \
arr[x] = arr[y];    \
arr[y] = t;         \
} while(0);

#define RAND_RANGE(min, max) ((rand() % (max - min)) + min)

int global_kill_flag = 0;
bool randomization = false;
int html;

bool ascending = false;
bool descending = false;
bool equal = false;

@interface ExperimentViewController ()

@end

@implementation ExperimentViewController
@synthesize running, startTime, stopTime;
@synthesize elapsed, timer, algTimer;
@synthesize problemSize, problemLabel, problemSlider;
@synthesize algType;
@synthesize runShield;

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
    [self resetHTMLTag];//reset html file to load depending on button
	// Do any additional setup after loading the view.
    [self nChange:nil];
    [elapsed setText:@"--"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


static int getUptimeInMilliseconds()
{
    const int64_t kOneMillion = 1000 * 1000;
    static mach_timebase_info_data_t s_timebase_info;
    
    if (s_timebase_info.denom == 0) {
        (void) mach_timebase_info(&s_timebase_info);
    }
    
    // mach_absolute_time() returns billionth of seconds,
    // so divide by one million to get milliseconds
    return (int)((mach_absolute_time() * s_timebase_info.numer) / (kOneMillion * s_timebase_info.denom));
}

int *data;
int *temp;
BOOL shouldRun;
BOOL isRunning;
int choice, next, original, originalSpot;//used in selection sort

-(IBAction)nChange:(id)sender
{
    [problemLabel setText:[NSString stringWithFormat:@"%d", (int)[problemSlider value]]];
}

-(IBAction)startRun:(id)sender
{
    if (isRunning)
    {
        shouldRun = FALSE;
        return;
    }

    [timer invalidate];
    startTime = mach_absolute_time();
    [elapsed setText:@"--"];
    [self setTimer:[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerInterrupt:) userInfo:nil repeats:YES]];
}


// Update the elapsed timer on the screen on a regularly scheduled
// timer -- about once per second
-(void)timerInterrupt:(id)sender
{
    if (LDBG) NSLog(@"Tick");
    [self updateElapsed];
}

// Actually put the run time onto the screen
-(void)updateElapsed
{
    mach_timebase_info_data_t s_timebase_info;
    mach_timebase_info(&s_timebase_info);
    int64_t now = mach_absolute_time();
    

    
    const int64_t kOneMillion = 1000 * 1000;
    int delta =(int)(((now - startTime) * s_timebase_info.numer)/ (kOneMillion * s_timebase_info.denom));

    [elapsed setText:[NSString stringWithFormat:@"%5.3f seconds", (float) delta/1000.0]];
}


// The run has terminated -- update the screen, invalidate the timer tick...
-(IBAction)stopRun:(id)sender
{
    stopTime = mach_absolute_time();
    [self updateElapsed];
    
    [timer invalidate];
    shouldRun = NO;
    isRunning = NO;
    
    mach_timebase_info_data_t s_timebase_info;
    mach_timebase_info(&s_timebase_info);
    
    const int64_t kOneMillion = 1000 * 1000;
    if (LDBG) NSLog(@"Milleseconds: %d", (int)(((stopTime - startTime) * s_timebase_info.numer)/ (kOneMillion * s_timebase_info.denom)));
    if (LDBG) NSLog(@"Start %llu stop %llu    difference %llu", startTime, stopTime, stopTime - startTime);
    [self dismissShield];
    
}


// NSTimer *algTimer;

-(void)bubbleSort
{
    //NSLog(@"Running bubble sort");
    int i, j;
    for (i = 0; i < problemSize; ++i)
    {
        for (j = i + 1; j < problemSize; ++j)
        {
            // Added in to the code, so that if
            // the user wants to terminate a run, we can
            // do that, and then be able to clean up
            // memory that was allocated temporarily
            if (!shouldRun)
            {
                problemSize = 1;
                continue;
            }
            
            if (data[i] > data[j])
            {
                int t = data[i];
                data[i] = data[j];
                data[j] = t;
            }
        }
    }
}
-(void)insertionSort{
    //NSLog(@"Running insertion sort");
    int j, i, key;
    for(j = 1; j < problemSize; j++){
        key = data[j];
        i = j -1;
            // Added in to the code, so that if
            // the user wants to terminate a run, we can
            // do that, and then be able to clean up
            // memory that was allocated temporarily
            if (!shouldRun)
            {
                problemSize = 1;
                continue;
            }
        while(i > 0 && data[i] > key){
            data[i + 1] = data[i];
            i = i -1;
        }
        data[i + 1] = key;
    }
}

-(void)selectionSort{
    for(int i = 0; i < problemSize; i++){
        choice = data[i];
        original = choice;
        next = i + 1;
        for(next; next < problemSize; next++){
            if (!shouldRun)
            {
                problemSize = 1;
                continue;
            }
            
            if(data[next] < choice){
                choice = data[next];
                originalSpot = next;
            }

        }
        data[i] = choice;
        data[originalSpot] = original;
    }
}
-(void)rankSort{//still need to implement !shouldRun or something in inner most loop
    //NSLog(@"running debug before");
    //[self debug];
    
    //NSLog(@"running rank sort...");
    
    int spot;
    int copy[problemSize];
    for(int i = 0; i < problemSize; i++){
        spot = 0;
        for(int j = 0 ; j < problemSize; j++){
            if (!shouldRun){
                problemSize = 1;
                continue;
            }
            if(data[i] < data[j] && data[i] != data[j]){
                spot++;
            }
        }
        copy[spot] = data[i];
    }
    
    //NSLog(@"debug after");
    //for(int i = 0; i< problemSize; i++){
    //    NSLog(@"%i", copy[i]);//new sorted data is in copy, not original array
    //}
    
}
-(void)heapSort{
    NSLog(@"Running heap sort");
    heapsort(data, problemSize, sizeof(int), intCompare);
}

-(void) debug{
    for(int i = 0; i< problemSize; i++){
        NSLog(@"%i", data[i]);
    }
}

int intCompare(const void *a, const void *b)
{
    int va = *((int *)a);
    int vb = *((int *)b);
    
    return va - vb;
}


//-(void)quickSort{
//    NSLog(@"Running quick sort");
//    qsort(data, problemSize, sizeof(int), intCompare);
//}

void quicksort_lomuto_norand(int *arr, int start, int end){
    if (start >= end)
    {
        return;
    }
    
    int p = lomuto_partition(arr, start, end, start);
    quicksort_lomuto_norand(arr, start, p-1);
    quicksort_lomuto_norand(arr, p+1, end);
}
void quicksort_lomuto_rand(int *arr, int start, int end)
{
    if (start >= end)
    {
        return;
    }
    
    int p = lomuto_partition(arr, start, end, RAND_RANGE(start, end));
    quicksort_lomuto_rand(arr, start, p-1);
    quicksort_lomuto_rand(arr, p+1, end);
}

void quicksort_hoare_norand(int *arr, int start, int end){
    if (start >= end)
    {
        return;
    }
    
    int p = hoare_partition(arr, start, end, start);
    quicksort_hoare_norand(arr, start, p);
    quicksort_hoare_norand(arr, p+1, end);
}
void quicksort_hoare_rand(int *arr, int start, int end)
{
    if (start >= end)
    {
        return;
    }
    
    int p = hoare_partition(arr, start, end, RAND_RANGE(start, end));
    quicksort_hoare_rand(arr, start, p);
    quicksort_hoare_rand(arr, p+1, end);
}

int hoare_partition(int *arr, int start, int end, int pi)
{
    int i = start-1;
    int j = end+1;
    int pv = arr[pi];
    
    while(1)
    {
        if (global_kill_flag)
        {
            exit(1);
        }
        
        while(arr[++i] < pv);
        while(arr[--j] > pv);
        if (i < j)
        {
            SWAP(arr, i, j);
        }
        else
        {
            return j;
        }
    }
}

int lomuto_partition(int *arr, int start, int end, int pi)
{
    int pv = arr[pi];
    int si = start;
    
    SWAP(arr, pi, end);
    
    for (int i = start; i < end; ++i)
    {
        if (global_kill_flag)
        {
            exit(1);
        }
        
        if (arr[i] <= pv)
        {
            SWAP(arr, si, i);
            ++si;
        }
    }
    
    SWAP(arr, si, end);
    return si;
}

-(void)do_it
{
    int i;
    
    data = (int *)malloc(sizeof(int) * problemSize);//This sets data to a bunch of random numbers
    
    if (data == NULL)
    {
        NSLog(@"Problem too large!");
        return;
    }
    
    for (i = 0; i < problemSize; ++i)
        data[i] = rand();
    
    switch (algType)
    {
        case 0:
            [self bubbleSort];
            break;
        case 1://hoare
            if(randomization){//this is false by default, gets set in toggleRandomization
                NSLog(@"hoare rand");
                quicksort_hoare_rand(data, 0, problemSize-1);}
            else{
                NSLog(@"hoare not rand");
                quicksort_hoare_norand(data, 0, problemSize-1);}
            break;
        case 2:
            [self insertionSort];
            break;
        case 3:
            break;
        case 4:
            [self selectionSort];
            break;
        case 5:
            [self rankSort];
            break;
        case 6:
            [self heapSort];
            break;
        case 7://quicksort lomuto
            if(randomization){//this is false by default, gets set in toggleRandomization
                NSLog(@"lomuto rand");
                quicksort_lomuto_rand(data, 0, problemSize-1);}
            else{
                NSLog(@"lomuto not rand");
                quicksort_lomuto_norand(data, 0, problemSize-1);}
            break;
    }
    
    if (LDBG) NSLog(@"Ending.");
    
    free(data);
    data = NULL;
    
}

-(IBAction)killRun:(id)sender
{
    shouldRun = FALSE;
}

-(IBAction)runAlgorithm:(id)sender
{
    if (isRunning)
    {
        if (LDBG) NSLog(@"Algorithm already running.  Killing current run");
        shouldRun = NO;
        return;
    }
   
   
    problemSize = [problemSlider value];
    if (LDBG) NSLog(@"Problem size %d", problemSize);
    shouldRun = TRUE;

    algType = [sender tag];
    if (LDBG) NSLog(@"Running algorithm %d", algType);
    
    [self createShield];
    
    [self startRun:self];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                   ^{
                       if (LDBG) NSLog(@"Starting the run...");
                       [self do_it];
                       if (LDBG) NSLog(@"Stopped sleeping.");
                       [self performSelectorOnMainThread:@selector(stopRun:) withObject:self waitUntilDone:NO];
                     });
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if (LDBG) NSLog(@"Segue named %@ %p", segue.identifier, segue.destinationViewController);
    
    InfoViewController *vc = [segue destinationViewController];
    if ([segue.identifier isEqualToString:@"qs"])
        [vc setFileToLoad:@"qs"];
    if ([segue.identifier isEqualToString:@"bubble"])
        [vc setFileToLoad:@"bubble"];
}

- (IBAction)done:(UIStoryboardSegue *)segue {
    if (LDBG) NSLog(@"Popping back to this view controller! %@ %p", segue.identifier, segue.destinationViewController);
    if (LDBG) NSLog(@"Back at main.  Destroy any peripheral or controller.");
    
    // reset UI elements etc here
}

-(void)createShield
{
    if (runShield == nil)
    {
        UINib *nib;
    
        if (LDBG) NSLog(@"Creating self from decoder, loading nib");
        
        CGSize iOSDeviceScreenSize = [[UIScreen mainScreen] bounds].size;

        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){//iPhone View
            if(iOSDeviceScreenSize.height  == 568){
                nib = [UINib nibWithNibName:@"EVC_iPhone4inch" bundle:nil];//3.5 inch
            }
            else{
                nib = [UINib nibWithNibName:@"EVC_iPhone" bundle:nil];//3.5 inch
            }
        }
        else{//iPad View
            nib = [UINib nibWithNibName:@"EVC_iPad" bundle:nil];
        }
        [nib instantiateWithOwner:self options:nil];
    }
    
    [self.view addSubview:runShield];
}

-(void)dismissShield
{
    [runShield removeFromSuperview];
    // [self setRunShield:nil];
}
-(IBAction)pickHTML:(id)sender{
    //htmlTag = [sender tag];
    
    html = [sender tag]; // Just an example
    
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    
    if (standardUserDefaults) {
        [standardUserDefaults setObject:[NSNumber numberWithInt:html] forKey:@"age"];
        [standardUserDefaults synchronize];
    }
}
-(void)resetHTMLTag{
    html = -1;
}
- (IBAction)toggleAscending:(id)sender {
    NSLog(@"toggling ascending...");
    ascending = !ascending;
}
- (IBAction)toggleDescending:(id)sender {
    NSLog(@"toggling descending...");
    descending = !descending;
}
- (IBAction)toggleValuesEqual:(id)sender {
    NSLog(@"toggling values equal...");
    equal = !equal;
}
- (IBAction)toggleRandomization:(id)sender {
    randomization = !randomization;
}
@end
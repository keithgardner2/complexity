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

bool shouldSetTime = NO;
bool updateLabels = false;

int *data;
int *temp;
BOOL shouldRun;
BOOL isRunning;
int choice, next, original, originalSpot;//used in selection sort

@interface ExperimentViewController ()

@end

@implementation ExperimentViewController
@synthesize running, startTime, stopTime;
@synthesize elapsed, timer, algTimer;
@synthesize problemSize, problemLabel, problemSlider;
@synthesize algType;
@synthesize runShield;
@synthesize myPickerView;
@synthesize pickerOptions;

@synthesize userAlg;
@synthesize userData;
NSInteger optionType;

- (IBAction)goBack:(id)sender {
//    NSInteger algTypePicker;
//    algTypePicker = [myPickerView selectedRowInComponent:0];
//    optionType = [pickerOptions selectedRowInComponent:0];
//    
//    NSLog(@"alg: %i", algTypePicker);
//    NSLog(@"opt: %i", optionType);
    
}

- (IBAction)updateLabels:(id)sender {
    updateLabels= !updateLabels;
}


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
    
    [userAlg setText:@"--"];
    [userData setText:@"--"];
    
    [self resetHTMLTag];//reset html file to load depending on button
	// Do any additional setup after loading the view.
    [self nChange:nil];
    [elapsed setText:@"--"];
    
    self.algColumn  = [[NSArray alloc]         initWithObjects:@"QS Hoare", @"QS Hoare Rand", @"QS Lomuto", @"QS Lomuto Rand",@"Insertion Sort",@"Selection Sort",@"Rank Sort",@"Heap Sort", @"Merge Sort", @"Bubble Sort", nil];
    self.optionsColumn = [[NSArray alloc] initWithObjects:@"Random", @"Ascending", @"Descending", @"Values Equal", nil];
    
    [myPickerView setDelegate:self];
    [pickerOptions setDelegate:self];

    [myPickerView setDataSource:self];
    [pickerOptions setDataSource:self];
    
    myPickerView.tag = 0;
    pickerOptions.tag = 1;
    
    myPickerView.delegate = self;
    pickerOptions.delegate = self;
    
    myPickerView.showsSelectionIndicator = YES;
    pickerOptions.showsSelectionIndicator = YES;
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent:(NSInteger)component {
    // Handle the selection
}

// tell the picker how many rows are available for a given component
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    NSUInteger numRows;
    if(pickerView.tag == 0){
        numRows = 10;//8 algorithms currently
    }
    else{
        numRows = 4;//4 data options
    }
    
    return numRows;
}

// tell the picker how many components it will have
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// tell the picker the title for a given component
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (LDBG) NSLog(@"setting rows name");
    shouldSetTime = YES;
    if(pickerView.tag ==0){
        return _algColumn[row];
    }
    else{
        return _optionsColumn[row];
    }
}

// tell the picker the width of each row for a given component
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    int sectionWidth;
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        if(pickerView.tag == 0){
            sectionWidth = 200;
        }
        else{
            sectionWidth = 200;
        }
        }
    else{
        if(pickerView.tag == 0)
            sectionWidth = 220;
        else
            sectionWidth = 200;
    }
    
    return sectionWidth;
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
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone && !shouldSetTime){//for iPhone, only set time once user has selected their options.
        return;
    }

    [elapsed setText:[NSString stringWithFormat:@"%5.3f seconds", (float) delta/1000.0]];
}


// The run has terminated -- update the screen, invalidate the timer tick...
-(IBAction)stopRun:(id)sender
{
    //NSLog(@"STOPPING RUN");
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

-(void)bubbleSort
{
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
    int j, i, key;
    for(j = 1; j < problemSize; j++){
        key = data[j];
        i = j -1;
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
        
        for(next = i + 1; next < problemSize; next++){
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
-(int)rankSort{
    int spot;
    int *copy = (int *)malloc(sizeof(int) * problemSize);
    for(int i =0; i <problemSize; i++){
        copy[i] = -1;
    }
    for(int i = 0; i < problemSize; i++){
        spot = 0;
        for(int j = 0; j < problemSize; j++){
            if (!shouldRun){
                problemSize = 1;
                free(copy);
                return 0;
            }
            if(data[i] < data[j] ){
                spot++;
            }
        }
        while(copy[spot] != -1){
            spot++;
        }
        copy[spot] = data[i];
    }
    
    free(copy);
    return 0;
}

-(void)heapSort{
    heapsort(data, problemSize, sizeof(int), intCompare);
}

void merge(int *arr, int *tmp, int start, int mid, int end)
{
    int li = start;
    int ri = mid;
    int mi = 0;
    
    while(li < mid && ri < end)
    {
        if (arr[li] < arr[ri])
        {
            tmp[mi] = arr[li];
            ++li;
        }
        else
        {
            tmp[mi] = arr[ri];
            ++ri;
        }
        ++mi;
    }
    while(li < mid)
    {
        tmp[mi] = arr[li];
        ++li;
        ++mi;
    }
    while(ri < end)
    {
        tmp[mi] = arr[ri];
        ++ri;
        ++mi;
    }
    memcpy(arr + start, tmp, sizeof(int) * (end - start));
}

void mergesort_aux(int *arr, int *tmp, int start, int end){
    if (end - start <= 1)
    {
        return;
    }
    int mid = (end + start) / 2;
    mergesort_aux(arr, tmp, start, mid);
    mergesort_aux(arr, tmp, mid, end);
    merge(arr, tmp, start, mid, end);
}

void mergeSort(int *arr, int size){
    int *tmp = malloc(sizeof(int) * size);
    mergesort_aux(arr, tmp, 0, size);
    free(tmp);
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

void quicksort_lomuto_norand(int *arr, int start, int end){
    if (start >= end)
    {
        return;
    }
    
    int p = lomuto_partition(arr, start, end, start);
    quicksort_lomuto_norand(arr, start, p-1);
    if(global_kill_flag){
        return;
    }
    quicksort_lomuto_norand(arr, p+1, end);
    if(global_kill_flag){
        global_kill_flag= 0;
        return;
    }
}
int quicksort_lomuto_rand(int *arr, int start, int end)
{
    if (start >= end)
    {
        return 0;
    }
    
    int p = lomuto_partition(arr, start, end, RAND_RANGE(start, end));
    quicksort_lomuto_rand(arr, start, p-1);
    if(global_kill_flag){
        global_kill_flag= 0;
        return 0;
    }
    quicksort_lomuto_rand(arr, p+1, end);
    if(global_kill_flag){
        global_kill_flag= 0;
        return 0;
    }
    return 0;
}

int quicksort_hoare_norand(int *arr, int start, int end){
    if (start >= end)
    {
        return 0 ;
    }
    
    int p = hoare_partition(arr, start, end, start);
    if(p ==-1){
        return 0;
    }
    quicksort_hoare_norand(arr, start, p);
    quicksort_hoare_norand(arr, p+1, end);
    return 0;
}
int quicksort_hoare_rand(int *arr, int start, int end)
{
    if (start >= end)
    {
        return 0;
    }
    
    int p = hoare_partition(arr, start, end, RAND_RANGE(start, end));
    if(p ==-1){
        return 0;
    }
    quicksort_hoare_rand(arr, start, p);
    quicksort_hoare_rand(arr, p+1, end);
    return 0;
}

int hoare_partition(int *arr, int start, int end, int pi)
{
    int i = start-1;
    int j = end+1;
    int pv = arr[pi];
    
    while(1)
    {
        if (!shouldRun)
        {
            global_kill_flag = 1;
        }
        if (global_kill_flag)
        {
            global_kill_flag = false;
            return -1;
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

int lomuto_partition(int *arr, int start, int end, int pi){
    int pv = arr[pi];
    int si = start;
    
    SWAP(arr, pi, end);
    
    for (int i = start; i < end; ++i)
    {
        if (!shouldRun)
        {
            global_kill_flag = 1;
            return 0;
        }
        if (global_kill_flag)
        {
            global_kill_flag = false;
            i = end +1;
            return 0;
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

    if(UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPhone){
        algType = (int) [myPickerView selectedRowInComponent:0];
        optionType = [pickerOptions selectedRowInComponent:0];
    }
    data = (int *)malloc(sizeof(int) * problemSize);//This sets data to a bunch of random numbers
    
    if (data == NULL)
    {
        NSLog(@"Problem too large!");
        return;
    }
    
    switch(optionType){
        case 0:
            for (i = 0; i < problemSize; ++i)
                data[i] = rand();
            break;
        case 1://ascending
            for (i = 0; i < problemSize; ++i)
                data[i] = i;
            break;
        case 2://descending
            for (i = 0; i < problemSize; i++)
                data[problemSize - i -1] = i;
            break;
        case 3://values =
            for (i = 0; i < problemSize; ++i){
                data[i] = 25;
            }
            break;
    }
    
    switch(algType){
        case 0:
            NSLog(@"1");
            quicksort_hoare_norand(data, 0, problemSize-1);
            break;
        case 1:
            quicksort_hoare_rand(data, 0, problemSize-1);
            NSLog(@"2");
            break;
        case 2:
            quicksort_lomuto_norand(data, 0, problemSize-1);
            NSLog(@"3");
            break;
        case 3:
            quicksort_lomuto_rand(data, 0, problemSize-1);
            NSLog(@"4");
            break;
        case 4:
            [self insertionSort];
            NSLog(@"5");
            break;
        case 5:
            [self selectionSort];
            NSLog(@"6");
            break;
        case 6:
            [self rankSort];
            NSLog(@"7");
            break;
        case 7:
            [self heapSort];
            NSLog(@"8");
            break;
        case 8:
            mergeSort(data, problemSize);
            NSLog(@"9");
            break;
        case 9:
            [self bubbleSort];
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

    if(UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPhone){//for iPAd, get tag. other wise its been set
        algType = (int) [sender tag];
    }
    
    if (LDBG) NSLog(@"Running algorithm %d option %d size %d", algType, (int) optionType, problemSize);
    
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

static ExperimentViewController *expVCPicker = nil;

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if (LDBG) NSLog(@"Segue named %@ %p", segue.identifier, segue.destinationViewController);
    
    if ([segue.identifier isEqualToString:@"AlgPicker"])
    {
        if (LDBG) NSLog(@"Segue to alg picker");
        expVCPicker = [segue destinationViewController];
    }
   
    InfoViewController *vc = [segue destinationViewController];
    if ([segue.identifier isEqualToString:@"qs"])
        [vc setFileToLoad:@"qs"];
    if ([segue.identifier isEqualToString:@"bubble"])
        [vc setFileToLoad:@"bubble"];
}

- (IBAction)done:(UIStoryboardSegue *)segue {
    //set which to run on
    if (LDBG) NSLog(@"Done called.");
    NSInteger algTypePicker;
    NSInteger option;
    
   if (expVCPicker)
   {
       algTypePicker = [[expVCPicker myPickerView] selectedRowInComponent:0];
       option = [[expVCPicker pickerOptions] selectedRowInComponent:0];
    
       if (LDBG) NSLog(@"alg: %i", (int) algTypePicker);
       if (LDBG) NSLog(@"opt: %i", (int) option);
    
       NSString * s1= _algColumn[algTypePicker];
       NSString * s2= _optionsColumn[option];
    
       [userAlg setText:s1];
       [userData setText:s2];
    
       algType = (int) algTypePicker;
       optionType = option;
   }
    
    if (LDBG) NSLog(@"done");
    if (LDBG) NSLog(@"Popping back to this view controller! %@ %p", segue.identifier, segue.destinationViewController);
    if (LDBG) NSLog(@"Back at main.  Destroy any peripheral or controller.");
    
}

-(void)createShield{
    if (runShield == nil)
    {
        UINib *nib;
    
        if (LDBG) NSLog(@"Creating self from decoder, loading nib");
        
        CGSize iOSDeviceScreenSize = [[UIScreen mainScreen] bounds].size;

        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){//iPhone View
            if(iOSDeviceScreenSize.height  == 568){
                nib = [UINib nibWithNibName:@"EVC_iPhone4inch" bundle:nil];
            }
            else{
                nib = [UINib nibWithNibName:@"EVC_iPhone" bundle:nil];
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
    html = (int) [sender tag];
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    if (standardUserDefaults) {
        [standardUserDefaults setObject:[NSNumber numberWithInt:html] forKey:@"age"];
        [standardUserDefaults synchronize];
    }
}
-(void)resetHTMLTag{
    html = -1;
}
@end
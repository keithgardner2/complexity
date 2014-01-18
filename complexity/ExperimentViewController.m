//
//  ExperimentViewController.m
//  complexity
//
//  Created by Patrick Madden on 12/7/13.
//  Copyright (c) 2013 Optimality Research Group. All rights reserved.
//

#import "ExperimentViewController.h"
#define LDBG 0

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
    NSLog(@"Running bubble sort");
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
    NSLog(@"Running insertion sort");
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

-(void)selectionSort{// just coded in, may be wrong.. need debug
    int choice, next, original, originalSpot;//move up later.....
    
//    NSLog(@"in selectionSort method");
//    for(int j = 0; j < problemSize; j++){
//        NSLog(@"%i", j);
//        NSLog(@"%i", data[j]);
//    }
//    NSLog(@"------------------");
    
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
    
//    for(int j = 0; j < problemSize; j++){
//        NSLog(@"%i", j);
//        NSLog(@"%i", data[j]);
//    }
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


-(void)quickSort
{
    NSLog(@"Running quick sort");
    qsort(data, problemSize, sizeof(int), intCompare);
}
-(void)do_it
{
    int i;

    data = (int *)malloc(sizeof(int) * problemSize);
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
        case 1:
            [self quickSort];
            break;
        case 2:
            [self insertionSort];
            break;
        case 3:
            NSLog(@"merge sort in case");
            break;
        case 4:
            NSLog(@"selectionSort in case");
            [self selectionSort];
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
@end

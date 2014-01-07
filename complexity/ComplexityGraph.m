//
//  ComplexityGraph.m
//  complexity
//
//  Created by Patrick Madden on 12/8/13.
//  Copyright (c) 2013 Optimality Research Group. All rights reserved.
//

#import "ComplexityGraph.h"
#define LDBG 0
@implementation ComplexityGraph
@synthesize c, k, n, cursor;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        c = (float *)malloc(sizeof(float) * 4);
        k = (float *)malloc(sizeof(float) * 4);

        for (int i = 0; i < 4; ++i)
        {
            c[i] = 1;
            k[i] = 0;
        }
        
        n = 1000;
        cursor = 0;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        c = (float *)malloc(sizeof(float) * 4);
        k = (float *)malloc(sizeof(float) * 4);

        for (int i = 0; i < 4; ++i)
        {
            c[i] = 1;
            k[i] = 0;
        }
        
        n = 10;
        cursor = 0;
    }
    return self;
}

float complexityFunction(int f, float c, float k, float n)
{
    switch (f)
    {
        case 0: // log n
            return c*log2(n+2) + k;
            break;
        case 1:  // n
            return c*n + k;
            break;
        case 2:  // n log n
            return c*n*log2(n) + k;
            break;
        case 3: // n^2
            return c*n*n + k;
            break;
    }
    return 1;
}



// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect bounds = [self bounds];
    [[UIColor blackColor] setFill];
    CGContextFillRect(context, bounds);
    
    [[UIColor whiteColor] setStroke];
    
    CGContextTranslateCTM(context, 0, bounds.size.height);
    CGContextScaleCTM(context, 1, -1);

    float maxv = 0;
    float v;
    int i;

    for (i = 0; i < 4; ++i)
    {
        v = complexityFunction(i, c[i], k[i], n);
        if (v > maxv)
            maxv = v;
    }
    
    if (LDBG) NSLog(@"Maxv = %f", maxv);

    CGContextSelectFont(context, "Helvetica", 20, kCGEncodingMacRoman);
    CGContextSetTextDrawingMode(context, kCGTextFill);
    char tmp[100];
    
    for (int f = 0; f < 4; ++f)
    {

        v = complexityFunction(f, c[f], k[f], 1 + (n-1)*cursor/bounds.size.width);
        switch (f)
        {
            case 0:
                [[UIColor whiteColor] setStroke];
                [[UIColor whiteColor] setFill];
                sprintf(tmp, "f(n) = %5.1f*log(n)   %5.1f", c[0], v);
                break;
            case 1:
                [[UIColor yellowColor] setStroke];
                [[UIColor yellowColor] setFill];
                sprintf(tmp, "f(n) = %5.1f*n     %5.1f", c[1], v);
                break;
            case 2:
                [[UIColor blueColor] setStroke];
                [[UIColor blueColor] setFill];
                sprintf(tmp, "f(n) = %5.1f*n*log(n)   %5.1f", c[2], v);
                break;
            case 3:
                [[UIColor greenColor] setStroke];
                [[UIColor greenColor] setFill];
                sprintf(tmp, "f(n) = %5.1f*n^2      %5.1f", c[3], v);
                break;
        }
        CGContextShowTextAtPoint(context, 10, bounds.size.height - (22*(f+1)), tmp, strlen(tmp));
        
        for (i = 1; i < bounds.size.width; ++i)
        {

            v = complexityFunction(f, c[f], k[f], 1 + ((n - 1)*(float)i)/bounds.size.width);
            // NSLog(@"f %d pt %d  --> %f (%f)", f, i, v, v/maxv);
            if (i == 1)
                CGContextMoveToPoint(context, i, (v/maxv) * bounds.size.height);
            CGContextAddLineToPoint(context, i, (v/maxv) * bounds.size.height);
        }

        CGContextStrokePath(context);
        


    }
    
    // Now draw the cursor line
    [[UIColor whiteColor] setStroke];
    CGContextMoveToPoint(context, cursor, 0);
    CGContextAddLineToPoint(context, cursor, bounds.size.height);
    CGContextStrokePath(context);
    
    
    // Now give the details on the curve
    sprintf(tmp, "Cursor at %3.1f, maximum n = %4.1f", 1 + (n - 1)*cursor/bounds.size.width, n);
    [[UIColor whiteColor] setFill];
    CGContextShowTextAtPoint(context, 10, 22*4, tmp, strlen(tmp));
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGRect bounds = [self bounds];
    for (UITouch *t in touches)
    {
        CGPoint p = [t locationInView:self];
        cursor = p.x;
    }
    if (cursor < 0) cursor = 0;
    if (cursor > bounds.size.width) cursor = bounds.size.width;
    [self setNeedsDisplay];
    
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchesBegan:touches withEvent:event];
}


@end

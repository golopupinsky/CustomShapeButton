//
//  CustomShapeButton.m
//  CustomShapeButton
//
//  Created by Sergey Yuzepovich on 11.12.14.
//  Copyright (c) 2014 Sergey Yuzepovich. All rights reserved.
//

#import "CustomShapeButton.h"

@implementation CustomShapeButton
{
    UIImage *img;
}

-(BOOL)isImageVisible:(CGPoint)point
{
    if(img == nil)
    {
        img = [self backgroundImageForState:UIControlStateNormal];
    }
    
    CGPoint fixedPoint = [self fixPoint:point forImage:img];
    
    return [self image:img alphaAtPixel:fixedPoint] > 0.1;
}

//image may be stretched on button. fixing here
-(CGPoint)fixPoint:(CGPoint)point forImage:(UIImage*)image
{
    int w = image.size.width;
    int h = image.size.height;
    
    point.x*= w / CGRectGetWidth(self.bounds);
    point.y*= h / CGRectGetHeight(self.bounds);
    return point;
}

-(float)image:(UIImage*)image alphaAtPixel:(CGPoint)point
{
    CGImageRef cgimage = [image CGImage];
    CFDataRef data = CGDataProviderCopyData(CGImageGetDataProvider(cgimage));
    const unsigned char * buffer =  CFDataGetBytePtr(data);
    unsigned char alpha = buffer[ (int)(image.size.width * (int)point.y + (int)point.x)*4 + 3];
    
    return alpha;
}

-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    if( [super pointInside:point withEvent:event] )
    {
        return [self isImageVisible:point];
    }
    
    return NO;
}
@end

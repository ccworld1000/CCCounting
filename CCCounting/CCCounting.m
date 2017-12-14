//
//  CCCounting.m
//  CCCounting
//
//  Created by deng you hua on 11/7/17.
//  Copyright © 2017 CC | ccworld1000@gmail.com. All rights reserved.
//

#import "CCCounting.h"
#import <QuartzCore/QuartzCore.h>

#pragma mark - CCCounter
@interface CCCounter : NSObject

@property CGFloat rate;
@property CCCountingType cType;

- (CGFloat) update:(CGFloat)t;
+ (CCCounter *) counterForType:(CCCountingType)cType;

@end

@implementation CCCounter

- (instancetype) init {
    self = [super init];
    if (self) {
        self.rate = 3.0;
    }

    return self;
}

- (CGFloat) update:(CGFloat)t {
    CGFloat time = t;

    switch (self.cType) {
        case CCCountingTypeLinear:
            break;
        case CCCountingTypeEaseIn:
            time = powf(t, self.rate);
            break;
        case CCCountingTypeEaseOut:
            time =  1.0 - powf((1.0 - t), self.rate);
            break;
        case CCCountingTypeEaseInOut: {
            time *= 2;
            if (time < 1)
                time = 0.5f * powf(t, self.rate);
            else
                time = 0.5f * (2.0f - powf(2.0 - t, self.rate));

        }
        break;
    }

    return time;
} /* update */

+ (CCCounter *) counterForType:(CCCountingType)cType {
    CCCounter * c = [CCCounter new];

    c.cType = cType;
    return c;
}

@end

#pragma mark - CCCounting
@interface CCCounting ()

@property CGFloat startingValue;
@property CGFloat destinationValue;
@property NSTimeInterval progress;
@property NSTimeInterval lastUpdate;
@property NSTimeInterval totalTime;
@property CGFloat easingRate;

@property (nonatomic, strong) CADisplayLink * timer;
@property (nonatomic, strong) CCCounter * counter;

@end

@implementation CCCounting

- (void) countFrom:(CGFloat)value to:(CGFloat)endValue {
    if (self.animationDuration == 0.0f) {
        self.animationDuration = 2.0f;
    }

    [self countFrom:value to:endValue withDuration:self.animationDuration];
}

- (void) countFrom:(CGFloat)startValue to:(CGFloat)endValue withDuration:(NSTimeInterval)duration {
    self.startingValue = startValue;
    self.destinationValue = endValue;

    // remove any (possible) old timers
    [self.timer invalidate];
    self.timer = nil;

    if (duration == 0.0) {
        // No animation
        [self setTextValue:endValue];
        [self runCompletionBlock];
        return;
    }

    self.easingRate = 3.0f;
    self.progress = 0;
    self.totalTime = duration;
    self.lastUpdate = [NSDate timeIntervalSinceReferenceDate];

    if (self.format == nil)
        self.format = @"%f";

    self.counter = [CCCounter counterForType:self.cType];

    CADisplayLink * timer = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateValue:)];
    timer.frameInterval = 2;
    [timer addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    [timer addToRunLoop:[NSRunLoop mainRunLoop] forMode:UITrackingRunLoopMode];
    self.timer = timer;
} /* countFrom */

- (void) countFromCurrentValueTo:(CGFloat)endValue {
    [self countFrom:[self currentValue] to:endValue];
}

- (void) countFromCurrentValueTo:(CGFloat)endValue withDuration:(NSTimeInterval)duration {
    [self countFrom:[self currentValue] to:endValue withDuration:duration];
}

- (void) countFromZeroTo:(CGFloat)endValue {
    [self countFrom:0.0f to:endValue];
}

- (void) countFromZeroTo:(CGFloat)endValue withDuration:(NSTimeInterval)duration {
    [self countFrom:0.0f to:endValue withDuration:duration];
}

- (void) updateValue:(NSTimer *)timer {
    // update progress
    NSTimeInterval now = [NSDate timeIntervalSinceReferenceDate];

    self.progress += now - self.lastUpdate;
    self.lastUpdate = now;

    if (self.progress >= self.totalTime) {
        [self.timer invalidate];
        self.timer = nil;
        self.progress = self.totalTime;
    }

    [self setTextValue:[self currentValue]];

    if (self.progress == self.totalTime) {
        [self runCompletionBlock];
    }
}

- (void) setTextValue:(CGFloat)value {
    if (self.attributedFormatBlock != nil) {
        self.attributedText = self.attributedFormatBlock(value);
    } else if (self.formatBlock != nil) {
        self.text = self.formatBlock(value);
    } else {
        // check if counting with ints - cast to int
        if ([self.format rangeOfString:@"%(.*)d" options:NSRegularExpressionSearch].location != NSNotFound || [self.format rangeOfString:@"%(.*)i"].location != NSNotFound ) {
            self.text = [NSString stringWithFormat:self.format, (int)value];
        } else {
            self.text = [NSString stringWithFormat:self.format, value];
        }
    }
}

- (void) setFormat:(NSString *)format {
    _format = format;
    // update label with new format
    [self setTextValue:self.currentValue];
}

- (void) runCompletionBlock {
    if (self.completionBlock) {
        self.completionBlock();
        self.completionBlock = nil;
    }
}

- (CGFloat) currentValue {
    if (self.progress >= self.totalTime) {
        return self.destinationValue;
    }

    CGFloat percent = self.progress / self.totalTime;
    CGFloat updateVal = [self.counter update:percent];
    return self.startingValue + (updateVal * (self.destinationValue - self.startingValue));
}

@end
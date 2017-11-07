//
//  CCCounting.h
//  CCCounting
//
//  Created by deng you hua on 11/7/17.
//  Copyright © 2017 CC | ccworld1000@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

/**
 *  CCCountingType
 */
typedef NS_ENUM(NSUInteger, CCCountingType) {
    /**
     *  EaseInOut
     */
    CCCountingTypeEaseInOut,
    /**
     *  EaseIn
     */
    CCCountingTypeEaseIn,
    /**
     *  EaseOut
     */
    CCCountingTypeEaseOut,
    /**
     *  Linear
     */
    CCCountingTypeLinear
};

typedef NSString* (^CCCountingFormatBlock)(CGFloat value);
typedef NSAttributedString* (^CCCountingAttributedFormatBlock)(CGFloat value);

/**
 *  CCCounting label
 */
@interface CCCounting : UILabel

@property (nonatomic, strong) NSString *format;
@property (nonatomic, assign) CCCountingType cType;
@property (nonatomic, assign) NSTimeInterval animationDuration;

@property (nonatomic, copy) CCCountingFormatBlock formatBlock;
@property (nonatomic, copy) CCCountingAttributedFormatBlock attributedFormatBlock;
@property (nonatomic, copy) void (^completionBlock)(void);

-(void)countFrom:(CGFloat)startValue to:(CGFloat)endValue;
-(void)countFrom:(CGFloat)startValue to:(CGFloat)endValue withDuration:(NSTimeInterval)duration;

-(void)countFromCurrentValueTo:(CGFloat)endValue;
-(void)countFromCurrentValueTo:(CGFloat)endValue withDuration:(NSTimeInterval)duration;

-(void)countFromZeroTo:(CGFloat)endValue;
-(void)countFromZeroTo:(CGFloat)endValue withDuration:(NSTimeInterval)duration;

- (CGFloat)currentValue;

@end


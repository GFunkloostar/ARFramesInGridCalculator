//
//  ARFramesInGridCalculator.m
//  Timer
//
//  Created by Gijs van Klooster on 06-12-13.
//  Copyright (c) 2013 Appy Road. All rights reserved.
//

#import "ARFramesInGridCalculator.h"



@implementation ARFramesInGridCalculator

- (id)initWithCellSize:(CGSize)cellSize rowCount:(NSInteger)rowCount columnCount:(NSInteger)columnCount andDirection:(ARFramesInGridDirection)direction;
{
    self = [super init];
    if (self)
	{
		_framesRounded	= YES;

		_cellSize		= cellSize;

		_initialOffset	= CGPointZero;
		_cellSpacing	= CGSizeZero;

		_rowCount		= rowCount == 0 ? NSIntegerMax : rowCount;
		_columnCount	= columnCount == 0 ? NSIntegerMax : columnCount;
		
		_gridDirection	= direction;
    }
	
    return self;
}

- (instancetype)initWithSingleColumnWithCellSize:(CGSize)cellSize
{
	return [self initWithCellSize:cellSize rowCount:0 columnCount:1 andDirection:ARFramesInGridDirectionVertical];
}

- (instancetype)initWithSingleRowWithCellSize:(CGSize)cellSize
{
	return [self initWithCellSize:cellSize rowCount:1 columnCount:0 andDirection:ARFramesInGridDirectionHorizontal];
}

#pragma mark - Public

- (CGRect)frameForIndex:(NSInteger)index
{
	if (index < 0) {
		return CGRectZero;
	}
	
	CGPoint point = [self originForIndex:index];
	CGRect retRect;
	
	if (_framesRounded)
	{
		retRect = CGRectMake(roundf(point.x), roundf(point.y), roundf(_cellSize.width), roundf(_cellSize.height));
	}
	else
	{
		retRect = CGRectMake(point.x, point.y, _cellSize.width, _cellSize.height);
	}
	
	return retRect;
}

#pragma mark - Private

- (CGPoint)originForIndex:(NSInteger)index
{
	NSInteger xCount;
	NSInteger yCount;
	
	if ((_columnCount != NSIntegerMax) && (_rowCount != NSIntegerMax))
	{
		index = index % (_columnCount * _rowCount);
	}
	
	switch (_gridDirection)
	{
		case ARFramesInGridDirectionHorizontal: {
			xCount = index % _columnCount;
			yCount = (int) floorf(index / _columnCount);
			break;
		}
		case ARFramesInGridDirectionVertical: {
			xCount = (int) floorf(index / _rowCount);
			yCount = index % _rowCount;
			
			break;
		}
		default:
			break;
	}
	
	CGFloat xOffset = _initialOffset.x + (xCount * (_cellSize.width + _cellSpacing.width));
	CGFloat yOffset = _initialOffset.y + (yCount * (_cellSize.height + _cellSpacing.height));
	
	CGPoint retPoint = CGPointMake(xOffset, yOffset);
	return retPoint;
}

#pragma mark - Tools

- (void)setCellWidthToFitWidth:(CGFloat)totalWidth count:(NSInteger)cellCount horizontalMargin:(CGFloat)horizontalMargin
{
	_cellSize.width = [ARFramesInGridCalculator cellWidthToFitWidth:totalWidth count:cellCount horizontalMargin:horizontalMargin];
	_initialOffset.x = horizontalMargin;
	_cellSpacing.width = horizontalMargin;
}

+ (CGFloat)cellWidthToFitWidth:(CGFloat)totalWidth count:(NSInteger)cellCount horizontalMargin:(CGFloat)horizontalMargin
{
	if (cellCount <= 0) {
		return 0.0;
	}
	
	return (totalWidth - ((cellCount + 1) * horizontalMargin)) / cellCount;
}

- (void)setHorizontalMarginForTotalWidth:(CGFloat)totalWidth cellWidth:(CGFloat)cellWidth count:(NSInteger)cellCount
{
	CGFloat margin = [ARFramesInGridCalculator horizontalMarginForTotalWidth:totalWidth cellWidth:cellWidth count:cellCount];
	
	_cellSize.width = cellWidth;
	_initialOffset.x = margin;
	_cellSpacing.width = margin;
}

+ (CGFloat)horizontalMarginForTotalWidth:(CGFloat)totalWidth cellWidth:(CGFloat)cellWidth count:(NSInteger)cellCount
{
	if (cellCount <= 0) {
		return 0.0;
	}

	return (totalWidth - (cellCount * cellWidth)) / (cellCount + 1);
}

@end

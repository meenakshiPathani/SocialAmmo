//
//  PagedFlowView.h
//  PicLab
//
//  Created by Rupesh on 2/15/14.
//  Copyright (c) 2014 The Social Ammo. All rights reserved.


@protocol PagedFlowViewDataSource;
@protocol PagedFlowViewDelegate;

typedef enum
{
    PagedFlowViewOrientationHorizontal = 0,
    PagedFlowViewOrientationVertical
}PagedFlowViewOrientation;

@interface PagedFlowView : UIView<UIScrollViewDelegate>{
    
    PagedFlowViewOrientation orientation;
    
    UIScrollView        *_scrollView;
    BOOL                _needsReload;
    CGSize              _pageSize;
    NSInteger           _pageCount;
    NSInteger           _currentPageIndex;

    NSMutableArray      *_cells;
    NSRange              _visibleRange;
    NSMutableArray      *_reusableCells;

    UIPageControl       *pageControl;
    
    CGFloat _minimumPageAlpha;
    CGFloat _minimumPageScale;

    
    id <PagedFlowViewDataSource> __weak _dataSource;
    id <PagedFlowViewDelegate>   __weak _delegate;
}

@property(nonatomic,weak)   id <PagedFlowViewDataSource> dataSource;
@property(nonatomic,weak)   id <PagedFlowViewDelegate>   delegate;
@property(nonatomic,strong)    UIPageControl       *pageControl;
@property (nonatomic, assign) CGFloat minimumPageAlpha;
@property (nonatomic, assign) CGFloat minimumPageScale;
@property (nonatomic, assign) PagedFlowViewOrientation orientation;
@property (nonatomic, assign, readonly) NSInteger currentPageIndex;

- (void)reloadData;

- (UIView *)dequeueReusableCell;
- (void)scrollToPage:(NSUInteger)pageNumber;

@end


@protocol  PagedFlowViewDelegate<NSObject>

- (CGSize)sizeForPageInFlowView:(PagedFlowView *)flowView;

@optional

- (void)flowView:(PagedFlowView *)flowView didScrollToPageAtIndex:(NSInteger)index;

- (void)flowView:(PagedFlowView *)flowView didTapPageAtIndex:(NSInteger)index;

@end


@protocol PagedFlowViewDataSource <NSObject>

- (NSInteger)numberOfPagesInFlowView:(PagedFlowView *)flowView;

- (UIView *)flowView:(PagedFlowView *)flowView cellForPageAtIndex:(NSInteger)index;

@end
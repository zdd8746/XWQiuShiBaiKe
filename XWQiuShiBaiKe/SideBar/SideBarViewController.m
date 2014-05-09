//
//  SideBarViewController.m
//  XWQSBK
//
//  Created by Ren XinWei on 13-4-28.
//  Copyright (c) 2013年 renxinwei. All rights reserved.
//

#import "SideBarViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "LeftSideBarViewController.h"

@interface SideBarViewController ()
{
    UIViewController  *_currentMainController;
    UITapGestureRecognizer *_tapGestureRecognizer;
    UIPanGestureRecognizer *_panGestureReconginzer;
    
    CGFloat currentTranslate;
}

@property (retain, nonatomic) LeftSideBarViewController *leftSideBarViewController;

@end

@implementation SideBarViewController

static BOOL _sideBarShowing;
static SideBarViewController *rootViewCon;
const int ContentOffset = 280;
const int ContentMinOffset = 60;
const float MoveAnimationDuration = 0.3;

+ (id)share
{
    return rootViewCon;
}

+ (BOOL)getShowingState
{
    return _sideBarShowing;
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
    // Do any additional setup after loading the view from its nib.
    if (rootViewCon) {
        rootViewCon = nil;
    }
	rootViewCon = self;
    
    _sideBarShowing = NO;
    currentTranslate = 0;
    
    self.contentView.layer.shadowOffset = CGSizeMake(0, 0);
    self.contentView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.contentView.layer.shadowOpacity = 1;
    
    LeftSideBarViewController *_leftCon = [[LeftSideBarViewController alloc] initWithNibName:@"LeftSideBarViewController" bundle:nil];
    _leftCon.delegate = self;
    self.leftSideBarViewController = _leftCon;
    [_leftCon release];
    
    [self addChildViewController:self.leftSideBarViewController];
    self.leftSideBarViewController.view.frame = self.navBackView.bounds;
    [self.navBackView addSubview:self.leftSideBarViewController.view];
    
    _panGestureReconginzer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panInContentView:)];
    _panGestureReconginzer.delegate = self;
    [self.contentView addGestureRecognizer:_panGestureReconginzer];
}

- (void)dealloc
{
    [_contentView release];
    [_navBackView release];

    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    if (toInterfaceOrientation == UIInterfaceOrientationPortrait) {
        return YES;
    }
    return NO;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    NSLog(@"rotate");
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

//添加tap手势，判断生效的范围
- (void)contentViewAddTapGestures
{
    if (_tapGestureRecognizer) {
        [self.contentView   removeGestureRecognizer:_tapGestureRecognizer];
        _tapGestureRecognizer = nil;
    }
    
    _tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnContentView:)];
    [self.contentView addGestureRecognizer:_tapGestureRecognizer];
}

- (void)tapOnContentView:(UITapGestureRecognizer *)tapGestureRecognizer
{
    [self moveAnimationWithDirection:SideBarShowDirectionNone duration:MoveAnimationDuration];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    CGFloat location = [gestureRecognizer locationInView:self.contentView].x;
    if (location < 70) {
        return YES;
    }
    return NO;
}

//向右拖动界面
- (void)panInContentView:(UIPanGestureRecognizer *)panGestureReconginzer
{
//    if (panGestureReconginzer.state == UIGestureRecognizerStateBegan) {
//        CGFloat location = [panGestureReconginzer locationInView:self.contentView].x;
//        if (location < 120) {
//            _panGestureReconginzer.cancelsTouchesInView = YES;
//        }
//    }
	if (panGestureReconginzer.state == UIGestureRecognizerStateChanged) {
        CGFloat translation = [panGestureReconginzer translationInView:self.contentView].x;
        UIView *view = nil;

        if (translation+currentTranslate > 0) {
            self.contentView.transform = CGAffineTransformMakeTranslation(translation+currentTranslate, 0);
            view = self.leftSideBarViewController.view;
        }
        
        [self.navBackView bringSubviewToFront:view];
	}
    else if (panGestureReconginzer.state == UIGestureRecognizerStateEnded) {
		currentTranslate = self.contentView.transform.tx;
        if (!_sideBarShowing) {
            if (fabs(currentTranslate)<ContentMinOffset) {
                [self moveAnimationWithDirection:SideBarShowDirectionNone duration:MoveAnimationDuration];
            }else if(currentTranslate>ContentMinOffset)
            {
                [self moveAnimationWithDirection:SideBarShowDirectionLeft duration:MoveAnimationDuration];
            }
        }else
        {
            if (fabs(currentTranslate)<ContentOffset-ContentMinOffset) {
                [self moveAnimationWithDirection:SideBarShowDirectionNone duration:MoveAnimationDuration];
                
            }else if(currentTranslate>ContentOffset-ContentMinOffset)
            {
                
                [self moveAnimationWithDirection:SideBarShowDirectionLeft duration:MoveAnimationDuration];
            }
        }
	}
}

#pragma mark - UINavigation delegate method

//在二级导航移除pan手势
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([navigationController.viewControllers count]>1) {
        [self removepanGestureReconginzerWhileNavConPushed:YES];
    }else
    {
        [self removepanGestureReconginzerWhileNavConPushed:NO];
    }
}

- (void)removepanGestureReconginzerWhileNavConPushed:(BOOL)push
{
    if (push) {
        if (_panGestureReconginzer) {
            [self.contentView removeGestureRecognizer:_panGestureReconginzer];
            [_panGestureReconginzer release];
            _panGestureReconginzer = nil;
        }
    }else
    {
        if (!_panGestureReconginzer) {
            _panGestureReconginzer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panInContentView:)];
            _panGestureReconginzer.delegate = self;
            [self.contentView addGestureRecognizer:_panGestureReconginzer];
        }
    }
}

#pragma mark - side bar select delegate

- (void)leftSideBarSelectWithController:(UIViewController *)controller
{
    if ([controller isKindOfClass:[UINavigationController class]]) {
        [(UINavigationController *)controller setDelegate:self];
    }
    if (_currentMainController == nil) {
		controller.view.frame = self.contentView.bounds;
		_currentMainController = controller;
		[self addChildViewController:_currentMainController];
		[self.contentView addSubview:_currentMainController.view];
		[_currentMainController didMoveToParentViewController:self];
	} else if (_currentMainController != controller && controller !=nil) {
		controller.view.frame = self.contentView.bounds;
		[_currentMainController willMoveToParentViewController:nil];
		[self addChildViewController:controller];
		self.view.userInteractionEnabled = NO;
		[self transitionFromViewController:_currentMainController
						  toViewController:controller
								  duration:0
								   options:UIViewAnimationOptionTransitionNone
								animations:^{}
								completion:^(BOOL finished){
									self.view.userInteractionEnabled = YES;
									[_currentMainController removeFromParentViewController];
									[controller didMoveToParentViewController:self];
									_currentMainController = controller;
								}
         ];
	}
    
    [self showSideBarControllerWithDirection:SideBarShowDirectionNone];
}

- (void)showSideBarControllerWithDirection:(SideBarShowDirection)direction
{
    
    if (direction!=SideBarShowDirectionNone) {
        UIView *view = nil;
        if (direction == SideBarShowDirectionLeft) {
            view = self.leftSideBarViewController.view;
        }
        [self.navBackView bringSubviewToFront:view];
    }
    [self moveAnimationWithDirection:direction duration:MoveAnimationDuration];
}

#pragma mark - animation method

//滑动中的动画
- (void)moveAnimationWithDirection:(SideBarShowDirection)direction duration:(float)duration
{
    void (^animations)(void) = ^{
		switch (direction) {
            case SideBarShowDirectionNone:
            {
                self.contentView.transform  = CGAffineTransformMakeTranslation(0, 0);
            }
                break;
            case SideBarShowDirectionLeft:
            {
                self.contentView.transform  = CGAffineTransformMakeTranslation(ContentOffset, 0);
            }
                break;
            default:
                break;
        }
	};
    void (^complete)(BOOL) = ^(BOOL finished) {
        self.contentView.userInteractionEnabled = YES;
        self.navBackView.userInteractionEnabled = YES;
        
        if (direction == SideBarShowDirectionNone) {
            
            if (_tapGestureRecognizer) {
                [self.contentView removeGestureRecognizer:_tapGestureRecognizer];
                _tapGestureRecognizer = nil;
            }
            _sideBarShowing = NO;
        }else
        {
            [self contentViewAddTapGestures];
            _sideBarShowing = YES;
        }
        currentTranslate = self.contentView.transform.tx;
	};
    self.contentView.userInteractionEnabled = NO;
    self.navBackView.userInteractionEnabled = NO;
    [UIView animateWithDuration:duration animations:animations completion:complete];
}

- (void)viewDidUnload {

    [super viewDidUnload];
}
@end

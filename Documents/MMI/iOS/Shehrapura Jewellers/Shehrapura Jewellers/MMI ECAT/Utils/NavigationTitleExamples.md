# Navigation Title on Left Side - Usage Examples

## 🎯 Overview

The MMI ECAT project now supports custom navigation title positioning, including left-aligned titles. This provides better UX and more design flexibility.

## 📱 Basic Usage

### 1. Simple Left-Aligned Title
```objc
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set title on the left side
    [self setNavigationTitleOnLeft:@"Jewel Desk"];
}
```

### 2. Left-Aligned Title with Custom Styling
```objc
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Custom font and color
    UIFont *customFont = [UIFont systemFontOfSize:20 weight:UIFontWeightBold];
    UIColor *customColor = [UIColor colorWithRed:1.0 green:0.8 blue:0.0 alpha:1.0]; // Gold color
    
    [self setNavigationTitleOnLeft:@"Jewel Desk" 
                              font:customFont 
                             color:customColor];
}
```

### 3. Left-Aligned Title with Subtitle
```objc
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Title with subtitle
    [self setNavigationTitleOnLeft:@"Jewel Desk" 
                          subtitle:@"Premium Collection"];
}
```

### 4. Left-Aligned Title with Icon
```objc
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Title with image (make sure the image exists in your assets)
    [self setNavigationTitleOnLeft:@"Jewel Desk" 
                        withImage:@"jewel_icon"];
}
```

## 🎨 Advanced Examples

### 5. Different Alignments
```objc
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Left alignment
    [self setNavigationTitle:@"Jewel Desk" alignment:NSTextAlignmentLeft];
    
    // Center alignment (default)
    [self setNavigationTitle:@"Jewel Desk" alignment:NSTextAlignmentCenter];
    
    // Right alignment
    [self setNavigationTitle:@"Jewel Desk" alignment:NSTextAlignmentRight];
}
```

### 6. Dynamic Title Updates
```objc
- (void)updateTitleForUser:(NSString *)username {
    // Update title dynamically
    [self setNavigationTitleOnLeft:[NSString stringWithFormat:@"Welcome, %@", username]];
}

- (void)updateTitleWithCount:(NSInteger)count {
    // Update title with count
    [self setNavigationTitleOnLeft:[NSString stringWithFormat:@"Cart (%ld)", (long)count]];
}
```

### 7. Reset to Default
```objc
- (void)resetToDefaultTitle {
    // Reset to center-aligned default title
    [self resetNavigationTitleToCenter];
}
```

## 🏗️ Implementation in Different View Controllers

### HomeVC Example
```objc
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.hidesBackButton = YES;
    
    // Set navigation title on the left side
    [self setNavigationTitleOnLeft:@"Jewel Desk"];
    
    // Rest of your setup code...
}
```

### Product List Example
```objc
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Title with category subtitle
    [self setNavigationTitleOnLeft:@"Products" 
                          subtitle:@"Gold Collection"];
    
    // Or with icon
    [self setNavigationTitleOnLeft:@"Products" 
                        withImage:@"product_icon"];
}
```

### Cart Example
```objc
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Dynamic title with count
    [self updateCartTitle];
}

- (void)updateCartTitle {
    NSInteger itemCount = [self getCartItemCount];
    [self setNavigationTitleOnLeft:[NSString stringWithFormat:@"Cart (%ld items)", (long)itemCount]];
}
```

### Profile Example
```objc
- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *username = [[NSUserDefaults standardUserDefaults] stringForKey:@"username"];
    
    // Personalized title
    [self setNavigationTitleOnLeft:@"Profile" 
                          subtitle:username];
}
```

## 🎨 Customization Options

### Font Customization
```objc
// Bold title
UIFont *boldFont = [UIFont boldSystemFontOfSize:18];
[self setNavigationTitleOnLeft:@"Title" font:boldFont color:nil];

// Custom font family
UIFont *customFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:16];
[self setNavigationTitleOnLeft:@"Title" font:customFont color:nil];
```

### Color Customization
```objc
// Brand colors
UIColor *brandColor = [UIColor colorWithRed:92/255.0f green:16/255.0f blue:19/255.0f alpha:1.0];
[self setNavigationTitleOnLeft:@"Title" font:nil color:brandColor];

// Gradient-like effect with custom color
UIColor *goldColor = [UIColor colorWithRed:1.0 green:0.8 blue:0.0 alpha:1.0];
[self setNavigationTitleOnLeft:@"Premium" font:nil color:goldColor];
```

### Subtitle Styling
```objc
// The subtitle automatically uses:
// - Smaller font (12pt)
// - Semi-transparent white (80% opacity)
// - Left alignment
[self setNavigationTitleOnLeft:@"Main Title" subtitle:@"Subtitle Text"];
```

## 🔧 Technical Details

### Available Methods
1. `setNavigationTitleOnLeft:(NSString *)title`
2. `setNavigationTitleOnLeft:(NSString *)title font:(UIFont *)font color:(UIColor *)color`
3. `setNavigationTitleOnLeft:(NSString *)title subtitle:(NSString *)subtitle`
4. `setNavigationTitleOnLeft:(NSString *)title withImage:(NSString *)imageName`
5. `setNavigationTitle:(NSString *)title alignment:(NSTextAlignment)alignment`
6. `resetNavigationTitleToCenter`

### Device-Specific Behavior
- **iPhone**: Title positioned on the left with proper spacing
- **iPad**: Larger spacing and font sizes automatically applied
- **Safe Area**: Automatically respects safe area insets
- **Rotation**: Handles orientation changes properly

### Performance Considerations
- Titles are calculated once and cached
- No performance impact on scrolling
- Memory efficient implementation
- Automatic cleanup on view deallocation

## 🚀 Best Practices

### 1. Consistency
```objc
// Use consistent styling across your app
- (void)setupConsistentTitle {
    UIFont *titleFont = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
    UIColor *titleColor = [UIColor whiteColor];
    
    [self setNavigationTitleOnLeft:@"Screen Title" 
                              font:titleFont 
                             color:titleColor];
}
```

### 2. Accessibility
```objc
// Titles are automatically accessible
// VoiceOver will read the title properly
[self setNavigationTitleOnLeft:@"Jewel Desk"];
```

### 3. Dynamic Content
```objc
// Update titles when data changes
- (void)dataDidUpdate {
    [self updateTitleForCurrentState];
}

- (void)updateTitleForCurrentState {
    NSString *newTitle = [self generateTitleForCurrentState];
    [self setNavigationTitleOnLeft:newTitle];
}
```

### 4. Error Handling
```objc
// Safe title setting
- (void)setTitleSafely:(NSString *)title {
    if (title && title.length > 0) {
        [self setNavigationTitleOnLeft:title];
    } else {
        [self resetNavigationTitleToCenter];
    }
}
```

## 📱 Example Screenshots

### Basic Left Title
```
┌─────────────────────────────────────┐
│ Jewel Desk                    [Menu] │
└─────────────────────────────────────┘
```

### Title with Subtitle
```
┌─────────────────────────────────────┐
│ Jewel Desk                    [Menu] │
│ Premium Collection                   │
└─────────────────────────────────────┘
```

### Title with Icon
```
┌─────────────────────────────────────┐
│ [💎] Jewel Desk               [Menu] │
└─────────────────────────────────────┘
```

## 🔄 Migration Guide

### From Old Title Setting
```objc
// Old way
self.title = @"Jewel Desk";

// New way
[self setNavigationTitleOnLeft:@"Jewel Desk"];
```

### From Custom Title Views
```objc
// Old way - complex custom title view
UILabel *titleLabel = [[UILabel alloc] init];
titleLabel.text = @"Title";
// ... complex setup code
self.navigationItem.titleView = titleLabel;

// New way - simple method call
[self setNavigationTitleOnLeft:@"Title"];
```

## ✅ Benefits

1. **Better UX**: Left-aligned titles are easier to read
2. **Consistency**: Uniform styling across the app
3. **Flexibility**: Multiple customization options
4. **Performance**: Optimized implementation
5. **Accessibility**: Built-in accessibility support
6. **Maintainability**: Easy to update and modify

## 🎯 Use Cases

- **Home Screen**: App name on the left
- **Product Lists**: Category name with subtitle
- **User Profile**: Personalized titles
- **Shopping Cart**: Dynamic count display
- **Settings**: Section titles
- **Search Results**: Search term display

This implementation provides a modern, flexible, and user-friendly navigation title system for your MMI ECAT app! 🎉 
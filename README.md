# Swift Cell-Height-Animation
Inspired by Facebook UITableview cell animation, which is the "see more" button on the cell that could dynamically change the cell height with animation.

## Requirements
- Swift 3
- iOS 8.0+

## Demo
<img src="https://raw.githubusercontent.com/Mononster/SwiftCellContentHeightAnimation/master/gif/seeMore.gif" width="300" height="500">

Also I added the transition animation when tapped imageView and the algorithm that displays the images on the cell.

<img src="https://raw.githubusercontent.com/Mononster/SwiftCellContentHeightAnimation/master/gif/tapAnimation.gif" width="300" height="500"> <img src="https://raw.githubusercontent.com/Mononster/SwiftCellContentHeightAnimation/master/gif/scroll.gif" width="300" height="500">

## Implementation

These two lines are the most important to accomplish the height changing animation effect. (I spent a lot of time reserching, but I never thought the solution will be rather simple)

``` Swift
tableView.beginUpdates()
tableView.endUpdate()
```

This is also denoted as a side effect of uitableview.
With this effect, we could then add animations for these two methods.

``` Swift
UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.3, animations: {
            self.tableView?.beginUpdates()
            self.tableView?.endUpdates()
        }, 
        completion: nil)
 ```
 
 The fixed-height view with higher priority will not get animated, only the one with lowest priority will get animated.
 
 ## Author

Marvin Zhan, marvinzhanmonster@gmail.com, Wechat : mononster
Currently University of Waterloo undergraduate student.

## License

MIT


# AutoLayout
my personal AutoLayout API

Sample code:
```swift
// auto layout
let pad: CGFloat = 20
subviews.usesAutolayout()
        
b1.leading => view.leading + pad
b1.trailing => b2.leading - pad
b1.bottom => view.bottom - pad
b1.top => v1.bottom + pad
b1.firstBaseline => b2.firstBaseline
        
b2.trailing => view.trailing - pad
b2.width => b1.width
        
v1.leading => view.leading + pad
v1.trailing => view.trailing - pad
v1.top => view.top + pad
        
v2.centerX => v1.centerX
v2.centerY => v1.centerY
v2.width => 100
v2.height => 100
```

//
//  CustomRoundedRectangle.swift
//

import SwiftUI

struct CustomRoundedRectangle: Shape {
  let topLeftRadius: CGFloat
  let topRightRadius: CGFloat
  let bottomLeftRadius: CGFloat
  let bottomRightRadius: CGFloat
  
  func path(in rect: CGRect) -> Path {
    var path = Path()
    
    let topLeft = rect.origin
    let topRight = CGPoint(x: rect.maxX, y: rect.minY)
    let bottomLeft = CGPoint(x: rect.minX, y: rect.maxY)
    let bottomRight = CGPoint(x: rect.maxX, y: rect.maxY)
    
    path.move(to: CGPoint(x: topLeft.x + topLeftRadius, y: topLeft.y))
    
    path.addLine(to: CGPoint(x: topRight.x - topRightRadius, y: topRight.y))
    path.addArc(
      center: CGPoint(x: topRight.x - topRightRadius, y: topRight.y + topRightRadius),
      radius: topRightRadius,
      startAngle: Angle(degrees: -90),
      endAngle: Angle(degrees: 0),
      clockwise: false
    )
    
    path.addLine(to: CGPoint(x: bottomRight.x, y: bottomRight.y - bottomRightRadius))
    path.addArc(
      center: CGPoint(x: bottomRight.x - bottomRightRadius, y: bottomRight.y - bottomRightRadius),
      radius: bottomRightRadius,
      startAngle: Angle(degrees: 0),
      endAngle: Angle(degrees: 90),
      clockwise: false
    )
    
    path.addLine(to: CGPoint(x: bottomLeft.x + bottomLeftRadius, y: bottomLeft.y))
    path.addArc(
      center: CGPoint(x: bottomLeft.x + bottomLeftRadius, y: bottomLeft.y - bottomLeftRadius),
      radius: bottomLeftRadius,
      startAngle: Angle(degrees: 90),
      endAngle: Angle(degrees: 180),
      clockwise: false
    )
    
    path.addLine(to: CGPoint(x: topLeft.x, y: topLeft.y + topLeftRadius))
    path.addArc(
      center: CGPoint(x: topLeft.x + topLeftRadius, y: topLeft.y + topLeftRadius),
      radius: topLeftRadius,
      startAngle: Angle(degrees: 180),
      endAngle: Angle(degrees: 270),
      clockwise: false
    )
    
    return path
  }
}

#Preview {
  VStack {
    CustomRoundedRectangle(
      topLeftRadius: 10,
      topRightRadius: 0,
      bottomLeftRadius: 0,
      bottomRightRadius: 0
    )
    .fill(.red)
    .frame(width: 100, height: 100)
    
    CustomRoundedRectangle(
      topLeftRadius: 0,
      topRightRadius: 10,
      bottomLeftRadius: 0,
      bottomRightRadius: 0
    )
    .fill(.red)
    .frame(width: 100, height: 100)
    
    CustomRoundedRectangle(
      topLeftRadius: 0,
      topRightRadius: 0,
      bottomLeftRadius: 10,
      bottomRightRadius: 0
    )
    .fill(.red)
    .frame(width: 100, height: 100)
    
    CustomRoundedRectangle(
      topLeftRadius: 0,
      topRightRadius: 0,
      bottomLeftRadius: 0,
      bottomRightRadius: 10
    )
    .fill(.red)
    .frame(width: 100, height: 100)
  }
  .padding(30)
}

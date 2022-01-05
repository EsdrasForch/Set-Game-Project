//
//  CardView.swift
//  Set
//
//  Created by Esdras Forch on 10/31/21.
//

import SwiftUI

//MARK: SHAPES
struct Diamond: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let edge = min(rect.width, rect.height)/2
        
        path.move(to: CGPoint(x: center.x, y: center.y-edge))
        path.addLine(to: CGPoint(x: center.x-edge, y: center.y))
        path.addLine(to: CGPoint(x: center.x, y: center.y+edge))
        path.addLine(to: CGPoint(x: center.x+edge, y: center.y))
        path.addLine(to: CGPoint(x: center.x, y: center.y-edge))
        
        return path
    }
}

struct Squiggle: Shape {
    
    private struct SquiggleRatios {
        static let widthPercentage: CGFloat = 0.15
        static let offsetPercentage: CGFloat = 0.20
        static let controlHorizontalOffsetPercentage: CGFloat = 0.10
        static let verticalControlPercentage: CGFloat = 0.40
    }
    
    func path(in rect: CGRect) -> Path {
        let topLeft = CGPoint(
            x: rect.width/2.0 - (rect.width * SquiggleRatios.widthPercentage/2.0),
            y: rect.height * SquiggleRatios.offsetPercentage
        )
        
        let bottomLeft = CGPoint(
            x: rect.width/2.0 - (rect.width * SquiggleRatios.widthPercentage/2.0),
            y: rect.height - (rect.height * SquiggleRatios.offsetPercentage)
        )
        
        let controlLeftOne = CGPoint(
            x: (topLeft.x) + (rect.width * SquiggleRatios.controlHorizontalOffsetPercentage),
            y: rect.height * (SquiggleRatios.verticalControlPercentage)
        )
        
        let controlLeftTwo = CGPoint(
            x: (topLeft.x) - (rect.width * SquiggleRatios.controlHorizontalOffsetPercentage),
            y: rect.height - (rect.height * SquiggleRatios.verticalControlPercentage)
        )
        
        let topRight = CGPoint(
            x: rect.width/2.0 + (rect.width * SquiggleRatios.widthPercentage/2.0),
            y: rect.height * SquiggleRatios.offsetPercentage
        )
        
        let bottomRight = CGPoint(
            x: rect.width/2.0 + (rect.width * SquiggleRatios.widthPercentage/2.0),
            y: rect.height - (rect.height * SquiggleRatios.offsetPercentage)
        )
        
        let controlRightOne = CGPoint(
            x: controlLeftTwo.x + (rect.width * SquiggleRatios.widthPercentage),
            y: controlLeftTwo.y
        )
        
        let controlRightTwo = CGPoint(
            x: controlLeftOne.x + (rect.width * SquiggleRatios.widthPercentage),
            y: controlLeftOne.y
        )
        
        let topCenter = CGPoint(
            x: (topLeft.x + topRight.x)/2.0,
            y: topLeft.y
        )
        
        let bottomCenter = CGPoint(
            x: (bottomLeft.x + bottomRight.x)/2.0,
            y: bottomLeft.y
        )
        
        let arcRadius = CGFloat(
            (topRight.x - topLeft.x)/2.0
        )
        
        var squiggle = Path()
        
        squiggle.move(to: bottomLeft)
        squiggle.addCurve(to: topLeft,
                          control1: controlLeftOne,
                          control2: controlLeftTwo)
        
        squiggle.addArc(
            center: topCenter,
            radius: arcRadius,
            startAngle: Angle.radians(Double.pi),
            endAngle: Angle.radians(0.0),
            clockwise: false
        )
        
        squiggle.move(to: topRight)
        squiggle.addCurve(
            to: bottomRight,
            control1: controlRightOne,
            control2: controlRightTwo
        )
        
        squiggle.addArc(
            center: bottomCenter,
            radius: arcRadius,
            startAngle: Angle.radians(0.0),
            endAngle: Angle.radians(Double.pi),
            clockwise: false
        )
        
        return squiggle
    }
}

struct Oval: Shape {
    var spacing: CGFloat = 3.5
    
    func path(in rect: CGRect) -> Path {
        return Capsule().path(in: rect)
    }
}

/*-----------------------------------------------------------------------------------------------------------------------------------------------------*/

struct CardView: View {
    let card: SetGame.Card
    
    private let cornerRadius: CGFloat = 10
    private let edgeLineWidth: CGFloat = 2
    
    var body: some View {
        GeometryReader { (proxy) in
            self.body(for: proxy.size, proxy: proxy)
        }
    }
    
    func body(for size: CGSize, proxy:GeometryProxy) -> some View {
        let factor = min(max(0.1, max(size.width, size.height) / 145), 1)
        let symbolCount = card.number.rawValue
        return ZStack {
            
            // Background with shadow
            Group {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(Color.white)
                    .shadow(color: card.isMatched ? Color.yellow : Color.black, radius: card.isSelected ? 10 * factor : 0)
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(lineWidth: edgeLineWidth)
                
                VStack {
                    ForEach(0..<symbolCount) { _ in
                        self.symbol
                    }
                }
                .padding((4.0 - CGFloat(symbolCount)) * 4)
            }
        }
        .foregroundColor(cardColor)
        .aspectRatio(1, contentMode: .fit)
        .padding(4 * factor)
        .scaleEffect(card.isSelected ? 1.2 : 1)
    }
    
    var symbol: some View {
        Group {
            if card.shape == .diamond {
                if card.shading == .outlined {
                    Diamond()
                        .stroke(lineWidth: 2)
                }
                else if card.shading == .stripped {
                    StripView(shape: Diamond(), color: cardColor)
                } else {
                    Diamond()
                        .fill()
                }
            }
            if card.shape == .oval {
                if card.shading == .outlined {
                    Oval()
                        .stroke(lineWidth: 2)
                }else if card.shading == .stripped {
                    StripView(shape: Oval(), color: cardColor)
                }
                else {
                    Oval()
                        .fill()
                }
            }
            if card.shape == .squiggle {
                if card.shading == .outlined {
                    Squiggle()
                        .stroke(lineWidth: 2)
                }else if card.shading == .stripped {
                    StripView(shape: Squiggle(), color: cardColor)
                }
                else {
                    Squiggle()
                        .fill()
                }
            }
        }
    }
    
/*-----------------------------------------------------------------------------------------------------------------------------------------------------*/
    
    var cardColor: Color {
        switch card.color {
        case .red:
            return Color.red
        case .purple:
            return Color.purple
        case .green:
            return Color.green
        }
    }
    
    var opacity: Double {
        card.shading == .stripped ? 0.3 : 1.0
    }
    
    private func colorForPath(for card: SetGame.Card) -> Color {
        switch card.color {
        case SetGame.Color.green:
            return .green
        case SetGame.Color.purple:
            return .purple
        case SetGame.Color.red:
            return .red
        }
    }
    
    private func colorForFill(for card: SetGame.Card) -> Color {
        switch card.shading {
        case .outlined:
            return .clear
        case .stripped:
            return .clear
        case .solid:
            return colorForPath(for: card)
        }
    }
}

//The view for our stripes
struct StripView<T>: View where T: Shape {
    let shape: T
    let numberOfStrips: Int = 10
    let lineWidth: CGFloat = 1
    let borderLineWidth: CGFloat = 1
    var color : Color = .red
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<numberOfStrips) { number in
                Color.white
                color.frame(width: lineWidth)
                if number == numberOfStrips - 1 {
                    Color.white
                }
            }
        }
        //Mask the shapes so that masks display inside of the shapes
        .mask(shape)
        .overlay(shape.stroke(color, lineWidth: borderLineWidth))
    }
}

struct CardView_Previews: PreviewProvider {
    static let game = SetGameViewModel()
    static var previews: some View {
        game.drawCard(1)
        let card = game.cards.first!
        
        return CardView(card: card)
            .previewLayout(.fixed(width: 200, height: 200))
    }
}


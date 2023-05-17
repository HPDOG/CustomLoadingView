//
//  WaveView.swift
//  CustomLoadingView
//
//  Created by HPDOG on 2022/8/23.
//

import UIKit
import QuartzCore

class WaveView: UIView {
    var waveHeight: CGFloat = 7
    var waveRate: CGFloat = 0.01
    var waveSpeed: CGFloat = 0.05
    var realWaveColor: UIColor = UIColor.init(red: 55 / 255.0, green: 153 / 255.0, blue: 249 / 255.0, alpha: 0)
    var waveOnBottom = true
    var closure: ((_ centerY: CGFloat)->())?
    var bottomViewTop: CGFloat = 0.0
    private var uiArrTemp = [UIView]()
    private var displayLink: CADisplayLink?
    private var realWaveLayer: CAShapeLayer?
    private var offset: CGFloat = 0
    private var displayLinkFramesPerSecond:Int = 60
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initWaveParame()
    }
    
    init(frame: CGRect, uiArr: [UIView]) {
        super.init(frame: frame)
        uiArrTemp = uiArr
        initWaveParame()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initWaveParame()
    }
    
    private func initWaveParame() {
        realWaveLayer = CAShapeLayer()
        var frame = bounds
        realWaveLayer?.frame.origin.y = frame.size.height - waveHeight
        frame.size.height = waveHeight
        realWaveLayer?.frame = frame
        layer.addSublayer(realWaveLayer!)
    }
    
    func startWave(framesPerSecond:Int=60) {
        if displayLink == nil {
            let displayLinkOfSelect : Selector
            displayLinkOfSelect = #selector(self.wave)
            displayLinkFramesPerSecond = framesPerSecond
            displayLink = CADisplayLink(target: self, selector: displayLinkOfSelect)
            displayLink!.add(to: RunLoop.current, forMode: RunLoop.Mode.common)
            displayLink?.preferredFramesPerSecond = displayLinkFramesPerSecond
        }
    }
    
    func endWave() {
        if displayLink != nil {
            displayLink!.invalidate()
            displayLink = nil
        }
    }
    
    @objc func wave() {
        self.offset += self.waveSpeed
        let startY = self.waveOnBottom ? 0 : self.frame.size.height
        
        let realPath = UIBezierPath()
        realPath.move(to: CGPoint(x: 0, y: startY))
        
        var x = CGFloat(0)
        var y = CGFloat(0)
        let uiArrTemp1 = NSMutableArray()
        
        while x <= (self.bounds.size.width) {
            y = self.waveHeight * sin(x * self.waveRate + self.offset)
            let realY = y + (self.waveOnBottom ? (self.frame.size.height) : 0)
            realPath.addLine(to: CGPoint(x: x, y: realY))
            
            for i in 0..<self.uiArrTemp.count {
                let view:UIView=(self.uiArrTemp[i])
                if ((view.center.x+0.5 > x)&&(view.center.x-0.5 <= x)) {
                    uiArrTemp1.add(realY)
                }
            }
            x += 1
        }
        
        let midX = (self.bounds.size.width) * 0.5
        let midY = self.waveHeight * sin(midX * self.waveRate + self.offset)
        
        if let closureBack = self.closure {
            closureBack(midY)
        }
        
        realPath.addLine(to: CGPoint(x: self.frame.size.width, y: startY))
        
        realPath.close()
        self.realWaveLayer?.path = realPath.cgPath
        self.realWaveLayer?.fillColor = self.realWaveColor.cgColor
        for i in 0..<self.uiArrTemp.count {
            let view:UIView=self.uiArrTemp[i]
            view.frame.origin.y = (self.bottomViewTop + (uiArrTemp1[i] as! CGFloat))
        }
    }
}


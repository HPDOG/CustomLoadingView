//
//  CustomLoadingView.swift
//  CustomLoadingView
//
//  Created by HPDOG on 2022/8/23.
//

import UIKit

public let RGBAlpa:((Float,Float,Float,Float) -> UIColor ) = { (r: Float, g: Float , b: Float , a: Float ) -> UIColor in
    return UIColor.init(red: CGFloat(CGFloat(r)/255.0), green: CGFloat(CGFloat(g)/255.0), blue: CGFloat(CGFloat(b)/255.0), alpha: CGFloat(a))
}

class CustomLoadingView: UIView {
    private let customLoadingBG = UIImageView()
    private let wordArr = ["loading1","loading2","loading3","loading4","loading5","loading6","loading7","loading8","loading9","loading10"]
    private var waveView : WaveView?
    private let uiArr = NSMutableArray()
    private var bottomViewTop = CGFloat()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        DispatchQueue.main.async {
            [weak self] in
            let maskView = UIApplication.shared.keyWindow!
            maskView.addSubview(self!)
            self?.backgroundColor = RGBAlpa(0,0,0,0.5)
            self?.addSubview(self!.customLoadingBG)
            self?.customLoadingBG.snp.makeConstraints { (make) in
                make.centerX.equalTo((self?.snp.centerX)!)
                make.centerY.equalTo((self?.snp.centerY)!)
                make.height.equalToSuperview().multipliedBy(0.4)
                make.width.equalTo((self?.customLoadingBG.snp.height)!)
            }
            self?.customLoadingBG.layoutIfNeeded()
            self?.loadingViewCreate()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func loadingViewCreate(){
        var uitemp = UIImageView()
        
        for i in 0..<wordArr.count {
            let bottom2 = UIImageView()
            bottom2.contentMode = .scaleAspectFit
            bottom2.image = UIImage(named: wordArr[i])
            customLoadingBG.addSubview(bottom2)
            bottom2.snp.makeConstraints { (make) in
                make.top.equalTo(customLoadingBG.snp.top)
                if(i==0){
                    make.left.equalTo(customLoadingBG)
                }else{
                    make.left.equalTo(uitemp.snp.right)
                }
                make.width.equalTo(customLoadingBG.snp.width).multipliedBy(0.1)
                make.height.equalTo(bottom2.snp.width).multipliedBy(2.1)
            }
            bottom2.layoutIfNeeded()
            uitemp = bottom2
            bottomViewTop = -(bottom2.frame.size.height/2)
            uiArr.add(bottom2)
        }
        
        waveView = WaveView.init(frame: customLoadingBG.bounds, uiArr: uiArr as! [UIView])
        customLoadingBG.addSubview(waveView!)
        waveView!.bottomViewTop = bottomViewTop
        waveView!.waveSpeed = 0.1
        waveView!.waveHeight = 7
        waveView!.waveRate = 0.03
        waveView!.startWave()
        
    }
}




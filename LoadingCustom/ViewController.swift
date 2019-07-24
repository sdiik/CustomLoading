//
//  ViewController.swift
//  LoadingCustom
//
//  Created by ahmad shiddiq on 23/07/19.
//  Copyright © 2019 ahmad shiddiq. All rights reserved.
//

import UIKit

class ViewController: UIViewController, URLSessionDownloadDelegate {
    var shapeLayer = CAShapeLayer()
    var pulsatngLayer: CAShapeLayer!
    
    let urlString = "https://firebasestorage.googleapis.com/v0/b/firestorechat-e64ac.appspot.com/o/intermediate_training_rec.mp4?alt=media&token=e20261d0-7219-49d2-b32d-367e1606500c"
    
    let percentageLabel: UILabel = {
        let label = UILabel()
        label.text = "Start"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 32)
        label.textColor = .white
        return label
    }()
    
    private func circleshapeLayout(strokeColor: UIColor, fillColor: UIColor)->CAShapeLayer{
        let circle = CAShapeLayer()
        let circularPath = UIBezierPath(arcCenter: .zero, radius: 100, startAngle: 0 , endAngle: 2 * CGFloat.pi, clockwise: true)
        circle.path = circularPath.cgPath
        circle.strokeColor = strokeColor.cgColor
        circle.lineWidth = 20
        circle.fillColor = fillColor.cgColor
        circle.lineCap = .round
        circle.position = view.center
        return circle
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    private func setupNotificationObsevers(){
        NotificationCenter.default.addObserver(self, selector: #selector(handleEnterForeground), name: .NSExtensionHostWillEnterForeground, object: nil)
    }
    
    @objc func handleEnterForeground(){
        animatePulsatingLayer()
    }
 
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.backgroundColor
        setupNotificationObsevers()
        drawCirlceBig()
        
        
        let delayInSec = 1.0
        DispatchQueue.main.asyncAfter(deadline: .now() + delayInSec) {
            // code here
            print("It works")
        }
    }
    
    func drawCirlceBig(){ 
        pulsatngLayer = circleshapeLayout(strokeColor: .clear, fillColor: .pulsatingFillColor)
        view.layer.addSublayer(pulsatngLayer)
        
        let trackLayer = circleshapeLayout(strokeColor: .trackStrokeColor, fillColor: .backgroundColor)
        view.layer.addSublayer(trackLayer)
        
        animatePulsatingLayer()
        
        shapeLayer = circleshapeLayout(strokeColor: .outlineStrokeColor, fillColor: .clear)
        shapeLayer.strokeEnd = 0
        shapeLayer.transform = CATransform3DMakeRotation(-CGFloat.pi/2, 0, 0, 1)
        view.layer.addSublayer(shapeLayer)
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewTapGesture)))
        
        view.addSubview(percentageLabel)
        percentageLabel.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        percentageLabel.center = view.center
    }
    
    private func animatePulsatingLayer(){
        let animated = CABasicAnimation(keyPath: "transform.scale")
        animated.toValue = 1.3
        animated.duration = 0.8
        animated.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        animated.autoreverses = true
        animated.repeatCount  = Float.infinity
        pulsatngLayer.add(animated, forKey: "pulsing")
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        print(totalBytesWritten, totalBytesExpectedToWrite)
        
        let percentage = CGFloat(totalBytesWritten) / CGFloat(totalBytesExpectedToWrite)
        
        DispatchQueue.main.async {
            self.percentageLabel.text = "\(Int(percentage*100))%"
            self.shapeLayer.strokeEnd = percentage
        }
        
        print(percentage)
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print("finished downloading file")
    }
 
    private func beginDownloadingFile(){
        shapeLayer.strokeEnd = 0
        
        let configuration = URLSessionConfiguration.default
        let operationQueue = OperationQueue()
        let urlSession = URLSession(configuration: configuration, delegate: self, delegateQueue: operationQueue)
        
        guard let url = URL(string: urlString) else { return }
        let downloadTask = urlSession.downloadTask(with: url)
        downloadTask.resume()
        
    }
    
    fileprivate func extractedFunc() {
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.toValue = 1
        basicAnimation.duration = 2
        basicAnimation.fillMode = .forwards
        basicAnimation.isRemovedOnCompletion = false
        shapeLayer.add(basicAnimation, forKey: "urSoBasic")
    }
    
    @objc private
    func viewTapGesture(){
        beginDownloadingFile()
        //extractedFunc()
    }
}

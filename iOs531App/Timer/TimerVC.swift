//
//  TimerVCViewController.swift
//  iOs531App
//
//  Created by Kevin Li on 9/29/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import UIKit

extension TimeInterval {
    var time: String {
        return String(format:"%02d:%02d", Int(self/60),  Int(ceil(truncatingRemainder(dividingBy: 60))) )
    }
}

extension Int {
    var degreesToRadians : CGFloat {
        return CGFloat(self) * .pi / 180
    }
}


class TimerVC: UIViewController {

    //MARK: Data
    var shapeLayer: CAShapeLayer!
    var pulsatingLayer: CAShapeLayer!
    var timeLeft: TimeInterval!
    var timer = Timer()
    var endTime: Date?
    var finishedSet: String!
    var nextSet: String!
    
    let timerLabel: UILabel = {
        let label = UILabel()
        label.text = "Start"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 32)
        label.textColor = .white
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("View did load called for TimerVC")
        
        setupNotificationObservers()
        
        view.backgroundColor = UIColor.backgroundColor
        
        setUpCircleLayers()
        
        addTimeLabel()
        addFinishedSetLabel()
        addNextSetLabel()
        
//        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
        
        print("Attempting to animate timer stroke")
        animateTimer()
        //Defines future end time by adding timeLeft to date
        endTime = Date().addingTimeInterval(timeLeft)
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        
    }
    
    private func addFinishedSetLabel(){
        let label = UILabel()
        
        
    }
    
    private func addNextSetLabel(){
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK: Private functions
    private func setUpCircleLayers(){
        //Creates pulsating layer
        pulsatingLayer = createCircleShapeLayer(strokeColor: .clear, fillColor: UIColor.pulsatingFillColor)
        view.layer.addSublayer(pulsatingLayer)
        //Initiates the pulsing animation
        animatePulsatingLayer()
        
        //Creates a track layer for the progress bar on top
        let trackLayer = createCircleShapeLayer(strokeColor: .trackStrokeColor, fillColor: .backgroundColor)
        view.layer.addSublayer(trackLayer)
        
        //Creates a shape layer that will go on the top of the track and fill it out as the timer progresses
        shapeLayer = createCircleShapeLayer(strokeColor: .outlineStrokeColor, fillColor: .clear)
        /*Since I want the circle to start its stroke at the top, and right now its starting at the horizontal axis and going clockwise, I
        rotate the shapeLayer 90 degrees left about the z-axis, which is pointing inwards toward the screen.
        */
        shapeLayer.transform = CATransform3DMakeRotation(-CGFloat.pi/2, 0, 0, 1)
        shapeLayer.strokeEnd = 0
        view.layer.addSublayer(shapeLayer)
    }
    
    private func createCircleShapeLayer(strokeColor: UIColor, fillColor: UIColor) -> CAShapeLayer{
        /*Specifies the direction in which the circle is going to be filled, starting from the horizontal. This circle is entirely filled
         since it goes from 0 to 2pi. The circle starts at the upper left corner of the screen initially since I specified that its center
         is 0. This is necessary since there is a bug with starting the circle at the center which causes its progress at 50% to be skewed
         greater than 50%.
        */
        let circularPath = UIBezierPath(arcCenter: .zero, radius: 100, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
        
        let layer = CAShapeLayer()
        layer.path = circularPath.cgPath
        
        layer.strokeColor = strokeColor.cgColor
        layer.lineWidth = 20
        layer.fillColor = fillColor.cgColor
        layer.lineCap = CAShapeLayerLineCap.round
        layer.position = view.center
        return layer
    }
    
    private func addTimeLabel() {
        //I ignore the x and y values for position here since I'm going to center it anyway. Height and width are 100
        timerLabel.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        //Label is centered
        timerLabel.center = view.center
        //Adds the timerLabel to the view.
        view.addSubview(timerLabel)
    }
    
    private func animateTimer() {
        //Animate the stroke
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        //Specifies the value to which the strokeEnd of the shape layer should animate to
        basicAnimation.toValue = 1
        //Specifies how long the animation should take in seconds
        basicAnimation.duration = timeLeft
        //These 2 lines tell the animation to not remove the stroke at completion; by default, it does.
        basicAnimation.fillMode = CAMediaTimingFillMode.forwards
        basicAnimation.isRemovedOnCompletion = false
        
        shapeLayer.add(basicAnimation, forKey: "timerAnimation")
    }
    
    //MARK: Objc methods
    @objc private func handleTap(){
        print("Attempting to animate timer stroke")
        animateTimer()
        //Defines future end time by adding timeLeft to date
        endTime = Date().addingTimeInterval(timeLeft)
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    
    @objc func updateTime(){
        if timeLeft > 0{
            timeLeft = endTime?.timeIntervalSinceNow ?? 0
            timerLabel.text = timeLeft.time
        }
    }
    
    @objc func handleForeground(){
        print("Entering foreground")
        animatePulsatingLayer()
    }
    
    private func animatePulsatingLayer(){
        print("Animating pulsating layer")
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.toValue = 1.3
        animation.duration = 0.8
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        animation.autoreverses = true
        animation.repeatCount = Float.infinity
        
        pulsatingLayer.add(animation, forKey: "pulsing")
    }
    

    private func setupNotificationObservers(){
        /*What's happening here is first, I begin observing the app for a certain notification, in this case, the foreground. When something happens to
         the app, like data coming in or task completion, it sends a notification to the notification center. In this case, I am looking for the
         foreground notification. The notification center then calls the selector on this view controller as a way of telling this controller that a
         notification it observes has been posted.
         */
        NotificationCenter.default.addObserver(self, selector: #selector(handleForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        
    }
    
}

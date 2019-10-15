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
    var timeLeft: Int!
    var timer : Timer!
    var finishedSet: String!
    var nextSet: String!
    var selectedTimer: Int!
    var startTime: Int!
    
    let timerLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 32)
        label.textColor = .white
        return label
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: 0, y: 0, width: 300, height: 50)
        label.text = "Rest Timer"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 32)
        label.textColor = .white
        return label
    }()
    
    let finishedSetLabel: UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: 0, y: 0, width: 300, height: 50)
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .white
        return label
    }()
    
    let nextSetLabel: UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: 0, y: 0, width: 300, height: 50)
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .white
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("TimerVC is aware of viewdidload call")
        
        view.backgroundColor = UIColor.backgroundColor
        
        startTime = timeLeft
        
        setUpCircleLayers()
        
        addLabels()
        addButtons()
        
        log.info("Attempting to animate timer stroke")
        animateTimer()
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        
    }
    
    private func addLabels() {
        addTimeLabel()
        addTitleLabel()
        addFinishedSetLabel()
        addNextSetLabel()
    }
    
    private func addButtons(){
        addExitButton()
        addSubtractButton()
        addPlusButton()
    }
    
    private func addTitleLabel(){
        view.addSubview(titleLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
        
    }
    
    private func addFinishedSetLabel(){
        finishedSetLabel.text = finishedSet
        
        view.addSubview(finishedSetLabel)
        
        finishedSetLabel.translatesAutoresizingMaskIntoConstraints = false
        finishedSetLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        finishedSetLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8).isActive = true
        
    }
    
    private func addNextSetLabel(){
        nextSetLabel.text = nextSet
        
        view.addSubview(nextSetLabel)
        
        nextSetLabel.translatesAutoresizingMaskIntoConstraints = false
        nextSetLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        nextSetLabel.topAnchor.constraint(equalTo: finishedSetLabel.bottomAnchor, constant: 8).isActive = true
    }
    
    private func addExitButton() {
        let exitButton = UIButton()
        exitButton.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        exitButton.setImage(UIImage(named: "Dismiss"), for: .normal)
        exitButton.addTarget(self, action: #selector(dismissTimer), for: .touchUpInside)
        
        view.addSubview(exitButton)
        exitButton.translatesAutoresizingMaskIntoConstraints = false
        exitButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        exitButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 8).isActive = true
    }
    
    private func addSubtractButton(){
        let subtractButton = UIButton()
        subtractButton.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        subtractButton.setTitle("-10 seconds", for: .normal)
        subtractButton.addTarget(self, action: #selector(subtractTime), for: .touchUpInside)
        
        view.addSubview(subtractButton)
        subtractButton.translatesAutoresizingMaskIntoConstraints = false
        subtractButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8).isActive = true
        subtractButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -32).isActive = true
        
    }
    
    private func addPlusButton(){
        let plusButton = UIButton()
        plusButton.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        plusButton.setTitle("+10 seconds", for: .normal)
        plusButton.addTarget(self, action: #selector(addTime), for: .touchUpInside)
        
        
        view.addSubview(plusButton)
        plusButton.translatesAutoresizingMaskIntoConstraints = false
        plusButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 8).isActive = true
        plusButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -32).isActive = true
        
    }
    
    private func addTimeLabel() {
        //I ignore the x and y values for position here since I'm going to center it anyway. Height and width are 100
        timerLabel.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        //Label is centered
        timerLabel.center = view.center
        //Since the timer takes 1 second to start, I want to make sure there's text in the label for that second
        timerLabel.text = formatTime()
        //Adds the timerLabel to the view.
        view.addSubview(timerLabel)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK: Private functions
    private func setUpCircleLayers(){
        
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
    
    private func animateTimer() {
        //Animate the stroke
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        //Specifies the value to which the strokeEnd of the shape layer should animate to
        basicAnimation.toValue = 1
        //Specifies how long the animation should take in seconds
        basicAnimation.duration = Double(timeLeft)
        //These 2 lines tell the animation to not remove the stroke at completion; by default, it does.
        basicAnimation.fillMode = CAMediaTimingFillMode.forwards
        basicAnimation.isRemovedOnCompletion = false
        
        shapeLayer.add(basicAnimation, forKey: "timerAnimation")
    }
    
    private func formatTime() -> String{
        let seconds = timeLeft % 60
        let minutes = timeLeft / 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    //MARK: Objc methods
    @objc private func dismissTimer(){
        timer.invalidate()
        dismiss(animated: true, completion: nil)
    }
    
    @objc func updateTime(){
        if timeLeft > 0{
            timeLeft -= 1
            timerLabel.text = formatTime()
        } else {
            dismissTimer()
        }
    }
    
    @objc func addTime(){
        //Update Time and UI
        print("Adding 10 seconds to time")
        timeLeft+=10
        timerLabel.text = formatTime()
        
        //Update the timer stroke
        animateTimer()
        updateStartTime(increment: true)
    }
    
    @objc func subtractTime(){
        //Update time and UI
        print("Subtracting 10 seconds to time")
        timeLeft-=10
        if timeLeft > 0 {
            timerLabel.text = formatTime()
        } else {
            timerLabel.text = "00:00"
        }
        
        animateTimer()
        updateStartTime(increment: false)
    }
    
    private func updateStartTime(increment: Bool){
        if increment {
            startTime+=10
        } else {
            startTime-=10
        }
        UserDefaults.standard.set(startTime, forKey: SavedKeys.getTimeLeftKeys(timer: selectedTimer))
    }
    
}

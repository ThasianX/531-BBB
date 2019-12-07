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
    //For drawing the progress indicator
    var shapeLayer: CAShapeLayer!
    var pulsatingLayer: CAShapeLayer!
    
    //For tracking time
    var timeLeft: TimeInterval!
    var timer : Timer!
    var endTime: Date?
    
    //For UI and data persistence purposes
    var finishedSet: String!
    var nextSet: String!
    var selectedTimer: Int!
    var startTime: Double!
    
    //Notification purposes
    let manager = LocalNotificationManager()
    
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
        label.numberOfLines = 0
        return label
    }()
    
    let nextSetLabel: UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: 0, y: 0, width: 300, height: 50)
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.backgroundColor
        
        setUpCircleLayers()
        
        addLabels()
        addButtons()
        
        animateTimer()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleState), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleState), name: UIApplication.didBecomeActiveNotification, object: nil)
        
        endTime = Date().addingTimeInterval(timeLeft)
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }

    @objc func handleState(notification: NSNotification){
        if notification.name == UIApplication.didEnterBackgroundNotification {
            timer.invalidate()
            scheduleNotification()
        } else if notification.name == UIApplication.didBecomeActiveNotification {
            timer.invalidate()
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
            manager.notifications.removeAll()
        }
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
        finishedSetLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16).isActive = true
        
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
        exitButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    private func addSubtractButton(){
        let image = UIImage(named: "SubtractTime")
        let subtractButton = UIButton(type: .custom)
        subtractButton.setImage(image, for: .normal)
        subtractButton.addTarget(self, action: #selector(subtractTime), for: .touchUpInside)
        
        view.addSubview(subtractButton)
        subtractButton.translatesAutoresizingMaskIntoConstraints = false
        subtractButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 32).isActive = true
        subtractButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
    }
    
    private func addPlusButton(){
        let image = UIImage(named: "AddTime")
        let plusButton = UIButton(type: .custom)
        plusButton.setImage(image, for: .normal)
        plusButton.addTarget(self, action: #selector(addTime), for: .touchUpInside)
        
        
        view.addSubview(plusButton)
        plusButton.translatesAutoresizingMaskIntoConstraints = false
        plusButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -32).isActive = true
        plusButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
    }
    
    private func addTimeLabel() {
        //I ignore the x and y values for position here since I'm going to center it anyway. Height and width are 100
        timerLabel.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        //Label is centered
        timerLabel.center = view.center
        //Since the timer takes 1 second to start, I want to make sure there's text in the label for that second
        timerLabel.text = timeLeft.time
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
    
    //MARK: Objc methods
    @objc private func dismissTimer(){
        timer.invalidate();
        
        manager.removeAllNotifications()
        dismiss(animated: true, completion: nil)
    }
    
    @objc func updateTime(){
        timeLeft = endTime?.timeIntervalSinceNow
        log.info("When called: \(timeLeft!)")
        if timeLeft > 0 {
            timerLabel.text = timeLeft.time
        } else {
            timerLabel.text = "00:00"
            dismissTimer()
        }
    }
    
    
    @objc func addTime(){
        log.info("Adding 10 seconds to time for timer \(selectedTimer!)")
        updateStartTime(increment: true)
        updateTime()
       
        animateTimer()
    }
    
    @objc func subtractTime(){
        log.info("Subtracting 10 seconds to time for timer \(selectedTimer!)")
        updateStartTime(increment: false)
        updateTime()
        
        animateTimer()
    }
    
    private func updateStartTime(increment: Bool){
        if increment {
            timeLeft += 10
            endTime! += 10
            startTime += 10
        } else {
            timeLeft-=10
            endTime! -= 10
            startTime-=10
        }
        UserDefaults.standard.set(startTime, forKey: SavedKeys.getTimeLeftKeys(timer: selectedTimer))
    }
    
    private func scheduleNotification(){
        manager.notifications.removeAll()
        manager.notifications.append(Notification(id: "reminder-timer-\(selectedTimer!)", title: "Break is over. Begin next set.", dateTime: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: Date(timeIntervalSinceNow: timeLeft))))
        manager.schedule()
    }
    
}

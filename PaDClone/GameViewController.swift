//
//  GameViewController.swift
//  PazuDora Clone
//
//  Created by Vivian Lee on 1/14/17.
//  Copyright (c) 2017 Vivian Lee. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {
    // properties
    var scene: GameScene!
    var level: Level!
    
    func beginGame() {
        shuffle()
    }
    
    func shuffle() {
        let newOrbs = level.shuffle()
        scene.addSprites(for: newOrbs)
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return .AllButUpsideDown
        } else {
            return .All
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure the view.
        let skView = view as! SKView
        //skView.isMultipleTouchEnabled = false
        
        // Create and configure the scene.
        scene = GameScene(size: skView.bounds.size)
        //scene.scaleMode = .aspectFill
        
        level = Level()
        scene.level = level
        
        // Present the scene.
        skView.presentScene(scene)
        
        beginGame()
        
    }
    
}

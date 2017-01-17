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
    
    override var shouldAutorotate : Bool {
        return true
    }

    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden : Bool {
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
        scene.addTiles()
        
        
        scene.swipeHandler = handleSwipe
        // Present the scene.
        skView.presentScene(scene)
        
        beginGame()
        
    }
    
    func handleSwipe(_ swap: Swap) {
        view.isUserInteractionEnabled = false
        
        level.performSwap(swap)
        
        scene.animate(swap) {
            self.view.isUserInteractionEnabled = true
        }
    }
    
}

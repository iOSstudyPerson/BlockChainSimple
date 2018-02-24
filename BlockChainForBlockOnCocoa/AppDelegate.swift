//
//  AppDelegate.swift
//  BlockChainForBlockOnCocoa
//
//  Created by 邓兴 on 2018/2/5.
//  Copyright © 2018年 邓兴. All rights reserved.
//

import Cocoa
import CryptoTokenKit

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!


    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        let genesisBlock = Block()
        
        var transaction = Transaction(from: "dx", to: "xzp", amount: 10)
        genesisBlock.addTransaction(transaction: transaction!)
        
        let blockChain = BlockChain(genesisBlock: genesisBlock)
        
        
        print("--------------------------------")
        
        transaction = Transaction(from: "swift", to: "objc", amount: 20)
        
        let block = blockChain.getNextBlock(transactions: [transaction!])
        blockChain.addBlock(block)
        print(blockChain.blocks.count)
        
    }

    func applicationWillTerminate(_ aNotification: Notification) {
    }


}



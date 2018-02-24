//
//  Transaction.swift
//  BlockChainForBlockOnCocoa
//
//  Created by 邓兴 on 2018/2/5.
//  Copyright © 2018年 邓兴. All rights reserved.
//

import Foundation
import Cocoa

/**
 *  区块链中的交易内容
 *
 *  Codable 数据属于json格式的, Codable 表示可解析
 *  @param from 交易的甲方
 *  @param to   交易的乙方
 *  @param amount 交易的数值内容
 */
class Transaction: Codable {
    var from : String!
    var to : String!
    var amount : Double
    
    init?(from : String?, to : String?, amount : Double) {
        guard from != nil && to != nil else {
            
            return nil;
        }
        self.from = from
        self.to = to
        self.amount = amount;
    }
}

/**
 *  账本的创建
 *  @param index 在区块链中第几位账本
 *  @param previousHash 当前账本的上一个账本的哈希值
 *  @param hash 该账本的哈希值
 *  @param nonce 递增数字
 *
 *  @warning hash = SHA-256 (最后一个区块的Hash + 新区块的基本信息 + 交易记录信息 + 随机数)
 */
class Block: Codable {
    var index : Int = 0
    var previousHash : String = ""
    var hash: String!
    var noice: Int
    
    private (set) var transactions: [Transaction] = [Transaction]()
    
    var key: String {
        
        get {
            
            let transactionData = try!JSONEncoder().encode(self.transactions)
            let transactionJSONString = String(data: transactionData, encoding: .utf8)
            
            return String(self.index) + String(previousHash) + String(self.noice) + transactionJSONString!
        }
    }
    
    func addTransaction(transaction: Transaction) {
        self.transactions.append(transaction) // 把后来增加的交易内容, 放到交易数组里面去
    }
    
    init() {
        self.noice = 0
    }
}

/**
 *  区块链的创建
 */
class BlockChain: Codable {
    private (set) var blocks : [Block] = [Block]()
    
    init(genesisBlock : Block) {
        addBlock(genesisBlock) // 创建爱你第一本账本
    }
    
    func addBlock(_ block : Block) -> Void {
        
        if self.blocks.isEmpty {
            block.previousHash = "0000000000" // 第一本账本的hash是 0000000000
            block.hash = generateHash(for: block) // 后来的账本生成hash
        }
        
        self.blocks.append(block)
    }
    
    // 创建后来账本的 hash
    func generateHash(for block: Block) -> String {
        
        var hash = block.key.sha1()
        
        // 近来的每一本账本的hash进行生成
        while !hash.hasPrefix("00") {
            
            block.noice += 1
            hash = block.key.sha1()
//            print(hash)
        }
        
        return hash
    }
    
    func getNextBlock(transactions : [Transaction]) -> Block {
        
        let block = Block()
        
        transactions.forEach { (transaction) in
            
            block.addTransaction(transaction: transaction)
        }
        
        let previousBlock = getPreviousBlock()
        block.index = self.blocks.count
        block.previousHash = previousBlock.hash
        block.hash = generateHash(for: block)
        return block
    }
    
    private func getPreviousBlock() -> Block {
        return self.blocks[self.blocks.count - 1]
    }
}

// sha1 算法, 将 NSString 转换成 sha1
extension String {
    
    func sha1() -> String {
        
        let task = Process()
        task.launchPath = "/usr/bin/shasum"
        task.arguments = []
        
        let inputPipe = Pipe()
        
        inputPipe.fileHandleForWriting.write(self.data(using: .utf8, allowLossyConversion: true)!)
        
        inputPipe.fileHandleForWriting.closeFile()
        
        let outputPipe = Pipe()
        
        task.standardOutput = outputPipe
        task.standardInput = inputPipe
        task.launch()
        
        let data = outputPipe.fileHandleForReading.readDataToEndOfFile()
        let hash = String(data: data, encoding: .utf8)
        
        return (hash?.replacingOccurrences(of: "  -\n", with: ""))!
    }
}

/**
 *  区块链的优缺点
 *  优点:
    1. 去中心化
    2. 不可修改
 *  缺点:
    1. 资源的消耗特别大
    2. 网路延迟
 *
 *  金融, 教学资源, 基因数据, 游戏
 */






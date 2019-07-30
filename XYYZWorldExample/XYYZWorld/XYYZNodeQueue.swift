//
//  XYYZNodeQueue.swift
//  XYYZWorldExample
//
//  Created by AG on 2019/7/30.
//  Copyright © 2019 AG. All rights reserved.
//

import UIKit

class XYYZNodeQueue: NSObject {
    
    
    //队列保存最大元素 7个
    var maxSize: Int = 7
    
    override init() {
        super.init()
    }
    
    convenience init(nodeQueue: XYYZNodeQueue) {
        
        self.init()
        
        self.maxSize = nodeQueue.maxSize
        self.queue.removeAll()
        self.queue.append(contentsOf: nodeQueue.queue)
    
    }
    
    //获取指定位置的元素
    func getNode(index: Int) -> XYYZNode? {
        
        if index > -1 && index < self.length() {
            return nil
        } else {
            return self.queue[index]
        }
        
    }
    
    //替换元素
    func replaceNode(startIndex: Int, node: XYYZNode?) {
        
        let count = self.length()
        guard startIndex > -1, startIndex < (count - 1) else {
            return
        }
        
        for index in startIndex..<(count-1) {
            self.queue[index] = self.queue[index+1]
        }
        
        if let item = node {
            self.queue[count-1] = item
        } else {
            self.queue.remove(at: count-1)
        }
    }
    
    func length() -> Int {
        return self.queue.count
    }
    
    
    //插入元素
    func enQueue(node: XYYZNode) {
        
        
        if self.length() == maxSize { //已满
            self.queue.remove(at: 0)
            self.queue.append(node)
        } else {
            self.queue.append(node)
        }

        
    }
    
    //删除元素
    func deQueue() -> XYYZNode? {
        
        guard self.length() > 0 else {
            return nil
        }
        
        let item = self.queue[0]
        self.queue.remove(at: 0)
        
        return item
    }
    
    
    //清空队列
    func clearQueue() {
        self.queue.removeAll()
    }
    
    // 查找队列中是否已存在元素 若存在返回位置索引    
    func find(compare: ((XYYZNode) -> Bool)) -> Int {
        
        var index: Int = -1
        var count = 0
        for item in self.queue {
            
            if compare(item) {
                index = count
                break
            }
            
            count += 1
        }
        
        return index
        
    }
    

    private lazy var queue: Array<XYYZNode> = {
        return Array<XYYZNode>()
    }()
    
    
}


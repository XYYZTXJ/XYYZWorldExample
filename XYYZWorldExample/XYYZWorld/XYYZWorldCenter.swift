//
//  XYYZWorldCenter.swift
//  XYYZWorldExample
//
//  Created by AG on 2019/7/30.
//  Copyright © 2019 AG. All rights reserved.
//

/**
 * 添加请求结点
 * 取消请求
 * 根据请求结点对象发出请求信息
 * 管理失败请求结点
 * 响应数据放入到操作对象中
 * 该类为单例类
 *
 * 支撑类为自选
 */

import UIKit
import Alamofire

class XYYZWorldConfiguration {
    //重复最大次数 默认3
    var repeatMax: Int = 3
    
    //网络连接异常
    var networkExcCode = [-1001, -1004, -1005, -1009]
    
    //未授权
    var unauthorizedCode = [403]
    
}


class XYYZWorldCenter: NSObject {
    
    
    override init() {
        super.init()
        
        //开启网络监听
        self.networkReachability?.startListening()
        
    }
    
    convenience init(configuration: XYYZWorldConfiguration) {
        self.init()
        self.configuration = configuration
    }

    
    public static let `default`: XYYZWorldCenter = {
        
        let configuration = XYYZWorldConfiguration()
        return XYYZWorldCenter(configuration: configuration)
    }()
    
    public var configuration: XYYZWorldConfiguration!
    
    //MARK : - TODO
    // 监听网络状态，三方
    lazy var networkReachability: NetworkReachabilityManager? = {
        
        let mananger = NetworkReachabilityManager()
        mananger?.listener = { (status) in
            
            switch status {
                
            case .unknown:// 未知不作处理
                break
                
            case .notReachable: //
                break
                
            case .reachable(.ethernetOrWiFi): //wifi
                self.onceAgainNetworkFaild()
                break
                
            case .reachable(.wwan): //移动网络
                self.onceAgainNetworkFaild()
                break
                
            }
            
        }
    
        return mananger
        
    }()
    
    private lazy var unauthorizedQueue: XYYZNodeQueue = {
        let _unauthorizedQueue  = XYYZNodeQueue()
        return _unauthorizedQueue
    }()
    
    private lazy var networkFaildQueue: XYYZNodeQueue = {
        
        let _networkFaildQueue = XYYZNodeQueue()
        return _networkFaildQueue
        
    }()
}

//和请求相关的
extension XYYZWorldCenter {
    
    func reuqest(node: XYYZNode) {
        
        switch node.requestType {
        case .get:
            self.requestOfGet(node: node)
            break
        case .post:
            self.requestOfGet(node: node)
            break
            
        }
        
    }
    
    //取消任务
    func cancelRequest(taskId: Int) {
        
        var index = self.unauthorizedQueue.find { (node) -> Bool in
            return node.taskId == taskId
        }
        self.unauthorizedQueue.replaceNode(startIndex: index, node: nil)
        
        index = self.networkFaildQueue.find(compare: { (node) -> Bool in
            return node.taskId == taskId
        })
        self.networkFaildQueue.replaceNode(startIndex: index, node: nil)
        
    }
    
    //MARK : - TODO
    // POST 这个方法的实现，需要通过第三方
    private func requestOfPost(node: XYYZNode) {
        guard let url = URL(string: node.URL) else {
            return
        }
    
        Alamofire.request(url, method: .post).responseData { (response) in
            
            guard case let .failure(error) = response.result else { return }
            
            self.handleError(error: error as NSError, node: node)
            
        }
    }
    
    //MARK : - TODO
    // Get 这个方法的实现，需要通过第三方
    private func requestOfGet(node: XYYZNode) {
        
        guard let url = URL(string: node.URL) else {
            return
        }
        
        Alamofire.request(url).responseData { (response) in
            
            guard case let .failure(error) = response.result else { return }
            
            self.handleError(error: error as NSError, node: node)
            
        }
        
    }
    
}

//处理失败的node
extension XYYZWorldCenter {
    
    //根据错误代码添加到不同的队列中
    private func handleError(error: NSError, node: XYYZNode) {
        
        if self.configuration.networkExcCode.contains(error.code) {
            self.addNetworkFaild(node: node)
        }
        
        if self.configuration.unauthorizedCode.contains(error.code) {
            self.addUnauthorized(node: node)
        }
        
    }
    
    //未授权的请求
    private func addUnauthorized(node: XYYZNode) {
        
        self.addQueue(node: node, queue: self.unauthorizedQueue)
        
    }
    //网络失败的请求
    private func addNetworkFaild(node: XYYZNode) {

        self.addQueue(node: node, queue: self.networkFaildQueue)

    }
    
    //授权成功后，尝试发出网络请求
    func onceAgainUnauthorized() {
        self.onceAgainRequest(queue: self.unauthorizedQueue)
    }
    
    //网络状态正常后，尝试发出网络请求
    private func onceAgainNetworkFaild() {
        self.onceAgainRequest(queue: self.networkFaildQueue)
    }

    //添加结点到队列中
    private func addQueue(node: XYYZNode, queue: XYYZNodeQueue) {
    
        let index = queue.find { (item) -> Bool in
            return node.URL.elementsEqual(item.URL)
        }
    
        if index > -1, let item = queue.getNode(index: index) {
            
            node.counter += item.counter
            
            //超过三次 丢弃
            if node.counter > self.configuration.repeatMax || node.counter < 0 {
                queue.replaceNode(startIndex: index, node: nil)
            } else {
                queue.replaceNode(startIndex: index, node: node)
            }
            
            
        } else {
            
            queue.enQueue(node: node)
            
        }
    }
    
    // 尝试请求
    private func onceAgainRequest(queue: XYYZNodeQueue) {
        
        while queue.length() > 0 {
            
            if let item = queue.deQueue() {
                
                self.reuqest(node: item)
            }
            
        }
        
    }
    
    
}

extension XYYZWorldCenter {
    
    
}






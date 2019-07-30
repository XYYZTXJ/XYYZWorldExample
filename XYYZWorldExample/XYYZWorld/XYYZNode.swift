//
//  XYYZNode.swift
//  XYYZWorldExample
//
//  Created by AG on 2019/7/30.
//  Copyright © 2019 AG. All rights reserved.
//

/**
 * 定义操作节点
 * taskId   任务id 初始化为0 网络请求时由网络请求类赋值ID，作为取消任务时使用
 * URL      请求地址
 * requestType  请求方法 默认get方法
 * serializerType 数据序列化类型
 * paramter 请求参数
 * responseHandler    响应对象
 * progressHandler    进度响应
 * counter 根据URL判断该URL失败了几次
 */

import UIKit

/**
 * 请求方式
 */
enum XYYZNetworkRequestType {
    case get
    case post
}

/**
 * 数据序列化类型
 */
enum XYYZNetworkRequestSerializerType {
    case none
    case json
}

class XYYZNode: NSObject {
    
    var taskId: Int = 0
    var URL: String = ""
    var parameter: Dictionary<String, Any>?
    var requestType: XYYZNetworkRequestType = .get
    var serializerType: XYYZNetworkRequestSerializerType = .none
    
    var responseHandler: ((Dictionary<String, Any>) -> Void)?
    var progressHandler: ((Progress) -> Void)?
    var errorHandler: ((Error) -> Void)?
    
    
    var counter: Int = 0
}

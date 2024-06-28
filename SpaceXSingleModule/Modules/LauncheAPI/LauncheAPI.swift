//
//  LauncheAPI.swift
//  LauncheAPI
//
//  Created by ho on 4/8/1403 AP.
//
 
import Foundation
import Combine 

public protocol LauncheAPIProtocol {  
    func getLaunchItems() async throws -> [LaunchItemModel]
}

final public class LauncheAPI: LauncheAPIProtocol {
    
    private enum Constants {
    }
    private var cancelables = Set<AnyCancellable>()
    private let networkAPI: NetworkAPIProtocol
    
    public init(networkAPI: NetworkAPIProtocol = NetworkAPI.shared) {
        self.networkAPI = networkAPI
    }
    
    public func getLaunchItems() async throws -> [LaunchItemModel] {
        return try await networkAPI.getLaunchItems()
    }
}

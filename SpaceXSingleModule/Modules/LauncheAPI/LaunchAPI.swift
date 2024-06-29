//
//  LauncheAPI.swift
//  LauncheAPI
//
//  Created by ho on 4/8/1403 AP.
//
 
import Foundation
import Combine 

public protocol LaunchAPIProtocol {
    func getLaunchItems(by paginationModel: PaginationModel) async throws -> PaginationResult<LaunchItemModel>
}

final public class LaunchAPI: LaunchAPIProtocol {
    
    private enum Constants {
    }
    private var cancelables = Set<AnyCancellable>()
    private let networkAPI: NetworkAPIProtocol
    
    public init(networkAPI: NetworkAPIProtocol = NetworkAPI.shared) {
        self.networkAPI = networkAPI
    }
    public func getLaunchItems(by paginationModel: PaginationModel) async throws -> PaginationResult<LaunchItemModel> {
        return try await networkAPI.getLaunchItems(by: paginationModel)
    }
}

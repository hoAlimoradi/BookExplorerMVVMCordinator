//
//  GeneralSenarioManager.swift
//  SpaceXSingleModule
//
//  Created by ho on 4/9/1403 AP.
//

import Foundation
import Combine

class GeneralSenarioManager {
    static let shared = GeneralSenarioManager()
    let didPopToSplashSubject = PassthroughSubject<Void, Never>()
    let recentlyFavoriteCountModelItemSubject = PassthroughSubject<Int, Never>() 
}
 

//
//  GeneralSenarioManager.swift
//

import Foundation
import Combine

class GeneralSenarioManager {
    static let shared = GeneralSenarioManager()
    let didPopToSplashSubject = PassthroughSubject<Void, Never>()
    let recentlyFavoriteCountModelItemSubject = PassthroughSubject<Int, Never>() 
}
 

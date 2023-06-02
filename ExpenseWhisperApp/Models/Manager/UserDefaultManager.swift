//
//  UserDefaultManager.swift
//  ExpenseWhisperApp
//
//  Created by 渡邊魁優 on 2023/06/02.
//

import Foundation

class UserDefaultsManager {
    
    private init(){}
    static public let shared = UserDefaultsManager()
    
    let userDefaults = UserDefaults.standard

    func setList(costs: [Cost], key: String) throws {
        guard let json = encode(costs: costs) else {
            throw UserDefaultsError.encodeError
        }
        userDefaults.set(json, forKey: key)
    }

    func getList(key: String) throws -> [Cost] {
        guard let json = userDefaults.string(forKey: key) else {
            throw UserDefaultsError.getFailure
        }
        guard let costs = decode(json: json) else {
            throw UserDefaultsError.decodeError
        }
        return costs
    }
    
    func setGoal(goal: Int, key: String) {
        userDefaults.set(goal, forKey: key)
    }
    
    func getGoal(key: String) -> Int {
        return userDefaults.integer(forKey: key)
    }
    
    private func encode(costs: [Cost]) -> String? {
        do {
            let data = try JSONEncoder().encode(costs)
            guard let json = String(data: data, encoding: .utf8) else {
                return nil
            }
            return json
        } catch {
            return nil
        }
    }
    
    private func decode(json: String) -> [Cost]? {
        do {
            guard let data = json.data(using: .utf8) else {
                return nil
            }
            let costs = try JSONDecoder().decode([Cost].self, from: data)
            return costs
        } catch {
            return nil
        }
    }
}


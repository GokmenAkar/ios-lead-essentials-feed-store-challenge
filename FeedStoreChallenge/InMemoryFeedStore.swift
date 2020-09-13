//
//  InMemoryFeedStore.swift
//  FeedStoreChallenge
//
//  Created by Developer on 13.09.2020.
//  Copyright © 2020 Essential Developer. All rights reserved.
//

import Foundation

public class InMemoryFeedStore: FeedStore {
    private var feed: (local: [LocalFeedImage], date: Date)?
    private var queue = DispatchQueue(label: "\(InMemoryFeedStore.self)Queue", qos: .userInitiated, attributes: .concurrent)
    
    public init() { }
    
    public func deleteCachedFeed(completion: @escaping DeletionCompletion) {
        queue.async(flags: .barrier) {
            self.feed = nil
            completion(nil)
        }
    }
    
    public func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion) {
        queue.async(flags: .barrier) {
            self.feed = (feed, timestamp)
            completion(nil)
        }
    }
    
    public func retrieve(completion: @escaping RetrievalCompletion) {
        queue.async {
            if let feed = self.feed {
                completion(.found(feed: feed.local, timestamp: feed.date))
            } else {
                completion(.empty)
            }
        }
    }
}

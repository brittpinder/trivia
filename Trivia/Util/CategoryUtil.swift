//
//  CategoryUtil.swift
//  Trivia
//
//  Created by Brittany Pinder on 2023-03-27.
//

import Foundation

struct CategoryUtil {

    static let categoryData: [String: CategoryViewModel] = [
        "General Knowledge": CategoryViewModel(displayName: "General", iconName: "questionmark"),
        "Entertainment: Books": CategoryViewModel(displayName: "Books", iconName: "book"),
        "Entertainment: Film": CategoryViewModel(displayName: "Film", iconName: "video.fill"),
        "Entertainment: Music": CategoryViewModel(displayName: "Music", iconName: "music.note"),
        "Entertainment: Musicals & Theatres": CategoryViewModel(displayName: "Theatre", iconName: "theatermasks.fill"),
        "Entertainment: Television": CategoryViewModel(displayName: "Television", iconName: "tv"),
        "Entertainment: Video Games": CategoryViewModel(displayName: "Video Games", iconName: "gamecontroller.fill"),
        "Entertainment: Board Games": CategoryViewModel(displayName: "Board Games", iconName: "dice.fill"),
        "Science & Nature": CategoryViewModel(displayName: "Science & Nature", iconName: "leaf.fill"),
        "Science: Computers": CategoryViewModel(displayName: "Computers", iconName: "desktopcomputer"),
        "Science: Mathematics": CategoryViewModel(displayName: "Mathematics", iconName: "plus.forwardslash.minus"),
        "Mythology": CategoryViewModel(displayName: "Mythology", iconName: "questionmark"),
        "Sports": CategoryViewModel(displayName: "Sports", iconName: "sportscourt.fill"),
        "Geography": CategoryViewModel(displayName: "Geography", iconName: "globe.americas.fill"),
        "History": CategoryViewModel(displayName: "History", iconName: "clock.fill"),
        "Politics": CategoryViewModel(displayName: "Politics", iconName: "building.columns.fill"),
        "Art": CategoryViewModel(displayName: "Art", iconName: "paintbrush.pointed.fill"),
        "Celebrities": CategoryViewModel(displayName: "Celebrities", iconName: "star.fill"),
        "Animals": CategoryViewModel(displayName: "Animals", iconName: "tortoise.fill"),
        "Vehicles": CategoryViewModel(displayName: "Vehicles", iconName: "car.fill"),
        "Entertainment: Comics": CategoryViewModel(displayName: "Comics", iconName: "captions.bubble.fill"),
        "Science: Gadgets": CategoryViewModel(displayName: "Gadgets", iconName: "ipod"),
        "Entertainment: Japanese Anime & Manga": CategoryViewModel(displayName: "Japanese Anime & Manga", iconName: "questionmark"),
        "Entertainment: Cartoon & Animations": CategoryViewModel(displayName: "Cartoon & Animations", iconName: "questionmark"),
    ]

    static func getCategory(for remoteName: String) -> CategoryViewModel {
        return categoryData[remoteName] ?? CategoryViewModel(displayName: remoteName, iconName: "questionmark")
    }
}



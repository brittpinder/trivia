//
//  CategoryUtil.swift
//  Trivia
//
//  Created by Brittany Pinder on 2023-03-27.
//

import Foundation

struct CategoryUtil {
    static let categoryData: [String: Category] = [
        "General Knowledge": Category(displayName: "General", iconName: "questionmark"),
        "Entertainment: Books": Category(displayName: "Books", iconName: "book"),
        "Entertainment: Film": Category(displayName: "Film", iconName: "video.fill"),
        "Entertainment: Music": Category(displayName: "Music", iconName: "music.note"),
        "Entertainment: Musicals & Theatres": Category(displayName: "Theatre", iconName: "theatermasks.fill"),
        "Entertainment: Television": Category(displayName: "Television", iconName: "questionmark"),
        "Entertainment: Video Games": Category(displayName: "Video Games", iconName: "gamecontroller.fill"),
        "Entertainment: Board Games": Category(displayName: "Board Games", iconName: "dice.fill"),
        "Science & Nature": Category(displayName: "Science & Nature", iconName: "leaf.fill"),
        "Science: Computers": Category(displayName: "Computers", iconName: "desktopcomputer"),
        "Science: Mathematics": Category(displayName: "Mathematics", iconName: "plus.forwardslash.minus"),
        "Mythology": Category(displayName: "Mythology", iconName: "questionmark"),
        "Sports": Category(displayName: "Sports", iconName: "questionmark"),
        "Geography": Category(displayName: "Geography", iconName: "globe.americas.fill"),
        "History": Category(displayName: "History", iconName: "clock.fill"),
        "Politics": Category(displayName: "Politics", iconName: "questionmark"),
        "Art": Category(displayName: "Art", iconName: "paintbrush.pointed.fill"),
        "Celebrities": Category(displayName: "Celebrities", iconName: "star.fill"),
        "Animals": Category(displayName: "Animals", iconName: "tortoise.fill"),
        "Vehicles": Category(displayName: "Vehicles", iconName: "car.fill"),
        "Entertainment: Comics": Category(displayName: "Comics", iconName: "questionmark"),
        "Science: Gadgets": Category(displayName: "Gadgets", iconName: "ipod"),
        "Entertainment: Japanese Anime & Manga": Category(displayName: "Japanese Anime & Manga", iconName: "questionmark"),
        "Entertainment: Cartoon & Animations": Category(displayName: "Cartoon & Animations", iconName: "questionmark"),
    ]

    static func getCategory(for remoteName: String) -> Category {
        return categoryData[remoteName] ?? Category(displayName: remoteName, iconName: "questionmark")
    }
}



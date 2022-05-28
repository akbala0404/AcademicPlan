//
//  Data.swift
//  AcademicPlan
//
//  Created by Акбала Тлеугалиева on 5/27/22.
//  Copyright © 2022 Akbala Tleugaliyeva. All rights reserved.
//

import Foundation
import SwiftyJSON

// MARK: - Welcome
struct Root: Codable {
    let iupSid: String
    let title: String
    let documentURL: String
    let academicYearID: Int
    let academicYear: String
    let semesters: [Semester]

    enum CodingKeys: String, CodingKey {
        case iupSid = "IUPSid"
        case title = "Title"
        case documentURL = "DocumentURL"
        case academicYearID = "AcademicYearId"
        case academicYear = "AcademicYear"
        case semesters = "Semesters"
    }
    
}

// MARK: - Semester
struct Semester: Codable {
    let Number: Int
    let disciplines: [Discipline]

    enum CodingKeys: String, CodingKey {
        case Number
        case disciplines = "Disciplines"
    }
}

// MARK: - Discipline
struct Discipline: Codable {
    let disciplineID: String
    let disciplineName: DisciplineName
    let lesson: [Lesson]

    enum CodingKeys: String, CodingKey {
        case disciplineID = "DisciplineId"
        case disciplineName = "DisciplineName"
        case lesson = "Lesson"
    }

}
    
// MARK: - DisciplineName
struct DisciplineName: Codable {
    let nameKk, nameRu, nameEn: String
}

// MARK: - Lesson
struct Lesson: Codable {
    let lessonTypeID, hours, realHours: Int

    enum CodingKeys: String, CodingKey {
        case lessonTypeID = "LessonTypeId"
        case hours = "Hours"
        case realHours = "RealHours"
    }
}


//
//  DatabaseService.swift
//  testBrowser
//
//  Created by Doston Mirsamukov on 5/6/23.
//

import Foundation
import SQLite3

final class DatabaseService {
  private var db: OpaquePointer?

  init() {
    guard let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
      print("Error creating file URL.")
      return
    }
    let fileURL = documentsURL.appendingPathComponent("webpages.db")
    if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
      print("Error opening database.")
      db = nil
    } else {
      let createTableStatement = """
            CREATE TABLE IF NOT EXISTS webpages (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                url TEXT NOT NULL,
                date TEXT NOT NULL
            );
            """
      if sqlite3_exec(db, createTableStatement, nil, nil, nil) != SQLITE_OK {
        print("Error creating table.")
      }
    }
  }

  deinit {
    if let db = db {
      sqlite3_close(db)
    }
  }

  func saveWebPage(url: String, date: Date) {
    let insertStatement = "INSERT INTO webpages (url, date) VALUES (?, ?);"
    var statement: OpaquePointer?
    if sqlite3_prepare_v2(db, insertStatement, -1, &statement, nil) == SQLITE_OK {
      sqlite3_bind_text(statement, 1, (url as NSString).utf8String, -1, nil)
      sqlite3_bind_text(statement, 2, (date.description as NSString).utf8String, -1, nil)
      if sqlite3_step(statement) != SQLITE_DONE {
        print("Error inserting row.")
      }
      sqlite3_finalize(statement)
    } else {
      print("Error preparing statement.")
    }
  }

  func getWebPages() -> [WebPage] {
    var webPages: [WebPage] = []
    let selectStatement = "SELECT id, url, date FROM webpages ORDER BY date DESC;"
    var statement: OpaquePointer?
    if sqlite3_prepare_v2(db, selectStatement, -1, &statement, nil) == SQLITE_OK {
      while sqlite3_step(statement) == SQLITE_ROW {
        let id = sqlite3_column_int64(statement, 0)
        let url = String(cString: sqlite3_column_text(statement, 1))
        let dateString = String(cString: sqlite3_column_text(statement, 2))
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ssZ"
        let date = dateFormatter.date(from: dateString)!
        webPages.append(WebPage(id: id, url: url, date: date))
      }
      sqlite3_finalize(statement)
    } else {
      print("Error preparing statement.")
    }
    return webPages
  }

  func getLatestSavedURL() -> String? {
      let selectStatement = "SELECT url FROM webpages ORDER BY date DESC LIMIT 1;"
      var statement: OpaquePointer?
      if sqlite3_prepare_v2(db, selectStatement, -1, &statement, nil) == SQLITE_OK {
          defer {
              sqlite3_finalize(statement)
          }
          if sqlite3_step(statement) == SQLITE_ROW {
              let url = String(cString: sqlite3_column_text(statement, 0))
              return url
          }
      } else {
          print("Error preparing statement.")
      }
      return nil
  }
}

import Foundation

// MARK: - Books
struct Books: Codable {
    let total: String
    let page: String
    let books: [Book]
}

// MARK: - Book
struct Book: Codable {
    let title: String
    let subtitle: String
    let isbn13: String
    let price: String
    let image: String
    let url: String
}

import UIKit

struct Person: Decodable {
    let name: String
    let films: [URL]
    let birth_year: String
}

struct Film: Decodable {
    let title: String
    let opening_crawl: String
    let release_date: String
}

class SwapiService {
    private static let baseURL = URL(string: "https://swapi.co/api/")
    private static let peoplePathComponent = "people"
    private static let filmPathComponent = "films"
    
    static func fetchPerson(id: Int, completion: @escaping (Person?) -> Void) {
        guard let baseURL = baseURL else { return completion(nil) }
        let peopleURL = baseURL.appendingPathComponent(peoplePathComponent)
        let finalURL = peopleURL.appendingPathComponent("\(id)")
        print(finalURL)
        
        URLSession.shared.dataTask(with: finalURL) { (data, _, error) in
            if let error = error {
                print(error, error.localizedDescription)
                return completion(nil)
            }
            guard let data = data else { return completion(nil)}
            do {
                let people = try JSONDecoder().decode(Person.self, from: data)
                completion(people)
            } catch {
                print(error, error.localizedDescription)
                return completion(nil)
            }
        }.resume()
    }
    
    static func fetchFilm(url: URL, completion: @escaping (Film?) -> Void) {
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                print(error, error.localizedDescription)
                return completion(nil)
            }
            guard let data = data else { return completion(nil)}
            do {
                let film = try JSONDecoder().decode(Film.self, from: data)
                completion(film)
            } catch {
                print(error, error.localizedDescription)
                return completion(nil)
            }
        }.resume()
        
    }
    
    
}

SwapiService.fetchPerson(id: 35) { (person) in
    guard let person = person else {return}
    print(person.name)
    print(person.birth_year)

    for filmURL in person.films {
        SwapiService.fetchFilm(url: filmURL) { (film) in
            print(film!.title)
        }
    }
}
//let vaderURL = URL(string: "https://swapi.co/api/films/2/")
//SwapiService.fetchFilm(url: vaderURL!) { (film) in
//    guard let film = film else {return}
//    print(film.opening_crawl)
//}

import Foundation

/// Заполняем основные таблицы
fillArtistFile(150)
fillPlaylistFile(150)
fillPlaylistOfPlaylistFile(150)
fillTracksFile(300)
fillTracksFile(150)
fillUsersFile(100)

/// Заполняем вспомогательные таблицы
fillTableFile(countOfFirst: 150, countOfSecond: 100, fileName: "favoriteArtistsOfUsers")
fillTableFile(countOfFirst: 150, countOfSecond: 100, fileName: "favoritePlaylistsOfUsers")
fillTableFile(countOfFirst: 300, countOfSecond: 100, fileName: "favoriteTracksOfUsers")
fillTableFile(countOfFirst: 16, countOfSecond: 100, fileName: "favoriteTypesOfUsers")
fillTableFile(countOfFirst: 150, countOfSecond: 150, fileName: "playlistsFromArtists")
fillTableFile(countOfFirst: 150, countOfSecond: 100, fileName: "playlistsInPlaylists")
fillTableFile(countOfFirst: 300, countOfSecond: 150, fileName: "tracksFromArtists")
fillTableFile(countOfFirst: 150, countOfSecond: 100, fileName: "tracksInPlaylist")
fillTableFile(countOfFirst: 150, countOfSecond: 17, fileName: "typeOfArtists")
fillTableFile(countOfFirst: 300, countOfSecond: 17, fileName: "typeOfTracks")

// MARK: - Функции для основных таблиц
func fillArtistFile(_ count: Int) {
    let names = loadFromFileWithName(name: "Artists")
    
    var currentString = ""
    for i in 0..<count {
        let current = "\(i),\(names[i]),https://\(randomString(7)),\(Int.random(in: 10000...200000)),https:\\\(randomString(7))\n"
        currentString += current
    }
    
    saveStringToFile(withName: "Users", dataCSVFormatString: currentString)
}

func fillPlaylistFile(_ count: Int) {
    let titles = loadFromFileWithName(name: "Playlists")
    var currentString = ""
    for i in 0..<count {
        let current = "\(i),\(titles[i]),https://\(randomString(7)),some description\(i),\(Int.random(in: 10000...200000)),\(randomBool())\n"
        currentString += current
    }
    
    saveStringToFile(withName: "Users", dataCSVFormatString: currentString)
}

func fillPlaylistOfPlaylistFile(_ count: Int) {
    let titles = loadFromFileWithName(name: "PlaylistOfPlaylist")
    var currentString = ""
    for i in 0..<count {
        let current = "\(i),\(titles),https://\(randomString(7)).jpg,some description\(i)\n"
        currentString += current
    }
    
    saveStringToFile(withName: "Users", dataCSVFormatString: currentString)
}

func fillTracksFile(_ count: Int) {
    let titles = loadFromFileWithName(name: "Tracks")
    var currentString = ""
    for i in 0..<count {
        var temp = "null"
        if let t = randomOptionalString() {
            temp = "https://\(t).mp4"
        }
        
        let current = "\(i),\(titles[i]),https://\(randomString(7)).jpg,\(temp),https://\(randomString(7)).mp3,\(Int.random(in: 100...300)),\(Int.random(in: 100000...1000000)),\(randomBool())\n"
        currentString += current
    }
    
    saveStringToFile(withName: "Users", dataCSVFormatString: currentString)
}

func fillUsersFile(_ count: Int) {
    let subs = ["month", "2 mounth", "3 mounth", "6 mounth", "9 mounth", "year"]
    let logins = loadFromFileWithName(name: "TracksLogins")
    let names = loadFromFileWithName(name: "TracksNames")
    let dates = loadFromFileWithName(name: "TracksDates")
    
    var currentString = ""
    for i in 0..<count {
        let current = "\(i),\(logins[i]),\(names[i]),\(randomString(7)),\(dates[i]),\(subs[Int.random(in: 0..<subs.count)])\n"
        currentString += current
    }
    
    saveStringToFile(withName: "Users", dataCSVFormatString: currentString)
}
// MARK: -

/// Функция которой передается два числа
/// 1 число количество значений в одной таблице
/// 2 число количество значений в другой таблице
/// Она создает третью таблицу в которую записывает первым числом уникальный Id типа  Int,
/// Далее функция пробегается по второй таблице, и на каждом шаге рандомно выбирает число которое показывает сколько значений из первой таблицы будут соответствовать данному значению из второй таблицы, затем мы рандомно выбираем значение из 1 таблицы и если ранее к заданному значению из 2 таблицы оно НЕ было добавлено то добавляем

func fillTableFile(countOfFirst: Int, countOfSecond: Int, fileName: String) {
    let firstRange = (0...countOfFirst)
    let secondRange = (0...countOfSecond)

    var currentId = 0
    var currentDataString = ""

    for element in secondRange {
        let countOfTracks = Int.random(in: 0...6)
        var added = [Int]()
        
        for _ in 0...countOfTracks {
            let randomId = Int.random(in: firstRange)
            
            if !added.contains(randomId) {
                added.append(randomId)
                
                currentDataString += "\(currentId),\(randomId),\(element)\n"
                currentId += 1
            }
        }
    }
    
    saveStringToFile(withName: fileName, dataCSVFormatString: currentDataString)
}

/// Функция загрузки данных из txt файла
func loadFromFileWithName(name: String) -> [String] {
    var result = [String]()
    let contents = try! String(contentsOfFile: "/Users/evgeny/Desktop/\(name).txt")
    let lines = contents.split(separator:"\n")
    for line in lines {
        result.append("\(line)")
    }
    
    return result
}

/// Функция которая сохраняет строку в CSV файл c заданым именем
func saveStringToFile(withName name: String, dataCSVFormatString: String) {
    let fileName = name
    let DocumentDirURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
    let fileURL = DocumentDirURL.appendingPathComponent(fileName).appendingPathExtension("csv")
    do {
        try dataCSVFormatString.write(to: fileURL, atomically: true, encoding: String.Encoding.utf8)
    } catch let error as NSError {
        print("Failed writing to URL: \(fileURL), Error: " + error.localizedDescription)
    }

}

// MARK: - Вспомогательные функции
func randomString(_ length: Int) -> String {
  let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
  return String((0..<length).map{ _ in letters.randomElement()! })
}

func randomOptionalString() -> String? {
    let number = Int.random(in: 0...30)
    if number > 15 {
        return randomString(7)
    } else {
        return nil
    }
}

func randomBool() -> Bool {
    let number = Int.random(in: 0...30)
    if number > 15 {
        return true
    } else {
        return false
    }
}

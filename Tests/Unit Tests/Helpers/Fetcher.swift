@testable import Fruta

extension Smoothie {

    static func fetchSynchronouslyFromServer() throws -> [Smoothie] {
        let data = try performGETRequest()
        return try deserializeData(data)
    }

    static func updateSynchronouslyOnServer(smoothie: Smoothie) throws {
        try smoothie.updateOnServer()
    }

}

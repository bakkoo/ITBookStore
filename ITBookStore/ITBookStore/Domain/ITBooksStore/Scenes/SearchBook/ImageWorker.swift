import Combine
import UIKit

protocol ImageWorker {
    func fetchImages(books: [Book])
}

final class DefaultImageWorker: ImageWorker {
    @Published var images: [UIImage] = []
    var onReload: (() -> Void)?
    private var subscribers = Set<AnyCancellable>()
    
    func fetchImages(books: [Book]) {
        images.removeAll()
        books.map({ $0.image })
            .publisher
            .compactMap { URL(string: $0) }
            .flatMap {
                URLSession.shared.dataTaskPublisher(for: $0)
            }
            .compactMap { $0.data }
            .compactMap { UIImage(data: $0) }
            .sink(receiveCompletion: ( {[weak self] _ in
                print("🟢 Images Fetched Succesfully")
                self?.onReload?()
            })) {[weak self] image in
                self?.images.append(image)
                print("////// IMAGE - ",image)
                print("images count at worker\(self?.images.count)")
                
            }.store(in: &subscribers)
    }
}

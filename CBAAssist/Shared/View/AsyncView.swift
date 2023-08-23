////
////  AsyncView.swift
////  CBAAssist
////
////  Created by Cole M on 3/2/22.
////
//
//import SwiftUI
//
//struct AsyncView<T, V: View>: View {
//    @State var result: Result<T, Error>?
//    let run: () async throws -> T
//    let build: (T) -> V
//    
//    init(run: @escaping () async throws -> T, @ViewBuilder build: @escaping (T) -> V) {
//        self.run = run
//        self.build = build
//    }
//    
//    var body: some View {
//        ZStack {
//            switch result {
//            case .some(.success(let value)):
//                build(value)
//            case .some(.failure(let error)):
//                Text("Error: \(error)" as String)
//            case .none:
//                if #available(iOS 15.0, *) {
//                    ProgressView().task {
//                        do {
//                            self.result = .success(try await run())
//                        } catch {
//                            self.result = .failure(error)
//                        }
//                    }
//                } else {
//                    // Fallback on earlier versions
//                }
//            }
//        }.id(result.debugDescription)
//    }
//}
